function [Duration_Robust]=Temporal_Robustness_2023_Clusters_Fixed(Vac,Num_Clusters)
    clear;
    clc;
    load(['Likelihood_Clusters_2023_' Vac '.mat'],'est_r','lat_c','lon_c','lambda');
    
    [~,indx_cluster]=sort(lambda(:,1),'descend');
    lat_c=lat_c(indx_cluster);
    lon_c=lon_c(indx_cluster);
    est_r=est_r(indx_cluster);
    
    lat=lat_c(1:Num_Clusters);
    lon=lon_c(1:Num_Clusters);
    Radius=est_r(1:Num_Clusters);
    
    Yr=[2023:-1:2017];
    Duration_Robust=zeros(Num_Clusters,1);
    for cc=1:Num_Clusters
        L=zeros(length(Yr),1);
        c_z=zeros(length(Yr),1);
        n_z=zeros(length(Yr),1);

        Grid_Data=readtable([pwd '\Spatial_Data\Grid_Population_Properties_2023.csv']);   
    
        % Determine the number of unaccinatd individuals in eac hgrid point
        if(strcmp(Vac,'MMR'))
            Number_Unvaccinated=Grid_Data.Age_5_to_9.*(1-Grid_Data.MMR_Vaccine_Uptake);
        end
        Total_Population=Grid_Data.Age_5_to_9;    
    
        d=deg2sm(distance(Grid_Data.Y,Grid_Data.X,lat(cc),lon(cc)));
        f_region=d<=Radius(cc);
        c_z(1)=sum(Number_Unvaccinated(f_region));
        n_z(1)=sum(Total_Population(f_region));
                
        c_tot=sum(Number_Unvaccinated);
        n_tot=sum(Total_Population);
    
    
        for yy=2022:-1:2017
            Grid_Data=readtable([pwd '\Spatial_Data\Grid_Population_Properties_' num2str(yy) '.csv']);       
            
            if(strcmp(Vac,'MMR'))
                Number_Unvaccinated=Grid_Data.Age_5_to_9.*(1-Grid_Data.MMR_Vaccine_Uptake);
            end
            Total_Population=Grid_Data.Age_5_to_9;    

            d=deg2sm(distance(Grid_Data.Y,Grid_Data.X,lat(cc),lon(cc)));

            f_region=d<=Radius(cc);
            c_z(2024-yy)=sum(Number_Unvaccinated(f_region));
            n_z(2024-yy)=sum(Total_Population(f_region));
            
            c_tot=c_tot+sum(Number_Unvaccinated);
            n_tot=n_tot+sum(Total_Population);
        end

        for yy=1:length(Yr)
            c_zy=sum(c_z(1:yy));
            n_zy=sum(n_z(1:yy));

            c_outy=c_tot-sum(c_z(1:yy));
            n_outy=n_tot-sum(n_z(1:yy));

            if(c_zy/n_zy>c_outy/n_outy)
                L(yy)=c_zy.*(log(c_zy)-log(n_zy))+(n_z-c_zy).*(log((n_zy-c_zy))-log(n_zy))+c_outy.*(log(c_outy)-log(n_outy))+(n_outy-c_outy).*(log((n_outy-c_outy))-log(n_outy));
            else
                L(yy)=c_tot.*log(c_tot)+(n_tot-c_tot).*log(n_tot-c_tot)-n_tot.*log(n_tot);
            end
        end
        Duration_Robust(yy)=min(Yr(L==max(L)));
    end
end
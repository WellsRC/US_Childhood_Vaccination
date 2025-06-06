function Identify_2023_Clusters(Vac)
    Grid_Data=readtable([pwd '\Spatial_Data\Age_5_to_9_Grid_2023.csv']);
    load('Cluster_Center_Radius_2023.mat','r','lat_c','lon_c');

    % Determine the number of unaccinatd individuals in eac hgrid point
    if(strcmp(Vac,'MMR'))
        Number_Unvaccinated=Grid_Data.Age_5_to_9.*(1-Grid_Data.MMR_Vaccine_Uptake);
    end
    Total_Population=Grid_Data.Age_5_to_9;

    % Identify the indexs who have at least one whole individual in the
    % cell
    indx_population=cell(length(Total_Population),1);
    for kk=1:length(Total_Population)
        indx_population{kk}=kk.*ones(1,floor(Total_Population(kk)));
    end
    indx_population=[indx_population{:}];

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Compute the spatial scan statisitc 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    L=zeros(length(lat_c),1);
    est_r=zeros(length(lat_c),1);

    c_tot=sum(Number_Unvaccinated);
    n_tot=sum(Total_Population);
    L0=c_tot.*log(c_tot)+(n_tot-c_tot).*log(n_tot-c_tot)-n_tot.*log(n_tot);

    parfor ii=1:length(L)
        d=deg2sm(distance(Grid_Data.Y,Grid_Data.X,lat_c(ii),lon_c(ii)));
        opts=optimoptions('surrogateopt','UseParallel',false,'InitialPoints',linspace(-3,log10(r(ii)),21),'MaxFunctionEvaluations',100,'PlotFcn',[]);
        [est_r(ii), L(ii)]=surrogateopt(@(x)Objective_Function_Cluster_Circle(x,d,Number_Unvaccinated,Total_Population),-3,log10(r(ii)),opts);
    end
    L=-L;
    est_r=10.^est_r;

    lambda=zeros(length(lat_c),1000);
    lambda(:,1)=L./L0;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Compute spatial scan statisitc under the Null Hypothesis
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    for ss=2:1000
        Number_Unvaccinated_Samp=MCMC_Unvaccinated_Population(sum(Number_Unvaccinated),Total_Population,indx_population);
        parfor ii=1:length(L)
            d=deg2sm(distance(Grid_Data.Y,Grid_Data.X,lat_c(ii),lon_c(ii)));
            lambda(ii,ss)=-Objective_Function_Cluster_Circle(log10(est_r(ii)),d,Number_Unvaccinated_Samp,Total_Population)./L0;
        end
    end
    save(['Likelihood_Clusters_2023_' Vac '.mat'],'L','L0','est_r','lat_c','lon_c','lambda');


end
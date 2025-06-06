function Figure_1(Vac,Num_Clusters)
    clc;
    load(['Likelihood_Clusters_2023_' Vac '.mat'],'est_r','lat_c','lon_c','lambda');
    
    [~,indx_cluster]=sort(lambda(:,1),'descend');
    lat_c=lat_c(indx_cluster);
    lon_c=lon_c(indx_cluster);
    est_r=est_r(indx_cluster);
    
    lat=lat_c(1:Num_Clusters);
    lon=lon_c(1:Num_Clusters);
    Radius=est_r(1:Num_Clusters);
    
    Yr=[2017:2023];
    Vaccination_Coverage=zeros(Num_Clusters,length(Yr));
    
    Cluster_Plot_lon=zeros(Num_Clusters,1001);
    Cluster_Plot_lat=zeros(Num_Clusters,1001);
    
    for cc=1:Num_Clusters
        theta_v=linspace(0,2*pi,101);
        theta_v=theta_v(1:end-1);
    
        [r_map,fval]=fmincon(@(x)sum(deg2sm(distance(10.^x.*sin(theta_v)+lat(cc),10.^x.*cos(theta_v)+lon(cc),lat(cc),lon(cc)))-Radius(cc)).^2,1,[],[],[],[],-3,4);
        r_map=10^r_map;
        Cluster_Plot_lat(cc,:)=r_map.*sin(linspace(0,2*pi,1001));
        Cluster_Plot_lon(cc,:)=r_map.*cos(linspace(0,2*pi,1001));
    end
    
    for yy=2017:2023
        Grid_Data=readtable([pwd '\Spatial_Data\Age_5_to_9_Grid_' num2str(yy) '.csv']);
    
         % Determine the number of unaccinatd individuals in eac hgrid point
        if(strcmp(Vac,'MMR'))
            Number_Vaccinated=Grid_Data.Age_5_to_9.*(Grid_Data.MMR_Vaccine_Uptake);
            if(yy==2023)
                plot_lon=Grid_Data.X;
                plot_lat=Grid_Data.Y;
                plot_unvac=Grid_Data.Age_5_to_9.*(1-Grid_Data.MMR_Vaccine_Uptake);
    
                plot_lon=plot_lon(plot_unvac>0);
                plot_lat=plot_lat(plot_unvac>0);
                plot_unvac=plot_unvac(plot_unvac>0);
            end
        end
        Total_Population=Grid_Data.Age_5_to_9;
        for cc=1:Num_Clusters
            d=deg2sm(distance(Grid_Data.Y,Grid_Data.X,lat(cc),lon(cc)));
            Vaccination_Coverage(cc,yy-2016)=round(100.*sum(Number_Vaccinated(d<=Radius(cc)))./sum(Total_Population(d<=Radius(cc))),1);
        end
    end
    close all;
    lg_lbl=cell(Num_Clusters,1);
    for cc=1:Num_Clusters
        lg_lbl{cc}=['Cluster ' char(64+cc)];
    end
    XL=cell(length(Yr),1);
    for yy=2017:2023
        XL{yy-2016}=[num2str(yy) char(8211) num2str(yy+1-2000)];
    end
    [CC,mk]=Cluster_Colours(Num_Clusters);
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    figure('units','normalized','outerposition',[0.1 0.05 0.6 1])
    
    ax1=usamap('conus');
            
    framem off; gridm off; mlabel off; plabel off;
    ax1.Position=[-0.3,-2,0.6,0.6];
    CM=[hex2rgb('#ffffff');
    hex2rgb('#f0f0f0');
    hex2rgb('#d9d9d9');
    hex2rgb('#bdbdbd');
    hex2rgb('#969696');
    hex2rgb('#737373');
    hex2rgb('#525252');
    hex2rgb('#252525');
    hex2rgb('#000000');];
    colormap(CM)
    
    scatterm(plot_lat,plot_lon,5,log10(plot_unvac),'filled'); hold on;
    clim([floor(min(log10(plot_unvac))),ceil(max(log10(plot_unvac)))]);
    geoshow(states,'FaceAlpha',0,'LineWidth',1,'EdgeColor',[0.75 0.75 0.75]);
    for cc=1:Num_Clusters
        plotm(lat(cc)+Cluster_Plot_lat(cc,:),lon(cc)+Cluster_Plot_lon(cc,:),'-','Color',CC(cc,:),'LineWidth',2); hold on;
    end
    
    
    
    subplot('Position',[0.09 0.70 0.9 0.285])
    pp=plot(Yr,Vaccination_Coverage,'-','LineWidth',2);
    for cc=1:Num_Clusters
        pp(cc).Marker=mk{cc};
        pp(cc).Color=CC(cc,:);
        pp(cc).MarkerSize=10;
        pp(cc).MarkerFaceColor=CC(cc,:);
    end
    set(gca,'tickdir','out','Fontsize',14,'Xtick',Yr,'XTickLabel',XL,'LineWidth',2,'YTick',[floor(min(Vaccination_Coverage(:)))-1:1:max(ceil(Vaccination_Coverage(:)))+1])
    ytickformat('percentage');
    box off;
    xlabel('School year','Fontsize',14)
    ylabel('Vaccine uptake','Fontsize',14)
    legend(lg_lbl,'Location','eastoutside','Fontsize',14)
    ylim([floor(min(Vaccination_Coverage(:)))-1 max(ceil(Vaccination_Coverage(:)))+1])
    text(-0.115,1,'A','FontSize',30,'Units','normalized')
    text(-0.115,-0.3,'B','FontSize',30,'Units','normalized')
    
    
    subplot('Position',[0.88 0.025 0.03 0.6])
    x=linspace(floor(min(log10(plot_unvac))),ceil(max(log10(plot_unvac))),1001);
    cx=linspace(floor(min(log10(plot_unvac))),ceil(max(log10(plot_unvac))),size(CM,1));
    for ii=1:1000
        patch([0 1 1 0],[x(ii) x(ii) x(ii+1) x(ii+1)],interp1(cx,CM,x(ii)),'LineStyle','none'); hold on
    end
    patch([0 1 1 0],[x(1) x(1) x(end) x(end)],'k','FaceAlpha',0,'LineWidth',1.5);
    axis off;
    xlim([0 1])
    ylim([ x(1) x(end)])
    
    tx=floor(min(log10(plot_unvac))):ceil(max(log10(plot_unvac)));
    for ii=1:length(tx)
        text(1.02,tx(ii),['10^{' num2str(tx(ii)) '}'],'VerticalAlignment','middle','HorizontalAlignment','left','FontSize',14)
    end
    
    text(3.2,mean([ x(1) x(end)]),'Number of unvaccinated children','FontSize',16,'Rotation',270,'HorizontalAlignment','center');
    
    ax1.Position=[-0.21,-0.39,1.32,1.32];

    exportgraphics(gcf, 'Figure_1.pdf','ContentType','vector');
end





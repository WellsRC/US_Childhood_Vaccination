function Figure_2(Vac,Num_Clusters)
    clc;

    lat=29.12+ (43.38-29.12).*rand(Num_Clusters,1);
    lon=-110.72+ (-79.97-(-110.72)).*rand(Num_Clusters,1);


    Cluster_Plot_lon=zeros(Num_Clusters,1001);
    Cluster_Plot_lat=zeros(Num_Clusters,1001);
    
    Year_Start=2017+randi(6,Num_Clusters,1);
    Year_End=Year_Start+round((2023-Year_Start).*rand(size(Year_Start)));
    rc=randi(Num_Clusters,1);
    theta_v=flip(linspace(0,2*pi,1001));
    
    for cc=1:Num_Clusters
        r_map=0.5+2.5.*rand(1);
        Cluster_Plot_lat(cc,:)=r_map.*sin(theta_v);
        Cluster_Plot_lon(cc,:)=r_map.*cos(theta_v);
    end

    close all;
    lg_lbl=cell(Num_Clusters,1);
    for cc=1:Num_Clusters
        lg_lbl{cc}=['Cluster ' char(64+cc)];
    end
    Yr=[2017:2023];
     XL=cell(length(Yr),1);
    for yy=2017:2023
        XL{yy-2016}=[num2str(yy) char(8211) num2str(yy+1-2000)];
    end

    [CC,~]=Cluster_Colours(Num_Clusters);
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    figure('units','normalized','outerposition',[0.15 0.15 0.6 0.7])
    
    ax1=usamap('conus');
            
    framem off; gridm off; mlabel off; plabel off;
    
    ax1.Position=[-0.22,-0.23,1.35,1.35];
    
    geoshow(states,'FaceAlpha',0,'LineWidth',1,'EdgeColor',[0.75 0.75 0.75]);

    for cc=1:Num_Clusters
        p_cluster=geoshape(lat(cc)+Cluster_Plot_lat(cc,:),lon(cc)+Cluster_Plot_lon(cc,:),'Geometry','Polygon');
        geoshow(p_cluster,'FaceColor',CC(cc,:),'EdgeColor',CC(cc,:),'FaceAlpha',rand(1),'LineWidth',2); 
        text(0.835,0.9-0.025.*(cc-1),['Cluster ' char(64+cc)],'Fontsize',16,'Color',CC(cc,:),'Units','normalized');
    end

    for yy=2017:2023
        p_cluster=geoshape(32.3+0.5.*sin(theta_v)-1.2.*(yy-2017),-76.5+0.5.*cos(theta_v)-0.33.*(yy-2017),'Geometry','Polygon');
        geoshow(p_cluster,'FaceColor','k','EdgeColor','k','FaceAlpha',[2023-yy]./(2023-2017),'LineWidth',2);
        text(0.775,0.4475-0.035.*(yy-2017),[num2str(yy) char(8211) num2str(yy+1-2000) ' to 2023' char(8211) '24' ],'Units','normalized','Fontsize',16)
    end
         

    exportgraphics(gcf, 'Figure_2.pdf','ContentType','vector');
end





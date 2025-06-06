function Figure_3(Vac,Num_Clusters)
    clc;

    lat=29.12+ (43.38-29.12).*rand(Num_Clusters,1);
    lon=-110.72+ (-79.97-(-110.72)).*rand(Num_Clusters,1);


    Cluster_Plot_lon=zeros(Num_Clusters,1001);
    Cluster_Plot_lat=zeros(Num_Clusters,1001);
    
    Year_Start=2017+randi(6,Num_Clusters,1);
    Year_End=Year_Start+round((2023-Year_Start).*rand(size(Year_Start)));
    rc=randi(Num_Clusters,1);
    Year_End(rc)=Year_Start(rc);
    for cc=1:Num_Clusters
        r_map=0.5+2.5.*rand(1);
        Cluster_Plot_lat(cc,:)=r_map.*sin(linspace(0,2*pi,1001));
        Cluster_Plot_lon(cc,:)=r_map.*cos(linspace(0,2*pi,1001));
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
    figure('units','normalized','outerposition',[0. 0.05 1 0.7])
    
    ax1=usamap('conus');
            
    framem off; gridm off; mlabel off; plabel off;
    ax1.Position=[-0.3,-2,0.6,0.6];
    
    geoshow(states,'FaceAlpha',0,'LineWidth',1,'EdgeColor',[0.75 0.75 0.75]);
    for cc=1:Num_Clusters
        plotm(lat(cc)+Cluster_Plot_lat(cc,:),lon(cc)+Cluster_Plot_lon(cc,:),'-','Color',CC(cc,:),'LineWidth',2); hold on;
    end
    
    subplot('Position',[0.621323529411765,0.1,0.370798319327731,0.89])
    for cc=1:Num_Clusters
        if(Year_Start(cc)<Year_End(cc))
            patch([Year_Start(cc) Year_Start(cc) Year_End(cc) Year_End(cc)],cc+[-0.45 0.45 0.45 -0.45],CC(cc,:),'LineStyle','none'); hold on
        else
            patch([Year_Start(cc)-0.01 Year_Start(cc)-0.01 Year_End(cc)+0.01 Year_End(cc)+0.01],cc+[-0.45 0.45 0.45 -0.45],CC(cc,:),'LineStyle','none'); hold on
        end
    end
    set(gca,'tickdir','out','Fontsize',14,'Xtick',[2017:2023],'XTickLabel',XL,'LineWidth',2,'YTickLabel',lg_lbl,'YTick',[1:Num_Clusters])
    box off;
    xlabel('School year','Fontsize',14)
    ylim([0.5 Num_Clusters+0.5])
    xlim([2017-0.25 2023+0.25])
    text(-1.665,0.98,'A','FontSize',30,'Units','normalized')
    text(-0.185,0.98,'B','FontSize',30,'Units','normalized')
       
   
    ax1.Position=[-0.38,-0.23,1.35,1.35];

    exportgraphics(gcf, 'Figure_3.pdf','ContentType','vector');
end





function Map_Impact_Trust_and_Uninsured_Overall(Vac_Nam)
clc;
close all;

S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));
for ii=1:length(State_FIP)
State_FIP(ii)=str2double(State_FIPc{ii});
end
S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

County_ID_temp={S.GEOID};
County_ID=zeros(size(County_ID_temp));
for ii=1:length(County_ID)
    County_ID(ii)=str2double(County_ID_temp{ii});
end

if(strcmp(Vac_Nam,'IPV'))
    load(['Impact_Trust_Medicine_Science_on_Uptake_Polio_2021_Overall_Weight.mat'],'dvds','dvdm','dvdu','vac_d');
else
    load(['Impact_Trust_Medicine_Science_on_Uptake_' Vac_Nam '_2021_Overall_Weight.mat'],'dvds','dvdm','dvdu','vac_d');
end
dvdu=-dvdu; % Want to examine the increase in insurance not an increase in the proportion uninsured
dvdu(dvdu>=0.5)=0.5-10^(-8);
vac_d=real(vac_d);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Trust in medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    C_uptake=[hex2rgb('#543005');
hex2rgb('#8c510a');
hex2rgb('#bf812d');
hex2rgb('#dfc27d');
hex2rgb('#f6e8c3');
hex2rgb('#35978f')];
    c_indx_uptake=[1:size(C_uptake,1)];
c_bound_uptake=[0 80;
         80 85;
         85 90;
         90 93;
         93 95;
         95 101]./100;

C_med=[hex2rgb('#f1eef6');
hex2rgb('#d0d1e6');
hex2rgb('#a6bddb');
hex2rgb('#74a9cf');
hex2rgb('#3690c0');
hex2rgb('#0570b0');
hex2rgb('#034e7b');];
c_indx_med=[1:size(C_med,1)];
c_bound_med=[0 0.005;
             0.005 0.01;
             0.01 0.015;
             0.015 0.02
             0.02 0.025
             0.025 0.03
             0.03 0.035];

C_sci=[hex2rgb('#ffffcc');
hex2rgb('#c2e699');
hex2rgb('#78c679');
hex2rgb('#31a354');
hex2rgb('#006837');];
c_indx_sci=[1:size(C_sci,1)];
c_bound_sci=[0 0.04;
             0.04 0.08;
             0.08 0.12;
             0.12 0.16;
             0.16 0.20;];


C_ins=[hex2rgb('#f2f0f7');
hex2rgb('#cbc9e2');
hex2rgb('#9e9ac8');
hex2rgb('#756bb1');
hex2rgb('#54278f');];
c_indx_ins=[1:size(C_ins,1)];
c_bound_ins=[0 0.1;
             0.1 0.2;
             0.2 0.3;
             0.3 0.4;
             0.4 0.5;];

     figure('units','normalized','outerposition',[0 0.075 1 1]);
     ax1=usamap('conus');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Uptake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    framem off; gridm off; mlabel off; plabel off;
    ax1.Position=[-0.3,0.4,0.6,0.6];
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax1, states,'Facecolor','none','LineWidth',0.5); hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ax2=usamap('conus');
    
    framem off; gridm off; mlabel off; plabel off;
    ax2.Position=[1.7,0.4,0.6,0.6];
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax2, states,'Facecolor','none','LineWidth',0.5); hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ax3=usamap('conus');
    
    framem off; gridm off; mlabel off; plabel off;
    ax3.Position=[-0.3,-0.1,0.6,0.6];
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax3, states,'Facecolor','none','LineWidth',0.5); hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Insurance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ax4=usamap('conus');
    
    framem off; gridm off; mlabel off; plabel off;
    ax4.Position=[1.7,-0.1,0.6,0.6];
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax4, states,'Facecolor','none','LineWidth',0.5); hold on;


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Uptake: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('Position',[0.41,0.525,0.01,0.45]);
    xlim([0 1]);
    ylim([0 max(c_indx_uptake)]);    
    ymin=2.25;
    dy=2/(1+sqrt(5));
    for ii=1:length(c_indx_uptake)
        patch([0 0 dy dy],c_indx_uptake(ii)-[1 0 0 1],C_uptake(ii,:),'LineStyle','none');
    end
    
    
    for mm=1:length(c_indx_uptake)
        text(ymin,mm-1,[num2str(100.*c_bound_uptake(mm,1),'%3.0f') '%'],'HorizontalAlignment','center','Fontsize',16);
    end
    text(ymin,length(c_indx_uptake),[num2str(100,'%3.0f') '%'],'HorizontalAlignment','center','Fontsize',16);
    text(ymin+2.5,max(c_indx_uptake)./2,{[Vac_Nam ' uptake']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    
text(-40,1,'A','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Science: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the colour bar
    subplot('Position',[0.41,0.025,0.01,0.45]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 max(c_indx_sci)]); 
    ymin=2.25;
    dy=2/(1+sqrt(5));
    for ii=1:length(c_indx_sci)
        patch([0 0 dy dy],c_indx_sci(ii)-[1 0 0 1],C_sci(ii,:),'LineStyle','none');
    end
    for mm=1:length(c_indx_sci)
        text(ymin,mm-1,[num2str(c_bound_sci(mm,1),'%3.2f')],'HorizontalAlignment','center','Fontsize',16);
    end
    text(ymin,length(c_bound_sci),[num2str(c_bound_sci(end,2),'%3.2f')],'HorizontalAlignment','center','Fontsize',16);

    text(ymin+2.5,mean([0 max(c_indx_sci)]),{['Elasticity of trust in science']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    
text(-40,1,'C','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Medicien: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('Position',[0.885,0.525,0.01,0.45]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 max(c_indx_med)]); 
    ymin=2.25;
    dy=2/(1+sqrt(5));
    
    for ii=1:length(c_indx_med)
        patch([0 0 dy dy],c_indx_med(ii)-[1 0 0 1],C_med(ii,:),'LineStyle','none');
    end
    for mm=1:length(c_indx_med)
        text(ymin,mm-1,[num2str(c_bound_med(mm,1),'%4.3f')],'HorizontalAlignment','center','Fontsize',16);
    end
    text(ymin,length(c_indx_med),[num2str(c_bound_med(end,2),'%4.3f')],'HorizontalAlignment','center','Fontsize',16);

    text(ymin+2.5,mean([0 max(c_indx_med)]),{['Elasticity of trust in medicine']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    
text(-40,1,'B','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Insurance: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('Position',[0.885,0.025,0.01,0.45]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 max(c_indx_ins)]);    
    ymin=2.25;
    dy=2/(1+sqrt(5));

    for ii=1:length(c_indx_ins)
        patch([0 0 dy dy],c_indx_ins(ii)-[1 0 0 1],C_ins(ii,:),'LineStyle','none');
    end
    for mm=1:length(c_indx_ins)
        text(ymin,mm-1,[num2str(c_bound_ins(mm,1),'%3.2f')],'HorizontalAlignment','center','Fontsize',16);
    end
    text(ymin,length(c_indx_ins),[num2str(c_bound_ins(end,2),'%3.2f') '+'],'HorizontalAlignment','center','Fontsize',16);
    text(ymin+2.5,mean([0 max(c_indx_ins)]),{['Elasticity of proportion insured']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;     
    text(-40,1,'D','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% relocate maps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ax1.Position=[-0.075,0.425,0.6,0.6];
    ax2.Position=[0.4,0.425,0.6,0.6];
    ax3.Position=[-0.075,-0.075,0.6,0.6];
    ax4.Position=[0.4,-0.075,0.6,0.6];

    NS=length(County_ID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Store the colours to be plotted
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CC_county_uptake=ones(length(County_ID),3);
    CC_county_med=ones(length(County_ID),3);
    CC_county_sci=ones(length(County_ID),3);
    CC_county_ins=ones(length(County_ID),3);
    
    for ii=1:length(County_ID)
        if(~isnan(vac_d(ii)))
            CC_county_uptake(ii,:)=C_uptake(c_indx_uptake(vac_d(ii)>=c_bound_uptake(:,1) & vac_d(ii)<c_bound_uptake(:,2)),:);
        else
            CC_county_uptake(ii,:)=[0.7 0.7 0.7];
        end

        if(~isnan(dvdm(ii)))
            CC_county_med(ii,:)=C_med(c_indx_med(dvdm(ii)>=c_bound_med(:,1) & dvdm(ii)<c_bound_med(:,2)),:);%interp1(x_med,C_med,dvdm(ii));
        else
            CC_county_med(ii,:)=[0.7 0.7 0.7];
        end

        if(~isnan(dvds(ii)))
            CC_county_sci(ii,:)=C_sci(c_indx_sci(dvds(ii)>=c_bound_sci(:,1) & dvds(ii)<c_bound_sci(:,2)),:);%interp1(x_sci,C_sci,dvds(ii));
        else
            CC_county_sci(ii,:)=[0.7 0.7 0.7];
        end

        if(~isnan(dvdu(ii)))
            CC_county_ins(ii,:)=C_ins(c_indx_ins(dvdu(ii)>=c_bound_ins(:,1) & dvdu(ii)<c_bound_ins(:,2)),:);%interp1(x_ins,C_ins,dvdu(ii));
        else
            CC_county_ins(ii,:)=[0.7 0.7 0.7];
        end
    end
        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot uptake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_uptake});
    
    geoshow(ax1,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax1, states,'Facecolor','none','LineWidth',1.5); hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_med});
    
    geoshow(ax2,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax2, states,'Facecolor','none','LineWidth',1.5); hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_sci});
    
    geoshow(ax3,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax3, states,'Facecolor','none','LineWidth',1.5); hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot insurance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_ins});
    
    geoshow(ax4,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax4, states,'Facecolor','none','LineWidth',1.5); hold on;

print(gcf,['Map_' Vac_Nam '_Overall_Weight.png'],'-dpng','-r600');
end
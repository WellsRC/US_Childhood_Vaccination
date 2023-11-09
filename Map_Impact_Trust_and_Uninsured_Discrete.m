function Map_Impact_Trust_and_Uninsured_Discrete(Vac_Nam,per_inc)
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
    load(['Impact_Trust_Medicine_Science_on_Uptake_Polio_2021_Disccrete_percent_inc=' num2str(per_inc*100) '.mat']);
else
    load(['Impact_Trust_Medicine_Science_on_Uptake_' Vac_Nam '_2021_Disccrete_percent_inc=' num2str(per_inc*100) '.mat']);
end
dvdu=-(Vac_u-Vac_v)./du'; 
dvdu(dvdu>0.5)=0.5;
dvds=(Vac_s-Vac_v)./ds';
dvdm=(Vac_m-Vac_v)./dm';
vac_d=Vac_plot;
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

C_med=[hex2rgb('#fff7fb');
hex2rgb('#ece7f2');
hex2rgb('#d0d1e6');
hex2rgb('#a6bddb');
hex2rgb('#74a9cf');
hex2rgb('#3690c0');
hex2rgb('#0570b0');
hex2rgb('#045a8d');
hex2rgb('#023858');];
x_med=linspace(0,0.02,size(C_med,1));

C_sci=[hex2rgb('#ffffe5');
hex2rgb('#f7fcb9');
hex2rgb('#d9f0a3');
hex2rgb('#addd8e');
hex2rgb('#78c679');
hex2rgb('#41ab5d');
hex2rgb('#238443');
hex2rgb('#006837');
hex2rgb('#004529');];
x_sci=linspace(0,0.1,size(C_sci,1));

C_ins=[hex2rgb('#fff7f3');
hex2rgb('#fde0dd');
hex2rgb('#fcc5c0');
hex2rgb('#fa9fb5');
hex2rgb('#f768a1');
hex2rgb('#dd3497');
hex2rgb('#ae017e');
hex2rgb('#7a0177');
hex2rgb('#49006a');];
x_ins=linspace(0,0.5,size(C_ins,1));

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Science: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create the colour bar
    subplot('Position',[0.41,0.025,0.01,0.45]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 1]);    
    ymin=2.25;
    dy=2/(1+sqrt(5));
    for ii=1:length(dx)-1
        patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(x_sci,C_sci,min(x_sci)+(max(x_sci)-min(x_sci)).*dx(ii)),'LineStyle','none');
    end
    x_sci_t=[0:0.02:0.1];
    dx_t=(x_sci_t-min(x_sci))./(max(x_sci)-min(x_sci));
    for mm=1:length(x_sci_t)
        text(ymin,dx_t(mm),num2str(x_sci_t(mm),'%3.2f'),'HorizontalAlignment','center','Fontsize',18);
    end
    text(ymin+2.5,0.5,{['Elasticity of trust in science']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Medicien: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('Position',[0.885,0.525,0.01,0.45]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 1]);    
    ymin=2.25;
    dy=2/(1+sqrt(5));
    for ii=1:length(dx)-1
        patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(x_med,C_med,min(x_med)+(max(x_med)-min(x_med)).*dx(ii)),'LineStyle','none');
    end
    x_med_t=[0:0.01:0.02];
    dx_t=(x_med_t-min(x_med))./(max(x_med)-min(x_med));
    for mm=1:length(x_med_t)
        text(ymin,dx_t(mm),num2str(x_med_t(mm),'%3.2f'),'HorizontalAlignment','center','Fontsize',18);
    end

    text(ymin+2.5,0.5,{['Elasticity of trust in medicine']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Insurance: colour bar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    subplot('Position',[0.885,0.025,0.01,0.45]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 1]);    
    ymin=2.25;
    dy=2/(1+sqrt(5));
    for ii=1:length(dx)-1
        patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(x_ins,C_ins,min(x_ins)+(max(x_ins)-min(x_ins)).*dx(ii)),'LineStyle','none');
    end
    x_ins_t=[0:0.1:0.5];
    dx_t=(x_ins_t-min(x_ins))./(max(x_ins)-min(x_ins));
    for mm=1:length(x_ins_t)-1
        text(ymin,dx_t(mm),num2str(x_ins_t(mm),'%3.2f'),'HorizontalAlignment','center','Fontsize',18);
    end
    mm=length(x_ins_t);
    text(ymin,dx_t(mm),[num2str(x_ins_t(mm),'%3.2f') '+'],'HorizontalAlignment','center','Fontsize',18);
    text(ymin+2.5,0.5,{['Elasticity of proportion insured']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;     
    
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
            CC_county_med(ii,:)=interp1(x_med,C_med,dvdm(ii));
        else
            CC_county_med(ii,:)=[0.7 0.7 0.7];
        end

        if(~isnan(dvds(ii)))
            CC_county_sci(ii,:)=interp1(x_sci,C_sci,dvds(ii));
        else
            CC_county_sci(ii,:)=[0.7 0.7 0.7];
        end

        if(~isnan(dvdu(ii)))
            CC_county_ins(ii,:)=interp1(x_ins,C_ins,dvdu(ii));
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

print(gcf,['Map_' Vac_Nam '_percent_inc=' num2str(per_inc*100) '.png'],'-dpng','-r600');
end
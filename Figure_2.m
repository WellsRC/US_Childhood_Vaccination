function Figure_2(Year_Inq)
clc;
close all;

S=shaperead([pwd '/Spatial_Data/Demographic_Data/cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
    State_FIP(ii)=str2double(State_FIPc{ii});
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

[~,County_ID,~]=Read_ID_Number();

Vac_Nam_v={'MMR','DTaP','Polio','VAR'};
Vac_Title_v={'MMR','DTaP','IPV','VAR'};
Vac_Uptake_v=zeros(length(County_ID),length(Vac_Nam_v));
NSamp=10^4;
Vac_Uptake_All_v=zeros(length(Vac_Nam_v),length(County_ID),NSamp);
for vv=1:4
    [Vac_Uptake] = County_Immunization_Statistics(Vac_Nam_v{vv},Year_Inq,County_ID);
    Vac_Uptake_All_v(vv,:,:)=repmat(Vac_Uptake,1,NSamp);
    tf=isnan(Vac_Uptake);
    [Vac_Uptake(isnan(Vac_Uptake)),v_temp]=Approximated_County_Immunization_Statistics(Vac_Nam_v{vv},Year_Inq,County_ID(isnan(Vac_Uptake)));
    Vac_Uptake_All_v(vv,tf,:)=v_temp;
    Vac_Uptake_v(:,vv)=Vac_Uptake;
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
    
    
    switch vv
        case 1
            figure('units','normalized','outerposition',[0 0.075 1 1]);
             ax1=usamap('conus');
        
            framem off; gridm off; mlabel off; plabel off;
            ax1.Position=[-0.3,0.4,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax1, states,'Facecolor','none','LineWidth',0.5); hold on;
        case 2
            ax2=usamap('conus');
            
            framem off; gridm off; mlabel off; plabel off;
            ax2.Position=[1.7,0.4,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax2, states,'Facecolor','none','LineWidth',0.5); hold on;
        case 3
            ax3=usamap('conus');
            
            framem off; gridm off; mlabel off; plabel off;
            ax3.Position=[-0.3,-0.1,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax3, states,'Facecolor','none','LineWidth',0.5); hold on;
        case 4
            ax4=usamap('conus');
            
            framem off; gridm off; mlabel off; plabel off;
            ax4.Position=[1.7,-0.1,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax4, states,'Facecolor','none','LineWidth',0.5); hold on;
    end

    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Uptake: colour bar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch vv
        case 1
            subplot('Position',[0.41,0.525,0.01,0.45]);
        case 2
            subplot('Position',[0.885,0.525,0.01,0.45]);
        case 3
            subplot('Position',[0.41,0.025,0.01,0.45]);            
        case 4
            subplot('Position',[0.885,0.025,0.01,0.45]);
    end

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
        text(ymin+2.5,max(c_indx_uptake)./2,{[Vac_Title_v{vv} ' uptake']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
        axis off;    
        text(-40,1,char(64+vv),'FontSize',32,'Units','normalized');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % relocate maps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
        NS=length(County_ID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Store the colours to be plotted
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CC_county_uptake=ones(length(County_ID),3);
        
        for ii=1:length(County_ID)
            if(~isnan(Vac_Uptake(ii)))
                CC_county_uptake(ii,:)=C_uptake(c_indx_uptake(Vac_Uptake(ii)>=c_bound_uptake(:,1) & Vac_Uptake(ii)<c_bound_uptake(:,2)),:);
            else
                CC_county_uptake(ii,:)=[0.7 0.7 0.7];
            end
    
        end
            
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plot uptake
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_uptake});
        switch vv
            case 1
                geoshow(ax1,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax1, states,'Facecolor','none','LineWidth',1.5); hold on;
            case 2
                geoshow(ax2,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax2, states,'Facecolor','none','LineWidth',1.5); hold on;
            case 3
                geoshow(ax3,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax3, states,'Facecolor','none','LineWidth',1.5); hold on;
            case 4
                geoshow(ax4,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax4, states,'Facecolor','none','LineWidth',1.5); hold on;
        end
end

ax1.Position=[-0.075,0.425,0.6,0.6];
ax2.Position=[0.4,0.425,0.6,0.6];
ax3.Position=[-0.075,-0.075,0.6,0.6];
ax4.Position=[0.4,-0.075,0.6,0.6];

print(gcf,['Figure2.png'],'-dpng','-r600');
print(gcf,['Figure2.tiff'],'-dtiff','-r600');
for vv=1:4
    per_county=mean(Vac_Uptake_v(:,vv)>=0.95);
    per_county_samp=squeeze(Vac_Uptake_All_v(vv,:,:)>=0.95);
    per_county_samp=mean(per_county_samp,1);
    fprintf(['Percent of counties with ' Vac_Title_v{vv} ' coverage is 95%% or higher: ' num2str(100.*per_county,'%3.1f') '(' num2str(100.*prctile(per_county_samp,2.5),'%3.1f') '-' num2str(100.*prctile(per_county_samp,97.5),'%3.1f') ')/n']);
    per_county=mean(Vac_Uptake_v(:,vv)<0.90);
    per_county_samp=squeeze(Vac_Uptake_All_v(vv,:,:)<0.90);
    per_county_samp=mean(per_county_samp,1);
    fprintf(['Percent of counties with ' Vac_Title_v{vv} ' coverage is less than 90%%: ' num2str(100.*per_county,'%3.1f') '(' num2str(100.*prctile(per_county_samp,2.5),'%3.1f') '-' num2str(100.*prctile(per_county_samp,97.5),'%3.1f') ')/n']);
end

    
    per_county_samp=squeeze(Vac_Uptake_All_v(1,:,:)>=0.95) & squeeze(Vac_Uptake_All_v(2,:,:)>=0.95) & squeeze(Vac_Uptake_All_v(3,:,:)>=0.95) & squeeze(Vac_Uptake_All_v(4,:,:)>=0.95);
    per_county_samp=mean(per_county_samp,1);

    per_county=mean(Vac_Uptake_v(:,1)>=0.95 & Vac_Uptake_v(:,2)>=0.95 & Vac_Uptake_v(:,3)>=0.95 & Vac_Uptake_v(:,4)>=0.95);
    fprintf(['Percent of counties coverage 95%% or higher for all: ' num2str(100.*per_county,'%3.1f') '(' num2str(100.*prctile(per_county_samp,2.5),'%3.1f') '-' num2str(100.*prctile(per_county_samp,97.5),'%3.1f') ')/n']);

    per_county_samp=squeeze(Vac_Uptake_All_v(1,:,:)<0.9) & squeeze(Vac_Uptake_All_v(2,:,:)<0.9) & squeeze(Vac_Uptake_All_v(3,:,:)<0.9) & squeeze(Vac_Uptake_All_v(4,:,:)<0.9);
    per_county_samp=mean(per_county_samp,1);

    per_county=mean(Vac_Uptake_v(:,1)<0.9 & Vac_Uptake_v(:,2)<0.9 & Vac_Uptake_v(:,3)<0.9 & Vac_Uptake_v(:,4)<0.9);
    fprintf(['Percent of counties coverage less than 90%% for all: ' num2str(100.*per_county,'%3.1f') '(' num2str(100.*prctile(per_county_samp,2.5),'%3.1f') '-' num2str(100.*prctile(per_county_samp,97.5),'%3.1f') ')/n']);

end
function Supplement_Figure_Elasticity_Insurance
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

Vac_Nam_v={'MMR','DTaP','IPV','VAR'};
for vv=1:4
    Vac_Nam=Vac_Nam_v{vv};
    if(strcmp(Vac_Nam,'IPV'))
        load(['Impact_Trust_Medicine_Science_on_Uptake_Polio_2021_Overall_Weight.mat'],'dvdu');
    else
        load(['Impact_Trust_Medicine_Science_on_Uptake_' Vac_Nam '_2021_Overall_Weight.mat'],'dvdu');
    end
    dvdx=-dvdu; % Want to examine the increase in insurance not an increase in the proportion uninsured
    dvdx(dvdx>=0.5)=0.5-10^(-8);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Trust in medicine
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
   
    C_Elastic=[hex2rgb('#f2f0f7');
    hex2rgb('#cbc9e2');
    hex2rgb('#9e9ac8');
    hex2rgb('#756bb1');
    hex2rgb('#54278f');];
    c_indx_ela=[1:size(C_Elastic,1)];
    c_bound_ela=[0 0.1;
                 0.1 0.2;
                 0.2 0.3;
                 0.3 0.4;
                 0.4 0.5;];
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
    %%  colour bar
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
        ylim([0 max(c_indx_ela)]);    
        ymin=2.25;
        dy=2/(1+sqrt(5));
         for ii=1:length(c_indx_ela)
            patch([0 0 dy dy],c_indx_ela(ii)-[1 0 0 1],C_Elastic(ii,:),'LineStyle','none');
        end
        for mm=1:length(c_indx_ela)
            text(ymin,mm-1,[num2str(c_bound_ela(mm,1),'%4.3f')],'HorizontalAlignment','center','Fontsize',16);
        end
        text(ymin,length(c_indx_ela),[num2str(c_bound_ela(end,2),'%4.3f') '+'],'HorizontalAlignment','center','Fontsize',16);
        
    
        text(ymin+2.5,mean([0 max(c_indx_ela)]),{['Elasticity of proportion insured']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
        axis off;     
        text(-40,1,char(64+vv),'FontSize',32,'Units','normalized');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % relocate maps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
        NS=length(County_ID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Store the colours to be plotted
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        CC_county_ela=ones(length(County_ID),3);
        
        for ii=1:length(County_ID)
            if(~isnan(dvdx(ii)))
                CC_county_ela(ii,:)=C_Elastic(c_indx_ela(dvdx(ii)>=c_bound_ela(:,1) & dvdx(ii)<c_bound_ela(:,2)),:);%interp1(x_med,C_med,dvdx(ii));
            else
                CC_county_ela(ii,:)=[0.7 0.7 0.7];
            end
        end
            
            
           
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plot uptake
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_ela});
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
print(gcf,['Supplement_Elastic_Insurance.png'],'-dpng','-r600');
end
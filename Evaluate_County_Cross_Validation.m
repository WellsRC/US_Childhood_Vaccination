clc;
close all;

S=shaperead([pwd '/Spatial_Data/Demographic_Data/cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
    State_FIP(ii)=str2double(State_FIPc{ii});
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

[~,County_ID_All,~]=Read_ID_Number();

Year_Inq=2017:2022;

Vac_Nam_v={'MMR','DTaP','Polio','VAR'};
Vac_Name={'MMR','DTaP','IPV','VAR'};

Year=cell(4.*length(Year_Inq),1);
Vaccine=cell(4.*length(Year_Inq),1);
for vv=1:length(Vac_Name)
    for yy=1:length(Year_Inq)
        Year{yy+(vv-1).*length(Year_Inq)}=[num2str(Year_Inq(yy)) char(8211) num2str(Year_Inq(yy)-1999)];
        Vaccine{yy+(vv-1).*length(Year_Inq)}=Vac_Name{vv};
    end
end

Mean_Error=cell(4.*length(Year_Inq),1);
Median_Error=cell(4.*length(Year_Inq),1);
Error_within_5=cell(4.*length(Year_Inq),1);
Error_Vac=cell(4,length(Year_Inq));
Error_Vac_County=cell(4,length(Year_Inq));
NSamp=10^5;
for vv=1:length(Vac_Name)
    for yy=1:length(Year_Inq)
        [Vac_Uptake_Data] = County_Immunization_Statistics(Vac_Nam_v{vv},Year_Inq(yy),County_ID_All);
        
        [Avg_Model_Vac_Uptake,~]=Approximated_County_Immunization_Statistics(Vac_Nam_v{vv},Year_Inq(yy),County_ID_All(~isnan(Vac_Uptake_Data)),NSamp);

        County_ID=County_ID_All(~isnan(Vac_Uptake_Data));
        Vac_Uptake_Data=Vac_Uptake_Data(~isnan(Vac_Uptake_Data));
    
        Diff_V=abs(100.*(Avg_Model_Vac_Uptake-Vac_Uptake_Data));
        Error_Vac{vv,yy}=100.*(Avg_Model_Vac_Uptake-Vac_Uptake_Data);
        Error_Vac_County{vv,yy}=County_ID(~isnan(Vac_Uptake_Data));
        Mean_Error{yy+(vv-1).*length(Year_Inq)}=[num2str(mean(Diff_V),'%3.2f') '%'];
        Median_Error{yy+(vv-1).*length(Year_Inq)}=[num2str(median(Diff_V),'%3.2f') '%'];
        Error_within_5{yy+(vv-1).*length(Year_Inq)}=[num2str(sum(Diff_V<=5)./length(Diff_V),'%4.3f')];
    end
end

T=table(Vaccine,Year,Mean_Error,Median_Error,Error_within_5);

writetable(T,'Tables_Supplement_Text.xlsx','Sheet','Table_S4');
close all;

Vac_Title_v={'MMR','DTaP','IPV','VAR'};
for yy=1:length(Year_Inq)
    for vv=1:4
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
        % Trust in medicine
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
            C_error=[hex2rgb('#67001f');
%                     hex2rgb('#b2182b');
%                     hex2rgb('#d6604d');
                    hex2rgb('#f4a582');
                    hex2rgb('#fddbc7');
                    hex2rgb('#ffffff');
                    hex2rgb('#d1e5f0');
                    hex2rgb('#92c5de');
%                     hex2rgb('#4393c3');
%                     hex2rgb('#2166ac');
                    hex2rgb('#053061')];
            c_indx_error=1:size(C_error,1);
        c_bound_error=[-100 -5;
                 -5 -3;
                 -3 -1;
                 -1 1;
                 1 3;
                 3 5;
                 5 100];
        
        
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
            ylim([0 max(c_indx_error)]);    
            ymin=2.25;
            dy=2/(1+sqrt(5));
            for ii=1:length(c_indx_error)
                patch([0 0 dy dy],c_indx_error(ii)-[1 0 0 1],C_error(ii,:),'LineStyle','none');
            end
            
            
            for mm=2:length(c_indx_error)
                text(ymin,mm-1,[num2str(c_bound_error(mm,1),'%3.0f') '%'],'HorizontalAlignment','center','Fontsize',16);
            end
            text(ymin,0,'<-5%','HorizontalAlignment','center','Fontsize',16);
            text(ymin,length(c_indx_error),'>5%','HorizontalAlignment','center','Fontsize',16);
            text(ymin+3,max(c_indx_error)./2,{[Vac_Title_v{vv} ' uptake error']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);

            text(ymin+1.5,max(c_indx_error).*0.25,{'Underestimate'},'HorizontalAlignment','center','Fontsize',12,'Rotation',270);

            text(ymin+1.5,max(c_indx_error).*0.75,{'Overestimate'},'HorizontalAlignment','center','Fontsize',12,'Rotation',270);

            axis off;    
            text(-40,1,char(64+vv),'FontSize',32,'Units','normalized');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % relocate maps
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
            NS=length(County_ID_All);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Store the colours to be plotted
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            CC_county_error=ones(length(County_ID_All),3);
            County_ID=Error_Vac_County{vv,yy};
            Error=Error_Vac{vv,yy};
            for ii=1:length(County_ID_All)
                if(ismember(County_ID_All(ii),County_ID))
                    t_f=County_ID_All(ii)==County_ID;
                    if(~isnan(Error(t_f)))
                        CC_county_error(ii,:)=C_error(c_indx_error(Error(t_f)>c_bound_error(:,1) & Error(t_f)<=c_bound_error(:,2)),:);
                    else
                        CC_county_error(ii,:)=[0.7 0.7 0.7];
                    end
                else
                    CC_county_error(ii,:)=[0.7 0.7 0.7];
                end
        
            end
                
                
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Plot uptake
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
            CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_error});
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

    print(gcf,['Error_Cross_Validation_Map_' num2str(Year_Inq(yy)) '.png'],'-dpng','-r600');
end



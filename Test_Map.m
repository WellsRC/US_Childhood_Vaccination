function Test_Map(Var_Plot)

% https://data.cdc.gov/Vaccinations/Vaccine-Hesitancy-for-COVID-19-County-and-local-es/q9mh-h2tw
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
    if(strcmp(Var_Plot,'Trust_in_Science')||strcmp(Var_Plot,'Trust_in_Medicine')||strcmp(Var_Plot,'MMR_Benefit_Political')||strcmp(Var_Plot,'MMR_School')||strcmp(Var_Plot,'Uninsured_19_under')||strcmp(Var_Plot,'Household_Children_under_18'))
        Year_Plot=[2019:2022];

        figure('units','normalized','outerposition',[0 0 0.5 0.75]);
        Raw_County_Factor_Plot_2019=Return_County_Data(Var_Plot,2019,County_ID);
        [~,CC_temp,Legend_label_Name,Y_Label_M,~,~]=Bounds_Plot_Colour(Var_Plot,2019,County_ID,Raw_County_Factor_Plot_2019);

        lbx=0;
        ubx=1;
        for jj=1:2
             % Create the colour bar
            subplot('Position',[0.931176470588234,0.025+0.375.*(jj-1),0.016827731092438,0.345]);
            dx=linspace(0,1,1001);
            xlim([0 1]);
            ylim([0 1]);    
            ymin=1.65;
            dy=2/(1+sqrt(5));
            for ii=1:length(dx)-1
                patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1([lbx (lbx+ubx)./2 ubx],CC_temp,lbx+(ubx-lbx).*dx(ii)),'LineStyle','none');
            end
            text(ymin,dx(1),['0'],'HorizontalAlignment','center','Fontsize',14);
            text(ymin,0.5,'0.5','HorizontalAlignment','center','Fontsize',14);
            text(ymin,dx(end),'1','HorizontalAlignment','center','Fontsize',14);
            text(3.3,0.5,'Relative trust','HorizontalAlignment','center','Fontsize',14,'Rotation',270);
            axis off; 
            
             % Create the colour bar
            subplot('Position',[0.425,0.025+0.375.*(jj-1),0.016827731092438,0.345]);
            dx=linspace(0,1,1001);
            xlim([0 1]);
            ylim([0 1]);    
            ymin=1.65;
            dy=2/(1+sqrt(5));
            for ii=1:length(dx)-1
                patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1([lbx (lbx+ubx)./2 ubx],CC_temp,lbx+(ubx-lbx).*dx(ii)),'LineStyle','none');
            end
            text(ymin,dx(1),['0'],'HorizontalAlignment','center','Fontsize',14);
            text(ymin,0.5,'0.5','HorizontalAlignment','center','Fontsize',14);
            text(ymin,dx(end),'1','HorizontalAlignment','center','Fontsize',14);
            text(3.3,0.5,'Relative trust','HorizontalAlignment','center','Fontsize',14,'Rotation',270);
            axis off;  
        end

        vp=subplot('Position',[0.082627118644068,0.755,0.85,0.22]);
        
        set(gca,'tickdir','out','LineWidth',2,'XTick',Year_Plot,'YTick',[0:0.2:1],'Yminortick','on','Fontsize',18);
        xlim([2018.5 2022.5]);
        ylim([0 1]);
        xlbp=Inf;
        xubp=-Inf;
        for jj=1:4
            ax=usamap('conus');

            framem off; gridm off; mlabel off; plabel off;
            ax.Position=[-0.095+0.45.*rem(jj-1,2),0.21-0.38.*floor((jj-1)./2),0.65,0.65];

            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;

            Raw_County_Factor_Plot=Return_County_Data(Var_Plot,Year_Plot(jj),County_ID);
            [County_Factor_Plot,CC_temp,~,~,Nat_Avg,Nat_std]=Bounds_Plot_Colour(Var_Plot,Year_Plot(jj),County_ID,Raw_County_Factor_Plot);
            pd = fitdist(Raw_County_Factor_Plot,'Kernel','Support',[0 1]);

            x_values=linspace(min(Raw_County_Factor_Plot),max(Raw_County_Factor_Plot),1001);
            xt_values=normcdf(x_values,Nat_Avg,Nat_std);
            yd = pdf(pd,x_values);
            yd=yd./max(yd);
            xlbp=min(xlbp,min(Raw_County_Factor_Plot));
            xubp=max(xubp,max(Raw_County_Factor_Plot));
            axes(vp) 
            ylim([xlbp xubp]);
            for ii=1:1000
                patch(Year_Plot(jj)+0.45.*[yd(ii) -yd(ii) -yd(ii+1) yd(ii+1)],[x_values(ii) x_values(ii) x_values(ii+1) x_values(ii+1)],interp1([lbx (lbx+ubx)./2 ubx],CC_temp,xt_values(ii)),'LineStyle','none'); hold on;
            end

            plot(Year_Plot(jj)+0.45.*yd,x_values,'k',Year_Plot(jj)-0.45.*yd,x_values,'k','LineWidth',1.5);

            CC_county=ones(length(County_ID_temp),3);

            for ii=1:length(County_ID)
                if(~isnan(County_Factor_Plot(ii)))
                    CC_county(ii,:)=interp1([lbx (lbx+ubx)./2 ubx],CC_temp,County_Factor_Plot(ii));
                else
                    CC_county(ii,:)=[0.7 0.7 0.7];
                end
            end        

            NS=length(County_ID_temp);


            CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
            title(ax,[num2str(Year_Plot(jj))],'Units','Normalized','Position',[0.5 0.86 0],'Fontsize',26)

            geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 

            geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;

        end  
        axes(vp) 
        ylabel(Y_Label_M);
        set(gca,'YTick',linspace(round(100.*xlbp),round(100.*xubp),3)./100)
        ylim([xlbp.*0.99 xubp.*1.01])
    elseif(strcmp(Var_Plot,'System_Trust'))
        FS={'Nurses','Doctors','Primary Physician','Healthcare System','Government Health Agencies','Pharmaceutical Companies'};
        FSP={'Nurses','Doctors','Primary Physician','Healthcare System','Health Agencies','Pharm. Companies'};
        
        
        figure('units','normalized','outerposition',[0 0 0.5 1]);
        Raw_County_Factor_Plot_2021=Return_County_Data(FS{1},2021,County_ID);
        [~,CC_temp,~,Y_Label_M,~,~]=Bounds_Plot_Colour(FS{1},2021,County_ID,Raw_County_Factor_Plot_2021);

        lbx=0;
        ubx=1;
        
        for jj=1:3
             % Create the colour bar
            subplot('Position',[0.931176470588234,0.025+0.25.*(jj-1),0.016827731092438,0.23]);
            dx=linspace(0,1,1001);
            xlim([0 1]);
            ylim([0 1]);    
            ymin=1.65;
            dy=2/(1+sqrt(5));
            for ii=1:length(dx)-1
                patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1([lbx (lbx+ubx)./2 ubx],CC_temp,lbx+(ubx-lbx).*dx(ii)),'LineStyle','none');
            end
            text(ymin,dx(1),['0'],'HorizontalAlignment','center','Fontsize',14);
            text(ymin,0.5,'0.5','HorizontalAlignment','center','Fontsize',14);
            text(ymin,dx(end),'1','HorizontalAlignment','center','Fontsize',14);
            text(3.3,0.5,'Relative trust','HorizontalAlignment','center','Fontsize',14,'Rotation',270);
            axis off; 
            
             % Create the colour bar
            subplot('Position',[0.425,0.025+0.25.*(jj-1),0.016827731092438,0.23]);
            dx=linspace(0,1,1001);
            xlim([0 1]);
            ylim([0 1]);    
            ymin=1.65;
            dy=2/(1+sqrt(5));
            for ii=1:length(dx)-1
                patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1([lbx (lbx+ubx)./2 ubx],CC_temp,lbx+(ubx-lbx).*dx(ii)),'LineStyle','none');
            end
            text(ymin,dx(1),['0'],'HorizontalAlignment','center','Fontsize',14);
            text(ymin,0.5,'0.5','HorizontalAlignment','center','Fontsize',14);
            text(ymin,dx(end),'1','HorizontalAlignment','center','Fontsize',14);
            text(3.3,0.5,'Relative trust','HorizontalAlignment','center','Fontsize',14,'Rotation',270);
            axis off;  
        end

        vp=subplot('Position',[0.082627118644068,0.813576494427557,0.85,0.165146909827761]);
        trust_v=zeros(1,6);
        for jj=1:6
            ax=usamap('conus');

            framem off; gridm off; mlabel off; plabel off;
            ax.Position=[-0.08+0.49.*rem(jj-1,2),0.325-0.25.*floor((jj-1)./2),0.6,0.6];

            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;

            Raw_County_Factor_Plot=Return_County_Data(FS{jj},2021,County_ID);
            [County_Factor_Plot,CC_temp,~,~,Nat_Avg,Nat_std]=Bounds_Plot_Colour(FS{jj},2021,County_ID,Raw_County_Factor_Plot);
            trust_v(jj)=Nat_Avg;
            CC_county=ones(length(County_ID_temp),3);

            for ii=1:length(County_ID)
                if(~isnan(County_Factor_Plot(ii)))
                    CC_county(ii,:)=interp1([lbx (lbx+ubx)./2 ubx],CC_temp,County_Factor_Plot(ii));
                else
                    CC_county(ii,:)=[0.7 0.7 0.7];
                end
            end        

            NS=length(County_ID_temp);


            CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
            title(ax,[FS{jj}],'Units','Normalized','Position',[0.5 0.89 0],'Fontsize',12)

            geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 

            geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;

        end  
        axes(vp) 
        plot([1:6],trust_v,'k-o','LineWidth',2);
        box off;
        YTL=round(linspace(round(100.*min(trust_v)),round(100.*max(trust_v)),3)./100,2);
        set(gca,'tickdir','out','LineWidth',2,'XTick',[1:6],'YTick',YTL,'Yminortick','on','Fontsize',12,'XTickLabel',FSP);
        ylabel('Trust');
        xlim([0.9 6.1]);
        ylim([min(trust_v.*0.99) max(trust_v.*1.01)])
    else
        Raw_County_Factor_Plot=Return_County_Data(Var_Plot,2022,County_ID);
        

        lbx=0;
        ubx=1;
        
        figure('units','normalized','outerposition',[0 0 0.65 0.65]);
        
        ax=usamap('conus');

        framem off; gridm off; mlabel off; plabel off;
%         ax.Position=[-0.095+0.45.*rem(jj-1,2),0.21-0.38.*floor((jj-1)./2),0.65,0.65];

        states = shaperead('usastatelo', 'UseGeoCoords', true);
        geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;

        [County_Factor_Plot,CC_temp,~,~,Nat_Avg,Nat_std]=Bounds_Plot_Colour(Var_Plot,2022,County_ID,Raw_County_Factor_Plot);
%             pd = fitdist(Raw_County_Factor_Plot,'Kernel','Support',[0 1]);
% 
%             x_values=linspace(min(Raw_County_Factor_Plot),max(Raw_County_Factor_Plot),1001);
%             xt_values=normcdf(x_values,Nat_Avg,Nat_std);
%             yd = pdf(pd,x_values);
%             yd=yd./max(yd);
%             xlbp=min(xlbp,min(Raw_County_Factor_Plot));
%             xubp=max(xubp,max(Raw_County_Factor_Plot));
%             axes(vp) 
%             ylim([xlbp xubp]);
%             for ii=1:1000
%                 patch(Year_Plot(jj)+0.45.*[yd(ii) -yd(ii) -yd(ii+1) yd(ii+1)],[x_values(ii) x_values(ii) x_values(ii+1) x_values(ii+1)],interp1([lbx (lbx+ubx)./2 ubx],CC_temp,xt_values(ii)),'LineStyle','none'); hold on;
%             end
% 
%             plot(Year_Plot(jj)+0.45.*yd,x_values,'k',Year_Plot(jj)-0.45.*yd,x_values,'k','LineWidth',1.5);

        CC_county=ones(length(County_ID_temp),3);

        for ii=1:length(County_ID)
            if(~isnan(County_Factor_Plot(ii)))
                CC_county(ii,:)=interp1([lbx (lbx+ubx)./2 ubx],CC_temp,County_Factor_Plot(ii));
            else
                CC_county(ii,:)=[0.7 0.7 0.7];
            end
        end        

        NS=length(County_ID_temp);


        CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});

        geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 

        geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;
    end
    print(gcf,[Var_Plot '.png'],'-dpng','-r300');
end
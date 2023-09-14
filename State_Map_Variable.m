function State_Map_Variable(Var_1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Input
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Var_1: Variable of interest to plot
% 'Trust_in_Medicine','Trust_in_Science','Vaccine_Adverse_Events','Parental_Age','Under_5_Age','Sex','Race','Political','Education','Economic','Household_Children_under_18','Uninsured_19_under','Income'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Construct the plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_ID_temp={S.STATEFP};
State_ID=zeros(size(State_ID_temp));

for ii=1:length(State_ID)
  State_ID(ii)=str2double(State_ID_temp{ii});  
end


figure('units','normalized','outerposition',[0.2 0.2 0.7 0.8]);
y=zeros(length(State_ID),4);
for Year_Q=2018:2021
    
    if(strcmp(Var_1,'Trust_in_Medicine')||strcmp(Var_1,'Trust_in_Science')||strcmp(Var_1,'Vaccine_Adverse_Events'))
        y(:,Year_Q-2017)=Return_State_Data(Var_1,Year_Q,State_ID);
    elseif(strcmp(Var_1,'Parental_Age')||strcmp(Var_1,'Under_5_Age')||strcmp(Var_1,'Sex')||strcmp(Var_1,'Race')||strcmp(Var_1,'Political')||strcmp(Var_1,'Education')||strcmp(Var_1,'Economic')||strcmp(Var_1,'Household_Children_under_18')||strcmp(Var_1,'Uninsured_19_under')||strcmp(Var_1,'Income'))
        [State_Demo,Data_Year]=Demographics_State(Var_1,State_ID);
        y(:,Year_Q-2017)=State_Demo(:,Data_Year==Year_Q);
        clearvars State_Demo Data_Year
    elseif(strcmp(Var_1,'Medical_Exemption')||strcmp(Var_1,'Total_Exemption')||strcmp(Var_1,'DTaP')||strcmp(Var_1,'Polio')||strcmp(Var_1,'MMR'))
        y(:,Year_Q-2017) = State_Immunization_Statistics(Var_1,Year_Q,State_ID);
    else
        y(:,Year_Q-2017)=NaN.*ones(length(State_ID),1);
    end
end

[Legend_label_Name,C] = Legend_Variable_Text(Var_1);
if(max(y(:))<=1)
    xc=prctile(y(:),[0:10:100]);
else
    xc=(prctile(y(:),[0:10:100]));
    xc(1)=floor(xc(1));
    xc(end)=ceil(xc(end));
    xc(2:end-1)=round(xc(2:end-1));
end
Pos_Subplot=[-0.09,0.4,0.6,0.6;0.325,0.4,0.6,0.6;-0.09,-0.10,0.6,0.6;0.325,-0.10,0.6,0.6;];


% Create the colour bar
subplot('Position',[0.85,0.02,0.016827731092438,0.96]);
dx=linspace(0,1,1001);
xlim([0 1]);
ylim([0 1]);    
ymin=1.05;
dy=2/(1+sqrt(5));
for ii=1:length(dx)-1
    patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(xc,C,prctile(y(:),100.*dx(ii))),'LineStyle','none');
end
for mm=1:length(xc)
    if(max(xc)<=1)
        text(ymin,0.1.*(mm-1),num2str(xc(mm),'%4.3f'),'HorizontalAlignment','left','Fontsize',18);
    else
        text(ymin,0.1.*(mm-1),num2str(xc(mm)),'HorizontalAlignment','left','Fontsize',18);
    end
end
text(6.5,0.5,Legend_label_Name,'HorizontalAlignment','center','Fontsize',24,'Rotation',270);
axis off;   

for Year_Q=2018:2021
    
    ax=usamap('conus');
    
    framem off; gridm off; mlabel off; plabel off;
    ax.Position=Pos_Subplot(Year_Q-2017,:);
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;  
    
    NS=length(State_ID_temp);
    
    CC_county=ones(length(State_ID_temp),3);
    
    for ii=1:length(State_ID)
        if(~isnan(y(ii,Year_Q-2017)))
            CC_county(ii,:)=interp1(xc,C,y(ii,Year_Q-2017));
        else
            CC_county(ii,:)=[0.7 0.7 0.7];
        end
    end
        
        
    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
    title(ax,[num2str(Year_Q)],'Units','Normalized','Position',[0.5 0.9 0],'Fontsize',26)
    
    geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;
end
 
end
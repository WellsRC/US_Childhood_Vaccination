clear;
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

Yr=2021;
Var_Name={'Trust_in_Medicine','Trust_in_Science','Vaccine_Adverse_Events'};
X=zeros(length(County_ID),length(Var_Name));
Var_Name_Demo={'Parental_Age','Under_5_Age','Sex','Race','Political','Education','Economic','Household_Children_under_18','Uninsured_19_under','Income'};
D=zeros(length(County_ID),length(Var_Name_Demo));

for jj=1:length(Var_Name)
    X(:,jj)=Return_County_Data(Var_Name{jj},Yr,County_ID);
end

for jj=1:length(Var_Name_Demo)
    [County_Demo,Data_Year]=Demographics_County(Var_Name_Demo{jj},County_ID);
    D(:,jj)=County_Demo(:,Data_Year==Yr);
end
if(Yr>=2020)
    COVID=ones(length(County_ID),1);
else
    COVID=zeros(length(County_ID),1);
end


xt=[X D COVID];

County_ID=County_ID(~isnan(sum(xt,2)));
xt=xt(~isnan(sum(xt,2)),:);

Inq='Medical_Exemption';
load(['Regression_Beta_' Inq '.mat'],'reg_par')
beta_v=reg_par(1:15)';
 if(~strcmp('Religious_and_Philosophical_Exemption',Inq))
    y=County_Immunization_Statistics(Inq,Yr,County_ID);
else
    y=County_Immunization_Statistics('Philosophical_Exemption',Yr,County_ID);
    y=y+County_Immunization_Statistics('Religious_Exemption',Yr,County_ID);
 end

x_V=[log(xt(:,1:2)./(1-xt(:,1:2))) log(xt(:,3)) log(xt(:,4:12)./(1-xt(:,4:12))) log(xt(:,13)) xt(:,14)];
X=[ones(length(y),1) x_V];
for ii=1:length(y)
    if(isnan(y(ii)))
        a=10.^reg_par(16);
        b=exp(-X(ii,:)*beta_v);
        y(ii)=a./(a+b);
    end
end


C=[1 1 1; hex2rgb('F5BE41'); hex2rgb('F25C00'); 0.9 0 0; 1 0 0; 0 0 0];
xc=[0:0.01:0.05];
y_t=y;
y_t(y>xc(end))=xc(end);

figure('units','normalized','outerposition',[0 0 1 1]);
ax=usamap('conus');

framem off; gridm off; mlabel off; plabel off;
ax.Position=[-0.21,-0.15,1.14,1.14];

states = shaperead('usastatelo', 'UseGeoCoords', true);
geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;

% Create the colour bar
subplot('Position',[0.931176470588234,0.02,0.016827731092438,0.96]);
dx=linspace(0,1,1001);
xlim([0 1]);
ylim([0 1]);    
ymin=1.65;
dy=2/(1+sqrt(5));
for ii=1:length(dx)-1
    patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(xc,C,max(xc).*dx(ii)),'LineStyle','none');
end
for mm=1:length(xc)
    text(ymin,0.25.*(mm-1),num2str(xc(mm),'%4.3f'),'HorizontalAlignment','center','Fontsize',18);
end
% text(2.9,0.5,Legend_label_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
axis off;    

ax.Position=[-0.16,-0.24,1.32,1.32];

NS=length(County_ID_temp);

CC_county=ones(length(County_ID_temp),3);

for ii=1:length(County_ID)
    if(~isnan(y(ii)))
        CC_county(ii,:)=interp1(xc,C,y_t(ii));
    else
        CC_county(ii,:)=[0.7 0.7 0.7];
    end
end
    
    

CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
% title(ax,[num2str(Year_Plot)],'Units','Normalized','Position',[0.5 0.9 0],'Fontsize',26)

geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 

geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;

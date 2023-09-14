clear;
clc;

D=readtable('Data_Transformed_Combined.xlsx');
Y=D.Vaccine_Uptake;
X=[D.Education D.Income D.Race D.Trust_in_Medicine];
Var_Name={'Education','Income','Race','Trust_in_Medicine'};
Var_Name_Demo={'Sex','Race','Political','Education','Economic','Uninsured_19_under','Income'};
C=[D.Vaccine_Disease D.COVID D.State_Religous_Exemptions D.State_Philosophical_Exemptions];
Disease=2;
COVID=1;
Yr=2021;
Inq='DTaP';



State_Religous_Exemptions=0;
State_Philosophical_Exemptions=0;
t_f=C(:,1)==Disease & C(:,2)==COVID & C(:,3)==State_Religous_Exemptions & C(:,4)==State_Philosophical_Exemptions;
mdl_NRE_NPE=fitlm(X(t_f,:),Y(t_f));


State_Religous_Exemptions=1;
State_Philosophical_Exemptions=0;
t_f=C(:,1)==Disease & C(:,2)==COVID & C(:,3)==State_Religous_Exemptions & C(:,4)==State_Philosophical_Exemptions;
mdl_RE_NPE=fitlm(X(t_f,:),Y(t_f));

State_Religous_Exemptions=1;
State_Philosophical_Exemptions=1;
t_f=C(:,1)==Disease & C(:,2)==COVID & C(:,3)==State_Religous_Exemptions & C(:,4)==State_Philosophical_Exemptions;
mdl_RE_PE=fitlm(X(t_f,:),Y(t_f));


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

State_FIPc={S.STATEFP};
County_State_FIP=zeros(size(State_FIPc));
for ii=1:length(County_State_FIP)
    County_State_FIP(ii)=str2double(State_FIPc{ii});
end


N_Samp=50;
Rand_Indx=randi(1000,N_Samp,1);
Rand_Trust_S=randi(1000,N_Samp,2);
Rand_Trust_M=randi(1000,N_Samp,2);
V=zeros(length(County_ID),N_Samp);
for ss=1:N_Samp
    XC=NaN.*zeros(length(County_ID),size(X,2));
    for ii=1:size(X,2)
        if(ismember(Var_Name(ii),Var_Name_Demo))
            [County_Demo,Data_Year]=Demographics_County(Var_Name{ii},County_ID,Rand_Indx(ss));
            XC(:,ii)=County_Demo(:,Data_Year==Yr);
        else
            XC(:,ii)=Return_County_Data(Var_Name{ii},Yr,County_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));
        end
    end
    [RVE,PVE] = Exemption_Timeline(Yr,County_State_FIP);
    XC=[log(XC(:,1)./(1-XC(:,1))) log(XC(:,2)) log(XC(:,3:4)./(1-XC(:,3:4)))];
    temp=County_Immunization_Statistics(Inq,Yr,County_ID);
    temp=log(temp./(1-temp));
    temp(isnan(temp))=(1-RVE(isnan(temp))).*(1-PVE(isnan(temp))).*predict(mdl_NRE_NPE,XC(isnan(temp),:))+RVE(isnan(temp)).*(1-PVE(isnan(temp))).*predict(mdl_RE_NPE,XC(isnan(temp),:))+RVE(isnan(temp)).*PVE(isnan(temp)).*predict(mdl_RE_PE,XC(isnan(temp),:));
    V(:,ss)=1./(1+exp(-temp));
end
V=real(V);
V_final=median(V,2);

f_nan=find(isnan(V_final));

for jj=1:length(f_nan)
    V_temp=V(f_nan,:);
    V_final(f_nan(jj))=median(V_temp(~isnan(V_temp)));
end


C=[0.4 0 0;1 1 1; 0 0 0.4];
xc=[floor(100.*min(V_final))/100 0.9 1];
close all;
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
    patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(xc,C,min(xc)+(max(xc)-min(xc)).*dx(ii)),'LineStyle','none');
end


dx_t=(xc-min(xc))./(max(xc)-min(xc));
for mm=1:length(xc)
    text(ymin,dx_t(mm),num2str(xc(mm),'%4.3f'),'HorizontalAlignment','center','Fontsize',18);
end
% text(2.9,0.5,Legend_label_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
axis off;    

ax.Position=[-0.16,-0.24,1.32,1.32];

NS=length(County_ID_temp);

CC_county=ones(length(County_ID_temp),3);

for ii=1:length(County_ID)
    if(~isnan(V_final(ii)))
        CC_county(ii,:)=interp1(xc,C,V_final(ii));
    else
        CC_county(ii,:)=[0.7 0.7 0.7];
    end
end
    
    

CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
% title(ax,[num2str(Year_Plot)],'Units','Normalized','Position',[0.5 0.9 0],'Fontsize',26)

geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 

geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;

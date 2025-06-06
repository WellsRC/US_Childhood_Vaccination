clear;
clc;
close all;

X0=[11.3171457194310	-1.63209534187076	-0.0584853507409258	7.37960486262375	-1.75247195699290	-0.314982151150020	-3.83065772148720	-7.48300676887643	0.263840970826084	2.51924669102108	-0.0715370513796143	-2.97038554046058	7.12860898192751	7.09014409135754e-07	0.830125921067711	-4.54229209994511	-1.45879249759752	-4.98365604328836	-12.5350082169085	-4.92639663781218	-11.2482616362968	-5.92722801308092	-3.48300240837127	-6.63779453724477	3.15705464735068	-6.34433926589904	-0.383394427868640	3.21020947236639	-5.32173935729242	-14.4374894324876	-6.00589412198510	1.50341119469279	2.72119734067602	11.8491360417996	-0.0436148777006649	-0.238058783490285];

T=readtable([pwd '\Spatial_Data\County_Data.xlsx'],'Sheet',['Year_' num2str(2021)]);
X=T(:,17:end);

Under_5=[T.Population_Under_5.*T.Total_Population];
State_FIP=[str2double(T.State_FP)];

    Religious_Exemption=[T.MMR_Religious_Exemption];
    Philosophial_Exemption=[T.MMR_Philosophical_Exemption];

X=[table(Religious_Exemption,Philosophial_Exemption) X];
County_Data.X=table2array(X);

beta_X=X0(1:end-2);
v_model = Estimated_County_Vaccine_Uptake(beta_X,County_Data.X);

v_model(~isnan(T.MMR))=T.MMR(~isnan(T.MMR));

v_model(v_model<=0.8)=0.8;

S=shaperead([pwd '\Spatial_Data\Demographic_Data\Shapefile\cb_2021_us_county_20m.shp'],'UseGeoCoords',true);

v_county=NaN.*zeros(length(S),1);

for ii=1:length(S)
    tf=strcmp(S(ii).GEOID,T.GEOID);
    v_county(ii)=v_model(tf);
end


figure('units','normalized','outerposition',[0.1 0.15 0.6 0.7]);
 ax1=usamap('conus');

framem off; gridm off; mlabel off; plabel off;
ax1.Position=[-0.3,0.4,0.6,0.6];

geoshow(ax1, S,'Facecolor','none','LineWidth',0.25); hold on;

subplot('Position',[0.89,0.035,0.02,0.94]);

Title_Name={'Vaccine uptake'};

C_Risk=flip([hex2rgb('#fff7f3');
hex2rgb('#fde0dd');
hex2rgb('#fcc5c0');
hex2rgb('#fa9fb5');
hex2rgb('#f768a1');
hex2rgb('#dd3497');
hex2rgb('#ae017e');
hex2rgb('#7a0177');
hex2rgb('#49006a');]);

y_indx=linspace(0.8,1,size(C_Risk,1));
x_risk=y_indx;

 x_indx=y_indx;
 c_indx=linspace(y_indx(1),y_indx(end),1001);
dx=c_indx(2)-c_indx(1);
xlim([0 1]);
ylim([y_indx(1) y_indx(end)+dx])
ymin=0.75;
dy=2/(1+sqrt(5));
for ii=1:length(c_indx)
    patch([0 0 dy dy],c_indx(ii)+[dx -dx -dx dx],interp1(x_risk,C_Risk,c_indx(ii)),'LineStyle','none');
end

patch([0 0 dy dy], [y_indx(1) y_indx(end)+dx y_indx(end)+dx y_indx(1)],'k','FaceAlpha',0,'LineWidth',2);

yl_indx=[y_indx(1):y_indx(end)];

text(ymin,y_indx(1),['\leq' num2str(100.*y_indx(1),'%3.0f') '%'],'Fontsize',14);            

for yy=2:length(y_indx)
    text(ymin,y_indx(yy),[num2str(100.*y_indx(yy),'%3.0f') '%'],'Fontsize',14);            
end
          

text(ymin+2.65,mean([y_indx(1) y_indx(end)]),Title_Name,'HorizontalAlignment','center','Fontsize',18,'Rotation',270);

axis off;  

NS=length(S);
CC_Risk=interp1(x_risk,C_Risk,v_county);

CC_Risk(isnan(v_county),:)=repmat([0.5 0.5 0.5],sum(isnan(v_county)),1);

CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_Risk});
geoshow(ax1,S,'SymbolSpec',CM,'LineStyle','None'); 
geoshow(ax1, S,'Facecolor','none','LineWidth',0.25); hold on;
ax1.Position=[-0.22,-0.22,1.35,1.35];
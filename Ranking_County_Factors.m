clear;
clc;
close all;

Year_Plot=2022;


S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end


S_temp=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_FIP=State_FIP(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

[~,I]=sort(State_FIP);
S=S_temp(I);
S_ID_temp={S.GEOID};
S_ID=zeros(size(S_ID_temp));

for ii=1:length(S_ID)
  S_ID(ii)=str2double(S_ID_temp{ii});  
end


    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% Trust in Science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
load('Estimate_LR_Trust_Science.mat','beta_z','Factor_S');
[~,Data_Year]=Stratified_Trust_in_Science_County(Factor_S{1},S_ID);

X_t=zeros(length(Factor_S),length(S_ID),length(Data_Year));

for jj=1:length(Factor_S)        
    [County_Trust_in_Science_v,Data_Year]=Stratified_Trust_in_Science_County(Factor_S{jj},S_ID);
    X_t(jj,:,:)=County_Trust_in_Science_v;
    for yy=1:length(Data_Year)
        tt=squeeze(X_t(jj,:,yy));
        X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
    end
end
[~,County_Trust_in_Science_v]=County_Trust_Overall(beta_z,X_t);
    
County_Trust_in_Science=NaN.*zeros(size(S_ID));

for ii=1:length(S_ID)
    z_t=log(County_Trust_in_Science_v(ii,:)./(1-County_Trust_in_Science_v(ii,:)));
    z_new=pchip(Data_Year,z_t,Year_Plot);
    t_new=1./(1+exp(-z_new));
    County_Trust_in_Science(ii)=t_new;
end

Scale_Trust_Science=1-(County_Trust_in_Science-min(County_Trust_in_Science))./(max(County_Trust_in_Science)-min(County_Trust_in_Science));

Scale_Trust_Science(isnan(Scale_Trust_Science))=median(Scale_Trust_Science(~isnan(Scale_Trust_Science)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%% Trust in Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
 load('Estimate_LR_Trust_Medicine.mat','beta_z','Factor_S');
[~,Data_Year]=Stratified_Trust_in_Medicine_County(Factor_S{1},S_ID);

X_t=zeros(length(Factor_S),length(S_ID),length(Data_Year));

for jj=1:length(Factor_S)        
    [County_Trust_in_Medicine_v,Data_Year]=Stratified_Trust_in_Medicine_County(Factor_S{jj},S_ID);
    X_t(jj,:,:)=County_Trust_in_Medicine_v;
    for yy=1:length(Data_Year)
        tt=squeeze(X_t(jj,:,yy));
        X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
    end
end
[~,County_Trust_in_Medicine_v]=County_Trust_Overall(beta_z,X_t);

County_Trust_in_Medicine=NaN.*zeros(size(S_ID));

for ii=1:length(S_ID)
    z_t=log(County_Trust_in_Medicine_v(ii,:)./(1-County_Trust_in_Medicine_v(ii,:)));
    z_new=pchip(Data_Year,z_t,Year_Plot);
    t_new=1./(1+exp(-z_new));
    County_Trust_in_Medicine(ii)=t_new;
end

Scale_Trust_Medicine=1-(County_Trust_in_Medicine-min(County_Trust_in_Medicine))./(max(County_Trust_in_Medicine)-min(County_Trust_in_Medicine));

Scale_Trust_Medicine(isnan(Scale_Trust_Medicine))=median(Scale_Trust_Medicine(~isnan(Scale_Trust_Medicine)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MMR Benefit:Political
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[County_Demo,Data_Year]=Demographics_County('Political',S_ID);
z_temp=log(County_Demo./(1-County_Demo));

County_MMR_Benefit=NaN.*zeros(length(S_ID),1);
    
for jj=1:length(S_ID)
    z_new=pchip(Data_Year,z_temp(jj,:),Year_Plot);
    County_MMR_Benefit(jj)=1./(1+exp(-z_new));
end
vb_demo=1./(1+exp(-pchip([2019 2022],log([0.88 0.91]./(1-[0.88 0.91])),Year_Plot)));
vb_rep=1./(1+exp(-pchip([2019 2022],log([0.89 0.83]./(1-[0.89 0.83])),Year_Plot)));
County_MMR_Benefit=vb_demo.*County_MMR_Benefit+vb_rep.*(1-County_MMR_Benefit);

Scale_MMR_Benefit_P=1-(County_MMR_Benefit-min(County_MMR_Benefit))./(max(County_MMR_Benefit)-min(County_MMR_Benefit));

Scale_MMR_Benefit_P(isnan(Scale_MMR_Benefit_P))=median(Scale_MMR_Benefit_P(~isnan(Scale_MMR_Benefit_P)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MMR Benefit: COVID-19 Vac Status
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([pwd '\State_Data\County_Data\COVID_County_Uptake.mat'],'fip_2022','Vac_Cov_2022')

County_MMR_Benefit=NaN.*zeros(length(S_ID),1);
temp_sid=str2double(fip_2022); 
for jj=1:length(S_ID)
    tf= temp_sid== S_ID(jj);
    if(sum(tf)>0)
        County_MMR_Benefit(jj)=max(Vac_Cov_2022(tf)./100);
    end
end


County_MMR_Benefit=0.91.*County_MMR_Benefit+0.7.*(1-County_MMR_Benefit);
Scale_MMR_Benefit_V=1-(County_MMR_Benefit-min(County_MMR_Benefit))./(max(County_MMR_Benefit)-min(County_MMR_Benefit));

Scale_MMR_Benefit_V(isnan(Scale_MMR_Benefit_V))=median(Scale_MMR_Benefit_V(~isnan(Scale_MMR_Benefit_V)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVID Vaccination Hesitancy: Hesititant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load([pwd '\State_Data\COVID_Vaccine_Hesitant_County.mat']);
    
County_Hesitation=zeros(length(S_ID),1);
hs=COVID_Vac.hesitant;
for jj=1:length(County_Hesitation)
   tf=COVID_Vac.fips==S_ID(jj);
   County_Hesitation(jj)=mean(hs(tf));
end

Scale_Hesitant=(County_Hesitation-min(County_Hesitation))./(max(County_Hesitation)-min(County_Hesitation));

Scale_Hesitant(isnan(Scale_Hesitant))=median(Scale_Hesitant(~isnan(Scale_Hesitant)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COVID Vaccination Hesitancy: Strongly Hesititant
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load([pwd '\State_Data\COVID_Vaccine_Hesitant_County.mat']);
    
County_Hesitation=zeros(length(S_ID),1);
hs=COVID_Vac.strongly_hesitant;
for jj=1:length(County_Hesitation)
   tf=COVID_Vac.fips==S_ID(jj);
   County_Hesitation(jj)=mean(hs(tf));
end

Scale_Strongly_Hesitant=(County_Hesitation-min(County_Hesitation))./(max(County_Hesitation)-min(County_Hesitation));

Scale_Strongly_Hesitant(isnan(Scale_Strongly_Hesitant))=median(Scale_Strongly_Hesitant(~isnan(Scale_Strongly_Hesitant)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Average 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Scale=(Scale_Strongly_Hesitant(:)+Scale_Hesitant(:)+Scale_MMR_Benefit_V(:)+Scale_MMR_Benefit_P(:)+Scale_Trust_Medicine(:)+Scale_Trust_Science(:))./6;

Scale_Norm=(Scale-min(Scale))./(max(Scale)-min(Scale));


CC_temp=[hex2rgb('#0571b0');1 1 1;hex2rgb('#ca0020')];
CC_county=interp1([0 0.5 1],CC_temp,Scale_Norm);



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
        patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1([0 0.5 1],CC_temp,dx(ii)),'LineStyle','none');
    end
    text(ymin,dx(1),['Low'],'HorizontalAlignment','center','Fontsize',18);
    text(ymin,dx(end),['High'],'HorizontalAlignment','center','Fontsize',18);
    text(3.21875,0.5,['Risk of decline in coverage'],'Rotation',270,'HorizontalAlignment','center','Fontsize',20);
    axis off;    
    
    ax.Position=[-0.16,-0.24,1.32,1.32];
    
    NS=length(S_ID_temp);
    
    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
    title(ax,[ num2str(Year_Plot)],'Units','Normalized','Position',[0.5 0.9 0],'Fontsize',26)
    
    geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;
    
    print(gcf,['Average_Ranking_Year=' num2str(Year_Plot) '.png'],'-dpng','-r300');

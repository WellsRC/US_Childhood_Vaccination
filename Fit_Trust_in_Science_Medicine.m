clear;
S=shaperead([pwd '\State_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);


S_ID_temp={S.GEOID};
S_ID=zeros(size(S_ID_temp));

for ii=1:length(S_ID)
  S_ID(ii)=str2double(S_ID_temp{ii});  
end


% Factor_S={'Age','Sex','Economic','Race','Education','Political'};
Factor_S={'Political'};
[County_Trust_in_Science,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},S_ID);

S_X_t=zeros(length(Factor_S),length(S_ID),length(Data_Year));
M_X_t=zeros(length(Factor_S),length(S_ID),length(Data_Year));

for jj=1:length(Factor_S)        
    [County_Trust_in_Science,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},S_ID);
    S_X_t(jj,:,:)=County_Trust_in_Science;
    M_X_t(jj,:,:)=County_Trust_in_Medicine;
    for yy=1:length(Data_Year)
        tt=squeeze(S_X_t(jj,:,yy));
        S_X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
        tt=squeeze(M_X_t(jj,:,yy));
        M_X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
    end
end

load([pwd '\State_Data\Trust_in_Science_Stratification.mat']);

Y_t=Trust_in_Science.National.Great_Deal+0.5.*Trust_in_Science.National.Only_Some;
Z_t=log(Y_t./(1-Y_t));
Z_t=Z_t(ismember(Trust_Year_Data,Data_Year));

load([pwd '\State_Data\Trust_in_Medicine_Stratification.mat']);

Y_t=Trust_in_Medicine.National.Great_Deal+0.5.*Trust_in_Medicine.National.Only_Some;
M_t=log(Y_t./(1-Y_t));
M_t=M_t(ismember(Trust_Year_Data,Data_Year));

[county_weight,year_weight,state_ID_weight,county_ID_weight,US_weight]=Return_Population_Weight_County();

w_c=zeros(length(S_ID),length(Data_Year));

for jj=1:length(w_c)
    tf=county_ID_weight == S_ID(jj); 
    if(sum(tf)>0)
        w_c(jj,:)= US_weight(tf,ismember(Data_Year,year_weight));
    end
end

for ii=1:length(Data_Year)
    w_c(:,ii)=w_c(:,ii)./sum(w_c(:,ii));
end
        
beta_z_Science=zeros(10^4,length(Factor_S)+1);
err=zeros(10^4,1);
x0=rand(10^4,length(Factor_S)+1);
parfor nn=1:10^4
    [beta_z_Science(nn,:),err(nn)]=lsqnonlin(@(x)LS_Trust_Fit(x,Z_t,S_X_t,w_c),x0(nn,:));
end
beta_z_Science=beta_z_Science(err==min(err),:);


figure(1)
[Z_est,~]=National_Level_Confidence(beta_z_Science,w_c,S_X_t);
plot(Data_Year,1./(1+exp(-Z_est)),'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z_t)),10,'r','filled'); hold on
ylabel('Trust in science');

beta_z_Medicine=zeros(10^4,length(Factor_S)+1);
err=zeros(10^4,1);
x0=rand(10^4,length(Factor_S)+1);
parfor nn=1:10^4
    [beta_z_Medicine(nn,:),err(nn)]=lsqnonlin(@(x)LS_Trust_Fit(x,M_t,M_X_t,w_c),x0(nn,:));
end
beta_z_Medicine=beta_z_Medicine(err==min(err),:);

figure(2)
[Z_est,~]=National_Level_Confidence(beta_z_Medicine,w_c,M_X_t);
plot(Data_Year,1./(1+exp(-Z_est)),'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-M_t)),10,'r','filled'); hold on
ylabel('Trust in medicine');

save('Estimate_LR_Trust_Science_Trust_Medicine.mat','beta_z_Science','beta_z_Medicine','Factor_S');
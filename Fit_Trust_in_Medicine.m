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


Factor_S={'Economic','Education','Political'};
[~,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},S_ID);

M_X_t=zeros(length(Factor_S),length(S_ID),length(Data_Year));

for jj=1:length(Factor_S)        
    [~,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},S_ID);
    M_X_t(jj,:,:)=County_Trust_in_Medicine;
    for yy=1:length(Data_Year)
        tt=squeeze(M_X_t(jj,:,yy));
        M_X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
    end
end

load([pwd '\State_Data\Trust_in_Medicine_Stratification.mat']);

Y_t=Trust_in_Medicine.National.Great_Deal+0.5.*Trust_in_Medicine.National.Only_Some;
Z.national=log(Y_t./(1-Y_t));
Z.national=Z.national(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Sex.male.Great_Deal+0.5.*Trust_in_Medicine.Sex.male.Only_Some;
Z.male=log(Y_t./(1-Y_t));
Z.male=Z.male(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Sex.female.Great_Deal+0.5.*Trust_in_Medicine.Sex.female.Only_Some;
Z.female=log(Y_t./(1-Y_t));
Z.female=Z.female(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Age.age_18_34.Great_Deal+0.5.*Trust_in_Medicine.Age.age_18_34.Only_Some;
Z.Age_18_34=log(Y_t./(1-Y_t));
Z.Age_18_34=Z.Age_18_34(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Age.age_35_49.Great_Deal+0.5.*Trust_in_Medicine.Age.age_35_49.Only_Some;
Z.Age_35_49=log(Y_t./(1-Y_t));
Z.Age_35_49=Z.Age_35_49(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Age.age_50_64.Great_Deal+0.5.*Trust_in_Medicine.Age.age_50_64.Only_Some;
Z.Age_50_64=log(Y_t./(1-Y_t));
Z.Age_50_64=Z.Age_50_64(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Age.age_over_65.Great_Deal+0.5.*Trust_in_Medicine.Age.age_over_65.Only_Some;
Z.Age_65_plus=log(Y_t./(1-Y_t));
Z.Age_65_plus=Z.Age_65_plus(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Race.white.Great_Deal+0.5.*Trust_in_Medicine.Race.white.Only_Some;
Z.white=log(Y_t./(1-Y_t));
Z.white=Z.white(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Race.black.Great_Deal+0.5.*Trust_in_Medicine.Race.black.Only_Some;
Z.black=log(Y_t./(1-Y_t));
Z.black=Z.black(ismember(Trust_Year_Data,Data_Year));

Y_t=Trust_in_Medicine.Race.other.Great_Deal+0.5.*Trust_in_Medicine.Race.other.Only_Some;
Z.other=log(Y_t./(1-Y_t));
Z.other=Z.other(ismember(Trust_Year_Data,Data_Year));


[county_weight]=Return_Population_Weight_County();

indx=1:24; % In case want to exploe fitting specific stratefications


lb=repmat([-250 -250 -250 -250],length(indx),1);
ub=repmat([250 250 250 250],length(indx),1);

lb=lb(:)';
ub=ub(:)';

d_err=Inf;
while(d_err>10^(-1))
    if(isinf(d_err))
        options=optimoptions('surrogateopt','MaxFunctionEvaluations',2500,'UseParallel',true,'PlotFcn','surrogateoptplot');
    else
        l_samp=lhsdesign(249,length(beta_temp));
        lb_t=min(0.99.*beta_temp,1.01.*beta_temp);
        ub_t=max(0.99.*beta_temp,1.01.*beta_temp);
        x0=[beta_temp;repmat(lb_t,249,1)+repmat(ub_t-lb_t,249,1).*l_samp];
        options=optimoptions('surrogateopt','InitialPoints',x0,'MaxFunctionEvaluations',750,'UseParallel',true,'PlotFcn','surrogateoptplot');
    end

    [beta_temp,err1]=surrogateopt(@(x)LS_Trust_Fit(x,Z,M_X_t,county_weight,indx,true),lb,ub,options);
    
    if(isinf(d_err))
        options=optimoptions("fmincon","MaxFunctionEvaluations",10^6,'MaxIterations',10^6);
    else
        options=optimoptions("fmincon","MaxFunctionEvaluations",10^3,'MaxIterations',10^3);
    end
    [beta_temp2,err2]=fmincon(@(x)LS_Trust_Fit(x,Z,M_X_t,county_weight,indx,true),beta_temp,[],[],[],[],lb,ub,[],options);
    d_err=err1-err2;
    if(err2<err1)
        beta_temp=beta_temp2;
        err1=err2;
    end
end

beta_temp=reshape(beta_temp,length(indx),4);

beta_z_Medicine=zeros(24,4);
for jj=1:length(indx)
    beta_z_Medicine(indx(jj),:)=beta_temp(jj,:);
end

save('Parameters_Trust_In_Medicine','beta_z_Medicine','Factor_S');


Trust_Stratified=Trust_Stratefied_County(county_weight,M_X_t,beta_z_Medicine);
[Trust]=Trust_Categories(county_weight,Trust_Stratified);

figure(1)
subplot(5,2,1)
plot(Data_Year,Trust.National,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.national)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('National')

subplot(5,2,2)
plot(Data_Year,Trust.Male,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.male)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Male')

subplot(5,2,3)
plot(Data_Year,Trust.Female,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.female)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Female')

subplot(5,2,4)
plot(Data_Year,Trust.Age_18_34,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_18_34)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Age_18_34')

subplot(5,2,5)
plot(Data_Year,Trust.Age_35_49,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_35_49)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Age_35_49')

subplot(5,2,6)
plot(Data_Year,Trust.Age_50_64,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_50_64)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Age_50_64')

subplot(5,2,7)
plot(Data_Year,Trust.Age_65_plus,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_65_plus)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Age_65_plus')

subplot(5,2,8)
plot(Data_Year,Trust.White,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.white)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('White')

subplot(5,2,9)
plot(Data_Year,Trust.Black,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.black)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Black')

subplot(5,2,10)
plot(Data_Year,Trust.Other,'k','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.other)),10,'r','filled'); hold on
ylabel('Trust in medicine');
title('Other')

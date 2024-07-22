clear;

[~,County_ID,~]=Read_ID_Number();

Factor_M={'Economic','Education','Political'};
[~,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_M{1},County_ID);

M_X_t=zeros(length(Factor_M),length(County_ID),length(Data_Year));

for jj=1:length(Factor_M)        
    [~,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_M{jj},County_ID);
    M_X_t(jj,:,:)=County_Trust_in_Medicine;
    for yy=1:length(Data_Year)
        tt=squeeze(M_X_t(jj,:,yy));
        M_X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Medicine_Stratification.mat']);

Y_t.National=Trust_in_Medicine.National.Great_Deal+0.5.*Trust_in_Medicine.National.Only_Some;
Y_t.National=Y_t.National(ismember(Trust_Year_Data,Data_Year));

Y_t.Male=Trust_in_Medicine.Sex.male.Great_Deal+0.5.*Trust_in_Medicine.Sex.male.Only_Some;
Y_t.Male=Y_t.Male(ismember(Trust_Year_Data,Data_Year));

Y_t.Female=Trust_in_Medicine.Sex.female.Great_Deal+0.5.*Trust_in_Medicine.Sex.female.Only_Some;
Y_t.Female=Y_t.Female(ismember(Trust_Year_Data,Data_Year));

Y_t.Age_18_34=Trust_in_Medicine.Age.age_18_34.Great_Deal+0.5.*Trust_in_Medicine.Age.age_18_34.Only_Some;
Y_t.Age_18_34=Y_t.Age_18_34(ismember(Trust_Year_Data,Data_Year));

Y_t.Age_35_49=Trust_in_Medicine.Age.age_35_49.Great_Deal+0.5.*Trust_in_Medicine.Age.age_35_49.Only_Some;
Y_t.Age_35_49=Y_t.Age_35_49(ismember(Trust_Year_Data,Data_Year));

Y_t.Age_50_64=Trust_in_Medicine.Age.age_50_64.Great_Deal+0.5.*Trust_in_Medicine.Age.age_50_64.Only_Some;
Y_t.Age_50_64=Y_t.Age_50_64(ismember(Trust_Year_Data,Data_Year));

Y_t.Age_65_plus=Trust_in_Medicine.Age.age_over_65.Great_Deal+0.5.*Trust_in_Medicine.Age.age_over_65.Only_Some;
Y_t.Age_65_plus=Y_t.Age_65_plus(ismember(Trust_Year_Data,Data_Year));

Y_t.White=Trust_in_Medicine.Race.white.Great_Deal+0.5.*Trust_in_Medicine.Race.white.Only_Some;
Y_t.White=Y_t.White(ismember(Trust_Year_Data,Data_Year));

Y_t.Black=Trust_in_Medicine.Race.black.Great_Deal+0.5.*Trust_in_Medicine.Race.black.Only_Some;
Y_t.Black=Y_t.Black(ismember(Trust_Year_Data,Data_Year));

Y_t.Other=Trust_in_Medicine.Race.other.Great_Deal+0.5.*Trust_in_Medicine.Race.other.Only_Some;
Y_t.Other=Y_t.Other(ismember(Trust_Year_Data,Data_Year));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Medicine_Error_Stratification.mat']);

Err.National=Trust_in_Medicine_Error.National.Great_Deal+0.5.*Trust_in_Medicine_Error.National.Only_Some;
Err.National=Err.National(ismember(Trust_Year_Data,Data_Year));

Err.Male=Trust_in_Medicine_Error.Sex.male.Great_Deal+0.5.*Trust_in_Medicine_Error.Sex.male.Only_Some;
Err.Male=Err.Male(ismember(Trust_Year_Data,Data_Year));

Err.Female=Trust_in_Medicine_Error.Sex.female.Great_Deal+0.5.*Trust_in_Medicine_Error.Sex.female.Only_Some;
Err.Female=Err.Female(ismember(Trust_Year_Data,Data_Year));

Err.Age_18_34=Trust_in_Medicine_Error.Age.age_18_34.Great_Deal+0.5.*Trust_in_Medicine_Error.Age.age_18_34.Only_Some;
Err.Age_18_34=Err.Age_18_34(ismember(Trust_Year_Data,Data_Year));

Err.Age_35_49=Trust_in_Medicine_Error.Age.age_35_49.Great_Deal+0.5.*Trust_in_Medicine_Error.Age.age_35_49.Only_Some;
Err.Age_35_49=Err.Age_35_49(ismember(Trust_Year_Data,Data_Year));

Err.Age_50_64=Trust_in_Medicine_Error.Age.age_50_64.Great_Deal+0.5.*Trust_in_Medicine_Error.Age.age_50_64.Only_Some;
Err.Age_50_64=Err.Age_50_64(ismember(Trust_Year_Data,Data_Year));

Err.Age_65_plus=Trust_in_Medicine_Error.Age.age_over_65.Great_Deal+0.5.*Trust_in_Medicine_Error.Age.age_over_65.Only_Some;
Err.Age_65_plus=Err.Age_65_plus(ismember(Trust_Year_Data,Data_Year));

Err.White=Trust_in_Medicine_Error.Race.white.Great_Deal+0.5.*Trust_in_Medicine_Error.Race.white.Only_Some;
Err.White=Err.White(ismember(Trust_Year_Data,Data_Year));

Err.Black=Trust_in_Medicine_Error.Race.black.Great_Deal+0.5.*Trust_in_Medicine_Error.Race.black.Only_Some;
Err.Black=Err.Black(ismember(Trust_Year_Data,Data_Year));

Err.Other=Trust_in_Medicine_Error.Race.other.Great_Deal+0.5.*Trust_in_Medicine_Error.Race.other.Only_Some;
Err.Other=Err.Other(ismember(Trust_Year_Data,Data_Year));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[county_weight]=Return_Population_Weight_County();

indx=1:24; % In case want to exploe fitting specific stratefications

if(isfile("Parameters_Trust_In_Medicine.mat"))
    d_err=1;
    load('Parameters_Trust_In_Medicine','beta_z_Medicine');
    beta_temp=beta_z_Medicine;
    beta_temp=beta_temp(:)';
    
    lb=repmat([-250 -250 -250 -250],length(indx),1);
    ub=repmat([250 250 250 250],length(indx),1);

    lb=lb(:)';
    ub=ub(:)';
else
    d_err=Inf;
end
while(d_err>10^(-1))
    if(isinf(d_err))
        lb=repmat([-10 -10 -10 -10],length(indx),1);
        ub=repmat([10 10 10 10],length(indx),1);

        lb=lb(:)';
        ub=ub(:)';

        options=optimoptions('surrogateopt','MaxFunctionEvaluations',2500,'UseParallel',true,'PlotFcn','surrogateoptplot');
    else
        l_samp=lhsdesign(249,length(beta_temp));
        lb_t=min(0.99.*beta_temp,1.01.*beta_temp);
        ub_t=max(0.99.*beta_temp,1.01.*beta_temp);
        x0=[beta_temp;repmat(lb_t,249,1)+repmat(ub_t-lb_t,249,1).*l_samp];
        options=optimoptions('surrogateopt','InitialPoints',x0,'MaxFunctionEvaluations',750,'UseParallel',true,'PlotFcn','surrogateoptplot');
    end

    [beta_temp,err1]=surrogateopt(@(x)LS_Trust_Fit(x,Y_t,Err,M_X_t,county_weight,indx),lb,ub,options);
    

    lb=repmat([-250 -250 -250 -250],length(indx),1);
    ub=repmat([250 250 250 250],length(indx),1);

    lb=lb(:)';
    ub=ub(:)';
    
    if(isinf(d_err))
        options=optimoptions("fmincon","MaxFunctionEvaluations",10^6,'MaxIterations',10^6,'UseParallel',true);
    else
        options=optimoptions("fmincon","MaxFunctionEvaluations",10^3,'MaxIterations',10^3,'UseParallel',true);
    end
    [beta_temp2,err2]=fmincon(@(x)LS_Trust_Fit(x,Y_t,Err,M_X_t,county_weight,indx),beta_temp,[],[],[],[],lb,ub,[],options);
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

save('Parameters_Trust_In_Medicine','beta_z_Medicine','Factor_M');


Trust_Stratified=Trust_Stratefied_County(county_weight,M_X_t,beta_z_Medicine);
[Trust]=Trust_Categories(county_weight,Trust_Stratified);

figure(1)
subplot(5,2,1)
plot(Data_Year,Trust.National,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.National,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('National')

subplot(5,2,2)
plot(Data_Year,Trust.Male,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Male,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Male')

subplot(5,2,3)
plot(Data_Year,Trust.Female,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Female,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Female')

subplot(5,2,4)
plot(Data_Year,Trust.Age_18_34,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Age_18_34,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Age_18_34')

subplot(5,2,5)
plot(Data_Year,Trust.Age_35_49,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Age_35_49,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Age_35_49')

subplot(5,2,6)
plot(Data_Year,Trust.Age_50_64,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Age_50_64,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Age_50_64')

subplot(5,2,7)
plot(Data_Year,Trust.Age_65_plus,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Age_65_plus,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Age_65_plus')

subplot(5,2,8)
plot(Data_Year,Trust.White,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.White,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('White')

subplot(5,2,9)
plot(Data_Year,Trust.Black,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Black,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Black')

subplot(5,2,10)
plot(Data_Year,Trust.Other,'k','LineWidth',2); hold on
scatter(Data_Year,Y_t.Other,10,'r','filled'); hold on
ylabel('Trust in Medicine');
title('Other')

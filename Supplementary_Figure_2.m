clear;
close all;
clc;

[~,County_ID,~]=Read_ID_Number();

Factor_S={'Economic','Education','Political'};
[~,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},County_ID);

M_X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));

for jj=1:length(Factor_S)        
    [~,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},County_ID);
    M_X_t(jj,:,:)=County_Trust_in_Medicine;
    for yy=1:length(Data_Year)
        tt=squeeze(M_X_t(jj,:,yy));
        M_X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
    end
end

load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Medicine_Stratification.mat']);

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



load('Parameters_Trust_In_Medicine','beta_z_Medicine','Factor_S');


Trust_Stratified=Trust_Stratefied_County(county_weight,M_X_t,beta_z_Medicine);
[Trust]=Trust_Categories(county_weight,Trust_Stratified);

figure('units','normalized','outerposition',[0.1 0.05 0.65 1]);
subplot('Position',[0.065 0.835 0.42 0.14])
plot(Data_Year,Trust.National,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.national)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','FontSize',14);
% xlabel('Year','FontSize',14)
title('Overall','FontSize',14)
ylim([0.5 0.75])
legend({'Estimate','Data'},'location','southwest')

subplot('Position',[0.565 0.835 0.42 0.14])
plot(Data_Year,Trust.Male,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.male)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','FontSize',14);
% xlabel('Year','FontSize',14)
title('Male','FontSize',14)
ylim([0.5 0.75])

subplot('Position',[0.065 0.645 0.42 0.14])
plot(Data_Year,Trust.Female,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.female)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','Fontsize',14);
% xlabel('Year','Fontsize',14)
title('Female','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.565 0.645 0.42 0.14])
plot(Data_Year,Trust.Age_18_34,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_18_34)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','Fontsize',14);
% xlabel('Year','Fontsize',14)
title('Ages: 18 to 34','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.065 0.455 0.42 0.14])
plot(Data_Year,Trust.Age_35_49,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_35_49)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','Fontsize',14);
% xlabel('Year','Fontsize',14)
title('Ages: 35 to 49','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.565 0.455 0.42 0.14])
plot(Data_Year,Trust.Age_50_64,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_50_64)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','Fontsize',14);
% xlabel('Year','Fontsize',14)
title('Ages: 50 to 64','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.065 0.265 0.42 0.14])
plot(Data_Year,Trust.Age_65_plus,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.Age_65_plus)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','Fontsize',14);
% xlabel('Year','Fontsize',14)
title('Ages: 65 and older','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.565 0.265 0.42 0.14])
plot(Data_Year,Trust.White,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.white)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75],'Xticklabel',[]); box off;
ylabel('Trust in Medicine','Fontsize',14);
% xlabel('Year','Fontsize',14)
title('Race: White','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.065 0.08 0.42 0.14])
plot(Data_Year,Trust.Black,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.black)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75]); box off;
ylabel('Trust in Medicine','Fontsize',14);
xlabel('Year','Fontsize',14)
title('Race: Black','Fontsize',14)
ylim([0.5 0.75])

subplot('Position',[0.565 0.08 0.42 0.14])
plot(Data_Year,Trust.Other,'b','LineWidth',2); hold on
scatter(Data_Year,1./(1+exp(-Z.other)),20,'r','filled'); hold on
set(gca,'LineWidth',2,'tickdir','out','Fontsize',12,'XTick',Data_Year,'YTick',[0.5:0.05:0.75]); box off;
ylabel('Trust in Medicine','Fontsize',14);
xlabel('Year','Fontsize',14)
title('Race: Other','Fontsize',14)
ylim([0.5 0.75])

print(gcf,['Supplementary_Figure_2.png'],'-dpng','-r600');
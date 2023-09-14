clear;
clc;

T=readtable('COVID-19_Vaccinations_in_the_United_States_County.csv');
YR=year(T.Date);
W=T.MMWR_week;
Vac_Cov_1=T.Administered_Dose1_Pop_Pct;
Vac_Cov=T.Series_Complete_Pop_Pct;

fip=T.FIPS;

MW=max(W(YR==2022));
Vac_Cov_2022=Vac_Cov(YR==2022 & MW==W);
Vac_Cov_1_2022=Vac_Cov_1(YR==2022 & MW==W);
fip_2022=fip(YR==2022 & MW==W);


MW=max(W(YR==2021));
Vac_Cov_2021=Vac_Cov(YR==2021 & MW==W);
Vac_Cov_1_2021=Vac_Cov_1(YR==2021 & MW==W);
fip_2021=fip(YR==2021 & MW==W);


MW=max(W(YR==2020));
Vac_Cov_2020=Vac_Cov(YR==2020 & MW==W);
Vac_Cov_1_2020=Vac_Cov_1(YR==2020 & MW==W);
fip_2020=fip(YR==2020 & MW==W);

save('COVID_County_Uptake.mat','Vac_Cov_2022','fip_2022','Vac_Cov_2021','fip_2021','Vac_Cov_2020','fip_2020');



clear;
clc;

T=readtable('Vaccine_Hesitancy_for_COVID-19__County_and_local_estimates.csv');

COVID_Vac.fips=T.FIPSCode;
COVID_Vac.hesitant=T.EstimatedHesitant;
COVID_Vac.hesitant_unsure=T.EstimatedHesitantOrUnsure;
COVID_Vac.strongly_hesitant=T.EstimatedStronglyHesitant;

save('COVID_Vaccine_Hesitant_County.mat','COVID_Vac');
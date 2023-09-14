S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_ID_temp={S.STATEFP};
State_ID=zeros(size(State_ID_temp));

for ii=1:length(State_ID)
  State_ID(ii)=str2double(State_ID_temp{ii});  
end
State_ID=unique(State_ID);
clearvars -except State_ID 

COVID_VAC_State=readtable([pwd '\COVID_19_Vaccination_Coverage\COVID-19_Vaccinations_in_the_United_States_Jurisdiction.csv']);
COVID_VAC_State=COVID_VAC_State(datenum(COVID_VAC_State.Date)==datenum('12/28/2022'),:);
COVID_VAC_State=sortrows(COVID_VAC_State,3);
load('State_FIP_Mapping_Acronym.mat');

tf=ismember(COVID_VAC_State.Location,State_FIP_Mapping(:,3));
COVID_VAC_State=COVID_VAC_State(tf,:);

FIP=zeros(height(COVID_VAC_State),1);
for jj=1:length(FIP)
    tf=strcmp(COVID_VAC_State.Location(jj),State_FIP_Mapping(:,3));
    FIP(jj)=State_FIP_Mapping{tf,1};
end

tf=ismember(FIP,State_ID);
COVID_VAC_State=COVID_VAC_State(tf,:);
FIP=FIP(tf);


COVID_VAC_County=readtable([pwd '\COVID_19_Vaccination_Coverage\COVID-19_Vaccinations_in_the_United_States_County.csv']);
COVID_VAC_County=COVID_VAC_County(datenum(COVID_VAC_County.Date)==datenum('12/28/2022'),:);
County_ID=COVID_VAC_County.FIPS;

Pop_5_plus=str2double(COVID_VAC_State.Administered_Dose1_Recip_5Plus)./(COVID_VAC_State.Administered_Dose1_Recip_5PlusPop_Pct./100);
Pop_All=str2double(COVID_VAC_State.Administered_Dose1_Recip)./(COVID_VAC_State.Administered_Dose1_Pop_Pct./100);
Pop_under_5=Pop_All-Pop_5_plus;
State_Single_Dose_under_5=zeros(length(State_ID),1);
State_Completed_Series_under_5=zeros(length(State_ID),1);
State_Additional_under_5=zeros(length(State_ID),1);
State_Bivalent_under_5=zeros(length(State_ID),1);
for jj=1:length(State_ID)
    tf=FIP==State_ID(jj);
    State_Single_Dose_under_5(jj)=(str2double(COVID_VAC_State.Administered_Dose1_Recip(tf))-str2double(COVID_VAC_State.Administered_Dose1_Recip_5Plus(tf)))/Pop_under_5(tf);
    State_Completed_Series_under_5(jj)=(str2double(COVID_VAC_State.Series_Complete_Yes(tf))-str2double(COVID_VAC_State.Series_Complete_5Plus(tf)))/Pop_under_5(tf);    
    State_Additional_under_5(jj)=(str2double(COVID_VAC_State.Additional_Doses(tf))-str2double(COVID_VAC_State.Additional_Doses_5Plus(tf)))/Pop_under_5(tf);
    State_Bivalent_under_5(jj)=(str2double(COVID_VAC_State.Administered_Bivalent(tf))-str2double(COVID_VAC_State.Bivalent_Booster_5Plus(tf)))/Pop_under_5(tf);
end

Pop_5_plus=str2double(COVID_VAC_County.Census2019_5PlusPop);
Pop_All=str2double(COVID_VAC_County.Census2019);
Pop_under_5=Pop_All-Pop_5_plus;
County_Single_Dose_under_5=zeros(length(County_ID),1);
County_Completed_Series_under_5=zeros(length(County_ID),1);
County_Additional_under_5=zeros(length(County_ID),1);
% County_Bivalent_under_5=zeros(length(County_ID),1);
for jj=1:length(County_ID)
    County_Single_Dose_under_5(jj)=(str2double(COVID_VAC_County.Administered_Dose1_Recip(jj))-str2double(COVID_VAC_County.Administered_Dose1_Recip_5Plus(jj)))/Pop_under_5(jj);
    County_Completed_Series_under_5(jj)=(str2double(COVID_VAC_County.Series_Complete_Yes(jj))-str2double(COVID_VAC_County.Series_Complete_5Plus(jj)))/Pop_under_5(jj);    
    County_Additional_under_5(jj)=(str2double(COVID_VAC_County.Booster_Doses(jj))-str2double(COVID_VAC_County.Booster_Doses_5Plus(jj)))/Pop_under_5(jj);
%     County_Bivalent_under_5(jj)=(str2double(COVID_VAC_County.Bivalent_Booster(jj))-str2double(COVID_VAC_County.Bivalent_Booster_5Plus(jj)))/Pop_under_5(jj);
end

Yr=[2017:2021];
Scenario={'Overall';'Any exemption';'No exemptions';'Only religious exemptions';'Religious and philosophical exemptions'};
Inqv={'MMR','DTaP','Polio','VAR'};


r_Single=zeros(4,2);
r_Complete=zeros(4,2);
r_Additional=zeros(4,2);
r_Bivalent=zeros(4,2);
mdl=cell(4,1);

for dd=1:length(Inqv)
    V_State=zeros(length(State_ID),length(Yr));
    Inq=Inqv{dd};
    for yy=1:length(Yr)
        V_State(:,yy)=State_Immunization_Statistics(Inq,Yr(yy),State_ID);  
    end
    V_State(V_State>=1)=1-10^(-3);
    V_State(V_State<=0)=10^(-3);

    V_State=log(V_State./(1-V_State));
    V_County=zeros(length(County_ID),length(Yr));
    Inq=Inqv{dd};
    for yy=1:length(Yr)
        V_County(:,yy)=County_Immunization_Statistics(Inq,Yr(yy),County_ID);  
    end
    
    V_County(V_County>=1)=1-10^(-3);
    V_County(V_County<=0)=10^(-3);

    V_County=log(V_County./(1-V_County));


    delta_State=V_State(:,Yr==2021)-V_State(:,Yr==2019);

    delta_County=V_County(:,Yr==2021)-V_County(:,Yr==2019);

    Y=[delta_State(:); delta_County(:)];


    X=[State_Single_Dose_under_5(:); County_Single_Dose_under_5(:)];
    X(X>=1)=1-10^(-3);
    X(X<=0)=10^(-3);
    t_n=~isnan(Y) & ~isnan(X);
    [r_Single(dd,1),r_Single(dd,2)]=corr(Y(t_n),log(X(t_n)./(1-X(t_n))));

    X=[State_Completed_Series_under_5(:); County_Completed_Series_under_5(:)];
    X(X>=1)=1-10^(-3);
    X(X<=0)=10^(-3);
    t_n=~isnan(Y) & ~isnan(X);
    [r_Complete(dd,1),r_Complete(dd,2)]=corr(Y(t_n),log(X(t_n)./(1-X(t_n))));

    
    X=[State_Additional_under_5(:); County_Additional_under_5(:)];
    X(X>=1)=1-10^(-3);
    X(X<=0)=10^(-3);
    t_n=~isnan(Y) & ~isnan(X);
    [r_Additional(dd,1),r_Additional(dd,2)]=corr(Y(t_n),log(X(t_n)./(1-X(t_n))));

    Y=[delta_State(:)];
    X=[State_Bivalent_under_5(:)];
    X(X>=1)=1-10^(-3);
    X(X<=0)=10^(-3);
    t_n=~isnan(Y) & ~isnan(X);
    [r_Bivalent(dd,1),r_Bivalent(dd,2)]=corr(Y(t_n),log(X(t_n)./(1-X(t_n))));

end


Age_Group={'Under 5 years of age';'Under 5 years of age';'Under 5 years of age';'Under 5 years of age'};
Vaccine={'MMR';'DTaP';'IPV';'VAR'};
At_least_one=cell(4,1);
Complete_Series=cell(4,1);
Additional_Dose=cell(4,1);
Bivalent_Booster=cell(4,1);

for dd=1:4
    At_least_one{dd}=[num2str(r_Single(dd,1),'%.3g') ' (p=' num2str(r_Single(dd,2),'%.3g') ')' ];
    Complete_Series{dd}=[num2str(r_Complete(dd,1),'%.3g') ' (p=' num2str(r_Complete(dd,2),'%.3g') ')' ];
    Additional_Dose{dd}=[num2str(r_Additional(dd,1),'%.3g') ' (p=' num2str(r_Additional(dd,2),'%.3g') ')' ];
    Bivalent_Booster{dd}=[num2str(r_Bivalent(dd,1),'%.3g') ' (p=' num2str(r_Bivalent(dd,2),'%.3g') ')' ];
end

T=table(Age_Group,Vaccine,At_least_one,Complete_Series,Additional_Dose,Bivalent_Booster);

writetable(T,'Under_5_COVID-19_Coverage.xlsx');
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read Tables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_State=readtable('COVID_Vaccination_Precision_Health.xlsx','Sheet','State');
T_Race=readtable('COVID_Vaccination_Precision_Health.xlsx','Sheet','Race');
T_Political=readtable('COVID_Vaccination_Precision_Health.xlsx','Sheet','Political');
loc_cur=pwd;
Factor_S={'COVID Skeptic';'System Distruster';'Cost-Anxious';'Watchful';'Enthusiast';'Vaccinated'};

Political_Values=[T_Political.Democratic_March T_Political.Republican_March T_Political.Independent_March];
Race_Values=[T_Race.White_March T_Race.Black_March T_Race.Lationo_March];
State_Values=[T_State.COVID_Skeptic T_State.System_Distruster T_State.CostAnxious T_State.Watchful T_State.Enthusiast T_State.Vaccinated]';

Table_State_FIP=T_State.State_FIP;

load([loc_cur(1:end-10) 'State_FIP_Mapping.mat']);

load([pwd '\County_Data\County_Population.mat']);
Data_SID=Population.State_ID;

Data_CID=Population.County_ID_Numeric(Data_SID~=2 & Data_SID~=15 & Data_SID<60);
Data_Year=Population.Year_Data;
P_Race_v=Population.Race;
P_Political_v=Population.Political;

county_weight_temp=Population.Sex.Male+Population.Sex.Female;
county_weight_temp=county_weight_temp(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);

P_Race=NaN.*zeros(length(Data_CID),3);
P_Political=NaN.*zeros(length(Data_CID),3);
county_weight=zeros(size(Data_CID));

P_Race_White_v=P_Race_v.White./(P_Race_v.White+P_Race_v.Black+P_Race_v.Other);
P_Race_Black_v=P_Race_v.Black./(P_Race_v.White+P_Race_v.Black+P_Race_v.Other);
P_Race_Other_v=P_Race_v.Other./(P_Race_v.White+P_Race_v.Black+P_Race_v.Other);

P_Race_White_v(P_Race_White_v==0)=10^(-16);
P_Race_Black_v(P_Race_Black_v==0)=10^(-16);
P_Race_Other_v(P_Race_Other_v==0)=10^(-16);

P_Race_White_v(P_Race_White_v==1)=1-10^(-16);
P_Race_Black_v(P_Race_Black_v==1)=1-10^(-16);
P_Race_Other_v(P_Race_Other_v==1)=1-10^(-16);

twr=P_Race_White_v./(P_Race_White_v+P_Race_Black_v+P_Race_Other_v);
tbr=P_Race_Black_v./(P_Race_White_v+P_Race_Black_v+P_Race_Other_v);
tor=P_Race_Other_v./(P_Race_White_v+P_Race_Black_v+P_Race_Other_v);

P_Race_White_v=twr;
P_Race_Black_v=tbr;
P_Race_Other_v=tor;

P_Race_White_v=P_Race_White_v(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);
P_Race_Black_v=P_Race_Black_v(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);
P_Race_Other_v=P_Race_Other_v(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);


z_race_w=log(P_Race_White_v./(1-P_Race_White_v));
z_race_b=log(P_Race_Black_v./(1-P_Race_Black_v));
z_race_o=log(P_Race_Other_v./(1-P_Race_Other_v));

z_political_d=log(P_Political_v.Democratic./(1-P_Political_v.Democratic));
z_political_r=log(P_Political_v.Republican./(1-P_Political_v.Republican));
z_political_i=log(P_Political_v.Other./(1-P_Political_v.Other));

z_political_d=z_political_d(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);
z_political_r=z_political_r(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);
z_political_i=z_political_i(Data_SID~=2 & Data_SID~=15 & Data_SID<60,:);

Data_SID=Data_SID(Data_SID~=2 & Data_SID~=15 & Data_SID<60);

for jj=1:length(Data_CID)    
    P_Political(jj,1)=1./(1+exp(-pchip(Data_Year,z_political_d(jj,:),2022)));
    P_Political(jj,2)=1./(1+exp(-pchip(Data_Year,z_political_r(jj,:),2022)));
    P_Political(jj,3)=1./(1+exp(-pchip(Data_Year,z_political_i(jj,:),2022)));    
    P_Political(jj,:)=P_Political(jj,:)./sum(P_Political(jj,:));
    
    P_Race(jj,1)=1./(1+exp(-pchip(Data_Year,z_race_w(jj,:),2022)));
    P_Race(jj,2)=1./(1+exp(-pchip(Data_Year,z_race_b(jj,:),2022)));
    P_Race(jj,3)=1./(1+exp(-pchip(Data_Year,z_race_o(jj,:),2022)));
        
    P_Race(jj,:)=P_Race(jj,:)./sum(P_Race(jj,:));
    
    county_weight(jj)=pchip(Data_Year,county_weight_temp(jj,:),2022);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% County weight for the state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


USID=unique(Population.State_ID);

for ii=1:length(USID)
    tf=Data_SID == USID(ii);
    county_weight(tf)=county_weight(tf)./sum(county_weight(tf));
end


County_Health_Factor_Race=NaN.*zeros(length(Data_SID),length(Factor_S));
County_Health_Factor_Political=NaN.*zeros(length(Data_SID),length(Factor_S));

for jj=1:length(Data_SID)
    for kk=1:length(Factor_S)
        County_Health_Factor_Race(jj,kk)=sum(P_Race(jj,:).*Race_Values(kk,:));
        County_Health_Factor_Political(jj,kk)=sum(P_Political(jj,:).*Political_Values(kk,:));
    end
end

for jj=1:length(USID)
   tf= Data_SID == USID(jj);
   ts= Table_State_FIP == USID(jj);
   for kk=1:length(Factor_S)
       temp_rc=county_weight(tf).*County_Health_Factor_Race(tf,kk);
       temp_rc=temp_rc(~isnan(temp_rc));
        NC=sum(temp_rc);
        County_Health_Factor_Race(tf,kk)=(State_Values(kk,ts)./NC).*County_Health_Factor_Race(tf,kk);        
        
        NC=sum(county_weight(tf).*County_Health_Factor_Political(tf,kk));
        County_Health_Factor_Political(tf,kk)=(State_Values(kk,ts)./NC).*County_Health_Factor_Political(tf,kk);
   end
end


save('County_Precision_Health_2022.mat','County_Health_Factor_Political','County_Health_Factor_Race','Data_CID','Factor_S');
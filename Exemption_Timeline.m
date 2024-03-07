function [RVE,PVE] = Exemption_Timeline(Year_Plot,State_ID,Vac)

if(strcmp(Vac,'MMR'))
    T=readtable([pwd '\State_Data\Demographic_Data\State_Exemptions.xlsx'],'Sheet','MMR');
else
    T=readtable([pwd '\State_Data\Demographic_Data\State_Exemptions.xlsx'],'Sheet','Others');
end

Year_Inq=[2015 2016 2017 2018 2019 2020 2021 2022];
Table_Ind=[3 11;4 12;5 13;6 14;7 15;8 16;9 17;10 18];

ty=Year_Inq==Year_Plot;

Table_Ind=Table_Ind(ty,:);


T_fips=T.State_FIPs;
raw_data=table2array(T(:,Table_Ind));
RVE=NaN.*zeros(length(State_ID),1);
PVE=NaN.*zeros(length(State_ID),1);
for jj=1:length(State_ID)
    tf=T_fips==State_ID(jj);
    if(sum(tf)>0)
        RVE(jj)=raw_data(tf,1);
        PVE(jj)=raw_data(tf,2);
    end
end


end


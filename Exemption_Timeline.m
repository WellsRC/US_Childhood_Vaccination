function [RVE,PVE] = Exemption_Timeline(Year_Plot,State_ID)

T=readtable([pwd '\State_Data\State_Exemptions.xlsx']);

Year_Inq=[2017 2018 2019 2020 2021];
Table_Ind=[3 8;4 9;5 10;6 11;7 12];

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


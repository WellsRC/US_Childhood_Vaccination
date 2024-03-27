function I_D = State_Immunization_Statistics(Var_1,Year_Plot,State_ID)

Inq={'DTaP','Polio','MMR','VAR'};
Year_Inq=[2017 2018 2019 2020 2021 2022];

Table_Ind=[3 4 5 6; 7 8 9 10; 11 12 13 14;15 16 17 18; 19 20 21 22; 23 24 25 26];


ty=Year_Inq==Year_Plot;
tv=strcmp(Var_1,Inq);

Table_Ind=Table_Ind(ty,:);
Table_Ind=Table_Ind(:,tv);

T=readtable([pwd '\State_Data\Demographic_Data\State_Level_Data.xlsx']);

T_fips=T.State_FIPs;
raw_data=table2array(T(:,Table_Ind));
I_D=NaN.*zeros(length(State_ID),1);
for jj=1:length(I_D)
    tf=T_fips==State_ID(jj);
    if(sum(tf)>0)
        I_D(jj)=raw_data(tf);
    end
end
end


function I_D = County_Immunization_Statistics(Var_1,Year_Plot,County_ID)

Inq={'DTaP','Polio','MMR','VAR'};
Year_Inq=[2017 2018 2019 2020 2021];

Table_Ind=[13 16 19 28; 44 47 50 59; 75 78 81 90;104 107 110 119; 133 136 139 148];

ty=Year_Inq==Year_Plot;
tv=strcmp(Var_1,Inq);

Table_Ind=Table_Ind(ty,:);
Table_Ind=Table_Ind(:,tv);

T=readtable([pwd '\State_Data\County_Data\County_Level_Data.xlsx']);

T_fips=T.CountyFIPS;
raw_data=table2array(T(:,Table_Ind));
I_D=NaN.*zeros(length(County_ID),1);
for jj=1:length(I_D)
    tf=T_fips==County_ID(jj);
    if(sum(tf)>0)
        I_D(jj)=raw_data(tf);
    end
end
end


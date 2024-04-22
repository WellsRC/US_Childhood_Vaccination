function I_D = State_Immunization_Statistics(Var_1,Year_Plot,State_ID)

Year_Inq=[2017 2018 2019 2020 2021 2022];

t_year=find(Year_Inq==Year_Plot);

T=readtable([pwd '\Spatial_Data\Vaccination_Data\State_Vaccination_Data.xlsx'],'Sheet',Var_1);

T_fips=T.State_FIPs;
raw_data=table2array(T(:,t_year+2)); % the first two columns are the state and fip number 

I_D=NaN.*zeros(length(State_ID),1);
for jj=1:length(I_D)
    tf=T_fips==State_ID(jj);
    if(sum(tf)>0)
        I_D(jj)=raw_data(tf);
    end
end
end


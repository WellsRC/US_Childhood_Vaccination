function I_D = County_Immunization_Statistics(Var_1,Year_Plot,County_ID)

Year_Inq=[2017 2018 2019 2020 2021 2022];

t_year=find(Year_Inq==Year_Plot);

T=readtable([pwd '\Spatial_Data\Vaccination_Data\County_Vaccination_Data.xlsx'],'Sheet',Var_1);

T_fips=T.CountyFIPS;
raw_data=table2array(T(:,t_year+3)); % first 3 columns are state, county and fips

I_D=NaN.*zeros(length(County_ID),1);
for jj=1:length(I_D)
    tf=T_fips==County_ID(jj);
    if(sum(tf)>0)
        I_D(jj)=raw_data(tf);
    end
end

end


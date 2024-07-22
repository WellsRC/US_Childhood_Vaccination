function [Num_Sampled,Per_Surveyed] = State_Immunization_Survey_Sample(Year_Plot,State_ID)

Year_Inq=[2017 2018 2019 2020 2021 2022];

t_year=find(Year_Inq==Year_Plot);

Per_Sampled=readtable([pwd '/Spatial_Data/Vaccination_Data/State_Vaccination_Data.xlsx'],'Sheet','Surveyed_Population');
Pop_Size=readtable([pwd '/Spatial_Data/Vaccination_Data/State_Vaccination_Data.xlsx'],'Sheet','Kindergarten_Population');

PS_fips=Per_Sampled.State_FIPs;
PopSize_fips=Pop_Size.State_FIPs;
raw_data=table2array(Per_Sampled(:,t_year+2)); % the first two columns are the state and fip number 
raw_data_popsize=table2array(Pop_Size(:,t_year+2)); % the first two columns are the state and fip number 

Num_Sampled=NaN.*zeros(length(State_ID),1);
Per_Surveyed=NaN.*zeros(length(State_ID),1);
for jj=1:length(Num_Sampled)
    t_ps=PS_fips==State_ID(jj);
    t_popsize=PopSize_fips==State_ID(jj);
    if((sum(t_ps)>0) && (sum(t_popsize)>0))
        Num_Sampled(jj)=raw_data(t_ps).*raw_data_popsize(t_popsize);
        Per_Surveyed(jj)=raw_data(t_ps);
    end
end
end


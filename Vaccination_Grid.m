clear;
clc;

for yy=2017:2022
    Pop=readtable([pwd '\Spatial_Data\Grid_Population_Properties_' num2str(yy) '.csv']);
    County_Vaccine_Uptake=readtable('Raw_and_Inferred_County_Uptake.xlsx','Sheet','MMR');
    County_Vaccine_Uptake=County_Vaccine_Uptake(County_Vaccine_Uptake.Year==yy,:);
    
    MMR_Vaccine_Uptake=zeros(height(Pop),1);
    for cc=1:height(County_Vaccine_Uptake)
        tf=str2double(County_Vaccine_Uptake.GEOID{cc})==Pop.GEOID;
        MMR_Vaccine_Uptake(tf)=County_Vaccine_Uptake.MMR_Vaccine_Uptake(cc);
    end
    Pop.MMR_Vaccine_Uptake=MMR_Vaccine_Uptake;
    writetable(Pop,[pwd '\Spatial_Data\Grid_Population_Properties_' num2str(yy) '.csv']);
end


Pop=readtable([pwd '\Spatial_Data\Grid_Population_Properties_' num2str(2023) '.csv']);
    County_Vaccine_Uptake=readtable('Raw_and_Inferred_County_Uptake.xlsx','Sheet','MMR');
    County_Vaccine_Uptake=County_Vaccine_Uptake(County_Vaccine_Uptake.Year==2022,:);
    
    MMR_Vaccine_Uptake=zeros(height(Pop),1);
    for cc=1:height(County_Vaccine_Uptake)
        tf=str2double(County_Vaccine_Uptake.GEOID{cc})==Pop.GEOID;
        MMR_Vaccine_Uptake(tf)=County_Vaccine_Uptake.MMR_Vaccine_Uptake(cc);
    end
    Pop.MMR_Vaccine_Uptake=MMR_Vaccine_Uptake;
    writetable(Pop,[pwd '\Spatial_Data\Grid_Population_Properties_' num2str(2023) '.csv']);
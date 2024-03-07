function [County_Demo,State_Demo]=Gen_Structure(Year_Data)

T=readtable('FIP_Code_Book.xlsx','Sheet','State');

T=T(T.state_level_FIPS~=2 & T.state_level_FIPS~=15 & T.state_level_FIPS<60,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State Structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
State_Demo.State_Name=T.state_name;
State_Demo.State_ID=T.state_level_FIPS;
%Male__Estimate__TotalPopulation
State_Demo.Sex.Male=NaN.*zeros(height(T),length(Year_Data));
%Male__Estimate__TotalPopulation
State_Demo.Sex.Female=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Age.Under_5.Male=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Age.Under_5.Female=NaN.*zeros(height(T),length(Year_Data));
% Estimate_Total_Total population_SELECTED AGE CATEGORIES_18 to 24 years
% Estimate_Total_Total population_AGE_25 to 29 years
% Estimate_Total_Total population_AGE_30 to 34 years
State_Demo.Age.Range_18_to_34=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_AGE_35 to 39 years
% Estimate_Total_Total population_AGE_40 to 44 years
% Estimate_Total_Total population_AGE_45 to 49 years
State_Demo.Age.Range_35_to_49=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_AGE_50 to 54 years
% Estimate_Total_Total population_AGE_55 to 59 years
% Estimate_Total_Total population_AGE_60 to 64 years
State_Demo.Age.Range_50_to_64=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_SELECTED AGE CATEGORIES_65 years and over
State_Demo.Age.Range_65_and_older=NaN.*zeros(height(T),length(Year_Data));


State_Demo.Education.Less_than_High_School=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Education.High_School=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Education.College=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Race.White=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Race.Black=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Race.Other=NaN.*zeros(height(T),length(Year_Data));


State_Demo.Economic.Lower=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Economic.Working=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Economic.Middle=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Economic.Upper=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Income=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Percent_Uninsured_Under_19=NaN.*zeros(height(T),length(Year_Data));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% County Structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=readgeotable(['cb_2018_us_county_500k.shp']);

State_FIP=str2double(T.STATEFP);

T=T(State_FIP~=2 & State_FIP~=15 & State_FIP<60,:);


County_Demo.County_Name={T.NAME};
County_Demo.State_ID=str2double(T.STATEFP);
County_Demo.County_ID=str2double(T.GEOID);
%Male__Estimate__TotalPopulation
County_Demo.Sex.Male=NaN.*zeros(height(T),length(Year_Data));
%Male__Estimate__TotalPopulation
County_Demo.Sex.Female=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_SELECTED AGE CATEGORIES_18 to 24 years
% Estimate_Total_Total population_AGE_25 to 29 years
% Estimate_Total_Total population_AGE_30 to 34 years
County_Demo.Age.Range_18_to_34=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_AGE_35 to 39 years
% Estimate_Total_Total population_AGE_40 to 44 years
% Estimate_Total_Total population_AGE_45 to 49 years
County_Demo.Age.Range_35_to_49=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_AGE_50 to 54 years
% Estimate_Total_Total population_AGE_55 to 59 years
% Estimate_Total_Total population_AGE_60 to 64 years
County_Demo.Age.Range_50_to_64=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_SELECTED AGE CATEGORIES_65 years and over
County_Demo.Age.Range_65_and_older=NaN.*zeros(height(T),length(Year_Data));


County_Demo.Education.Less_than_High_School=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Education.High_School=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Education.College=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Race.White=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Race.Black=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Race.Other=NaN.*zeros(height(T),length(Year_Data));


County_Demo.Economic.Lower=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Economic.Working=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Economic.Middle=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Economic.Upper=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Income=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Percent_Uninsured_Under_19=NaN.*zeros(height(T),length(Year_Data));
end
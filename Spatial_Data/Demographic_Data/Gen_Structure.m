function [County_Demo,State_Demo]=Gen_Structure(Year_Data)

T=readtable('FIP_Code_Book.xlsx','Sheet','State');

T=T(T.state_level_FIPS~=2 & T.state_level_FIPS~=15 & T.state_level_FIPS<60,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% State Structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
State_Demo.State_Name=T.state_name;
State_Demo.State_ID=T.state_level_FIPS;

State_Demo.Population.Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.White=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Black=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Other=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Male.White_Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Black_Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Other_Total=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Female.White_Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Black_Total=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Other_Total=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Male.White.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.White.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.White.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.White.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Female.White.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.White.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.White.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.White.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Male.Black.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Black.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Black.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Black.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Female.Black.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Black.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Black.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Black.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Male.Other.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Other.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Other.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Male.Other.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Population.Female.Other.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Other.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Other.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Population.Female.Other.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

State_Demo.Education.Less_than_High_School=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Education.High_School=NaN.*zeros(height(T),length(Year_Data));
State_Demo.Education.College=NaN.*zeros(height(T),length(Year_Data));

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

County_Demo.Population.Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.White=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Black=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Other=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Male.White_Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Black_Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Other_Total=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Female.White_Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Black_Total=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Other_Total=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Male.White.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.White.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.White.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.White.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Female.White.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.White.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.White.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.White.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Male.Black.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Black.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Black.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Black.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Female.Black.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Black.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Black.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Black.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Male.Other.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Other.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Other.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Male.Other.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Population.Female.Other.Age_18_34=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Other.Age_35_49=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Other.Age_50_64=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Population.Female.Other.Age_65_plus=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Education.Less_than_High_School=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Education.High_School=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Education.College=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Economic.Lower=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Economic.Working=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Economic.Middle=NaN.*zeros(height(T),length(Year_Data));
County_Demo.Economic.Upper=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Income=NaN.*zeros(height(T),length(Year_Data));

County_Demo.Percent_Uninsured_Under_19=NaN.*zeros(height(T),length(Year_Data));
end
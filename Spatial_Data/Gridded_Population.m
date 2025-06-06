clear;
clc;

% for yy=2017:2023
for yy=2021:2023
    County_Data=readtable('County_Data.xlsx','Sheet',['Year_' num2str(yy)]);
    if(yy>=2020)
        PT=readtable([pwd '\Demographic_Data\Gridded_Population\ppp_USA_2020_1km_Aggregated_UNadj.csv']);
    else
        PT=readtable([pwd '\Demographic_Data\Gridded_Population\ppp_USA_' num2str(yy) '_1km_Aggregated_UNadj.csv']);
    end

    
    PT=PT(PT.Z>0,:);

    PT.GEOID=cell(height(PT),1);
    PT.MMR_Religious_Exemption=NaN.*zeros(height(PT),1);
    PT.MMR_Philosophical_Exemption=NaN.*zeros(height(PT),1);
    PT.Other_Religious_Exemption=NaN.*zeros(height(PT),1);
    PT.Other_Philosophical_Exemption=NaN.*zeros(height(PT),1);
    PT.Population_5_to_9=NaN.*zeros(height(PT),1);
    PT.Population_20_to_24=NaN.*zeros(height(PT),1);
    PT.Population_25_to_29=NaN.*zeros(height(PT),1);
    PT.Population_30_to_34=NaN.*zeros(height(PT),1);
    PT.Population_35_to_39=NaN.*zeros(height(PT),1);
    PT.Population_40_to_44=NaN.*zeros(height(PT),1);

    PT.Education_Less_Grade_9=NaN.*zeros(height(PT),1);
    PT.Education_Grade_9_12=NaN.*zeros(height(PT),1);
    PT.Education_HS_Grad=NaN.*zeros(height(PT),1);
    PT.Education_Some_College=NaN.*zeros(height(PT),1);
    PT.Education_Associate_Degree=NaN.*zeros(height(PT),1);
    PT.Education_Bachelor_Degree=NaN.*zeros(height(PT),1);
    PT.Education_Grad_Prof_Degree=NaN.*zeros(height(PT),1);

    PT.PIR_Under_50=NaN.*zeros(height(PT),1);
    PT.PIR_50_74=NaN.*zeros(height(PT),1);
    PT.PIR_75_99=NaN.*zeros(height(PT),1);
    PT.PIR_100_124=NaN.*zeros(height(PT),1);
    PT.PIR_125_149=NaN.*zeros(height(PT),1);
    PT.PIR_150_174=NaN.*zeros(height(PT),1);
    PT.PIR_175_184=NaN.*zeros(height(PT),1);
    PT.PIR_185_199=NaN.*zeros(height(PT),1);
    PT.PIR_200_299=NaN.*zeros(height(PT),1);
    PT.PIR_300_399=NaN.*zeros(height(PT),1);
    PT.PIR_400_499=NaN.*zeros(height(PT),1);
    PT.PIR_500_over=NaN.*zeros(height(PT),1);

    PT.Median_Income_Family=NaN.*zeros(height(PT),1);
    
    PT.GINI_Index=NaN.*zeros(height(PT),1);

    PT.Population_White=NaN.*zeros(height(PT),1);
    PT.Population_African_American=NaN.*zeros(height(PT),1);
    PT.Population_AI_AN=NaN.*zeros(height(PT),1);
    PT.Population_Asian=NaN.*zeros(height(PT),1);
    PT.Population_NH_PI=NaN.*zeros(height(PT),1);

    PT.Uninsured=NaN.*zeros(height(PT),1);
    PT.Private_insured=NaN.*zeros(height(PT),1);
    PT.Public_insured=NaN.*zeros(height(PT),1);

    PT.Rural_Urban_Continum_Code=NaN.*zeros(height(PT),1);

    County_S=shaperead([pwd '\Demographic_Data\Shapefile\cb_' num2str(yy) '_us_county_20m.shp'],'UseGeoCoords',true);


    State_FIPc={County_S.STATEFP};
    State_FIP=zeros(size(State_FIPc));
    
    for ii=1:length(State_FIP)
        State_FIP(ii)=str2double(State_FIPc{ii});
    end
    
    County_S=County_S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

    for cc=1:length(County_S)
        tf=strcmp(County_Data.GEOID,County_S(cc).GEOID);
        [p_in,p_on]=inpolygon(PT.X,PT.Y,County_S(cc).Lon,County_S(cc).Lat);


        PT.GEOID(p_in|p_on)={County_Data.GEOID(tf)};
        PT.MMR_Religious_Exemption(p_in|p_on)=County_Data.MMR_Religious_Exemption(tf);
        PT.MMR_Philosophical_Exemption(p_in|p_on)=County_Data.MMR_Philosophical_Exemption(tf);
        PT.Other_Religious_Exemption(p_in|p_on)=County_Data.Other_Religious_Exemption(tf);
        PT.Other_Philosophical_Exemption(p_in|p_on)=County_Data.Other_Philosophical_Exemption(tf);
        PT.Population_5_to_9(p_in|p_on)=County_Data.Population_5_to_9(tf);
        PT.Population_20_to_24(p_in|p_on)=County_Data.Population_20_to_24(tf);
        PT.Population_25_to_29(p_in|p_on)=County_Data.Population_25_to_29(tf);
        PT.Population_30_to_34(p_in|p_on)=County_Data.Population_30_to_34(tf);
        PT.Population_35_to_39(p_in|p_on)=County_Data.Population_35_to_39(tf);
        PT.Population_40_to_44(p_in|p_on)=County_Data.Population_40_to_44(tf);
    
        PT.Education_Less_Grade_9(p_in|p_on)=County_Data.Education_Less_Grade_9(tf);
        PT.Education_Grade_9_12(p_in|p_on)=County_Data.Education_Grade_9_12(tf);
        PT.Education_HS_Grad(p_in|p_on)=County_Data.Education_HS_Grad(tf);
        PT.Education_Some_College(p_in|p_on)=County_Data.Education_Some_College(tf);
        PT.Education_Associate_Degree(p_in|p_on)=County_Data.Education_Associate_Degree(tf);
        PT.Education_Bachelor_Degree(p_in|p_on)=County_Data.Education_Bachelor_Degree(tf);
        PT.Education_Grad_Prof_Degree(p_in|p_on)=County_Data.Education_Grad_Prof_Degree(tf);
    
        PT.PIR_Under_50(p_in|p_on)=County_Data.PIR_Under_50(tf);
        PT.PIR_50_74(p_in|p_on)=County_Data.PIR_50_74(tf);
        PT.PIR_75_99(p_in|p_on)=County_Data.PIR_75_99(tf);
        PT.PIR_100_124(p_in|p_on)=County_Data.PIR_100_124(tf);
        PT.PIR_125_149(p_in|p_on)=County_Data.PIR_125_149(tf);
        PT.PIR_150_174(p_in|p_on)=County_Data.PIR_150_174(tf);
        PT.PIR_175_184(p_in|p_on)=County_Data.PIR_175_184(tf);
        PT.PIR_185_199(p_in|p_on)=County_Data.PIR_185_199(tf);
        PT.PIR_200_299(p_in|p_on)=County_Data.PIR_200_299(tf);
        PT.PIR_300_399(p_in|p_on)=County_Data.PIR_300_399(tf);
        PT.PIR_400_499(p_in|p_on)=County_Data.PIR_400_499(tf);
        PT.PIR_500_over(p_in|p_on)=County_Data.PIR_500_over(tf);
    
        PT.Median_Income_Family(p_in|p_on)=County_Data.Median_Income_Family(tf);
        
        PT.GINI_Index(p_in|p_on)=County_Data.GINI_Index(tf);
    
        PT.Population_White(p_in|p_on)=County_Data.Population_White(tf);
        PT.Population_African_American(p_in|p_on)=County_Data.Population_African_American(tf);
        PT.Population_AI_AN(p_in|p_on)=County_Data.Population_AI_AN(tf);
        PT.Population_Asian(p_in|p_on)=County_Data.Population_Asian(tf);
        PT.Population_NH_PI(p_in|p_on)=County_Data.Population_NH_PI(tf);
    
        PT.Uninsured(p_in|p_on)=County_Data.Uninsured(tf);
        PT.Private_insured(p_in|p_on)=County_Data.Private_insured(tf);
        PT.Public_insured(p_in|p_on)=County_Data.Public_insured(tf);
    
        PT.Rural_Urban_Continum_Code(p_in|p_on)=County_Data.Rural_Urban_Continum_Code(tf);
    end
    
    PT=PT(~isnan(PT.Population_5_to_9),:);
    writetable(PT,['Grid_Population_Properties_' num2str(yy) '.csv']);
end
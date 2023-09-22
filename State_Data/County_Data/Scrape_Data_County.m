clear;
clc;
rng('shuffle');
% https://data.census.gov/table?q=S0101
Year_Data=[2010:2021];
N_Samp=1000;
T=readtable('ACSST5Y2021.S0101-Data.csv');

T_County=T.GEO_ID;

State_ID=zeros(size(T_County));

for ii=1:length(State_ID)
    temp=T_County{ii};
    State_ID(ii)=str2double(temp(end-4:end-3));
end
N_Tot=height(T);
Population.County_Name=T.NAME;
Population.State_ID=State_ID;
%Male__Estimate__TotalPopulation
Population.Sex.Male=NaN.*zeros(height(T),length(Year_Data));
%Male__Estimate__TotalPopulation
Population.Sex.Female=NaN.*zeros(height(T),length(Year_Data));

Population.Age.Under_5.Male=NaN.*zeros(height(T),length(Year_Data));
Population.Age.Under_5.Female=NaN.*zeros(height(T),length(Year_Data));
% Estimate_Total_Total population_SELECTED AGE CATEGORIES_18 to 24 years
% Estimate_Total_Total population_AGE_25 to 29 years
% Estimate_Total_Total population_AGE_30 to 34 years
Population.Age.Range_18_to_34=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_AGE_35 to 39 years
% Estimate_Total_Total population_AGE_40 to 44 years
% Estimate_Total_Total population_AGE_45 to 49 years
Population.Age.Range_35_to_49=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_AGE_50 to 54 years
% Estimate_Total_Total population_AGE_55 to 59 years
% Estimate_Total_Total population_AGE_60 to 64 years
Population.Age.Range_50_to_64=NaN.*zeros(height(T),length(Year_Data));

% Estimate_Total_Total population_SELECTED AGE CATEGORIES_65 years and over
Population.Age.Range_65_and_older=NaN.*zeros(height(T),length(Year_Data));


Population.Education.Less_than_High_School=NaN.*zeros(height(T),length(Year_Data));
Population.Education.High_School=NaN.*zeros(height(T),length(Year_Data));
Population.Education.College=NaN.*zeros(height(T),length(Year_Data));

Population.Race.White=NaN.*zeros(height(T),length(Year_Data));
Population.Race.Black=NaN.*zeros(height(T),length(Year_Data));
Population.Race.Other=NaN.*zeros(height(T),length(Year_Data));


Population.Economic.Lower=NaN.*zeros(height(T),length(Year_Data));
Population.Economic.Working=NaN.*zeros(height(T),length(Year_Data));
Population.Economic.Middle=NaN.*zeros(height(T),length(Year_Data));
Population.Economic.Upper=NaN.*zeros(height(T),length(Year_Data));

Population.Income=NaN.*zeros(height(T),length(Year_Data));

%Population.Household_Children_under_18=NaN.*zeros(height(T),length(Year_Data));

for yy=1:length(Year_Data)
    T=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S0101-Data.csv']);
    tf=ismember(T.GEO_ID,T_County);
    T=T(tf,:);
    
    E=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1501-Data.csv']);
    tf=ismember(E.GEO_ID,T_County);
    E=E(tf,:);
    
    Ec=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1901-Data.csv']);
    tf=ismember(Ec.GEO_ID,T_County);
    Ec=Ec(tf,:);
    
    RW=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001H-Data.csv']);
    tf=ismember(RW.GEO_ID,T_County);
    RW=RW(tf,:);
    
    RB=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001B-Data.csv']);
    tf=ismember(RB.GEO_ID,T_County);
    RB=RB(tf,:);
        
    temp_EC=Ec.S1901_C01_001E;
    temp_EC_ME=Ec.S1901_C01_001M;
    
    if(~isnan(str2double(temp_EC(1))))
        temp_EC=str2double(temp_EC);
        temp_EC_ME=str2double(temp_EC_ME);
    end


    temp_EC_std=zeros(size(temp_EC_ME));
       
    temp_lower1=Ec.S1901_C01_002E;
    temp_lower2=Ec.S1901_C01_003E;
    temp_lower3=Ec.S1901_C01_004E;
    
    temp_work1=Ec.S1901_C01_005E;
    temp_work2=Ec.S1901_C01_006E;
    
    temp_middle1=Ec.S1901_C01_007E;
    temp_middle2=Ec.S1901_C01_008E;
    
    temp_upper1=Ec.S1901_C01_009E;
    temp_upper2=Ec.S1901_C01_010E;
    temp_upper3=Ec.S1901_C01_011E;   
    
    temp_income_house=Ec.S1901_C01_012E; 

    temp_lower1_ME=Ec.S1901_C01_002M;
    temp_lower2_ME=Ec.S1901_C01_003M;
    temp_lower3_ME=Ec.S1901_C01_004M;
    
    temp_work1_ME=Ec.S1901_C01_005M;
    temp_work2_ME=Ec.S1901_C01_006M;
    
    temp_middle1_ME=Ec.S1901_C01_007M;
    temp_middle2_ME=Ec.S1901_C01_008M;
    
    temp_upper1_ME=Ec.S1901_C01_009M;
    temp_upper2_ME=Ec.S1901_C01_010M;
    temp_upper3_ME=Ec.S1901_C01_011M;   
    
    temp_income_house_ME=Ec.S1901_C01_012M; 
    
    if(~isnan(str2double(temp_lower1(1))))
       temp_lower1=str2double(temp_lower1); 
       temp_lower2=str2double(temp_lower2);
       temp_lower3=str2double(temp_lower3);
       
       temp_work1=str2double(temp_work1);
       temp_work2=str2double(temp_work2);
       
       temp_middle1=str2double(temp_middle1);
       temp_middle2=str2double(temp_middle2);
       
       temp_upper1=str2double(temp_upper1);
       temp_upper2=str2double(temp_upper2);
       temp_upper3=str2double(temp_upper3);


       temp_lower1_ME=str2double(temp_lower1_ME); 
       temp_lower2_ME=str2double(temp_lower2_ME);
       temp_lower3_ME=str2double(temp_lower3_ME);
       
       temp_work1_ME=str2double(temp_work1_ME);
       temp_work2_ME=str2double(temp_work2_ME);
       
       temp_middle1_ME=str2double(temp_middle1_ME);
       temp_middle2_ME=str2double(temp_middle2_ME);
       
       temp_upper1_ME=str2double(temp_upper1_ME);
       temp_upper2_ME=str2double(temp_upper2_ME);
       temp_upper3_ME=str2double(temp_upper3_ME);
       
    end
    
    if(~isnan(str2double(temp_income_house(1))))        
       temp_income_house=str2double(temp_income_house);     
       temp_income_house_ME=str2double(temp_income_house_ME); 
    end
    

    temp_lower1_std=zeros(size(temp_lower1_ME));
    temp_lower2_std=zeros(size(temp_lower1_ME));
    temp_lower3_std=zeros(size(temp_lower1_ME));
    
    temp_work1_std=zeros(size(temp_lower1_ME));
    temp_work2_std=zeros(size(temp_lower1_ME));
    
    temp_middle1_std=zeros(size(temp_lower1_ME));
    temp_middle2_std=zeros(size(temp_lower1_ME));
    
    temp_upper1_std=zeros(size(temp_lower1_ME));
    temp_upper2_std=zeros(size(temp_lower1_ME));
    temp_upper3_std=zeros(size(temp_lower1_ME));
    
    
    temp_income_house_std=zeros(size(temp_income_house_ME));


    temp_E_Pop_18=E.S1501_C01_001E;
    temp_LHS_18=E.S1501_C01_002E;
    temp_HS_18=E.S1501_C01_003E;
    temp_C1_18=E.S1501_C01_004E;
    temp_C2_18=E.S1501_C01_005E;
    
    temp_E_Pop_25=E.S1501_C01_006E;
    temp_LHS1_25=E.S1501_C01_007E;
    temp_LHS2_25=E.S1501_C01_008E;
    temp_HS_25=E.S1501_C01_009E;
    temp_C1_25=E.S1501_C01_010E;
    temp_C2_25=E.S1501_C01_011E;
    temp_C3_25=E.S1501_C01_012E;
    temp_C4_25=E.S1501_C01_013E;
    
    temp_pop_total=T.S0101_C01_001E;
    
    temp_white=RW.B01001H_001E;
    temp_black=RB.B01001B_001E;
    
    
    temp_25_29=T.S0101_C01_007E;
    temp_30_34=T.S0101_C01_008E;

    temp_35_39=T.S0101_C01_009E;
    temp_40_44=T.S0101_C01_010E;
    temp_45_49=T.S0101_C01_011E;

    temp_50_54=T.S0101_C01_012E;
    temp_55_59=T.S0101_C01_013E;
    temp_60_64=T.S0101_C01_014E;

    temp_E_Pop_18_ME=E.S1501_C01_001M;
    temp_LHS_18_ME=E.S1501_C01_002M;
    temp_HS_18_ME=E.S1501_C01_003M;
    temp_C1_18_ME=E.S1501_C01_004M;
    temp_C2_18_ME=E.S1501_C01_005M;

    temp_E_Pop_25_ME=E.S1501_C01_006M;
    temp_LHS1_25_ME=E.S1501_C01_007M;
    temp_LHS2_25_ME=E.S1501_C01_008M;
    temp_HS_25_ME=E.S1501_C01_009M;
    temp_C1_25_ME=E.S1501_C01_010M;
    temp_C2_25_ME=E.S1501_C01_011M;
    temp_C3_25_ME=E.S1501_C01_012M;
    temp_C4_25_ME=E.S1501_C01_013M;   
    
    temp_white_ME=RW.B01001H_001M;
    temp_black_ME=RB.B01001B_001M;
    
    temp_25_29_ME=T.S0101_C01_007M;
    temp_30_34_ME=T.S0101_C01_008M;

    temp_35_39_ME=T.S0101_C01_009M;
    temp_40_44_ME=T.S0101_C01_010M;
    temp_45_49_ME=T.S0101_C01_011M;

    temp_50_54_ME=T.S0101_C01_012M;
    temp_55_59_ME=T.S0101_C01_013M;
    temp_60_64_ME=T.S0101_C01_014M;
    
    if(Year_Data(yy)<2017)
        temp_male=T.S0101_C02_001E;
        temp_female=T.S0101_C03_001E;

        temp_18_24=T.S0101_C01_022E;

        temp_65_over=T.S0101_C01_028E;
        
        %temp_under_5_male=T.S0101_C02_002E;
        %temp_under_5_female=T.S0101_C03_002E;

        temp_male_ME=T.S0101_C02_001M;
        temp_female_ME=T.S0101_C03_001M;

        temp_18_24_ME=T.S0101_C01_022M;

        temp_65_over_ME=T.S0101_C01_028M;
        
        %temp_under_5_male_ME=T.S0101_C02_002M;
        %temp_under_5_female_ME=T.S0101_C03_002M;

    else        
        temp_male=T.S0101_C03_001E;
        temp_female=T.S0101_C05_001E;

        temp_18_24=T.S0101_C01_023E;

        temp_65_over=T.S0101_C01_030E;
        
        
        %temp_under_5_male=T.S0101_C03_002E;
        %temp_under_5_female=T.S0101_C05_002E;

        temp_male_ME=T.S0101_C03_001M;
        temp_female_ME=T.S0101_C05_001M;

        temp_18_24_ME=T.S0101_C01_023M;

        temp_65_over_ME=T.S0101_C01_030M;
        
        
        %temp_under_5_male_ME=T.S0101_C03_002M;
        %temp_under_5_female_ME=T.S0101_C05_002M;
    end
    
    temp_white_std=zeros(size(temp_white_ME));
    temp_black_std=zeros(size(temp_black_ME));   

    temp_E_Pop_18_std=zeros(size(temp_E_Pop_18_ME));
    temp_LHS_18_std=zeros(size(temp_E_Pop_18_ME));
    temp_HS_18_std=zeros(size(temp_E_Pop_18_ME));
    temp_C1_18_std=zeros(size(temp_E_Pop_18_ME));
    temp_C2_18_std=zeros(size(temp_E_Pop_18_ME));
    
    temp_E_Pop_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_LHS1_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_LHS2_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_HS_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_C1_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_C2_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_C3_25_std=zeros(size(temp_E_Pop_25_ME));
    temp_C4_25_std=zeros(size(temp_E_Pop_25_ME));

    temp_25_29_std=zeros(size(temp_25_29_ME));
    temp_30_34_std=zeros(size(temp_25_29_ME));

    temp_35_39_std=zeros(size(temp_25_29_ME));
    temp_40_44_std=zeros(size(temp_25_29_ME));
    temp_45_49_std=zeros(size(temp_25_29_ME));

    temp_50_54_std=zeros(size(temp_25_29_ME));
    temp_55_59_std=zeros(size(temp_25_29_ME));
    temp_60_64_std=zeros(size(temp_25_29_ME));

    temp_male_std=zeros(size(temp_male));
    temp_female_std=zeros(size(temp_male));

    temp_18_24_std=zeros(size(temp_male));

    temp_65_over_std=zeros(size(temp_male));
    
    %temp_under_5_male_std=zeros(size(temp_male));
    %temp_under_5_female_std=zeros(size(temp_male));
    
    if(~isnan(str2double(temp_LHS_18(1))))     
        
        temp_LHS_18=str2double(temp_LHS_18);
        temp_HS_18=str2double(temp_HS_18);
        temp_C1_18=str2double(temp_C1_18);
        temp_C2_18=str2double(temp_C2_18);


        temp_LHS_18_ME=str2double(temp_LHS_18_ME);
        temp_HS_18_ME=str2double(temp_HS_18_ME);
        temp_C1_18_ME=str2double(temp_C1_18_ME);
        temp_C2_18_ME=str2double(temp_C2_18_ME);
          
    end
    
    if(~isnan(str2double(temp_white(1))))
            temp_white=str2double(temp_white);
            temp_white_ME=str2double(temp_white_ME);
    end
        
    if(~isnan(str2double(temp_black(1))))
        temp_black=str2double(temp_black);
        temp_black_ME=str2double(temp_black_ME);
    end
    
    if(~isnan(str2double(temp_E_Pop_18(1))))
            temp_E_Pop_18=str2double(temp_E_Pop_18);
            temp_E_Pop_18_ME=str2double(temp_E_Pop_18_ME);
    end
        
    if(~isnan(str2double(temp_E_Pop_25(1))))
        temp_E_Pop_25=str2double(temp_E_Pop_25);
        temp_E_Pop_25_ME=str2double(temp_E_Pop_25_ME);
    end
    
    if(~isnan(str2double(temp_LHS1_25(1))))       
        temp_LHS1_25=str2double(temp_LHS1_25);
        temp_LHS2_25=str2double(temp_LHS2_25);
        temp_HS_25=str2double(temp_HS_25);
        temp_C1_25=str2double(temp_C1_25);
        temp_C2_25=str2double(temp_C2_25);
        temp_C3_25=str2double(temp_C3_25);
        temp_C4_25=str2double(temp_C4_25); 

        temp_LHS1_25_ME=str2double(temp_LHS1_25_ME);
        temp_LHS2_25_ME=str2double(temp_LHS2_25_ME);
        temp_HS_25_ME=str2double(temp_HS_25_ME);
        temp_C1_25_ME=str2double(temp_C1_25_ME);
        temp_C2_25_ME=str2double(temp_C2_25_ME);
        temp_C3_25_ME=str2double(temp_C3_25_ME);
        temp_C4_25_ME=str2double(temp_C4_25_ME); 
    end
    
    if(~isnan(str2double(temp_male(1))))
        temp_male=str2double(temp_male);
        temp_female=str2double(temp_female);
        
        temp_pop_total=str2double(temp_pop_total);
        
        temp_18_24=str2double(temp_18_24);
        temp_25_29=str2double(temp_25_29);
        temp_30_34=str2double(temp_30_34);
        
        temp_35_39=str2double(temp_35_39);
        temp_40_44=str2double(temp_40_44);
        temp_45_49=str2double(temp_45_49);
        
        temp_50_54=str2double(temp_50_54);
        temp_55_59=str2double(temp_55_59);
        temp_60_64=str2double(temp_60_64);
        
        temp_65_over=str2double(temp_65_over);
        
        %temp_under_5_male=str2double(%temp_under_5_male);
        %temp_under_5_female=str2double(%temp_under_5_female);

        temp_male_ME=str2double(temp_male_ME);
        temp_female_ME=str2double(temp_female_ME);
        
        temp_pop_total_ME=str2double(temp_pop_total_ME);
        
        temp_18_24_ME=str2double(temp_18_24_ME);
        temp_25_29_ME=str2double(temp_25_29_ME);
        temp_30_34_ME=str2double(temp_30_34_ME);
        
        temp_35_39_ME=str2double(temp_35_39_ME);
        temp_40_44_ME=str2double(temp_40_44_ME);
        temp_45_49_ME=str2double(temp_45_49_ME);
        
        temp_50_54_ME=str2double(temp_50_54_ME);
        temp_55_59_ME=str2double(temp_55_59_ME);
        temp_60_64_ME=str2double(temp_60_64_ME);
        
        temp_65_over_ME=str2double(temp_65_over_ME);
        
        %temp_under_5_male_ME=str2double(%temp_under_5_male_ME);
        %temp_under_5_female_ME=str2double(%temp_under_5_female_ME);
    end
    

    temp_EC_ME(temp_EC_ME<0 | isnan(temp_EC_ME))=10^(-3);
    temp_lower1_ME(temp_lower1_ME<0 | isnan(temp_lower1_ME))=10^(-3);
    temp_lower2_ME(temp_lower2_ME<0 | isnan(temp_lower1_ME))=10^(-3);
    temp_lower3_ME(temp_lower3_ME<0 | isnan(temp_lower3_ME))=10^(-3);
    
    temp_work1_ME(temp_work1_ME<0 | isnan(temp_work1_ME))=10^(-3);
    temp_work2_ME(temp_work2_ME<0 | isnan(temp_work2_ME))=10^(-3);
    
    temp_middle1_ME(temp_middle1_ME<0 | isnan(temp_middle1_ME))=10^(-3);
    temp_middle2_ME(temp_middle2_ME<0 | isnan(temp_middle2_ME))=10^(-3);
    
    temp_upper1_ME(temp_upper1_ME<0 | isnan(temp_upper1_ME))=10^(-3);
    temp_upper2_ME(temp_upper2_ME<0 | isnan(temp_upper2_ME))=10^(-3);
    temp_upper3_ME(temp_upper3_ME<0 | isnan(temp_upper3_ME))=10^(-3);
    
    temp_income_house_ME(temp_income_house_ME<0 | isnan(temp_income_house_ME))=10^(-3);

    temp_E_Pop_18_ME(temp_E_Pop_18_ME<0 | isnan(temp_E_Pop_18_ME))=10^(-3);
    temp_LHS_18_ME(temp_LHS_18_ME<0 | isnan(temp_LHS_18_ME))=10^(-3);
    temp_HS_18_ME(temp_HS_18_ME<0 | isnan(temp_HS_18_ME))=10^(-3);
    temp_C1_18_ME(temp_C1_18_ME<0 | isnan(temp_C1_18_ME))=10^(-3);
    temp_C2_18_ME(temp_C2_18_ME<0 | isnan(temp_C2_18_ME))=10^(-3);

    temp_E_Pop_25_ME(temp_E_Pop_25_ME<0 | isnan(temp_E_Pop_25_ME))=10^(-3);
    temp_LHS1_25_ME(temp_LHS1_25_ME<0 | isnan(temp_LHS1_25_ME))=10^(-3);
    temp_LHS2_25_ME(temp_LHS2_25_ME<0 | isnan(temp_LHS2_25_ME))=10^(-3);
    temp_HS_25_ME(temp_HS_25_ME<0 | isnan(temp_HS_25_ME))=10^(-3);
    temp_C1_25_ME(temp_C1_25_ME<0 | isnan(temp_C1_25_ME))=10^(-3);
    temp_C2_25_ME(temp_C2_25_ME<0 | isnan(temp_C2_25_ME))=10^(-3);
    temp_C3_25_ME(temp_C3_25_ME<0 | isnan(temp_C3_25_ME))=10^(-3);
    temp_C4_25_ME(temp_C4_25_ME<0 | isnan(temp_C4_25_ME))=10^(-3);
    
    temp_white_ME(temp_white_ME<0 | isnan(temp_white_ME))=10^(-3);
    temp_black_ME(temp_black_ME<0 | isnan(temp_black_ME))=10^(-3);
    
    temp_25_29_ME(temp_25_29_ME<0 | isnan(temp_25_29_ME))=10^(-3);
    temp_30_34_ME(temp_30_34_ME<0 | isnan(temp_30_34_ME))=10^(-3);

    temp_35_39_ME(temp_35_39_ME<0 | isnan(temp_35_39_ME))=10^(-3);
    temp_40_44_ME(temp_40_44_ME<0 | isnan(temp_40_44_ME))=10^(-3);
    temp_45_49_ME(temp_45_49_ME<0 | isnan(temp_45_49_ME))=10^(-3);

    temp_50_54_ME(temp_50_54_ME<0 | isnan(temp_50_54_ME))=10^(-3);
    temp_55_59_ME(temp_55_59_ME<0 | isnan(temp_55_59_ME))=10^(-3);
    temp_60_64_ME(temp_60_64_ME<0 | isnan(temp_60_64_ME))=10^(-3);
    temp_65_over_ME(temp_65_over_ME<0 | isnan(temp_65_over_ME))=10^(-3);

    temp_18_24_ME(temp_18_24_ME<0 | isnan(temp_18_24_ME))=10^(-3);
    temp_male_ME(temp_male_ME<0 | isnan(temp_male_ME))=10^(-3);
    temp_female_ME(temp_female_ME<0 | isnan(temp_female_ME))=10^(-3);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the std for the distributeion
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-10),'MaxFunctionEvaluations',1000,'MaxIterations',2500,'StepTolerance',10^(-8));
    N_temp=length(temp_EC_std);
    parfor tt=1:N_temp
        if(~isnan(temp_EC(tt)))
            temp_EC_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_EC(tt),z)-(temp_EC(tt)-temp_EC_ME(tt)));(norminv(0.95,temp_EC(tt),z)-(temp_EC(tt)+temp_EC_ME(tt)))]),temp_EC_ME(tt),[],[],options);
        end        
        if(~isnan(temp_lower1(tt)))
            temp_lower1_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_lower1(tt),z)-(temp_lower1(tt)-temp_lower1_ME(tt)));(norminv(0.95,temp_lower1(tt),z)-(temp_lower1(tt)+temp_lower1_ME(tt)))]),temp_lower1_ME(tt),[],[],options);
        end        
        if(~isnan(temp_lower2(tt)))
            temp_lower2_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_lower2(tt),z)-(temp_lower2(tt)-temp_lower2_ME(tt)));(norminv(0.95,temp_lower2(tt),z)-(temp_lower2(tt)+temp_lower2_ME(tt)))]),temp_lower2_ME(tt),[],[],options);
        end        
        if(~isnan(temp_lower3(tt)))
            temp_lower3_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_lower3(tt),z)-(temp_lower3(tt)-temp_lower3_ME(tt)));(norminv(0.95,temp_lower3(tt),z)-(temp_lower3(tt)+temp_lower3_ME(tt)))]),temp_lower3_ME(tt),[],[],options);
        end        
        if(~isnan(temp_work1(tt)))
            temp_work1_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_work1(tt),z)-(temp_work1(tt)-temp_work1_ME(tt)));(norminv(0.95,temp_work1(tt),z)-(temp_work1(tt)+temp_work1_ME(tt)))]),temp_work1_ME(tt),[],[],options);
        end        
        if(~isnan(temp_work2(tt)))
            temp_work2_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_work2(tt),z)-(temp_work2(tt)-temp_work2_ME(tt)));(norminv(0.95,temp_work2(tt),z)-(temp_work2(tt)+temp_work2_ME(tt)))]),temp_work2_ME(tt),[],[],options);
        end        
        if(~isnan(temp_middle1(tt)))
            temp_middle1_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_middle1(tt),z)-(temp_middle1(tt)-temp_middle1_ME(tt)));(norminv(0.95,temp_middle1(tt),z)-(temp_middle1(tt)+temp_middle1_ME(tt)))]),temp_middle1_ME(tt),[],[],options);
        end        
        if(~isnan(temp_middle2(tt)))
            temp_middle2_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_middle2(tt),z)-(temp_middle2(tt)-temp_middle2_ME(tt)));(norminv(0.95,temp_middle2(tt),z)-(temp_middle2(tt)+temp_middle2_ME(tt)))]),temp_middle2_ME(tt),[],[],options);
        end        
        if(~isnan(temp_upper1(tt)))
            temp_upper1_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_upper1(tt),z)-(temp_upper1(tt)-temp_upper1_ME(tt)));(norminv(0.95,temp_upper1(tt),z)-(temp_upper1(tt)+temp_upper1_ME(tt)))]),temp_upper1_ME(tt),[],[],options);
        end        
        if(~isnan(temp_upper2(tt)))
            temp_upper2_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_upper2(tt),z)-(temp_upper2(tt)-temp_upper2_ME(tt)));(norminv(0.95,temp_upper2(tt),z)-(temp_upper2(tt)+temp_upper2_ME(tt)))]),temp_upper2_ME(tt),[],[],options);
        end        
        if(~isnan(temp_upper3(tt)))
            temp_upper3_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_upper3(tt),z)-(temp_upper3(tt)-temp_upper3_ME(tt)));(norminv(0.95,temp_upper3(tt),z)-(temp_upper3(tt)+temp_upper3_ME(tt)))]),temp_upper3_ME(tt),[],[],options);
        end        
        if(~isnan(temp_income_house(tt)))
            temp_income_house_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_income_house(tt),z)-(temp_income_house(tt)-temp_income_house_ME(tt)));(norminv(0.95,temp_income_house(tt),z)-(temp_income_house(tt)+temp_income_house_ME(tt)))]),temp_income_house_ME(tt),[],[],options);
        end        
        if(~isnan(temp_E_Pop_18(tt)))
            temp_E_Pop_18_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_E_Pop_18(tt),z)-(temp_E_Pop_18(tt)-temp_E_Pop_18_ME(tt)));(norminv(0.95,temp_E_Pop_18(tt),z)-(temp_E_Pop_18(tt)+temp_E_Pop_18_ME(tt)))]),temp_E_Pop_18_ME(tt),[],[],options);
        end        
        if(~isnan(temp_LHS_18(tt)))
            temp_LHS_18_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_LHS_18(tt),z)-(temp_LHS_18(tt)-temp_LHS_18_ME(tt)));(norminv(0.95,temp_LHS_18(tt),z)-(temp_LHS_18(tt)+temp_LHS_18_ME(tt)))]),temp_LHS_18_ME(tt),[],[],options);
        end        
        if(~isnan(temp_HS_18(tt)))
            temp_HS_18_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_HS_18(tt),z)-(temp_HS_18(tt)-temp_HS_18_ME(tt)));(norminv(0.95,temp_HS_18(tt),z)-(temp_HS_18(tt)+temp_HS_18_ME(tt)))]),temp_HS_18_ME(tt),[],[],options);
        end        
        if(~isnan(temp_C1_18(tt)))
            temp_C1_18_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_C1_18(tt),z)-(temp_C1_18(tt)-temp_C1_18_ME(tt)));(norminv(0.95,temp_C1_18(tt),z)-(temp_C1_18(tt)+temp_C1_18_ME(tt)))]),temp_C1_18_ME(tt),[],[],options);
        end        
        if(~isnan(temp_C2_18(tt)))
            temp_C2_18_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_C2_18(tt),z)-(temp_C2_18(tt)-temp_C2_18_ME(tt)));(norminv(0.95,temp_C2_18(tt),z)-(temp_C2_18(tt)+temp_C2_18_ME(tt)))]),temp_C2_18_ME(tt),[],[],options);
        end        
        if(~isnan(temp_E_Pop_25(tt)))
            temp_E_Pop_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_E_Pop_25(tt),z)-(temp_E_Pop_25(tt)-temp_E_Pop_25_ME(tt)));(norminv(0.95,temp_E_Pop_25(tt),z)-(temp_E_Pop_25(tt)+temp_E_Pop_25_ME(tt)))]),temp_E_Pop_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_LHS1_25(tt)))
            temp_LHS1_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_LHS1_25(tt),z)-(temp_LHS1_25(tt)-temp_LHS1_25_ME(tt)));(norminv(0.95,temp_LHS1_25(tt),z)-(temp_LHS1_25(tt)+temp_LHS1_25_ME(tt)))]),temp_LHS1_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_LHS2_25(tt)))
            temp_LHS2_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_LHS2_25(tt),z)-(temp_LHS2_25(tt)-temp_LHS2_25_ME(tt)));(norminv(0.95,temp_LHS2_25(tt),z)-(temp_LHS2_25(tt)+temp_LHS2_25_ME(tt)))]),temp_LHS2_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_HS_25(tt)))
            temp_HS_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_HS_25(tt),z)-(temp_HS_25(tt)-temp_HS_25_ME(tt)));(norminv(0.95,temp_HS_25(tt),z)-(temp_HS_25(tt)+temp_HS_25_ME(tt)))]),temp_HS_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_C1_25(tt)))
            temp_C1_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_C1_25(tt),z)-(temp_C1_25(tt)-temp_C1_25_ME(tt)));(norminv(0.95,temp_C1_25(tt),z)-(temp_C1_25(tt)+temp_C1_25_ME(tt)))]),temp_C1_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_C2_25(tt)))
            temp_C2_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_C2_25(tt),z)-(temp_C2_25(tt)-temp_C2_25_ME(tt)));(norminv(0.95,temp_C2_25(tt),z)-(temp_C2_25(tt)+temp_C2_25_ME(tt)))]),temp_C2_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_C3_25(tt)))
            temp_C3_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_C3_25(tt),z)-(temp_C3_25(tt)-temp_C3_25_ME(tt)));(norminv(0.95,temp_C3_25(tt),z)-(temp_C3_25(tt)+temp_C3_25_ME(tt)))]),temp_C3_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_C4_25(tt)))
            temp_C4_25_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_C4_25(tt),z)-(temp_C4_25(tt)-temp_C4_25_ME(tt)));(norminv(0.95,temp_C4_25(tt),z)-(temp_C4_25(tt)+temp_C4_25_ME(tt)))]),temp_C4_25_ME(tt),[],[],options);
        end        
        if(~isnan(temp_25_29(tt)))
            temp_25_29_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_25_29(tt),z)-(temp_25_29(tt)-temp_25_29_ME(tt)));(norminv(0.95,temp_25_29(tt),z)-(temp_25_29(tt)+temp_25_29_ME(tt)))]),temp_25_29_ME(tt),[],[],options);
        end        
        if(~isnan(temp_30_34(tt)))
            temp_30_34_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_30_34(tt),z)-(temp_30_34(tt)-temp_30_34_ME(tt)));(norminv(0.95,temp_30_34(tt),z)-(temp_30_34(tt)+temp_30_34_ME(tt)))]),temp_30_34_ME(tt),[],[],options);
        end        
        if(~isnan(temp_35_39(tt)))
            temp_35_39_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_35_39(tt),z)-(temp_35_39(tt)-temp_35_39_ME(tt)));(norminv(0.95,temp_35_39(tt),z)-(temp_35_39(tt)+temp_35_39_ME(tt)))]),temp_35_39_ME(tt),[],[],options);
        end        
        if(~isnan(temp_40_44(tt)))
            temp_40_44_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_40_44(tt),z)-(temp_40_44(tt)-temp_40_44_ME(tt)));(norminv(0.95,temp_40_44(tt),z)-(temp_40_44(tt)+temp_40_44_ME(tt)))]),temp_40_44_ME(tt),[],[],options);
        end        
        if(~isnan(temp_45_49(tt)))
            temp_45_49_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_45_49(tt),z)-(temp_45_49(tt)-temp_45_49_ME(tt)));(norminv(0.95,temp_45_49(tt),z)-(temp_45_49(tt)+temp_45_49_ME(tt)))]),temp_45_49_ME(tt),[],[],options);
        end        
        if(~isnan(temp_50_54(tt)))
            temp_50_54_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_50_54(tt),z)-(temp_50_54(tt)-temp_50_54_ME(tt)));(norminv(0.95,temp_50_54(tt),z)-(temp_50_54(tt)+temp_50_54_ME(tt)))]),temp_50_54_ME(tt),[],[],options);
        end        
        if(~isnan(temp_55_59(tt)))
            temp_55_59_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_55_59(tt),z)-(temp_55_59(tt)-temp_55_59_ME(tt)));(norminv(0.95,temp_55_59(tt),z)-(temp_55_59(tt)+temp_55_59_ME(tt)))]),temp_55_59_ME(tt),[],[],options);
        end        
        if(~isnan(temp_60_64(tt)))
            temp_60_64_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_60_64(tt),z)-(temp_60_64(tt)-temp_60_64_ME(tt)));(norminv(0.95,temp_60_64(tt),z)-(temp_60_64(tt)+temp_60_64_ME(tt)))]),temp_60_64_ME(tt),[],[],options);
        end        
        if(~isnan(temp_male(tt)))
            temp_male_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_male(tt),z)-(temp_male(tt)-temp_male_ME(tt)));(norminv(0.95,temp_male(tt),z)-(temp_male(tt)+temp_male_ME(tt)))]),temp_male_ME(tt),[],[],options);
        end        
        if(~isnan(temp_female(tt)))
            temp_female_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_female(tt),z)-(temp_female(tt)-temp_female_ME(tt)));(norminv(0.95,temp_female(tt),z)-(temp_female(tt)+temp_female_ME(tt)))]),temp_female_ME(tt),[],[],options);
        end        
        if(~isnan(temp_18_24(tt)))
            temp_18_24_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_18_24(tt),z)-(temp_18_24(tt)-temp_18_24_ME(tt)));(norminv(0.95,temp_18_24(tt),z)-(temp_18_24(tt)+temp_18_24_ME(tt)))]),temp_18_24_ME(tt),[],[],options);
        end        
        if(~isnan(temp_65_over(tt)))
            temp_65_over_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_65_over(tt),z)-(temp_65_over(tt)-temp_65_over_ME(tt)));(norminv(0.95,temp_65_over(tt),z)-(temp_65_over(tt)+temp_65_over_ME(tt)))]),temp_65_over_ME(tt),[],[],options);
        end
        %temp_under_5_male_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_under_5_male(tt),z)-(temp_under_5_male(tt)-temp_under_5_male_ME(tt)));(norminv(0.95,temp_under_5_male(tt),z)-(temp_under_5_male(tt)+temp_under_5_male_ME(tt)))]),temp_under_5_male_ME(tt),[],[],options);
        %temp_under_5_female_std(tt)=lsqnonlin(@(z)([(norminv(0.05,temp_under_5_female(tt),z)-(temp_under_5_female(tt)-temp_under_5_female_ME(tt)));(norminv(0.95,temp_under_5_female(tt),z)-(temp_under_5_female(tt)+temp_under_5_female_ME(tt)))]),temp_under_5_female_ME(tt),[],[],options);

    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Calculate outcomes for aggregated compartments
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    
    if(yy==1)
        temp_white_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_black_v=zeros(N_Tot,length(Year_Data),N_Samp);
        
        temp_65_over_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_income_house_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_male_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_female_v=zeros(N_Tot,length(Year_Data),N_Samp);
        
        temp_18_24_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_25_29_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_30_34_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_35_39_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_40_44_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_45_49_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_50_54_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_55_59_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_60_64_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_E_Pop_18_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_LHS_18_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_E_Pop_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_LHS1_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_LHS2_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_HS_18_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_HS_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_C1_18_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_C2_18_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_C1_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_C2_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_C3_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_C4_25_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_lower1_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_lower2_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_lower3_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_work1_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_work2_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_middle1_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_middle2_v=zeros(N_Tot,length(Year_Data),N_Samp);
        
        temp_upper1_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_upper2_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_upper3_v=zeros(N_Tot,length(Year_Data),N_Samp);
    
        temp_EC_v=zeros(N_Tot,length(Year_Data),N_Samp);
        temp_pop_total_v=zeros(N_Tot,length(Year_Data),N_Samp);
    end
    for zz=1:N_Tot
        t_cindx=ismember(T.GEO_ID,T_County{zz});
        if(sum(t_cindx)>0)
            temp_EC_v(zz,yy,:)=normrnd(temp_EC(t_cindx),temp_EC_std(t_cindx),1,N_Samp);
            temp_income_house_v(zz,yy,:)=normrnd(temp_income_house(t_cindx),temp_income_house_std(t_cindx),1,N_Samp);
    
            temp_white_v(zz,yy,:)=normrnd(temp_white(t_cindx),temp_white_std(t_cindx),1,N_Samp);
            temp_black_v(zz,yy,:)=normrnd(temp_black(t_cindx),temp_black_std(t_cindx),1,N_Samp);
    
            temp_male_v(zz,yy,:)=normrnd(temp_male(t_cindx),temp_male_std(t_cindx),1,N_Samp);
            temp_female_v(zz,yy,:)=normrnd(temp_female(t_cindx),temp_female_std(t_cindx),1,N_Samp);
        
            temp_18_24_v(zz,yy,:)=normrnd(temp_18_24(t_cindx),temp_18_24_std(t_cindx),1,N_Samp);
            temp_25_29_v(zz,yy,:)=normrnd(temp_25_29(t_cindx),temp_25_29_std(t_cindx),1,N_Samp);
            temp_30_34_v(zz,yy,:)=normrnd(temp_30_34(t_cindx),temp_30_34_std(t_cindx),1,N_Samp);
        
            temp_35_39_v(zz,yy,:)=normrnd(temp_35_39(t_cindx),temp_35_39_std(t_cindx),1,N_Samp);
            temp_40_44_v(zz,yy,:)=normrnd(temp_40_44(t_cindx),temp_40_44_std(t_cindx),1,N_Samp);
            temp_45_49_v(zz,yy,:)=normrnd(temp_45_49(t_cindx),temp_45_49_std(t_cindx),1,N_Samp);
        
            temp_50_54_v(zz,yy,:)=normrnd(temp_50_54(t_cindx),temp_50_54_std(t_cindx),1,N_Samp);
            temp_55_59_v(zz,yy,:)=normrnd(temp_55_59(t_cindx),temp_55_59_std(t_cindx),1,N_Samp);
            temp_60_64_v(zz,yy,:)=normrnd(temp_60_64(t_cindx),temp_60_64_std(t_cindx),1,N_Samp);
    
            temp_65_over_v(zz,yy,:)=normrnd(temp_65_over(t_cindx),temp_65_over_std(t_cindx),1,N_Samp);
            
            temp_E_Pop_18_v(zz,yy,:)=normrnd(temp_E_Pop_18(t_cindx),temp_E_Pop_18_std(t_cindx),1,N_Samp);
            temp_LHS_18_v(zz,yy,:)=normrnd(temp_LHS_18(t_cindx),temp_LHS_18_std(t_cindx),1,N_Samp);
            temp_E_Pop_25_v(zz,yy,:)=normrnd(temp_E_Pop_25(t_cindx),temp_E_Pop_25_std(t_cindx),1,N_Samp);
            temp_LHS1_25_v(zz,yy,:)=normrnd(temp_LHS1_25(t_cindx),temp_LHS1_25_std(t_cindx),1,N_Samp);
            temp_LHS2_25_v(zz,yy,:)=normrnd(temp_LHS2_25(t_cindx),temp_LHS2_25_std(t_cindx),1,N_Samp);
            temp_HS_18_v(zz,yy,:)=normrnd(temp_HS_18(t_cindx),temp_HS_18_std(t_cindx),1,N_Samp);
            temp_HS_25_v(zz,yy,:)=normrnd(temp_HS_25(t_cindx),temp_HS_25_std(t_cindx),1,N_Samp);
            temp_C1_18_v(zz,yy,:)=normrnd(temp_C1_18(t_cindx),temp_C1_18_std(t_cindx),1,N_Samp);
            temp_C2_18_v(zz,yy,:)=normrnd(temp_C2_18(t_cindx),temp_C2_18_std(t_cindx),1,N_Samp);
            temp_C1_25_v(zz,yy,:)=normrnd(temp_C1_25(t_cindx),temp_C1_25_std(t_cindx),1,N_Samp);
            temp_C2_25_v(zz,yy,:)=normrnd(temp_C2_25(t_cindx),temp_C2_25_std(t_cindx),1,N_Samp);
            temp_C3_25_v(zz,yy,:)=normrnd(temp_C3_25(t_cindx),temp_C3_25_std(t_cindx),1,N_Samp);
            temp_C4_25_v(zz,yy,:)=normrnd(temp_C4_25(t_cindx),temp_C4_25_std(t_cindx),1,N_Samp);
    
            temp_lower1_v(zz,yy,:)=normrnd(temp_lower1(t_cindx),temp_lower1_std(t_cindx),1,N_Samp);
            temp_lower2_v(zz,yy,:)=normrnd(temp_lower2(t_cindx),temp_lower2_std(t_cindx),1,N_Samp);
            temp_lower3_v(zz,yy,:)=normrnd(temp_lower3(t_cindx),temp_lower3_std(t_cindx),1,N_Samp);
        
            temp_work1_v(zz,yy,:)=normrnd(temp_work1(t_cindx),temp_work1_std(t_cindx),1,N_Samp);
            temp_work2_v(zz,yy,:)=normrnd(temp_work2(t_cindx),temp_work2_std(t_cindx),1,N_Samp);
        
            temp_middle1_v(zz,yy,:)=normrnd(temp_middle1(t_cindx),temp_middle1_std(t_cindx),1,N_Samp);
            temp_middle2_v(zz,yy,:)=normrnd(temp_middle2(t_cindx),temp_middle2_std(t_cindx),1,N_Samp);
            
            temp_upper1_v(zz,yy,:)=normrnd(temp_upper1(t_cindx),temp_upper1_std(t_cindx),1,N_Samp);
            temp_upper2_v(zz,yy,:)=normrnd(temp_upper2(t_cindx),temp_upper2_std(t_cindx),1,N_Samp);
            temp_upper3_v(zz,yy,:)=normrnd(temp_upper3(t_cindx),temp_upper3_std(t_cindx),1,N_Samp);
            temp_pop_total_v(zz,yy)=temp_pop_total(t_cindx);
        end
    end
    
    
end

Population.Year_Data=Year_Data;
Population.County_ID_Long=T_County;

Trim_T_County=zeros(length(T_County),1);
for ii=1:length(T_County)
    temp_c=T_County{ii};
   Trim_T_County(ii)=str2double( temp_c(end-4:end));
end

Population.County_ID_Numeric=Trim_T_County;

T=readtable('countypres_2000-2020.xlsx');

table_year=unique(T.year);

temp_D=NaN.*zeros(length(T_County),length(table_year),N_Samp);
temp_R=NaN.*zeros(length(T_County),length(table_year),N_Samp);


county_fips=T.county_fips;
county_fips_u=unique(county_fips);
for yy=1:length(table_year)
   for cc=1:length(county_fips_u)
        tf = Trim_T_County==county_fips_u(cc);
        if(sum(tf)>0)
            TS=T(T.year==table_year(yy) & county_fips==county_fips_u(cc),:);
            t_d=strcmp(TS.party,'DEMOCRAT');
            t_r=strcmp(TS.party,'REPUBLICAN');
            t_o= ~(t_d | t_r);        
            if(sum(t_d)>0)
                temp_D(tf,yy,:)=betarnd(sum(TS.candidatevotes(t_d)),unique(TS.totalvotes(t_d))-sum(TS.candidatevotes(t_d)),1,N_Samp);
            end
            if(sum(t_r)>0)
                temp_R(tf,yy,:)=betarnd(sum(TS.candidatevotes(t_r)),unique(TS.totalvotes(t_r))-sum(TS.candidatevotes(t_r)),1,N_Samp);;
            end
        end        
    end
end

Population.Political.Democratic=NaN.*zeros(length(T_County),length(Year_Data));
Population.Political.Republican=NaN.*zeros(length(T_County),length(Year_Data));
Population.Political.Other=NaN.*zeros(length(T_County),length(Year_Data));

temp_D(temp_D==0)=10^(-16);
temp_R(temp_R==0)=10^(-16);

temp_D(temp_D==1)=1-10^(-16);
temp_R(temp_R==1)=1-10^(-16);


Democratic_v=NaN.*zeros(length(T_County),length(Year_Data),N_Samp);
Republican_v=NaN.*zeros(length(T_County),length(Year_Data),N_Samp);

for ss=1:N_Samp
    for jj=1:length(T_County)        
        z=log(squeeze(temp_D(jj,:,ss))./(1-squeeze(temp_D(jj,:,ss))));   
        if(sum(~isnan(z))>=2) 
            z_new=pchip(table_year(~isnan(z)),z(~isnan(z)),Year_Data);
            Democratic_v(jj,:,ss)=real(1./(1+exp(-z_new)));
        end
        z=log(squeeze(temp_R(jj,:,ss))./(1-squeeze(temp_R(jj,:,ss))));  
        if(sum(~isnan(z))>=2)
            z_new=pchip(table_year(~isnan(z)),z(~isnan(z)),Year_Data);
            Republican_v(jj,:,ss)=real(1./(1+exp(-z_new)));
        end        
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Uninsured 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T=readtable('SAHIE_Uninsured_County_under_19.csv');

Data_ID=T.ID;
Data_Year=T.Year;

UIE=T.Uninsured__./100;
UIE_ME=T.Uninsured__MOE./100;
temp_UI_v=zeros(length(Population.County_ID_Numeric),length(Year_Data),N_Samp);

for jj=1:length(temp_UI_v(:,1,1))
    tf=Data_ID==Population.County_ID_Numeric(jj);
    if(sum(tf)>1)
        ty=Data_Year(tf);
        temp_UI=UIE(tf);
        temp_UI_ME=UIE_ME(tf);
        ty=ty(~isnan(temp_UI));
        temp_UI=temp_UI(~isnan(temp_UI));
        temp_UI_ME=temp_UI_ME(~isnan(temp_UI_ME));
        if(sum(ty)>1)
            for tt=1:length(ty)
                temp_std=lsqnonlin(@(z)([(norminv(0.05,temp_UI(tt),z)-(temp_UI(tt)-temp_UI_ME(tt)));(norminv(0.95,temp_UI(tt),z)-(temp_UI(tt)+temp_UI_ME(tt)))]),temp_UI_ME(tt),[],[],options);
                temp_UI_v(jj,Year_Data==ty(tt),:)=normrnd(temp_UI(tt),temp_std,1,N_Samp);
            end
            for ss=1:N_Samp
                z_temp=squeeze(temp_UI_v(jj,ismember(Year_Data,ty),ss));
                z_temp=log(z_temp./(1-z_temp));
                z_new=pchip(ty,z_temp,Year_Data);
                y_temp=real(1./(1+exp(-z_new)));
                temp_UI_v(jj,:,ss)=y_temp;
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Generate structures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
for ss=1:N_Samp
    for yy=1:length(Year_Data)
        temp_pop_total=temp_pop_total_v(:,yy);
        temp_other_v=temp_pop_total-squeeze(temp_white_v(:,yy,ss))-squeeze(temp_black_v(:,yy,ss));
        
        temp_18_34=squeeze(temp_18_24_v(:,yy,ss)+temp_25_29_v(:,yy,ss)+temp_30_34_v(:,yy,ss));
        temp_35_49=squeeze(temp_35_39_v(:,yy,ss)+temp_40_44_v(:,yy,ss)+temp_45_49_v(:,yy,ss));
        temp_50_64=squeeze(temp_50_54_v(:,yy,ss)+temp_55_59_v(:,yy,ss)+temp_60_64_v(:,yy,ss));
        
        if(Year_Data(yy)<2015)
            temp_LHS=squeeze((temp_E_Pop_18_v(:,yy,ss).*(temp_LHS_18_v(:,yy,ss))+temp_E_Pop_25_v(:,yy,ss).*(temp_LHS1_25_v(:,yy,ss)+temp_LHS2_25_v(:,yy,ss)))./100);
            temp_HS=squeeze((temp_E_Pop_18_v(:,yy,ss).*(temp_HS_18_v(:,yy,ss))+temp_E_Pop_25_v(:,yy,ss).*(temp_HS_25_v(:,yy,ss)))./100);
            temp_C=squeeze((temp_E_Pop_18_v(:,yy,ss).*(temp_C1_18_v(:,yy,ss)+temp_C2_18_v(:,yy,ss))+temp_E_Pop_25_v(:,yy,ss).*(temp_C1_25_v(:,yy,ss)+temp_C2_25_v(:,yy,ss)+temp_C3_25_v(:,yy,ss)+temp_C4_25_v(:,yy,ss)))./100);
        else        
            temp_LHS=squeeze(temp_LHS_18_v(:,yy,ss)+temp_LHS1_25_v(:,yy,ss)+temp_LHS2_25_v(:,yy,ss));
            temp_HS=squeeze(temp_HS_18_v(:,yy,ss)+temp_HS_25_v(:,yy,ss));
            temp_C=squeeze(temp_C1_18_v(:,yy,ss)+temp_C2_18+temp_C1_25_v(:,yy,ss)+temp_C2_25_v(:,yy,ss)+temp_C3_25_v(:,yy,ss)+temp_C4_25_v(:,yy,ss));
        end
        
        if(Year_Data(yy)<2017)
            %temp_under_5_male=(temp_under_5_male./100).*temp_male;
            %temp_under_5_female=(temp_under_5_female./100).*temp_female;
            temp_18_34=(temp_18_34./100).*temp_pop_total;
            temp_35_49=(temp_35_49./100).*temp_pop_total;
            temp_50_64=(temp_50_64./100).*temp_pop_total;
            temp_65_over=squeeze(temp_65_over_v(:,yy,ss)./100).*temp_pop_total;
        end
        
        temp_lower=squeeze(temp_EC_v(:,yy,ss).*(temp_lower1_v(:,yy,ss)+temp_lower2_v(:,yy,ss)+temp_lower3_v(:,yy,ss))./100);
        temp_working=squeeze(temp_EC_v(:,yy,ss).*(temp_work1_v(:,yy,ss)+temp_work2_v(:,yy,ss))./100);
        temp_middle=squeeze(temp_EC_v(:,yy,ss).*(temp_middle1_v(:,yy,ss)+temp_middle2_v(:,yy,ss))./100);
        temp_upper=squeeze(temp_EC_v(:,yy,ss).*(temp_upper1_v(:,yy,ss)+temp_upper2_v(:,yy,ss)+temp_upper3_v(:,yy,ss))./100);
        
        Population.Sex.Male(:,yy)=squeeze(temp_male_v(:,yy,ss));
        Population.Sex.Female(:,yy)=squeeze(temp_female_v(:,yy,ss));
        
        Population.Age.Range_18_to_34(:,yy)=temp_18_34;
        Population.Age.Range_35_to_49(:,yy)=temp_35_49;
        Population.Age.Range_50_to_64(:,yy)=temp_50_64;
        Population.Age.Range_65_and_older(:,yy)=temp_65_over;          

        Population.Education.Less_than_High_School(:,yy)=temp_LHS;          
        Population.Education.High_School(:,yy)=temp_HS;          
        Population.Education.College(:,yy)=temp_C;     
        
        Population.Race.White(:,yy)=squeeze(temp_white_v(:,yy,ss));          
        Population.Race.Black(:,yy)=squeeze(temp_black_v(:,yy,ss));          
        Population.Race.Other(:,yy)=squeeze(temp_other_v);
        
        
        Population.Economic.Lower(:,yy)=temp_lower;
        Population.Economic.Working(:,yy)=temp_working;
        Population.Economic.Middle(:,yy)=temp_middle;
        Population.Economic.Upper(:,yy)=temp_upper;
        
        Population.Income(:,yy)=squeeze(temp_income_house_v(:,yy,ss));
            
    end
    Population.Uninsured_19_under=squeeze(temp_UI_v(:,:,ss));
    Population.Political.Democratic=squeeze(Democratic_v(:,:,ss));
    Population.Political.Republican=squeeze(Republican_v(:,:,ss));
    Population.Political.Other=1-Population.Political.Republican-Population.Political.Democratic;
    save(['County_Population_' num2str(ss) '.mat'],'Population');
end
        
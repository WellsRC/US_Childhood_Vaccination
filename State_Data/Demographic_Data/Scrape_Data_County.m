clear;
clc;
% https://data.census.gov/table?q=S0101
Year_Data=[2010:2022];
[County_Demo,~]=Gen_Structure(Year_Data);

for yy=1:length(Year_Data)
    T=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S0101-Data.csv']);    
    T_VN=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S0101-Column-Metadata.csv']);

    temp=zeros(height(T),1);
    for jj=1:length(temp)
        test=T.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    T.GEO_ID=temp;
    tf=ismember(temp,County_Demo.County_ID);
    T=T(tf,:);
    
    E=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1501-Data.csv']);
    if(Year_Data(yy)<2017)
        E_VN=readtable(['ACSST5Y' num2str(2017) '.S1501-Column-Metadata.csv']);
    else
        E_VN=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1501-Column-Metadata.csv']);
    end
    
    temp=zeros(height(E),1);
    for jj=1:length(temp)
        test=E.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    E.GEO_ID=temp;
    tf=ismember(temp,County_Demo.County_ID);
    E=E(tf,:);
    
    Ec=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1901-Data.csv']);
    if(Year_Data(yy)<2017)
        Ec_VN=readtable(['ACSST5Y' num2str(2017) '.S1901-Column-Metadata.csv']);
    else
        Ec_VN=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1901-Column-Metadata.csv']);
    end
    
    temp=zeros(height(Ec),1);
    for jj=1:length(temp)
        test=Ec.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    Ec.GEO_ID=temp;
    tf=ismember(temp,County_Demo.County_ID);
    Ec=Ec(tf,:);
    
    RW=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001H-Data.csv']);
    RW_VN=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001H-Column-Metadata.csv']);
    
    temp=zeros(height(RW),1);
    for jj=1:length(temp)
        test=RW.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    RW.GEO_ID=temp;
    tf=ismember(temp,County_Demo.County_ID);
    RW=RW(tf,:);
    
    RB=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001B-Data.csv']);
    RB_VN=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001B-Column-Metadata.csv']);
    
    temp=zeros(height(RB),1);
    for jj=1:length(temp)
        test=RB.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    RB.GEO_ID=temp;
    tf=ismember(temp,County_Demo.County_ID);
    RB=RB(tf,:);
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %% Economic Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!Total') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames);
    temp_EC=table2array(Ec(:,tf));
    
    if(~isnan(str2double(temp_EC(1))))
        temp_EC=str2double(temp_EC);
    end

    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!Less than $10,000') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!Less than $10,000');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames);   
    temp_lower1=table2array(Ec(:,tf));

    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$10,000 to $14,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$10,000 to $14,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_lower2=table2array(Ec(:,tf));

    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$15,000 to $24,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$15,000 to $24,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_lower3=table2array(Ec(:,tf));
    

    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$25,000 to $34,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$25,000 to $34,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_work1=table2array(Ec(:,tf));

    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$35,000 to $49,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$35,000 to $49,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_work2=table2array(Ec(:,tf));
    
    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$50,000 to $74,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$50,000 to $74,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_middle1=table2array(Ec(:,tf));
    
    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$75,000 to $99,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$75,000 to $99,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_middle2=table2array(Ec(:,tf));
    
    
    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$100,000 to $149,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$100,000 to $149,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_upper1=table2array(Ec(:,tf));
    
    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$150,000 to $199,999') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$150,000 to $199,999');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_upper2=table2array(Ec(:,tf));
    
    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!$200,000 or more') | strcmp(Ec_VN.Label,'Estimate!!Households!!Total!!$200,000 or more');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_upper3=table2array(Ec(:,tf));   
    

    tf=strcmp(Ec_VN.Label,'Households!!Estimate!!Median income (dollars)') | strcmp(Ec_VN.Label,'Estimate!!Households!!Median income (dollars)');
    cv=Ec_VN.ColumnName(tf);
    tf=strcmp(cv,Ec.Properties.VariableNames); 
    temp_income_house=table2array(Ec(:,tf)); 

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
    end
    
    if(~isnan(str2double(temp_income_house(1))))        
       temp_income_house=str2double(temp_income_house);     
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %% Education Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 18 to 24 years') | strcmp(E_VN.Label,'Total!!Estimate!!Population 18 to 24 years') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 18 to 24 years');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_E_Pop_18=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 18 to 24 years!!Less than high school graduate') | strcmp(E_VN.Label,'Total!!Estimate!!Population 18 to 24 years!!Less than high school graduate') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 18 to 24 years!!Less than high school graduate');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_LHS_18=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 18 to 24 years!!High school graduate (includes equivalency)') | strcmp(E_VN.Label,'Total!!Estimate!!Population 18 to 24 years!!High school graduate (includes equivalency)') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 18 to 24 years!!High school graduate (includes equivalency)');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_HS_18=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 18 to 24 years!!Some college or associate''s degree') | strcmp(E_VN.Label,'Estimate!!Total!!Population 18 to 24 years!!Some college or associate''s degree') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 18 to 24 years!!Some college or associate''s degree');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_C1_18=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 18 to 24 years!!Bachelor''s degree or higher') | strcmp(E_VN.Label,'Total!!Estimate!!Population 18 to 24 years!!Bachelor''s degree or higher') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 18 to 24 years!!Bachelor''s degree or higher');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_C2_18=table2array(E(:,tf));
    

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_E_Pop_25=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!Less than 9th grade') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over!!Less than 9th grade') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!Less than 9th grade');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_LHS1_25=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!9th to 12th grade, no diploma') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over!!9th to 12th grade, no diploma') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!9th to 12th grade, no diploma');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_LHS2_25=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!High school graduate (includes equivalency)') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over!!High school graduate (includes equivalency)') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!High school graduate (includes equivalency)');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_HS_25=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!Some college, no degree') | strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!Some college, no degree') | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!Some college, no degree');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_C1_25=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!Associate''s degree') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over!!Associate''s degree')  | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!Associate''s degree');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_C2_25=table2array(E(:,tf));
    
    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!Bachelor''s degree') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over!!Bachelor''s degree')  | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!Bachelor''s degree');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_C3_25=table2array(E(:,tf));

    tf=strcmp(E_VN.Label,'Estimate!!Total!!Population 25 years and over!!Graduate or professional degree') | strcmp(E_VN.Label,'Total!!Estimate!!Population 25 years and over!!Graduate or professional degree')  | strcmp(E_VN.Label,'Estimate!!Total!!AGE BY EDUCATIONAL ATTAINMENT!!Population 25 years and over!!Graduate or professional degree');
    cv=E_VN.ColumnName(tf);
    tf=strcmp(cv,E.Properties.VariableNames);
    temp_C4_25=table2array(E(:,tf));
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %% Total Population Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    tf=strcmp(T_VN.Label,'Estimate!!Total!!Total population') | strcmp(T_VN.Label,'Total!!Estimate!!Total population');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_pop_total=table2array(T(:,tf));
    
    tf=strcmp(T_VN.Label,'Estimate!!Male!!Total population') | strcmp(T_VN.Label,'Male!!Estimate!!Total population');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_total=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!Total population') | strcmp(T_VN.Label,'Female!!Estimate!!Total population');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_total=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!SELECTED AGE CATEGORIES!!18 to 24 years') | strcmp(T_VN.Label,'Total!!Estimate!!SELECTED AGE CATEGORIES!!18 to 24 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!SELECTED AGE CATEGORIES!!18 to 24 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_18_24=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!SELECTED AGE CATEGORIES!!18 to 24 years') | strcmp(T_VN.Label,'Male!!Estimate!!SELECTED AGE CATEGORIES!!18 to 24 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!SELECTED AGE CATEGORIES!!18 to 24 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_18_24=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!SELECTED AGE CATEGORIES!!18 to 24 years') | strcmp(T_VN.Label,'Female!!Estimate!!SELECTED AGE CATEGORIES!!18 to 24 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!SELECTED AGE CATEGORIES!!18 to 24 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_18_24=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!25 to 29 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!25 to 29 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!25 to 29 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_25_29=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!25 to 29 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!25 to 29 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!25 to 29 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_25_29=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!25 to 29 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!25 to 29 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!25 to 29 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_25_29=table2array(T(:,tf));
    
    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!30 to 34 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!30 to 34 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!30 to 34 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_30_34=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!30 to 34 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!30 to 34 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!30 to 34 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_30_34=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!30 to 34 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!30 to 34 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!30 to 34 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_30_34=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!35 to 39 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!35 to 39 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!35 to 39 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_35_39=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!35 to 39 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!35 to 39 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!35 to 39 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_35_39=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!35 to 39 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!35 to 39 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!35 to 39 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_35_39=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!40 to 44 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!40 to 44 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!40 to 44 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_40_44=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!40 to 44 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!40 to 44 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!40 to 44 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_40_44=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!40 to 44 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!40 to 44 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!40 to 44 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_40_44=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!45 to 49 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!45 to 49 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!45 to 49 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_45_49=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!45 to 49 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!45 to 49 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!45 to 49 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_45_49=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!45 to 49 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!45 to 49 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!45 to 49 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_45_49=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!50 to 54 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!50 to 54 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!50 to 54 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_50_54=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!50 to 54 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!50 to 54 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!50 to 54 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_50_54=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!50 to 54 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!50 to 54 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!50 to 54 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_50_54=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!55 to 59 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!55 to 59 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!55 to 59 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_55_59=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!55 to 59 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!55 to 59 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!55 to 59 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_55_59=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!55 to 59 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!55 to 59 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!55 to 59 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_55_59=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!AGE!!60 to 64 years') | strcmp(T_VN.Label,'Total!!Estimate!!AGE!!60 to 64 years') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!AGE!!60 to 64 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_60_64=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!AGE!!60 to 64 years') | strcmp(T_VN.Label,'Male!!Estimate!!AGE!!60 to 64 years') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!AGE!!60 to 64 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_60_64=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!AGE!!60 to 64 years') | strcmp(T_VN.Label,'Female!!Estimate!!AGE!!60 to 64 years') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!AGE!!60 to 64 years');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_60_64=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Total!!SELECTED AGE CATEGORIES!!65 years and over') | strcmp(T_VN.Label,'Total!!Estimate!!SELECTED AGE CATEGORIES!!65 years and over') | strcmp(T_VN.Label,'Estimate!!Total!!Total population!!SELECTED AGE CATEGORIES!!65 years and over');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_total_65_plus=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Male!!SELECTED AGE CATEGORIES!!65 years and over') | strcmp(T_VN.Label,'Male!!Estimate!!SELECTED AGE CATEGORIES!!65 years and over') | strcmp(T_VN.Label,'Estimate!!Male!!Total population!!SELECTED AGE CATEGORIES!!65 years and over');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_male_65_plus=table2array(T(:,tf));

    tf=strcmp(T_VN.Label,'Estimate!!Female!!SELECTED AGE CATEGORIES!!65 years and over') | strcmp(T_VN.Label,'Female!!Estimate!!SELECTED AGE CATEGORIES!!65 years and over') | strcmp(T_VN.Label,'Estimate!!Female!!Total population!!SELECTED AGE CATEGORIES!!65 years and over');
    cv=T_VN.ColumnName(tf);
    tf=strcmp(cv,T.Properties.VariableNames);
    temp_female_65_plus=table2array(T(:,tf));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %% White only population Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    
    tf=strcmp(RW_VN.Label,'Estimate!!Total') | strcmp(RW_VN.Label,'Estimate!!Total:');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wpop_total=table2array(RW(:,tf));
    
    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_total=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_total=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!18 and 19 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!18 and 19 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_18_19=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!18 and 19 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!18 and 19 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_18_19=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!20 to 24 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!20 to 24 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_20_24=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!20 to 24 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!20 to 24 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_20_24=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!25 to 29 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!25 to 29 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_25_29=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!25 to 29 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!25 to 29 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_25_29=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!30 to 34 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!30 to 34 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_30_34=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!30 to 34 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!30 to 34 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_30_34=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!35 to 44 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!35 to 44 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_35_44=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!35 to 44 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!35 to 44 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_35_44=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!45 to 54 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!45 to 54 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_45_54=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!45 to 54 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!45 to 54 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_45_54=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!55 to 64 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!55 to 64 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_55_64=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!55 to 64 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!55 to 64 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_55_64=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!65 to 74 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!65 to 74 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_65_74=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!65 to 74 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!65 to 74 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_65_74=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!75 to 84 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!75 to 84 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_75_84=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!75 to 84 years') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!75 to 84 years');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_75_84=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Male!!85 years and over') | strcmp(RW_VN.Label,'Estimate!!Total:!!Male:!!85 years and over');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wmale_85_plus=table2array(RW(:,tf));

    tf=strcmp(RW_VN.Label,'Estimate!!Total!!Female!!85 years and over') | strcmp(RW_VN.Label,'Estimate!!Total:!!Female:!!85 years and over');
    cv=RW_VN.ColumnName(tf);
    tf=strcmp(cv,RW.Properties.VariableNames);
    temp_wfemale_85_plus=table2array(RW(:,tf));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    %% Black only population Data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    

    tf=strcmp(RB_VN.Label,'Estimate!!Total') | strcmp(RB_VN.Label,'Estimate!!Total:');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bpop_total=table2array(RB(:,tf));
    
    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_total=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_total=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!18 and 19 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!18 and 19 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_18_19=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!18 and 19 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!18 and 19 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_18_19=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!20 to 24 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!20 to 24 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_20_24=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!20 to 24 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!20 to 24 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_20_24=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!25 to 29 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!25 to 29 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_25_29=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!25 to 29 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!25 to 29 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_25_29=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!30 to 34 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!30 to 34 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_30_34=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!30 to 34 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!30 to 34 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_30_34=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!35 to 44 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!35 to 44 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_35_44=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!35 to 44 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!35 to 44 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_35_44=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!45 to 54 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!45 to 54 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_45_54=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!45 to 54 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!45 to 54 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_45_54=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!55 to 64 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!55 to 64 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_55_64=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!55 to 64 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!55 to 64 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_55_64=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!65 to 74 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!65 to 74 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_65_74=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!65 to 74 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!65 to 74 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_65_74=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!75 to 84 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!75 to 84 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_75_84=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!75 to 84 years') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!75 to 84 years');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_75_84=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Male!!85 years and over') | strcmp(RB_VN.Label,'Estimate!!Total:!!Male:!!85 years and over');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bmale_85_plus=table2array(RB(:,tf));

    tf=strcmp(RB_VN.Label,'Estimate!!Total!!Female!!85 years and over') | strcmp(RB_VN.Label,'Estimate!!Total:!!Female:!!85 years and over');
    cv=RB_VN.ColumnName(tf);
    tf=strcmp(cv,RB.Properties.VariableNames);
    temp_bfemale_85_plus=table2array(RB(:,tf));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Calculate outcomes for aggregated compartments
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    
    if(yy==1)
        
        temp_income_house_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

        temp_E_Pop_18_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_LHS_18_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_E_Pop_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_LHS1_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_LHS2_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_HS_18_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_HS_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_C1_18_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_C2_18_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_C1_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_C2_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_C3_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_C4_25_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
    
        temp_lower1_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_lower2_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_lower3_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
    
        temp_work1_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_work2_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
    
        temp_middle1_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_middle2_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        
        temp_upper1_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_upper2_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_upper3_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
    
        temp_EC_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        
        temp_pop_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_18_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_18_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_18_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_35_39_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_35_39_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_35_39_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_40_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_40_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_40_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_45_49_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_45_49_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_45_49_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_50_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_50_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_50_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_55_59_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_55_59_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_55_59_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_60_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_60_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_60_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_total_65_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_male_65_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_female_65_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

        temp_wpop_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_18_19_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_18_19_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_20_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_20_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_35_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_35_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_45_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_45_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_55_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_55_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_65_74_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_65_74_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_75_84_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_75_84_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wmale_85_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_wfemale_85_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

        temp_bpop_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_total_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_18_19_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_18_19_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_20_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_20_24_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_25_29_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_30_34_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_35_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_35_44_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_45_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_45_54_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_55_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_55_64_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_65_74_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_65_74_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_75_84_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_75_84_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bmale_85_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
        temp_bfemale_85_plus_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

    end
    for zz=1:length(County_Demo.County_ID)
        t_cindx=ismember(T.GEO_ID,County_Demo.County_ID(zz));
        if(sum(t_cindx)>0)           
            temp_pop_total_v(zz,yy)=temp_pop_total(t_cindx);
            temp_male_total_v(zz,yy)=temp_male_total(t_cindx);
            temp_female_total_v(zz,yy)=temp_female_total(t_cindx);
            temp_total_18_24_v(zz,yy)=temp_total_18_24(t_cindx);
            temp_male_18_24_v(zz,yy)=temp_male_18_24(t_cindx);
            temp_female_18_24_v(zz,yy)=temp_female_18_24(t_cindx);
            temp_total_25_29_v(zz,yy)=temp_total_25_29(t_cindx);
            temp_male_25_29_v(zz,yy)=temp_male_25_29(t_cindx);
            temp_female_25_29_v(zz,yy)=temp_female_25_29(t_cindx);
            temp_total_30_34_v(zz,yy)=temp_total_30_34(t_cindx);
            temp_male_30_34_v(zz,yy)=temp_male_30_34(t_cindx);
            temp_female_30_34_v(zz,yy)=temp_female_30_34(t_cindx);
            temp_total_35_39_v(zz,yy)=temp_total_35_39(t_cindx);
            temp_male_35_39_v(zz,yy)=temp_male_35_39(t_cindx);
            temp_female_35_39_v(zz,yy)=temp_female_35_39(t_cindx);
            temp_total_40_44_v(zz,yy)=temp_total_40_44(t_cindx);
            temp_male_40_44_v(zz,yy)=temp_male_40_44(t_cindx);
            temp_female_40_44_v(zz,yy)=temp_female_40_44(t_cindx);
            temp_total_45_49_v(zz,yy)=temp_total_45_49(t_cindx);
            temp_male_45_49_v(zz,yy)=temp_male_45_49(t_cindx);
            temp_female_45_49_v(zz,yy)=temp_female_45_49(t_cindx);
            temp_total_50_54_v(zz,yy)=temp_total_50_54(t_cindx);
            temp_male_50_54_v(zz,yy)=temp_pop_total(t_cindx);
            temp_female_50_54_v(zz,yy)=temp_male_50_54(t_cindx);
            temp_total_55_59_v(zz,yy)=temp_total_55_59(t_cindx);
            temp_male_55_59_v(zz,yy)=temp_male_55_59(t_cindx);
            temp_female_55_59_v(zz,yy)=temp_female_55_59(t_cindx);
            temp_total_60_64_v(zz,yy)=temp_total_60_64(t_cindx);
            temp_male_60_64_v(zz,yy)=temp_male_60_64(t_cindx);
            temp_female_60_64_v(zz,yy)=temp_female_60_64(t_cindx);
            temp_total_65_plus_v(zz,yy)=temp_total_65_plus(t_cindx);
            temp_male_65_plus_v(zz,yy)=temp_male_65_plus(t_cindx);
            temp_female_65_plus_v(zz,yy)=temp_female_65_plus(t_cindx);
        end
        

        t_cindx=ismember(E.GEO_ID,County_Demo.County_ID(zz));
        if(sum(t_cindx)>0)
            temp_E_Pop_18_v(zz,yy)=temp_E_Pop_18(t_cindx);
            temp_LHS_18_v(zz,yy)=temp_LHS_18(t_cindx);
            temp_E_Pop_25_v(zz,yy)=temp_E_Pop_25(t_cindx);
            temp_LHS1_25_v(zz,yy)=temp_LHS1_25(t_cindx);
            temp_LHS2_25_v(zz,yy)=temp_LHS2_25(t_cindx);
            temp_HS_18_v(zz,yy)=temp_HS_18(t_cindx);
            temp_HS_25_v(zz,yy)=temp_HS_25(t_cindx);
            temp_C1_18_v(zz,yy)=temp_C1_18(t_cindx);
            temp_C2_18_v(zz,yy)=temp_C2_18(t_cindx);
            temp_C1_25_v(zz,yy)=temp_C1_25(t_cindx);
            temp_C2_25_v(zz,yy)=temp_C2_25(t_cindx);
            temp_C3_25_v(zz,yy)=temp_C3_25(t_cindx);
            temp_C4_25_v(zz,yy)=temp_C4_25(t_cindx);
        end
        
        t_cindx=ismember(Ec.GEO_ID,County_Demo.County_ID(zz));
        if(sum(t_cindx)>0)
            
            temp_EC_v(zz,yy)=temp_EC(t_cindx);

            temp_lower1_v(zz,yy)=temp_lower1(t_cindx);
            temp_lower2_v(zz,yy)=temp_lower2(t_cindx);
            temp_lower3_v(zz,yy)=temp_lower3(t_cindx);
        
            temp_work1_v(zz,yy)=temp_work1(t_cindx);
            temp_work2_v(zz,yy)=temp_work2(t_cindx);
        
            temp_middle1_v(zz,yy)=temp_middle1(t_cindx);
            temp_middle2_v(zz,yy)=temp_middle2(t_cindx);
            
            temp_upper1_v(zz,yy)=temp_upper1(t_cindx);
            temp_upper2_v(zz,yy)=temp_upper2(t_cindx);
            temp_upper3_v(zz,yy)=temp_upper3(t_cindx);

            temp_income_house_v(zz,yy)=temp_income_house(t_cindx);    
        end

        t_cindx=ismember(RB.GEO_ID,County_Demo.County_ID(zz));
        if(sum(t_cindx)>0)
            temp_bpop_total_v(zz,yy)=temp_bpop_total(t_cindx);
            temp_bmale_total_v(zz,yy)=temp_bmale_total(t_cindx);
            temp_bfemale_total_v(zz,yy)=temp_bfemale_total(t_cindx);
            temp_bmale_18_19_v(zz,yy)=temp_bmale_18_19(t_cindx);
            temp_bfemale_18_19_v(zz,yy)=temp_bfemale_18_19(t_cindx);
            temp_bmale_20_24_v(zz,yy)=temp_bmale_20_24(t_cindx);
            temp_bfemale_20_24_v(zz,yy)=temp_bfemale_20_24(t_cindx);
            temp_bmale_25_29_v(zz,yy)=temp_bmale_25_29(t_cindx);
            temp_bfemale_25_29_v(zz,yy)=temp_bfemale_25_29(t_cindx);
            temp_bmale_30_34_v(zz,yy)=temp_bmale_30_34(t_cindx);
            temp_bfemale_30_34_v(zz,yy)=temp_bfemale_30_34(t_cindx);
            temp_bmale_35_44_v(zz,yy)=temp_bmale_35_44(t_cindx);
            temp_bfemale_35_44_v(zz,yy)=temp_bfemale_35_44(t_cindx);
            temp_bmale_45_54_v(zz,yy)=temp_bmale_45_54(t_cindx);
            temp_bfemale_45_54_v(zz,yy)=temp_bfemale_45_54(t_cindx);
            temp_bmale_55_64_v(zz,yy)=temp_bmale_55_64(t_cindx);
            temp_bfemale_55_64_v(zz,yy)=temp_bfemale_55_64(t_cindx);
            temp_bmale_65_74_v(zz,yy)=temp_bmale_65_74(t_cindx);
            temp_bfemale_65_74_v(zz,yy)=temp_bfemale_65_74(t_cindx);
            temp_bmale_75_84_v(zz,yy)=temp_bmale_75_84(t_cindx);
            temp_bfemale_75_84_v(zz,yy)=temp_bfemale_75_84(t_cindx);
            temp_bmale_85_plus_v(zz,yy)=temp_bmale_85_plus(t_cindx);
            temp_bfemale_85_plus_v(zz,yy)=temp_bfemale_85_plus(t_cindx);
        end
        
        t_cindx=ismember(RW.GEO_ID,County_Demo.County_ID(zz));
        if(sum(t_cindx)>0)
            temp_wpop_total_v(zz,yy)=temp_wpop_total(t_cindx);
            temp_wmale_total_v(zz,yy)=temp_wmale_total(t_cindx);
            temp_wfemale_total_v(zz,yy)=temp_wfemale_total(t_cindx);
            temp_wmale_18_19_v(zz,yy)=temp_wmale_18_19(t_cindx);
            temp_wfemale_18_19_v(zz,yy)=temp_wfemale_18_19(t_cindx);
            temp_wmale_20_24_v(zz,yy)=temp_wmale_20_24(t_cindx);
            temp_wfemale_20_24_v(zz,yy)=temp_wfemale_20_24(t_cindx);
            temp_wmale_25_29_v(zz,yy)=temp_wmale_25_29(t_cindx);
            temp_wfemale_25_29_v(zz,yy)=temp_wfemale_25_29(t_cindx);
            temp_wmale_30_34_v(zz,yy)=temp_wmale_30_34(t_cindx);
            temp_wfemale_30_34_v(zz,yy)=temp_wfemale_30_34(t_cindx);
            temp_wmale_35_44_v(zz,yy)=temp_wmale_35_44(t_cindx);
            temp_wfemale_35_44_v(zz,yy)=temp_wfemale_35_44(t_cindx);
            temp_wmale_45_54_v(zz,yy)=temp_wmale_45_54(t_cindx);
            temp_wfemale_45_54_v(zz,yy)=temp_wfemale_45_54(t_cindx);
            temp_wmale_55_64_v(zz,yy)=temp_wmale_55_64(t_cindx);
            temp_wfemale_55_64_v(zz,yy)=temp_wfemale_55_64(t_cindx);
            temp_wmale_65_74_v(zz,yy)=temp_wmale_65_74(t_cindx);
            temp_wfemale_65_74_v(zz,yy)=temp_wfemale_65_74(t_cindx);
            temp_wmale_75_84_v(zz,yy)=temp_wmale_75_84(t_cindx);
            temp_wfemale_75_84_v(zz,yy)=temp_wfemale_75_84(t_cindx);
            temp_wmale_85_plus_v(zz,yy)=temp_wmale_85_plus(t_cindx);
            temp_wfemale_85_plus_v(zz,yy)=temp_wfemale_85_plus(t_cindx);
        end
    end
end

County_Demo.Year_Data=Year_Data;

T=readtable('countypres_2000-2020.csv');

table_year=unique(T.year);

temp_D=NaN.*zeros(length(County_Demo.County_ID),length(table_year));
temp_R=NaN.*zeros(length(County_Demo.County_ID),length(table_year));


county_fips=T.county_fips;
county_fips_u=unique(county_fips);
for yy=1:length(table_year)
   for cc=1:length(county_fips_u)
        tf = County_Demo.County_ID==county_fips_u(cc);
        if(sum(tf)>0)
            TS=T(T.year==table_year(yy) & county_fips==county_fips_u(cc),:);
            t_d=strcmp(TS.party,'DEMOCRAT');
            t_r=strcmp(TS.party,'REPUBLICAN');
            t_o= ~(t_d | t_r);        
            if(sum(t_d)>0)
                temp_D(tf,yy)=sum(TS.candidatevotes(t_d))./unique(TS.totalvotes(t_d));
            end
            if(sum(t_r)>0)
                temp_R(tf,yy)=sum(TS.candidatevotes(t_r))./unique(TS.totalvotes(t_r));
            end
        end        
    end
end

County_Demo.Political.Democratic=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
County_Demo.Political.Republican=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
County_Demo.Political.Other=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

temp_D(temp_D==0)=10^(-16);
temp_R(temp_R==0)=10^(-16);

temp_D(temp_D==1)=1-10^(-16);
temp_R(temp_R==1)=1-10^(-16);


Democratic_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));
Republican_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

for jj=1:length(County_Demo.County_ID)       
    z=log(squeeze(temp_D(jj,:))./(1-squeeze(temp_D(jj,:))));   
    if(sum(~isnan(z))>=2) 
        z_new=pchip(table_year(~isnan(z)),z(~isnan(z)),Year_Data);
        Democratic_v(jj,:)=real(1./(1+exp(-z_new)));
    end
    z=log(squeeze(temp_R(jj,:))./(1-squeeze(temp_R(jj,:))));  
    if(sum(~isnan(z))>=2)
        z_new=pchip(table_year(~isnan(z)),z(~isnan(z)),Year_Data);
        Republican_v(jj,:)=real(1./(1+exp(-z_new)));
    end        
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Health insurance under 19
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=readtable("Health_Insurance_Under_19.xlsx");
table_year=unique(T.year);
temp_UI=NaN.*zeros(length(County_Demo.County_ID),length(table_year));

county_fips=T.fip;
county_fips_u=unique(county_fips);
for yy=1:length(table_year)
   for cc=1:length(county_fips_u)
        tf = County_Demo.County_ID==county_fips_u(cc);
        if(sum(tf)>0)
            TS=T(T.year==table_year(yy) & county_fips==county_fips_u(cc),:);
            if(height(TS)>0)
                temp_UI(tf,yy)=TS.Number_Uninsured./TS.Population;
            end
        end        
    end
end

temp_UI(temp_UI==0)=10^(-16);
temp_UI(temp_UI==1)=1-10^(-16);


temp_UI_v=NaN.*zeros(length(County_Demo.County_ID),length(Year_Data));

for jj=1:length(County_Demo.County_ID)        
    z=log(squeeze(temp_UI(jj,:))./(1-squeeze(temp_UI(jj,:))));   
    if(sum(~isnan(z))>=2) 
        z_new=pchip(table_year(~isnan(z)),z(~isnan(z)),Year_Data);
        temp_UI_v(jj,:)=real(1./(1+exp(-z_new)));
    end   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Generate structures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

for yy=1:length(Year_Data)
    temp_pop_total=temp_pop_total_v(:,yy);
    temp_other=temp_pop_total-temp_wpop_total_v(:,yy)-temp_bpop_total_v(:,yy);
    temp_other_male=temp_male_total_v(:,yy)-temp_wmale_total_v(:,yy)-temp_bmale_total_v(:,yy);
    temp_other_female=temp_female_total_v(:,yy)-temp_wfemale_total_v(:,yy)-temp_bfemale_total_v(:,yy);
    

    rm_45_49=temp_male_45_49_v(:,yy)./(temp_male_45_49_v(:,yy)+temp_male_50_54_v(:,yy));
    rf_45_49=temp_female_45_49_v(:,yy)./(temp_female_45_49_v(:,yy)+temp_female_50_54_v(:,yy));

    temp_18_34=temp_total_18_24_v(:,yy)+temp_total_25_29_v(:,yy)+temp_total_30_34_v(:,yy);
    temp_35_49=temp_total_35_39_v(:,yy)+temp_total_40_44_v(:,yy)+temp_total_45_49_v(:,yy);
    temp_50_64=temp_total_50_54_v(:,yy)+temp_total_55_59_v(:,yy)+temp_total_60_64_v(:,yy);

    temp_male_18_34=temp_male_18_24_v(:,yy)+temp_male_25_29_v(:,yy)+temp_male_30_34_v(:,yy);
    temp_male_35_49=temp_male_35_39_v(:,yy)+temp_male_40_44_v(:,yy)+temp_male_45_49_v(:,yy);
    temp_male_50_64=temp_male_50_54_v(:,yy)+temp_male_55_59_v(:,yy)+temp_male_60_64_v(:,yy);

    temp_female_18_34=temp_female_18_24_v(:,yy)+temp_female_25_29_v(:,yy)+temp_female_30_34_v(:,yy);
    temp_female_35_49=temp_female_35_39_v(:,yy)+temp_female_40_44_v(:,yy)+temp_female_45_49_v(:,yy);
    temp_female_50_64=temp_female_50_54_v(:,yy)+temp_female_55_59_v(:,yy)+temp_female_60_64_v(:,yy);
    
    if(Year_Data(yy)<2015)
        temp_LHS=squeeze((temp_E_Pop_18_v(:,yy).*(temp_LHS_18_v(:,yy))+temp_E_Pop_25_v(:,yy).*(temp_LHS1_25_v(:,yy)+temp_LHS2_25_v(:,yy)))./100);
        temp_HS=squeeze((temp_E_Pop_18_v(:,yy).*(temp_HS_18_v(:,yy))+temp_E_Pop_25_v(:,yy).*(temp_HS_25_v(:,yy)))./100);
        temp_C=squeeze((temp_E_Pop_18_v(:,yy).*(temp_C1_18_v(:,yy)+temp_C2_18_v(:,yy))+temp_E_Pop_25_v(:,yy).*(temp_C1_25_v(:,yy)+temp_C2_25_v(:,yy)+temp_C3_25_v(:,yy)+temp_C4_25_v(:,yy)))./100);
    else        
        temp_LHS=squeeze(temp_LHS_18_v(:,yy)+temp_LHS1_25_v(:,yy)+temp_LHS2_25_v(:,yy));
        temp_HS=squeeze(temp_HS_18_v(:,yy)+temp_HS_25_v(:,yy));
        temp_C=squeeze(temp_C1_18_v(:,yy)+temp_C2_18_v(:,yy)+temp_C1_25_v(:,yy)+temp_C2_25_v(:,yy)+temp_C3_25_v(:,yy)+temp_C4_25_v(:,yy));
    end
    
    if(Year_Data(yy)<2017)
        temp_18_34=(temp_18_34./100).*temp_pop_total;
        temp_35_49=(temp_35_49./100).*temp_pop_total;
        temp_50_64=(temp_50_64./100).*temp_pop_total;
        temp_65_plus=(temp_total_65_plus_v(:,yy)./100).*temp_pop_total;

        temp_male_18_34=(temp_male_18_34./100).*temp_male_total_v(:,yy);
        temp_male_35_49=(temp_male_35_49./100).*temp_male_total_v(:,yy);
        temp_male_50_64=(temp_male_50_64./100).*temp_male_total_v(:,yy);
        temp_male_65_plus=(temp_male_65_plus_v(:,yy)./100).*temp_male_total_v(:,yy);

        temp_female_18_34=(temp_female_18_34./100).*temp_female_total_v(:,yy);
        temp_female_35_49=(temp_female_35_49./100).*temp_female_total_v(:,yy);
        temp_female_50_64=(temp_female_50_64./100).*temp_female_total_v(:,yy);
        temp_female_65_plus=(temp_female_65_plus_v(:,yy)./100).*temp_female_total_v(:,yy);
    end
    
    temp_lower=squeeze(temp_EC_v(:,yy).*(temp_lower1_v(:,yy)+temp_lower2_v(:,yy)+temp_lower3_v(:,yy))./100);
    temp_working=squeeze(temp_EC_v(:,yy).*(temp_work1_v(:,yy)+temp_work2_v(:,yy))./100);
    temp_middle=squeeze(temp_EC_v(:,yy).*(temp_middle1_v(:,yy)+temp_middle2_v(:,yy))./100);
    temp_upper=squeeze(temp_EC_v(:,yy).*(temp_upper1_v(:,yy)+temp_upper2_v(:,yy)+temp_upper3_v(:,yy))./100);
    
    County_Demo.Population.Total(:,yy)=temp_pop_total;
    County_Demo.Population.Male.Total(:,yy)=temp_male_total_v(:,yy);
    County_Demo.Population.Female.Total(:,yy)=temp_male_total_v(:,yy);
    County_Demo.Population.Age_18_34(:,yy)=temp_18_34;
    County_Demo.Population.Age_35_49(:,yy)=temp_35_49;
    County_Demo.Population.Age_50_64(:,yy)=temp_50_64;
    County_Demo.Population.Age_65_plus(:,yy)=temp_65_plus;
    County_Demo.Population.White(:,yy)=temp_wpop_total_v(:,yy);
    County_Demo.Population.Black(:,yy)=temp_bpop_total_v(:,yy);
    County_Demo.Population.Other(:,yy)=temp_other;

    County_Demo.Population.Male.White_Total(:,yy)=temp_wmale_total_v(:,yy);
    County_Demo.Population.Male.Black_Total(:,yy)=temp_bmale_total_v(:,yy);
    County_Demo.Population.Male.Other_Total(:,yy)=temp_other_male;

    County_Demo.Population.Female.White_Total(:,yy)=temp_wfemale_total_v(:,yy);
    County_Demo.Population.Female.Black_Total(:,yy)=temp_bfemale_total_v(:,yy);
    County_Demo.Population.Female.Other_Total(:,yy)=temp_other_female;

    County_Demo.Population.Male.White.Age_18_34(:,yy)=temp_wmale_18_19_v(:,yy)+temp_wmale_20_24_v(:,yy)+temp_wmale_25_29_v(:,yy)+temp_wmale_30_34_v(:,yy);
    County_Demo.Population.Male.White.Age_35_49(:,yy)=temp_wmale_35_44_v(:,yy)+rm_45_49.*temp_wmale_45_54_v(:,yy);
    County_Demo.Population.Male.White.Age_50_64(:,yy)=(1-rm_45_49).*temp_wmale_45_54_v(:,yy)+temp_wmale_55_64_v(:,yy);
    County_Demo.Population.Male.White.Age_65_plus(:,yy)=temp_wmale_65_74_v(:,yy)+temp_wmale_75_84_v(:,yy)+temp_wmale_85_plus_v(:,yy);

    County_Demo.Population.Male.Black.Age_18_34(:,yy)=temp_bmale_18_19_v(:,yy)+temp_bmale_20_24_v(:,yy)+temp_bmale_25_29_v(:,yy)+temp_bmale_30_34_v(:,yy);
    County_Demo.Population.Male.Black.Age_35_49(:,yy)=temp_bmale_35_44_v(:,yy)+rm_45_49.*temp_bmale_45_54_v(:,yy);
    County_Demo.Population.Male.Black.Age_50_64(:,yy)=(1-rm_45_49).*temp_bmale_45_54_v(:,yy)+temp_bmale_55_64_v(:,yy);
    County_Demo.Population.Male.Black.Age_65_plus(:,yy)=temp_bmale_65_74_v(:,yy)+temp_bmale_75_84_v(:,yy)+temp_bmale_85_plus_v(:,yy);

    County_Demo.Population.Male.Other.Age_18_34(:,yy)=max(temp_male_18_34-County_Demo.Population.Male.White.Age_18_34(:,yy)-County_Demo.Population.Male.Black.Age_18_34(:,yy),0);
    County_Demo.Population.Male.Other.Age_35_49(:,yy)=max(temp_male_35_49-County_Demo.Population.Male.White.Age_35_49(:,yy)-County_Demo.Population.Male.Black.Age_35_49(:,yy),0);
    County_Demo.Population.Male.Other.Age_50_64(:,yy)=max(temp_male_50_64-County_Demo.Population.Male.White.Age_50_64(:,yy)-County_Demo.Population.Male.Black.Age_50_64(:,yy),0);
    County_Demo.Population.Male.Other.Age_65_plus(:,yy)=max(temp_male_65_plus-County_Demo.Population.Male.White.Age_65_plus(:,yy)-County_Demo.Population.Male.Black.Age_65_plus(:,yy),0);
    
    County_Demo.Population.Female.White.Age_18_34(:,yy)=temp_wfemale_18_19_v(:,yy)+temp_wfemale_20_24_v(:,yy)+temp_wfemale_25_29_v(:,yy)+temp_wfemale_30_34_v(:,yy);
    County_Demo.Population.Female.White.Age_35_49(:,yy)=temp_wfemale_35_44_v(:,yy)+rf_45_49.*temp_wfemale_45_54_v(:,yy);
    County_Demo.Population.Female.White.Age_50_64(:,yy)=(1-rf_45_49).*temp_wfemale_45_54_v(:,yy)+temp_wfemale_55_64_v(:,yy);
    County_Demo.Population.Female.White.Age_65_plus(:,yy)=temp_wfemale_65_74_v(:,yy)+temp_wfemale_75_84_v(:,yy)+temp_wfemale_85_plus_v(:,yy);

    County_Demo.Population.Female.Black.Age_18_34(:,yy)=temp_bfemale_18_19_v(:,yy)+temp_bfemale_20_24_v(:,yy)+temp_bfemale_25_29_v(:,yy)+temp_bfemale_30_34_v(:,yy);
    County_Demo.Population.Female.Black.Age_35_49(:,yy)=temp_bfemale_35_44_v(:,yy)+rf_45_49.*temp_bfemale_45_54_v(:,yy);
    County_Demo.Population.Female.Black.Age_50_64(:,yy)=(1-rf_45_49).*temp_bfemale_45_54_v(:,yy)+temp_bfemale_55_64_v(:,yy);
    County_Demo.Population.Female.Black.Age_65_plus(:,yy)=temp_bfemale_65_74_v(:,yy)+temp_bfemale_75_84_v(:,yy)+temp_bfemale_85_plus_v(:,yy);

    County_Demo.Population.Female.Other.Age_18_34(:,yy)=max(temp_female_18_34-County_Demo.Population.Female.White.Age_18_34(:,yy)-County_Demo.Population.Female.Black.Age_18_34(:,yy),0);
    County_Demo.Population.Female.Other.Age_35_49(:,yy)=max(temp_female_35_49-County_Demo.Population.Female.White.Age_35_49(:,yy)-County_Demo.Population.Female.Black.Age_35_49(:,yy),0);
    County_Demo.Population.Female.Other.Age_50_64(:,yy)=max(temp_female_50_64-County_Demo.Population.Female.White.Age_50_64(:,yy)-County_Demo.Population.Female.Black.Age_50_64(:,yy),0);
    County_Demo.Population.Female.Other.Age_65_plus(:,yy)=max(temp_female_65_plus-County_Demo.Population.Female.White.Age_65_plus(:,yy)-County_Demo.Population.Female.Black.Age_65_plus(:,yy),0);
    
    County_Demo.Education.Less_than_High_School(:,yy)=temp_LHS;          
    County_Demo.Education.High_School(:,yy)=temp_HS;          
    County_Demo.Education.College(:,yy)=temp_C;     
    
    County_Demo.Economic.Lower(:,yy)=temp_lower;
    County_Demo.Economic.Working(:,yy)=temp_working;
    County_Demo.Economic.Middle(:,yy)=temp_middle;
    County_Demo.Economic.Upper(:,yy)=temp_upper;
    
    County_Demo.Income(:,yy)=squeeze(temp_income_house_v(:,yy));
        
end
County_Demo.Percent_Uninsured_Under_19=squeeze(temp_UI_v(:,:));
County_Demo.Political.Democratic=squeeze(Democratic_v(:,:));
County_Demo.Political.Republican=squeeze(Republican_v(:,:));
County_Demo.Political.Other=1-County_Demo.Political.Republican-County_Demo.Political.Democratic;

for ss=1:size(County_Demo.Population.Male.Other.Age_18_34,1)
    temp_s=County_Demo.Population.Male.Black.Age_18_34(ss,:)+County_Demo.Population.Male.White.Age_18_34(ss,:)+County_Demo.Population.Male.Other.Age_18_34(ss,:)+County_Demo.Population.Female.Black.Age_18_34(ss,:)+County_Demo.Population.Female.White.Age_18_34(ss,:)+County_Demo.Population.Female.Other.Age_18_34(ss,:);
    temp_s=temp_s+County_Demo.Population.Male.Black.Age_35_49(ss,:)+County_Demo.Population.Male.White.Age_35_49(ss,:)+County_Demo.Population.Male.Other.Age_35_49(ss,:)+County_Demo.Population.Female.Black.Age_35_49(ss,:)+County_Demo.Population.Female.White.Age_35_49(ss,:)+County_Demo.Population.Female.Other.Age_35_49(ss,:);
    temp_s=temp_s+County_Demo.Population.Male.Black.Age_50_64(ss,:)+County_Demo.Population.Male.White.Age_50_64(ss,:)+County_Demo.Population.Male.Other.Age_50_64(ss,:)+County_Demo.Population.Female.Black.Age_50_64(ss,:)+County_Demo.Population.Female.White.Age_50_64(ss,:)+County_Demo.Population.Female.Other.Age_50_64(ss,:);
    temp_s=temp_s+County_Demo.Population.Male.Black.Age_65_plus(ss,:)+County_Demo.Population.Male.White.Age_65_plus(ss,:)+County_Demo.Population.Male.Other.Age_65_plus(ss,:)+County_Demo.Population.Female.Black.Age_65_plus(ss,:)+County_Demo.Population.Female.White.Age_65_plus(ss,:)+County_Demo.Population.Female.Other.Age_65_plus(ss,:);

    if(isnan(sum(temp_s)))
        tf=~isnan(temp_s);
        County_Demo.Population.Male.Other.Age_18_34(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Other.Age_18_34(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Other.Age_35_49(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Other.Age_35_49(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Other.Age_50_64(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Other.Age_50_64(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Other.Age_65_plus(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Other.Age_65_plus(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Female.Other.Age_18_34(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Other.Age_18_34(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Other.Age_35_49(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Other.Age_35_49(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Other.Age_50_64(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Other.Age_50_64(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Other.Age_65_plus(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Other.Age_65_plus(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Male.White.Age_18_34(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.White.Age_18_34(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.White.Age_35_49(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.White.Age_35_49(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.White.Age_50_64(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.White.Age_50_64(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.White.Age_65_plus(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.White.Age_65_plus(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Female.White.Age_18_34(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.White.Age_18_34(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.White.Age_35_49(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.White.Age_35_49(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.White.Age_50_64(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.White.Age_50_64(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.White.Age_65_plus(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.White.Age_65_plus(ss,tf)),County_Demo.Year_Data(~tf)),0);
        
        County_Demo.Population.Male.Black.Age_18_34(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Black.Age_18_34(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Black.Age_35_49(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Black.Age_35_49(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Black.Age_50_64(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Black.Age_50_64(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Black.Age_65_plus(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Black.Age_65_plus(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Female.Black.Age_18_34(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Black.Age_18_34(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Black.Age_35_49(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Black.Age_35_49(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Black.Age_50_64(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Black.Age_50_64(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Black.Age_65_plus(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Black.Age_65_plus(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Age_18_34(ss,~tf)=County_Demo.Population.Male.Black.Age_18_34(ss,~tf)+County_Demo.Population.Male.White.Age_18_34(ss,~tf)+County_Demo.Population.Male.Other.Age_18_34(ss,~tf)+County_Demo.Population.Female.Black.Age_18_34(ss,~tf)+County_Demo.Population.Female.White.Age_18_34(ss,~tf)+County_Demo.Population.Female.Other.Age_18_34(ss,~tf);
        County_Demo.Population.Age_35_49(ss,~tf)=County_Demo.Population.Male.Black.Age_35_49(ss,~tf)+County_Demo.Population.Male.White.Age_35_49(ss,~tf)+County_Demo.Population.Male.Other.Age_35_49(ss,~tf)+County_Demo.Population.Female.Black.Age_35_49(ss,~tf)+County_Demo.Population.Female.White.Age_35_49(ss,~tf)+County_Demo.Population.Female.Other.Age_35_49(ss,~tf);
        County_Demo.Population.Age_50_64(ss,~tf)=County_Demo.Population.Male.Black.Age_50_64(ss,~tf)+County_Demo.Population.Male.White.Age_50_64(ss,~tf)+County_Demo.Population.Male.Other.Age_50_64(ss,~tf)+County_Demo.Population.Female.Black.Age_50_64(ss,~tf)+County_Demo.Population.Female.White.Age_50_64(ss,~tf)+County_Demo.Population.Female.Other.Age_50_64(ss,~tf);
        County_Demo.Population.Age_65_plus(ss,~tf)=County_Demo.Population.Male.Black.Age_65_plus(ss,~tf)+County_Demo.Population.Male.White.Age_65_plus(ss,~tf)+County_Demo.Population.Male.Other.Age_65_plus(ss,~tf)+County_Demo.Population.Female.Black.Age_65_plus(ss,~tf)+County_Demo.Population.Female.White.Age_65_plus(ss,~tf)+County_Demo.Population.Female.Other.Age_65_plus(ss,~tf);
    end
    if(isnan(sum(County_Demo.Education.Less_than_High_School(ss,:))))     
        tf=~isnan(County_Demo.Education.Less_than_High_School(ss,:));
        County_Demo.Education.Less_than_High_School(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Education.Less_than_High_School(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Education.High_School(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Education.High_School(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Education.College(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Education.College(ss,tf)),County_Demo.Year_Data(~tf)),0);
    end
    if(isnan(sum(County_Demo.Population.Male.Other_Total(ss,:))))
        tf=~isnan(County_Demo.Population.Male.Other_Total(ss,:));
        County_Demo.Population.Male.Other_Total(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Other_Total(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.White_Total(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.White_Total(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Male.Black_Total(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Male.Black_Total(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Female.Other_Total(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Other_Total(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.White_Total(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.White_Total(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Population.Female.Black_Total(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Population.Female.Black_Total(ss,tf)),County_Demo.Year_Data(~tf)),0);

        County_Demo.Population.Male.Total(ss,~tf)=County_Demo.Population.Male.Other_Total(ss,~tf)+County_Demo.Population.Male.White_Total(ss,~tf)+County_Demo.Population.Male.Black_Total(ss,~tf);
        County_Demo.Population.Female.Total(ss,~tf)=County_Demo.Population.Female.Other_Total(ss,~tf)+County_Demo.Population.Female.White_Total(ss,~tf)+County_Demo.Population.Female.Black_Total(ss,~tf);

        County_Demo.Population.White(ss,~tf)=County_Demo.Population.Male.White_Total(ss,~tf)+County_Demo.Population.Female.White_Total(ss,~tf);
        County_Demo.Population.Black(ss,~tf)=County_Demo.Population.Male.Black_Total(ss,~tf)+County_Demo.Population.Female.Black_Total(ss,~tf);
        County_Demo.Population.Other(ss,~tf)=County_Demo.Population.Male.Other_Total(ss,~tf)+County_Demo.Population.Female.Other_Total(ss,~tf);

    end
    if(isnan(sum(County_Demo.Economic.Lower(ss,:)))) 
        tf=~isnan(County_Demo.Economic.Lower(ss,:));       
        County_Demo.Economic.Lower(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Economic.Lower(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Economic.Working(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Economic.Working(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Economic.Middle(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Economic.Middle(ss,tf)),County_Demo.Year_Data(~tf)),0);
        County_Demo.Economic.Upper(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Economic.Upper(ss,tf)),County_Demo.Year_Data(~tf)),0);
    end
    if(isnan(sum(County_Demo.Income(ss,:))))
        tf=~isnan(County_Demo.Income(ss,:));
        County_Demo.Income(ss,~tf)=max(pchip(County_Demo.Year_Data(tf),(County_Demo.Income(ss,tf)),County_Demo.Year_Data(~tf)),0);
    end

    if(isnan(sum(County_Demo.Political.Democratic(ss,:))))        
        tf=~isnan(County_Demo.Political.Democratic(ss,:));
        County_Demo.Political.Democratic(ss,~tf)=1./(1+exp(-pchip(County_Demo.Year_Data(tf),log(County_Demo.Political.Democratic(ss,tf)./(1-County_Demo.Political.Democratic(ss,tf))),County_Demo.Year_Data(~tf))));
        County_Demo.Political.Republican(ss,~tf)=1./(1+exp(-pchip(County_Demo.Year_Data(tf),log(County_Demo.Political.Republican(ss,tf)./(1-County_Demo.Political.Republican(ss,tf))),County_Demo.Year_Data(~tf))));
        County_Demo.Political.Other(ss,~tf)=1./(1+exp(-pchip(County_Demo.Year_Data(tf),log(County_Demo.Political.Other(ss,tf)./(1-County_Demo.Political.Other(ss,tf))),County_Demo.Year_Data(~tf))));

        temp_t=County_Demo.Political.Democratic(ss,:)+County_Demo.Political.Republican(ss,:)+County_Demo.Political.Other(ss,:);
        County_Demo.Political.Democratic(ss,:)=County_Demo.Political.Democratic./temp_t;
        County_Demo.Political.Republican(ss,:)=County_Demo.Political.Republican./temp_t;
        County_Demo.Political.Other(ss,:)=County_Demo.Political.Other./temp_t;
    end

    if(isnan(sum(County_Demo.Percent_Uninsured_Under_19(ss,:))))        
        tf=~isnan(County_Demo.Percent_Uninsured_Under_19(ss,:));
        County_Demo.Percent_Uninsured_Under_19(ss,~tf)=1./(1+exp(-pchip(County_Demo.Year_Data(tf),log(County_Demo.Percent_Uninsured_Under_19(ss,tf)./(1-County_Demo.Percent_Uninsured_Under_19(ss,tf))),County_Demo.Year_Data(~tf))));
    end

end
save(['County_Population.mat'],'County_Demo');

        
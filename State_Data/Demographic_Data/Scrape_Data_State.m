clear;
clc;
rng('shuffle');
% https://data.census.gov/table?q=S0101
Year_Data=[2010:2022];

[~,State_Demo]=Gen_Structure(Year_Data);

for yy=1:length(Year_Data)
     T=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S0101-Data.csv']);    
    temp=zeros(height(T),1);
    for jj=1:length(temp)
        test=T.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    T.GEO_ID=temp;
    tf=ismember(temp,State_Demo.State_ID);
    T=T(tf,:);
    
    E=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1501-Data.csv']);
    temp=zeros(height(E),1);
    for jj=1:length(temp)
        test=E.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    E.GEO_ID=temp;
    tf=ismember(temp,State_Demo.State_ID);
    E=E(tf,:);
    
    Ec=readtable(['ACSST5Y' num2str(Year_Data(yy)) '.S1901-Data.csv']);
    temp=zeros(height(Ec),1);
    for jj=1:length(temp)
        test=Ec.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    Ec.GEO_ID=temp;
    tf=ismember(temp,State_Demo.State_ID);
    Ec=Ec(tf,:);
    
    RW=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001H-Data.csv']);
    temp=zeros(height(RW),1);
    for jj=1:length(temp)
        test=RW.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    RW.GEO_ID=temp;
    tf=ismember(temp,State_Demo.State_ID);
    RW=RW(tf,:);
    
    RB=readtable(['ACSDT5Y' num2str(Year_Data(yy)) '.B01001B-Data.csv']);
    temp=zeros(height(RB),1);
    for jj=1:length(temp)
        test=RB.GEO_ID(jj);
        ff=find(test{:}=='S')+1;
        test=test{:};
        temp(jj)=str2double(test(ff:end));
    end
    RB.GEO_ID=temp;
    tf=ismember(temp,State_Demo.State_ID);
    RB=RB(tf,:);
         
    temp_EC=Ec.S1901_C01_001E;
    
    if(~isnan(str2double(temp_EC(1))))
        temp_EC=str2double(temp_EC);
    end

       
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
    
    if(Year_Data(yy)<2017)
        temp_male=T.S0101_C02_001E;
        temp_female=T.S0101_C03_001E;

        temp_18_24=T.S0101_C01_022E;

        temp_65_over=T.S0101_C01_028E;
    else        
        temp_male=T.S0101_C03_001E;
        temp_female=T.S0101_C05_001E;

        temp_18_24=T.S0101_C01_023E;

        temp_65_over=T.S0101_C01_030E;
    end

    if(~isnan(str2double(temp_LHS_18(1))))     
        
        temp_LHS_18=str2double(temp_LHS_18);
        temp_HS_18=str2double(temp_HS_18);
        temp_C1_18=str2double(temp_C1_18);
        temp_C2_18=str2double(temp_C2_18);          
    end
    
    if(~isnan(str2double(temp_white(1))))
            temp_white=str2double(temp_white);
    end
        
    if(~isnan(str2double(temp_black(1))))
        temp_black=str2double(temp_black);
    end
    
    if(~isnan(str2double(temp_E_Pop_18(1))))
            temp_E_Pop_18=str2double(temp_E_Pop_18);
    end
        
    if(~isnan(str2double(temp_E_Pop_25(1))))
        temp_E_Pop_25=str2double(temp_E_Pop_25);
    end
    
    if(~isnan(str2double(temp_LHS1_25(1))))       
        temp_LHS1_25=str2double(temp_LHS1_25);
        temp_LHS2_25=str2double(temp_LHS2_25);
        temp_HS_25=str2double(temp_HS_25);
        temp_C1_25=str2double(temp_C1_25);
        temp_C2_25=str2double(temp_C2_25);
        temp_C3_25=str2double(temp_C3_25);
        temp_C4_25=str2double(temp_C4_25); 
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
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Calculate outcomes for aggregated compartments
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    
    
    if(yy==1)
        temp_white_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_black_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        
        temp_65_over_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_income_house_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_male_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_female_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        
        temp_18_24_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_25_29_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_30_34_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_35_39_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_40_44_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_45_49_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_50_54_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_55_59_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_60_64_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_E_Pop_18_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_LHS_18_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_E_Pop_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_LHS1_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_LHS2_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_HS_18_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_HS_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_C1_18_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_C2_18_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_C1_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_C2_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_C3_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_C4_25_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_lower1_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_lower2_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_lower3_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_work1_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_work2_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_middle1_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_middle2_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        
        temp_upper1_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_upper2_v=zeros(length(State_Demo.State_ID),length(Year_Data));
        temp_upper3_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    
        temp_EC_v=zeros(length(State_Demo.State_ID),length(Year_Data));

        temp_pop_total_v=zeros(length(State_Demo.State_ID),length(Year_Data));
    end
    for zz=1:length(State_Demo.State_ID)
        t_cindx=ismember(T.GEO_ID,State_Demo.State_ID(zz));
        if(sum(t_cindx)>0)
           
            temp_male_v(zz,yy)=temp_male(t_cindx);
            temp_female_v(zz,yy)=temp_female(t_cindx);
        
            temp_18_24_v(zz,yy)=temp_18_24(t_cindx);
            temp_25_29_v(zz,yy)=temp_25_29(t_cindx);
            temp_30_34_v(zz,yy)=temp_30_34(t_cindx);
        
            temp_35_39_v(zz,yy)=temp_35_39(t_cindx);
            temp_40_44_v(zz,yy)=temp_40_44(t_cindx);
            temp_45_49_v(zz,yy)=temp_45_49(t_cindx);
        
            temp_50_54_v(zz,yy)=temp_50_54(t_cindx);
            temp_55_59_v(zz,yy)=temp_55_59(t_cindx);
            temp_60_64_v(zz,yy)=temp_60_64(t_cindx);
    
            temp_65_over_v(zz,yy)=temp_65_over(t_cindx);
                
            temp_pop_total_v(zz,yy)=temp_pop_total(t_cindx);
        end
        

        t_cindx=ismember(Ec.GEO_ID,State_Demo.State_ID(zz));
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
        
        t_cindx=ismember(Ec.GEO_ID,State_Demo.State_ID(zz));
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

        t_cindx=ismember(RB.GEO_ID,State_Demo.State_ID(zz));
        if(sum(t_cindx)>0)
            temp_black_v(zz,yy)=temp_black(t_cindx);
        end
        
        t_cindx=ismember(RW.GEO_ID,State_Demo.State_ID(zz));
        if(sum(t_cindx)>0)
            temp_white_v(zz,yy)=temp_white(t_cindx);
        end
    end
end

State_Demo.Year_Data=Year_Data;

T=readtable('countypres_2000-2020.csv');

table_year=unique(T.year);

temp_D=NaN.*zeros(length(State_Demo.State_ID),length(table_year));
temp_R=NaN.*zeros(length(State_Demo.State_ID),length(table_year));


state_fips=T.county_fips;
state_fips=floor(state_fips./10^3);
state_fips_u=unique(state_fips);
for yy=1:length(table_year)
   for cc=1:length(state_fips_u)
        tf = State_Demo.State_ID==state_fips_u(cc);
        if(sum(tf)>0)
            TS=T(T.year==table_year(yy) & state_fips==state_fips_u(cc),:);
            t_d=strcmp(TS.party,'DEMOCRAT');
            t_r=strcmp(TS.party,'REPUBLICAN');
            t_o= ~(t_d | t_r);        
            if(sum(t_d)>0)
                temp_D(tf,yy)=sum(TS.candidatevotes(t_d))./sum(unique(TS.totalvotes(t_d)));
            end
            if(sum(t_r)>0)
                temp_R(tf,yy)=sum(TS.candidatevotes(t_r))./sum(unique(TS.totalvotes(t_r)));
            end
        end        
    end
end

State_Demo.Political.Democratic=NaN.*zeros(length(State_Demo.State_ID),length(Year_Data));
State_Demo.Political.Republican=NaN.*zeros(length(State_Demo.State_ID),length(Year_Data));
State_Demo.Political.Other=NaN.*zeros(length(State_Demo.State_ID),length(Year_Data));

temp_D(temp_D==0)=10^(-16);
temp_R(temp_R==0)=10^(-16);

temp_D(temp_D==1)=1-10^(-16);
temp_R(temp_R==1)=1-10^(-16);


Democratic_v=NaN.*zeros(length(State_Demo.State_ID),length(Year_Data));
Republican_v=NaN.*zeros(length(State_Demo.State_ID),length(Year_Data));

for jj=1:length(State_Demo.State_ID)       
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

temp_UI=NaN.*zeros(length(State_Demo.State_ID),length(table_year));


state_fips=T.fip;
state_fips=floor(state_fips./10^3);
state_fips_u=unique(state_fips);
for yy=1:length(table_year)
   for cc=1:length(state_fips_u)
        tf = State_Demo.State_ID==state_fips_u(cc);
        if(sum(tf)>0)
            TS=T(T.year==table_year(yy) & state_fips==state_fips_u(cc),:);
            if(height(TS)>0)
                temp_UI(tf,yy)=sum(TS.Number_Uninsured)./sum(TS.Population);
            end
        end        
    end
end

temp_UI(temp_UI==0)=10^(-16);
temp_UI(temp_UI==1)=1-10^(-16);


temp_UI_v=NaN.*zeros(length(State_Demo.State_ID),length(Year_Data));

for jj=1:length(State_Demo.State_ID)        
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
    temp_other_v=temp_pop_total-squeeze(temp_white_v(:,yy))-squeeze(temp_black_v(:,yy));
    
    temp_18_34=squeeze(temp_18_24_v(:,yy)+temp_25_29_v(:,yy)+temp_30_34_v(:,yy));
    temp_35_49=squeeze(temp_35_39_v(:,yy)+temp_40_44_v(:,yy)+temp_45_49_v(:,yy));
    temp_50_64=squeeze(temp_50_54_v(:,yy)+temp_55_59_v(:,yy)+temp_60_64_v(:,yy));
    
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
        temp_65_over=squeeze(temp_65_over_v(:,yy)./100).*temp_pop_total;
    end
    
    temp_lower=squeeze(temp_EC_v(:,yy).*(temp_lower1_v(:,yy)+temp_lower2_v(:,yy)+temp_lower3_v(:,yy))./100);
    temp_working=squeeze(temp_EC_v(:,yy).*(temp_work1_v(:,yy)+temp_work2_v(:,yy))./100);
    temp_middle=squeeze(temp_EC_v(:,yy).*(temp_middle1_v(:,yy)+temp_middle2_v(:,yy))./100);
    temp_upper=squeeze(temp_EC_v(:,yy).*(temp_upper1_v(:,yy)+temp_upper2_v(:,yy)+temp_upper3_v(:,yy))./100);
    
    State_Demo.Sex.Male(:,yy)=squeeze(temp_male_v(:,yy));
    State_Demo.Sex.Female(:,yy)=squeeze(temp_female_v(:,yy));
    
    State_Demo.Age.Range_18_to_34(:,yy)=temp_18_34;
    State_Demo.Age.Range_35_to_49(:,yy)=temp_35_49;
    State_Demo.Age.Range_50_to_64(:,yy)=temp_50_64;
    State_Demo.Age.Range_65_and_older(:,yy)=temp_65_over;          

    State_Demo.Education.Less_than_High_School(:,yy)=temp_LHS;          
    State_Demo.Education.High_School(:,yy)=temp_HS;          
    State_Demo.Education.College(:,yy)=temp_C;     
    
    State_Demo.Race.White(:,yy)=squeeze(temp_white_v(:,yy));          
    State_Demo.Race.Black(:,yy)=squeeze(temp_black_v(:,yy));          
    State_Demo.Race.Other(:,yy)=squeeze(temp_other_v);
    
    
    State_Demo.Economic.Lower(:,yy)=temp_lower;
    State_Demo.Economic.Working(:,yy)=temp_working;
    State_Demo.Economic.Middle(:,yy)=temp_middle;
    State_Demo.Economic.Upper(:,yy)=temp_upper;
    
    State_Demo.Income(:,yy)=squeeze(temp_income_house_v(:,yy));
        
end
State_Demo.Percent_Uninsured_Under_19=squeeze(temp_UI_v(:,:));
State_Demo.Political.Democratic=squeeze(Democratic_v(:,:));
State_Demo.Political.Republican=squeeze(Republican_v(:,:));
State_Demo.Political.Other=1-State_Demo.Political.Republican-State_Demo.Political.Democratic;

for ss=1:size(State_Demo.Sex.Male,1)
    if(isnan(sum(State_Demo.Sex.Male(ss,:))))
        tf=~isnan(State_Demo.Sex.Male(ss,:));
        State_Demo.Sex.Male(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Sex.Male(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Sex.Female(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Sex.Female(ss,tf)),State_Demo.Year_Data(~tf)));

        State_Demo.Age.Range_18_to_34(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Age.Range_18_to_34(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Age.Range_35_to_49(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Age.Range_35_to_49(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Age.Range_50_to_64(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Age.Range_50_to_64(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Age.Range_65_and_older(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Age.Range_65_and_older(ss,tf)),State_Demo.Year_Data(~tf)));        
    end
    if(isnan(sum(State_Demo.Education.Less_than_High_School(ss,:))))     
        tf=~isnan(State_Demo.Education.Less_than_High_School(ss,:));
        State_Demo.Education.Less_than_High_School(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Education.Less_than_High_School(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Education.High_School(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Education.High_School(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Education.College(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Education.College(ss,tf)),State_Demo.Year_Data(~tf)));
    end
    if(isnan(sum(State_Demo.Race.White(ss,:))))
        tf=~isnan(State_Demo.Race.White(ss,:));
        State_Demo.Race.White(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Race.White(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Race.Black(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Race.Black(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Race.Other(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Race.Other(ss,tf)),State_Demo.Year_Data(~tf)));
    end
    if(isnan(sum(State_Demo.Economic.Lower(ss,:)))) 
        tf=~isnan(State_Demo.Economic.Lower(ss,:));       
        State_Demo.Economic.Lower(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Economic.Lower(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Economic.Working(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Economic.Working(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Economic.Middle(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Economic.Middle(ss,tf)),State_Demo.Year_Data(~tf)));
        State_Demo.Economic.Upper(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Economic.Upper(ss,tf)),State_Demo.Year_Data(~tf)));
    end
    if(isnan(sum(State_Demo.Income(ss,:))))
        tf=~isnan(State_Demo.Income(ss,:));
        State_Demo.Income(ss,~tf)=exp(pchip(State_Demo.Year_Data(tf),log(State_Demo.Income(ss,tf)),State_Demo.Year_Data(~tf)));
    end

    if(isnan(sum(State_Demo.Political.Democratic(ss,:))))        
        tf=~isnan(State_Demo.Political.Democratic(ss,:));
        State_Demo.Political.Democratic(ss,~tf)=1./(1+exp(-pchip(State_Demo.Year_Data(tf),log(State_Demo.Political.Democratic(ss,tf)./(1-State_Demo.Political.Democratic(ss,tf))),State_Demo.Year_Data(~tf))));
        State_Demo.Political.Republican(ss,~tf)=1./(1+exp(-pchip(State_Demo.Year_Data(tf),log(State_Demo.Political.Republican(ss,tf)./(1-State_Demo.Political.Republican(ss,tf))),State_Demo.Year_Data(~tf))));
        State_Demo.Political.Other(ss,~tf)=1./(1+exp(-pchip(State_Demo.Year_Data(tf),log(State_Demo.Political.Other(ss,tf)./(1-State_Demo.Political.Other(ss,tf))),State_Demo.Year_Data(~tf))));

        temp_t=State_Demo.Political.Democratic(ss,:)+State_Demo.Political.Republican(ss,:)+State_Demo.Political.Other(ss,:);
        State_Demo.Political.Democratic(ss,:)=State_Demo.Political.Democratic./temp_t;
        State_Demo.Political.Republican(ss,:)=State_Demo.Political.Republican./temp_t;
        State_Demo.Political.Other(ss,:)=State_Demo.Political.Other./temp_t;
    end

    if(isnan(sum(State_Demo.Percent_Uninsured_Under_19(ss,:))))        
        tf=~isnan(State_Demo.Percent_Uninsured_Under_19(ss,:));
        State_Demo.Percent_Uninsured_Under_19(ss,~tf)=1./(1+exp(-pchip(State_Demo.Year_Data(tf),log(State_Demo.Percent_Uninsured_Under_19(ss,tf)./(1-State_Demo.Percent_Uninsured_Under_19(ss,tf))),State_Demo.Year_Data(~tf))));
    end

end
save(['State_Population.mat'],'State_Demo');

        
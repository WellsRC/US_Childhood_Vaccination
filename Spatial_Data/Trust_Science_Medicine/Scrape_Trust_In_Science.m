clear;
clc;
    
Sheet_Name={'National','Age','Sex','Race','Education','Political','Economic'};
Trust_Year_Data=[1973:2023];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% National
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','National','ReadVariableNames', true);
T_Err=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','National','ReadVariableNames', true);

Year_Table=T.year;


p=T.great_deal./100;
z=log(p./(1-p));
z_new=pchip(Year_Table,z,Trust_Year_Data);
great_deal_new=1./(1+exp(-z_new));

p=T.only_some./100;
z=log(p./(1-p));
z_new=pchip(Year_Table,z,Trust_Year_Data);
only_some_new=1./(1+exp(-z_new));

p=T.hardly_any./100;
z=log(p./(1-p));
z_new=pchip(Year_Table,z,Trust_Year_Data);
hardly_any_new=1./(1+exp(-z_new));

temp_tot=great_deal_new+only_some_new+hardly_any_new;

Trust_in_Science.National.Great_Deal=great_deal_new./temp_tot;
Trust_in_Science.National.Only_Some=only_some_new./temp_tot;
Trust_in_Science.National.Hardly_Any=hardly_any_new./temp_tot;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_temp=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','Sex','ReadVariableNames', true);
T_Err_temp=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','Sex','ReadVariableNames', true);

Vr={'female','male'};
for indx=1:2
    T=T_temp(strcmp(T_temp.sex,Vr{indx}),:);
    Year_Table=T.year;
    
    T_Err=T_Err_temp(strcmp(T_Err_temp.sex,Vr{indx}),:);
    
    p=T.great_deal./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    great_deal_new=1./(1+exp(-z_new));
    
    p=T.only_some./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    only_some_new=1./(1+exp(-z_new));

    p=T.hardly_any./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    hardly_any_new=1./(1+exp(-z_new));
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;        

    eval(['Trust_in_Science.Sex.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
    eval(['Trust_in_Science.Sex.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
    eval(['Trust_in_Science.Sex.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Race
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_temp=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','Race','ReadVariableNames', true);
T_Err_temp=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','Race','ReadVariableNames', true);

Vr={'white','black','other'};
for indx=1:3
    T=T_temp(strcmp(T_temp.race,Vr{indx}),:);
    Year_Table=T.year;

    T_Err=T_Err_temp(strcmp(T_Err_temp.race,Vr{indx}),:);
    
    p=T.great_deal./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    great_deal_new=1./(1+exp(-z_new));
    
    p=T.only_some./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    only_some_new=1./(1+exp(-z_new));

    p=T.hardly_any./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    hardly_any_new=1./(1+exp(-z_new));
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;

    eval(['Trust_in_Science.Race.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
    eval(['Trust_in_Science.Race.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
    eval(['Trust_in_Science.Race.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Political
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_temp=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','Political','ReadVariableNames', true);
T_Err_temp=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','Political','ReadVariableNames', true);

Vr={'democrat','republican','other'};
for indx=1:3
    T=T_temp(strcmp(T_temp.party,Vr{indx}),:);
    Year_Table=T.year;
    T_Err=T_Err_temp(strcmp(T_Err_temp.party,Vr{indx}),:);
    
    p=T.great_deal./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    great_deal_new=1./(1+exp(-z_new));
    
    p=T.only_some./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    only_some_new=1./(1+exp(-z_new));

    p=T.hardly_any./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    hardly_any_new=1./(1+exp(-z_new));
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;

    eval(['Trust_in_Science.Political.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
    eval(['Trust_in_Science.Political.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
    eval(['Trust_in_Science.Political.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Education
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_temp=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','Education','ReadVariableNames', true);
T_Err_temp=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','Education','ReadVariableNames', true);

Vr={'less_than_hs','hs','college'};
for indx=1:3
    T=T_temp(strcmp(T_temp.education,Vr{indx}),:);
    Year_Table=T.year;
    T_Err=T_Err_temp(strcmp(T_Err_temp.education,Vr{indx}),:);
    
    p=T.great_deal./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    great_deal_new=1./(1+exp(-z_new));
    
    p=T.only_some./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    only_some_new=1./(1+exp(-z_new));

    p=T.hardly_any./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    hardly_any_new=1./(1+exp(-z_new));
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;

    eval(['Trust_in_Science.Education.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
    eval(['Trust_in_Science.Education.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
    eval(['Trust_in_Science.Education.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Economic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_temp=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','Economic','ReadVariableNames', true);
T_Err_temp=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','Economic','ReadVariableNames', true);

Vr={'lower','working','middle','upper'};
for indx=1:4
    T=T_temp(strcmp(T_temp.economic,Vr{indx}),:);
    Year_Table=T.year;

    T_Err=T_Err_temp(strcmp(T_Err_temp.economic,Vr{indx}),:);
    
    p=T.great_deal./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    great_deal_new=1./(1+exp(-z_new));
    
    p=T.only_some./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    only_some_new=1./(1+exp(-z_new));

    p=T.hardly_any./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    hardly_any_new=1./(1+exp(-z_new));
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;
    
    eval(['Trust_in_Science.Economic.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
    eval(['Trust_in_Science.Economic.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
    eval(['Trust_in_Science.Economic.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Age
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_temp=readtable([pwd '\Trust_In_Science.xlsx'],'Sheet','Age','ReadVariableNames', true);
T_Err_temp=readtable([pwd '\Trust_In_Science_Error.xlsx'],'Sheet','Age','ReadVariableNames', true);

Vr={'age_18_34','age_35_49','age_50_64','age_over_65'};
for indx=1:4
    T=T_temp(strcmp(T_temp.age_class,Vr{indx}),:);
    Year_Table=T.year;

    T_Err=T_Err_temp(strcmp(T_Err_temp.age_class,Vr{indx}),:);
    
    p=T.great_deal./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    great_deal_new=1./(1+exp(-z_new));
    
    p=T.only_some./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    only_some_new=1./(1+exp(-z_new));

    p=T.hardly_any./100;
    z=log(p./(1-p));
    z_new=pchip(Year_Table,z,Trust_Year_Data);
    hardly_any_new=1./(1+exp(-z_new));
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;

    eval(['Trust_in_Science.Age.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
    eval(['Trust_in_Science.Age.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
    eval(['Trust_in_Science.Age.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
    
end
save(['Trust_in_Science_Stratification.mat'],'Trust_in_Science','Trust_Year_Data');


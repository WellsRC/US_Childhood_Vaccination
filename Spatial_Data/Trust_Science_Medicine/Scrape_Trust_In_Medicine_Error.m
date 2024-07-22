clear;
clc;
    
Sheet_Name={'National','Age','Sex','Race','Education','Political','Economic'};
Trust_Year_Data=[1973:2023];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% National
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','National','ReadVariableNames', true);
T=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','National','ReadVariableNames', true);

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



Trust_in_Medicine_Error.National.Great_Deal=great_deal_new;
Trust_in_Medicine_Error.National.Only_Some=only_some_new;
Trust_in_Medicine_Error.National.Hardly_Any=hardly_any_new;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Sex','ReadVariableNames', true);
T_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Sex','ReadVariableNames', true);

Vr={'female','male'};
for indx=1:2
    T=T_temp(strcmp(T_temp.sex,Vr{indx}),:);
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
    
            

    eval(['Trust_in_Medicine_Error.Sex.' Vr{indx} '.Great_Deal=great_deal_new;']);
    eval(['Trust_in_Medicine_Error.Sex.' Vr{indx} '.Only_Some=only_some_new;']);
    eval(['Trust_in_Medicine_Error.Sex.' Vr{indx} '.Hardly_Any=hardly_any_new;']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Race
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Race','ReadVariableNames', true);
T_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Race','ReadVariableNames', true);

Vr={'white','black','other'};
for indx=1:3
    T=T_temp(strcmp(T_temp.race,Vr{indx}),:);
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
    
    

    eval(['Trust_in_Medicine_Error.Race.' Vr{indx} '.Great_Deal=great_deal_new;']);
    eval(['Trust_in_Medicine_Error.Race.' Vr{indx} '.Only_Some=only_some_new;']);
    eval(['Trust_in_Medicine_Error.Race.' Vr{indx} '.Hardly_Any=hardly_any_new;']);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Political
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Political','ReadVariableNames', true);
T_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Political','ReadVariableNames', true);

Vr={'democrat','republican','other'};
for indx=1:3
    T=T_temp(strcmp(T_temp.party,Vr{indx}),:);
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
    
    

    eval(['Trust_in_Medicine_Error.Political.' Vr{indx} '.Great_Deal=great_deal_new;']);
    eval(['Trust_in_Medicine_Error.Political.' Vr{indx} '.Only_Some=only_some_new;']);
    eval(['Trust_in_Medicine_Error.Political.' Vr{indx} '.Hardly_Any=hardly_any_new;']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Education
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Education','ReadVariableNames', true);
T_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Education','ReadVariableNames', true);

Vr={'less_than_hs','hs','college'};
for indx=1:3
    T=T_temp(strcmp(T_temp.education,Vr{indx}),:);
    Year_Table=T.year;
    T=T_temp(strcmp(T_temp.education,Vr{indx}),:);
    
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
    
    

    eval(['Trust_in_Medicine_Error.Education.' Vr{indx} '.Great_Deal=great_deal_new;']);
    eval(['Trust_in_Medicine_Error.Education.' Vr{indx} '.Only_Some=only_some_new;']);
    eval(['Trust_in_Medicine_Error.Education.' Vr{indx} '.Hardly_Any=hardly_any_new;']);
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Economic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Economic','ReadVariableNames', true);
T_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Economic','ReadVariableNames', true);

Vr={'lower','working','middle','upper'};
for indx=1:4
    T=T_temp(strcmp(T_temp.economic,Vr{indx}),:);
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
    
    
    
    eval(['Trust_in_Medicine_Error.Economic.' Vr{indx} '.Great_Deal=great_deal_new;']);
    eval(['Trust_in_Medicine_Error.Economic.' Vr{indx} '.Only_Some=only_some_new;']);
    eval(['Trust_in_Medicine_Error.Economic.' Vr{indx} '.Hardly_Any=hardly_any_new;']);
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Age
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Age','ReadVariableNames', true);
T_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Age','ReadVariableNames', true);

Vr={'age_18_34','age_35_49','age_50_64','age_over_65'};
for indx=1:4
    T=T_temp(strcmp(T_temp.age_class,Vr{indx}),:);
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
    
    

    eval(['Trust_in_Medicine_Error.Age.' Vr{indx} '.Great_Deal=great_deal_new;']);
    eval(['Trust_in_Medicine_Error.Age.' Vr{indx} '.Only_Some=only_some_new;']);
    eval(['Trust_in_Medicine_Error.Age.' Vr{indx} '.Hardly_Any=hardly_any_new;']);
    
end
save(['Trust_in_Medicine_Error_Stratification.mat'],'Trust_in_Medicine_Error','Trust_Year_Data');


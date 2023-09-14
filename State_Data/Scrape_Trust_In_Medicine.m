clear;
clc;
for samp_num=1:1000
    Sheet_Name={'National','Age','Sex','Race','Education','Political','Economic'};
    
    N_Samp=1;
    Trust_Year_Data=[1973:2022];
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% National
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','National','ReadVariableNames', true);
    T_Err=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','National','ReadVariableNames', true);
    
    Year_Table=T.year;
    
    [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);
    
    
    temp_tot=great_deal_new+only_some_new+hardly_any_new;
    
    Trust_in_Medicine.National.Great_Deal=great_deal_new./temp_tot;
    Trust_in_Medicine.National.Only_Some=only_some_new./temp_tot;
    Trust_in_Medicine.National.Hardly_Any=hardly_any_new./temp_tot;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Sex
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Sex','ReadVariableNames', true);
    T_Err_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Sex','ReadVariableNames', true);
    
    Vr={'female','male'};
    for indx=1:2
        T=T_temp(strcmp(T_temp.sex,Vr{indx}),:);
        Year_Table=T.year;
        
        T_Err=T_Err_temp(strcmp(T_Err_temp.sex,Vr{indx}),:);
        [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);
    
        
        temp_tot=great_deal_new+only_some_new+hardly_any_new;
        
    
        eval(['Trust_in_Medicine.Sex.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
        eval(['Trust_in_Medicine.Sex.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
        eval(['Trust_in_Medicine.Sex.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Race
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Race','ReadVariableNames', true);
    T_Err_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Race','ReadVariableNames', true);
    
    Vr={'white','black','other'};
    for indx=1:3
        T=T_temp(strcmp(T_temp.race,Vr{indx}),:);
        Year_Table=T.year;
    
        T_Err=T_Err_temp(strcmp(T_Err_temp.race,Vr{indx}),:);
        [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);    
        
        temp_tot=great_deal_new+only_some_new+hardly_any_new;
        
    
        eval(['Trust_in_Medicine.Race.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
        eval(['Trust_in_Medicine.Race.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
        eval(['Trust_in_Medicine.Race.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Political
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Political','ReadVariableNames', true);
    T_Err_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Political','ReadVariableNames', true);
    
    Vr={'democrat','republican','other'};
    for indx=1:3
        T=T_temp(strcmp(T_temp.party,Vr{indx}),:);
        Year_Table=T.year;
        T_Err=T_Err_temp(strcmp(T_Err_temp.party,Vr{indx}),:);
        [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);
    
        
        temp_tot=great_deal_new+only_some_new+hardly_any_new;
        
    
        eval(['Trust_in_Medicine.Political.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
        eval(['Trust_in_Medicine.Political.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
        eval(['Trust_in_Medicine.Political.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Education
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Education','ReadVariableNames', true);
    T_Err_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Education','ReadVariableNames', true);
    
    Vr={'less_than_hs','hs','college'};
    for indx=1:3
        T=T_temp(strcmp(T_temp.education,Vr{indx}),:);
        Year_Table=T.year;
        T_Err=T_Err_temp(strcmp(T_Err_temp.education,Vr{indx}),:);
        [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);
        
        temp_tot=great_deal_new+only_some_new+hardly_any_new;
        
    
        eval(['Trust_in_Medicine.Education.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
        eval(['Trust_in_Medicine.Education.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
        eval(['Trust_in_Medicine.Education.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
        
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Economic
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Economic','ReadVariableNames', true);
    T_Err_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Economic','ReadVariableNames', true);
    
    Vr={'lower','working','middle','upper'};
    for indx=1:4
        T=T_temp(strcmp(T_temp.economic,Vr{indx}),:);
        Year_Table=T.year;
    
        T_Err=T_Err_temp(strcmp(T_Err_temp.economic,Vr{indx}),:);
        [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);
    
        
        temp_tot=great_deal_new+only_some_new+hardly_any_new;
        
    
        eval(['Trust_in_Medicine.Economic.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
        eval(['Trust_in_Medicine.Economic.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
        eval(['Trust_in_Medicine.Economic.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
        
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Age
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    T_temp=readtable([pwd '\Trust_In_Medicine.xlsx'],'Sheet','Age','ReadVariableNames', true);
    T_Err_temp=readtable([pwd '\Trust_In_Medicine_Error.xlsx'],'Sheet','Age','ReadVariableNames', true);
    
    Vr={'age_18_34','age_35_49','age_50_64','age_over_65'};
    for indx=1:4
        T=T_temp(strcmp(T_temp.age_class,Vr{indx}),:);
        Year_Table=T.year;
    
        T_Err=T_Err_temp(strcmp(T_Err_temp.age_class,Vr{indx}),:);
        [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp);
    
        
        temp_tot=great_deal_new+only_some_new+hardly_any_new;
        
    
        eval(['Trust_in_Medicine.Age.' Vr{indx} '.Great_Deal=great_deal_new./temp_tot;']);
        eval(['Trust_in_Medicine.Age.' Vr{indx} '.Only_Some=only_some_new./temp_tot;']);
        eval(['Trust_in_Medicine.Age.' Vr{indx} '.Hardly_Any=hardly_any_new./temp_tot;']);
        
    end
    save(['Trust_in_Medicine_Stratification_' num2str(samp_num) '.mat'],'Trust_in_Medicine','Trust_Year_Data');
end

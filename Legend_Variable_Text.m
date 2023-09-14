function [Legend_label_Name,C] = Legend_Variable_Text(Var_1)

C=[84,48,5;140,81,10;191,129,45;223,194,125;246,232,195;245,245,245;199,234,229;128,205,193;53,151,143;1,102,94;0,60,48]./256;
if strcmp(Var_1,'Trust_in_Medicine')
    Legend_label_Name= 'Level of trust in medicine';  
elseif strcmp(Var_1,'Trust_in_Science')
    Legend_label_Name= 'Level of trust in science';
elseif strcmp(Var_1,'Vaccine_Adverse_Events')
    Legend_label_Name= 'Reported vaccine adverse events per capita';
    C=flip(C);
elseif strcmp(Var_1,'Parental_Age')
    Legend_label_Name= 'Percent of population between 18 and 49';
elseif strcmp(Var_1,'Under_5_Age')
    Legend_label_Name= 'Percent of population under 5';
elseif strcmp(Var_1,'Sex')
    Legend_label_Name= 'Percent of population that is male';
elseif strcmp(Var_1,'Race')
    Legend_label_Name= 'Percent of population that is white';
elseif strcmp(Var_1,'Political')
    Legend_label_Name= 'Percent of population that is democratic';
elseif strcmp(Var_1,'Education')
    Legend_label_Name= 'Percent of population that has some college';
elseif strcmp(Var_1,'Economic')
    Legend_label_Name= 'Percent of population that is in the upper income class';
elseif strcmp(Var_1,'Household_Children_under_18')
    Legend_label_Name= 'Percent of households with cilder under 18';
elseif strcmp(Var_1,'Uninsured_19_under')
    Legend_label_Name= 'Percent of population under 19 that is uninsured';
elseif strcmp(Var_1,'Income')
    Legend_label_Name= 'Median household income';
elseif(strcmp(Var_1,'Medical_Exemption'))
    Legend_label_Name= 'Medical Exemption';
    C=flip(C);
elseif(strcmp(Var_1,'Total_Exemption'))
    Legend_label_Name= 'Total Exemption';
    C=flip(C);
elseif(strcmp(Var_1,'DTaP'))  
    Legend_label_Name= 'DTaP uptake';
elseif(strcmp(Var_1,'Polio'))    
    Legend_label_Name= 'Polio uptake';
elseif(strcmp(Var_1,'MMR'))
    Legend_label_Name= 'MMR uptake';
else
    Legend_label_Name=Var_1;
end

end
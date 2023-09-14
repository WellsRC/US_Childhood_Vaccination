function [scaled_Factor,CC_temp,Legend_label_Name,Y_Label_M,Nat_Avg,Nat_std]=Bounds_Plot_Colour(Var_Name,Year_Q,County_ID,Raw_County_Factor_Plot)

[~,year_weight,~,county_ID_weight,US_weight]=Return_Population_Weight_County;
    
w_c=zeros(length(County_ID),1);

Year_Q=min(Year_Q,2021);

for jj=1:length(w_c)
    tf=county_ID_weight == County_ID(jj); 
   w_c(jj)= US_weight(tf,ismember(Year_Q,year_weight));
end

w_c=w_c(~isnan(Raw_County_Factor_Plot))./sum(w_c(~isnan(Raw_County_Factor_Plot)));

Nat_Avg=sum(Raw_County_Factor_Plot(~isnan(Raw_County_Factor_Plot)).*w_c(:));
Nat_std=std(Raw_County_Factor_Plot(~isnan(Raw_County_Factor_Plot)),w_c);

scaled_Factor=normcdf(Raw_County_Factor_Plot,Nat_Avg,Nat_std);

CC_temp=[hex2rgb('#ca0020');1 1 1;hex2rgb('#0571b0');];
if(strcmp(Var_Name,'All_immunizations'))    
%     CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of kindergaretener with all immunizations';
    Y_Label_M='Proportion of kindergareteners';
elseif(strcmp(Var_Name,'Medical_Exemption'))
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of kindergaretener with medical exemptions';
    Y_Label_M='Proportion of kindergareteners';
    
elseif(strcmp(Var_Name,'Religious_Exemption'))    
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of kindergaretener with religous exemptions';
    Y_Label_M='Proportion of kindergareteners';
    
elseif(strcmp(Var_Name,'Philosophical_Exemption')) 
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of kindergaretener with philosophical exemptions';
    Y_Label_M='Proportion of kindergareteners';   
    
elseif(strcmp(Var_Name,'DTaP'))    
    Legend_label_Name='Relative percentage of kindergaretener with all DTaP immunizations';
    Y_Label_M='Proportion of kindergareteners';
    
elseif(strcmp(Var_Name,'Polio'))    
    Legend_label_Name='Relative percentage of kindergaretener with all Polio immunizations';
    Y_Label_M='Proportion of kindergareteners';
    
elseif(strcmp(Var_Name,'MMR'))
    Legend_label_Name='Relative percentage of kindergaretener with all MMR immunizations';
    Y_Label_M='Proportion of kindergareteners';
    
elseif(strcmp(Var_Name,'Household_Children_under_18'))
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of households with children under 18';
    Y_Label_M='Proportion households';
elseif(strcmp(Var_Name,'Uninsured_19_under'))
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of children under 19 uninsured';
    Y_Label_M='Proportion uninsured';
elseif(strcmp(Var_Name,'MMR_School'))
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage of parental choice for MMR';
    Y_Label_M='Proportion for choice';
elseif(strcmp(Var_Name,'COVID_Vaccination_Hesitancy'))
   CC_temp=flip(CC_temp);
   Legend_label_Name='Relative extent of COVID vaccination hesitancy';
   Y_Label_M='Proportion for choice';
elseif(strcmp(Var_Name,'MMR_Benefit_Political'))        
   Legend_label_Name='Relative percentage beleive that benefit of MMR outweighs risk (Politcal)';
elseif(strcmp(Var_Name,'MMR_Benefit_COVID_Vaccination'))   
   Legend_label_Name='Relative percentage beleive that benefit of MMR outweighs risk (COVID vaccination)';
elseif(strcmp(Var_Name,'Political_COVID_Skeptic'))   
    CC_temp=flip(CC_temp);
   Legend_label_Name='Relative percentage that are skeptic about COVID (Political)';
elseif(strcmp(Var_Name,'Race_COVID_Skeptic'))
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage that are skeptic about COVID (Race)';
elseif(strcmp(Var_Name,'Political_System_Distruster'))
    CC_temp=flip(CC_temp);
   Legend_label_Name='Relative percentage that distrust health system (Political)';
elseif(strcmp(Var_Name,'Race_System_Distruster'))
    CC_temp=flip(CC_temp);
    Legend_label_Name='Relative percentage that distrust health system (Race)';
elseif(strcmp(Var_Name,'Trust_in_Medicine'))    
    Legend_label_Name='Relative trust in medicine';
    Y_Label_M='Trust in medicine';
elseif(strcmp(Var_Name,'Trust_in_Science'))
    Legend_label_Name='Relative trust in science';
    Y_Label_M='Trust in science';
elseif(strcmp(Var_Name,'Primary Physician'))
   Legend_label_Name='Relative trust in Primary Physician';
    Y_Label_M='Trust in Primary Physician';
elseif(strcmp(Var_Name,'Nurses'))
   Legend_label_Name='Relative trust in nurses';
    Y_Label_M='Trust in nurses';  
elseif(strcmp(Var_Name,'Doctors'))
   Legend_label_Name='Relative trust in doctors';
    Y_Label_M='Trust in doctors';  
elseif(strcmp(Var_Name,'Healthcare System'))
   Legend_label_Name='Relative trust in healthcare system';
    Y_Label_M='Trust in  healthcare system'; 
elseif(strcmp(Var_Name,'Pharmaceutical Companies'))
    Legend_label_Name='Relative trust in Pharmaceutical Companies';
    Y_Label_M='Trust in Pharmaceutical Companies'; 
elseif(strcmp(Var_Name,'Government Health Agencies'))
    Legend_label_Name='Relative trust in Government Health Agencies';
    Y_Label_M='Trust in Government Health Agencies'; 
elseif(strcmp(Var_Name,'Treatment recommendations'))
    Legend_label_Name='Relative proportion follow treatment recommendations';
    Y_Label_M='follow treatment recommendations'; 
elseif(strcmp(Var_Name,'Book follow-up'))
    Legend_label_Name='Relative proportion book follow-up';
    Y_Label_M='book follow-up'; 
elseif(strcmp(Var_Name,'Vaccine_Adverse_Events'))   
    CC_temp=flip(CC_temp); 
    Legend_label_Name='Relative report of vaccine adverse events';
    Y_Label_M='book follow-up'; 
end
end
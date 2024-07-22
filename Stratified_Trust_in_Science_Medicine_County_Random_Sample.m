function [County_Trust_in_Science,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County_Random_Sample(Var_1,County_ID,Samp_Size)
    
    load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Science_Stratification.mat']);
    load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Medicine_Stratification.mat']);


    load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Science_Error_Stratification.mat']);
    load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Medicine_Error_Stratification.mat']);

    load([pwd '/Spatial_Data/Demographic_Data/County_Population.mat']);
    Data_CID=County_Demo.County_ID;
    Data_Year=County_Demo.Year_Data;
    if(strcmp(Var_1,'Age')||strcmp(Var_1,'Race'))
        P=County_Demo.Population;
    elseif(strcmp(Var_1,'Sex'))
        P.male=County_Demo.Population.Male.Total;
        P.female=County_Demo.Population.Female.Total;
    else
        eval(['P=County_Demo.' Var_1 ';']);
    end
    eval(['TRS=Trust_in_Science.' Var_1 ';']);
    eval(['TRM=Trust_in_Medicine.' Var_1 ';']);
    
    eval(['ErrS=Trust_in_Science_Error.' Var_1 ';']);
    eval(['ErrM=Trust_in_Medicine_Error.' Var_1 ';']);

    County_Trust_in_Science=NaN.*zeros(length(County_ID),length(Data_Year),Samp_Size);
    County_Trust_in_Medicine=NaN.*zeros(length(County_ID),length(Data_Year),Samp_Size);
    if(strcmp(Var_1,'Age'))
        for yy=1:length(Data_Year)

            S_18_34=normrnd(TRS.age_18_34.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.age_18_34.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_35_49=normrnd(TRS.age_35_49.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.age_35_49.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_50_64=normrnd(TRS.age_50_64.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.age_50_64.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_65p=normrnd(TRS.age_over_65.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.age_over_65.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            SO_18_34=normrnd(TRS.age_18_34.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.age_18_34.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_35_49=normrnd(TRS.age_35_49.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.age_35_49.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_50_64=normrnd(TRS.age_50_64.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.age_50_64.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_65p=normrnd(TRS.age_over_65.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.age_over_65.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            M_18_34=normrnd(TRM.age_18_34.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.age_18_34.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_35_49=normrnd(TRM.age_35_49.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.age_35_49.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_50_64=normrnd(TRM.age_50_64.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.age_50_64.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_65p=normrnd(TRM.age_over_65.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.age_over_65.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            MO_18_34=normrnd(TRM.age_18_34.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.age_18_34.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_35_49=normrnd(TRM.age_35_49.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.age_35_49.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_50_64=normrnd(TRM.age_50_64.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.age_50_64.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_65p=normrnd(TRM.age_over_65.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.age_over_65.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            for ii=1:length(County_ID)
                tf=Data_CID == County_ID(ii);
                if(sum(tf)>0)
                
                    Pop_temp=P.Age_18_34(tf,yy)+P.Age_35_49(tf,yy)+P.Age_50_64(tf,yy)+P.Age_65_plus(tf,yy);
                    
    
                    County_Trust_in_Science(ii,yy,:)=(S_18_34.*P.Age_18_34(tf,yy)+S_35_49.*P.Age_35_49(tf,yy)+S_50_64.*P.Age_50_64(tf,yy)+S_65p.*P.Age_65_plus(tf,yy));
                       
                    County_Trust_in_Science(ii,yy,:)=squeeze(County_Trust_in_Science(ii,yy,:))'+0.5.*(SO_18_34.*P.Age_18_34(tf,yy)+SO_35_49.*P.Age_35_49(tf,yy)+SO_50_64.*P.Age_50_64(tf,yy)+SO_65p.*P.Age_65_plus(tf,yy));
    
                    County_Trust_in_Science(ii,yy,:)=County_Trust_in_Science(ii,yy,:)./Pop_temp;

    
                    County_Trust_in_Medicine(ii,yy,:)=(M_18_34.*P.Age_18_34(tf,yy)+M_35_49.*P.Age_35_49(tf,yy)+M_50_64.*P.Age_50_64(tf,yy)+M_65p.*P.Age_65_plus(tf,yy));
                    
    
                    County_Trust_in_Medicine(ii,yy,:)=squeeze(County_Trust_in_Medicine(ii,yy,:))'+0.5.*(MO_18_34.*P.Age_18_34(tf,yy)+MO_35_49.*P.Age_35_49(tf,yy)+MO_50_64.*P.Age_50_64(tf,yy)+MO_65p.*P.Age_65_plus(tf,yy));
    
                    County_Trust_in_Medicine(ii,yy,:)=County_Trust_in_Medicine(ii,yy,:)./Pop_temp;
                end
            end
        end
    elseif(strcmp(Var_1,'Sex'))

        for yy=1:length(Data_Year)

            S_Male=normrnd(TRS.male.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.male.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_Female=normrnd(TRS.female.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.female.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            SO_Male=normrnd(TRS.male.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.male.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_Female=normrnd(TRS.female.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.female.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            M_Male=normrnd(TRM.male.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.male.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_Female=normrnd(TRM.female.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.female.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            MO_Male=normrnd(TRM.male.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.male.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_Female=normrnd(TRM.female.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.female.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            for ii=1:length(County_ID)
                tf=Data_CID == County_ID(ii);
                if(sum(tf)>0)
                
                    Pop_temp=P.male(tf,yy)+P.female(tf,yy);
                    
    
                    County_Trust_in_Science(ii,yy,:)=(S_Male.*P.male(tf,yy)+S_Female.*P.female(tf,yy));
                       
                    County_Trust_in_Science(ii,yy,:)=squeeze(County_Trust_in_Science(ii,yy,:))'+0.5.*(SO_Male.*P.male(tf,yy)+SO_Female.*P.female(tf,yy));
    
                    County_Trust_in_Science(ii,yy,:)=County_Trust_in_Science(ii,yy,:)./Pop_temp;

    
                    County_Trust_in_Medicine(ii,yy,:)=(M_Male.*P.male(tf,yy)+M_Female.*P.female(tf,yy));
                    
    
                    County_Trust_in_Medicine(ii,yy,:)=squeeze(County_Trust_in_Medicine(ii,yy,:))'+0.5.*(MO_Male.*P.male(tf,yy)+MO_Female.*P.female(tf,yy));
    
                    County_Trust_in_Medicine(ii,yy,:)=County_Trust_in_Medicine(ii,yy,:)./Pop_temp;
                end
            end
        end    
       
    elseif(strcmp(Var_1,'Race'))        
        for yy=1:length(Data_Year)

            S_white=normrnd(TRS.white.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.white.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_black=normrnd(TRS.black.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.black.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_other=normrnd(TRS.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            SO_white=normrnd(TRS.white.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.white.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_black=normrnd(TRS.black.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.black.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_other=normrnd(TRS.other.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.other.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            M_white=normrnd(TRM.white.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.white.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_black=normrnd(TRM.black.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.black.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_other=normrnd(TRM.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            MO_white=normrnd(TRM.white.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.white.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_black=normrnd(TRM.black.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.black.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_other=normrnd(TRM.other.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.other.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            for ii=1:length(County_ID)
                tf=Data_CID == County_ID(ii);
                if(sum(tf)>0)
                
                    Pop_temp=P.White(tf,yy)+P.Black(tf,yy)+P.Other(tf,yy);
                    
        
                    County_Trust_in_Science(ii,yy,:)=(S_white.*P.White(tf,yy)+S_black.*P.Black(tf,yy)+S_other.*P.Other(tf,yy));
                       
                    County_Trust_in_Science(ii,yy,:)=squeeze(County_Trust_in_Science(ii,yy,:))'+0.5.*(SO_white.*P.White(tf,yy)+SO_black.*P.Black(tf,yy)+SO_other.*P.Other(tf,yy));
        
                    County_Trust_in_Science(ii,yy,:)=County_Trust_in_Science(ii,yy,:)./Pop_temp;
        
        
                    County_Trust_in_Medicine(ii,yy,:)=(M_white.*P.White(tf,yy)+M_black.*P.Black(tf,yy)+M_other.*P.Other(tf,yy));
                    
        
                    County_Trust_in_Medicine(ii,yy,:)=squeeze(County_Trust_in_Medicine(ii,yy,:))'+0.5.*(MO_white.*P.White(tf,yy)+MO_black.*P.Black(tf,yy)+MO_other.*P.Other(tf,yy));
        
                    County_Trust_in_Medicine(ii,yy,:)=County_Trust_in_Medicine(ii,yy,:)./Pop_temp;
                end
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for yy=1:length(Data_Year)
            S_democrat=normrnd(TRS.democrat.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.democrat.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_republican=normrnd(TRS.republican.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.republican.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_other=normrnd(TRS.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            SO_democrat=normrnd(TRS.democrat.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.democrat.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_republican=normrnd(TRS.republican.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.republican.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_other=normrnd(TRS.other.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.other.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            M_democrat=normrnd(TRM.democrat.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.democrat.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_republican=normrnd(TRM.republican.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.republican.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_other=normrnd(TRM.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.other.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            MO_democrat=normrnd(TRM.democrat.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.democrat.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_republican=normrnd(TRM.republican.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.republican.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_other=normrnd(TRM.other.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.other.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            for ii=1:length(County_ID)
                tf=Data_CID == County_ID(ii);
                if(sum(tf)>0)
                
                    Pop_temp=P.Democratic(tf,yy)+P.Republican(tf,yy)+P.Other(tf,yy);
                    
        
                    County_Trust_in_Science(ii,yy,:)=(S_democrat.*P.Democratic(tf,yy)+S_republican.*P.Republican(tf,yy)+S_other.*P.Other(tf,yy));
                       
                    County_Trust_in_Science(ii,yy,:)=squeeze(County_Trust_in_Science(ii,yy,:))'+0.5.*(SO_democrat.*P.Democratic(tf,yy)+SO_republican.*P.Republican(tf,yy)+SO_other.*P.Other(tf,yy));
        
                    County_Trust_in_Science(ii,yy,:)=County_Trust_in_Science(ii,yy,:)./Pop_temp;
        
        
                    County_Trust_in_Medicine(ii,yy,:)=(M_democrat.*P.Democratic(tf,yy)+M_republican.*P.Republican(tf,yy)+M_other.*P.Other(tf,yy));
                    
        
                    County_Trust_in_Medicine(ii,yy,:)=squeeze(County_Trust_in_Medicine(ii,yy,:))'+0.5.*(MO_democrat.*P.Democratic(tf,yy)+MO_republican.*P.Republican(tf,yy)+MO_other.*P.Other(tf,yy));
        
                    County_Trust_in_Medicine(ii,yy,:)=County_Trust_in_Medicine(ii,yy,:)./Pop_temp;
                end
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for yy=1:length(Data_Year)
            S_less_than_hs=normrnd(TRS.less_than_hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.less_than_hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_hs=normrnd(TRS.hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_college=normrnd(TRS.college.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.college.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            SO_less_than_hs=normrnd(TRS.less_than_hs.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.less_than_hs.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_hs=normrnd(TRS.hs.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.hs.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_college=normrnd(TRS.college.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.college.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            M_less_than_hs=normrnd(TRM.less_than_hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.less_than_hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_hs=normrnd(TRM.hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.hs.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_college=normrnd(TRM.college.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.college.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
        
            MO_less_than_hs=normrnd(TRM.less_than_hs.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.less_than_hs.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_hs=normrnd(TRM.hs.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.hs.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_college=normrnd(TRM.college.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.college.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            for ii=1:length(County_ID)
                tf=Data_CID == County_ID(ii);
                if(sum(tf)>0)
                
                    Pop_temp=P.Less_than_High_School(tf,yy)+P.High_School(tf,yy)+P.College(tf,yy);
                    
        
                    County_Trust_in_Science(ii,yy,:)=(S_less_than_hs.*P.Less_than_High_School(tf,yy)+S_hs.*P.High_School(tf,yy)+S_college.*P.College(tf,yy));
                       
                    County_Trust_in_Science(ii,yy,:)=squeeze(County_Trust_in_Science(ii,yy,:))'+0.5.*(SO_less_than_hs.*P.Less_than_High_School(tf,yy)+SO_hs.*P.High_School(tf,yy)+SO_college.*P.College(tf,yy));
        
                    County_Trust_in_Science(ii,yy,:)=County_Trust_in_Science(ii,yy,:)./Pop_temp;
        
        
                    County_Trust_in_Medicine(ii,yy,:)=(M_less_than_hs.*P.Less_than_High_School(tf,yy)+M_hs.*P.High_School(tf,yy)+M_college.*P.College(tf,yy));
                    
        
                    County_Trust_in_Medicine(ii,yy,:)=squeeze(County_Trust_in_Medicine(ii,yy,:))'+0.5.*(MO_less_than_hs.*P.Less_than_High_School(tf,yy)+MO_hs.*P.High_School(tf,yy)+MO_college.*P.College(tf,yy));
        
                    County_Trust_in_Medicine(ii,yy,:)=County_Trust_in_Medicine(ii,yy,:)./Pop_temp;
                end
            end
        end
    elseif(strcmp(Var_1,'Economic'))       
        for yy=1:length(Data_Year)

            S_lower=normrnd(TRS.lower.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.lower.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_working=normrnd(TRS.working.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.working.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_middle=normrnd(TRS.middle.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.middle.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            S_upper=normrnd(TRS.upper.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrS.upper.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            SO_lower=normrnd(TRS.lower.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.lower.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_working=normrnd(TRS.working.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.working.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_middle=normrnd(TRS.middle.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.middle.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            SO_upper=normrnd(TRS.upper.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrS.upper.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            M_lower=normrnd(TRM.lower.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.lower.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_working=normrnd(TRM.working.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.working.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_middle=normrnd(TRM.middle.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.middle.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            M_upper=normrnd(TRM.upper.Great_Deal(Trust_Year_Data==Data_Year(yy)),ErrM.upper.Great_Deal(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);

            MO_lower=normrnd(TRM.lower.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.lower.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_working=normrnd(TRM.working.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.working.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_middle=normrnd(TRM.middle.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.middle.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            MO_upper=normrnd(TRM.upper.Only_Some(Trust_Year_Data==Data_Year(yy)),ErrM.upper.Only_Some(Trust_Year_Data==Data_Year(yy)),1,Samp_Size);
            for ii=1:length(County_ID)
                tf=Data_CID == County_ID(ii);
                if(sum(tf)>0)
                
                    Pop_temp=P.Lower(tf,yy)+P.Working(tf,yy)+P.Middle(tf,yy)+P.Upper(tf,yy);
                    
    
                    County_Trust_in_Science(ii,yy,:)=(S_lower.*P.Lower(tf,yy)+S_working.*P.Working(tf,yy)+S_middle.*P.Middle(tf,yy)+S_upper.*P.Upper(tf,yy));
                       
                    County_Trust_in_Science(ii,yy,:)=squeeze(County_Trust_in_Science(ii,yy,:))'+0.5.*(SO_lower.*P.Lower(tf,yy)+SO_working.*P.Working(tf,yy)+SO_middle.*P.Middle(tf,yy)+SO_upper.*P.Upper(tf,yy));
    
                    County_Trust_in_Science(ii,yy,:)=County_Trust_in_Science(ii,yy,:)./Pop_temp;

    
                    County_Trust_in_Medicine(ii,yy,:)=(M_lower.*P.Lower(tf,yy)+M_working.*P.Working(tf,yy)+M_middle.*P.Middle(tf,yy)+M_upper.*P.Upper(tf,yy));
                    
    
                    County_Trust_in_Medicine(ii,yy,:)=squeeze(County_Trust_in_Medicine(ii,yy,:))'+0.5.*(MO_lower.*P.Lower(tf,yy)+MO_working.*P.Working(tf,yy)+MO_middle.*P.Middle(tf,yy)+MO_upper.*P.Upper(tf,yy));
    
                    County_Trust_in_Medicine(ii,yy,:)=County_Trust_in_Medicine(ii,yy,:)./Pop_temp;
                end
            end
        end
    end
        
    end
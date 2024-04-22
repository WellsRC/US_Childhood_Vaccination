function [County_Trust_in_Science,County_Trust_in_Medicine,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Var_1,County_ID)
    
    load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Science_Stratification.mat']);
    load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Medicine_Stratification.mat']);
    load([pwd '\Spatial_Data\Demographic_Data\County_Population.mat']);
    Data_CID=County_Demo.County_ID;
    Data_Year=County_Demo.Year_Data;
    eval(['P=County_Demo.' Var_1 ';']);
    eval(['TRS=Trust_in_Science.' Var_1 ';']);
    eval(['TRM=Trust_in_Medicine.' Var_1 ';']);
    County_Trust_in_Science=NaN.*zeros(length(County_ID),length(Data_Year));
    County_Trust_in_Medicine=NaN.*zeros(length(County_ID),length(Data_Year));
    if(strcmp(Var_1,'Age'))
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Range_18_to_34(tf,:)+P.Range_35_to_49(tf,:)+P.Range_50_to_64(tf,:)+P.Range_50_to_64(tf,:);
                County_Trust_in_Science(ii,:)=(TRS.age_18_34.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_18_to_34(tf,:)+TRS.age_35_49.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_35_to_49(tf,:)+TRS.age_50_64.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:)+TRS.age_over_65.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)+0.5.*(TRS.age_18_34.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_18_to_34(tf,:)+TRS.age_35_49.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_35_to_49(tf,:)+TRS.age_50_64.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:)+TRS.age_over_65.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:));
                County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)./Pop_temp;

                County_Trust_in_Medicine(ii,:)=(TRM.age_18_34.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_18_to_34(tf,:)+TRM.age_35_49.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_35_to_49(tf,:)+TRM.age_50_64.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:)+TRM.age_over_65.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:));
               County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)+0.5.*(TRM.age_18_34.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_18_to_34(tf,:)+TRM.age_35_49.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_35_to_49(tf,:)+TRM.age_50_64.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:)+TRM.age_over_65.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Range_50_to_64(tf,:));
                County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Sex'))
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Male(tf,:)+P.Female(tf,:);
                County_Trust_in_Science(ii,:)=(TRS.male.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Male(tf,:)+TRS.female.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Female(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)+0.5.*(TRS.male.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Male(tf,:)+TRS.female.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Female(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)./Pop_temp;
               
               County_Trust_in_Medicine(ii,:)=(TRM.male.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Male(tf,:)+TRM.female.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Female(tf,:));
               County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)+0.5.*(TRM.male.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Male(tf,:)+TRM.female.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Female(tf,:));
                County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Race'))        
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.White(tf,:)+P.Black(tf,:)+P.Other(tf,:);
                County_Trust_in_Science(ii,:)=(TRS.white.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.White(tf,:)+TRS.black.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Black(tf,:)+TRS.other.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)+0.5.*(TRS.white.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.White(tf,:)+TRS.black.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Black(tf,:)+TRS.other.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
                County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)./Pop_temp;

                County_Trust_in_Medicine(ii,:)=(TRM.white.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.White(tf,:)+TRM.black.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Black(tf,:)+TRM.other.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
               County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)+0.5.*(TRM.white.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.White(tf,:)+TRM.black.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Black(tf,:)+TRM.other.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
                County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Democratic(tf,:)+P.Republican(tf,:)+P.Other(tf,:);
                County_Trust_in_Science(ii,:)=(TRS.democrat.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Democratic(tf,:)+TRS.republican.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Republican(tf,:)+TRS.other.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)+0.5.*(TRS.democrat.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Democratic(tf,:)+TRS.republican.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Republican(tf,:)+TRS.other.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)./Pop_temp;
               
               County_Trust_in_Medicine(ii,:)=(TRM.democrat.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Democratic(tf,:)+TRM.republican.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Republican(tf,:)+TRM.other.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
               County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)+0.5.*(TRM.democrat.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Democratic(tf,:)+TRM.republican.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Republican(tf,:)+TRM.other.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Other(tf,:));
                County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Less_than_High_School(tf,:)+P.High_School(tf,:)+P.College(tf,:);
                County_Trust_in_Science(ii,:)=(TRS.less_than_hs.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Less_than_High_School(tf,:)+TRS.hs.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.High_School(tf,:)+TRS.college.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.College(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)+0.5.*(TRS.less_than_hs.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Less_than_High_School(tf,:)+TRS.hs.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.High_School(tf,:)+TRS.college.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.College(tf,:));
                County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)./Pop_temp;

                County_Trust_in_Medicine(ii,:)=(TRM.less_than_hs.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Less_than_High_School(tf,:)+TRM.hs.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.High_School(tf,:)+TRM.college.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.College(tf,:));
               County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)+0.5.*(TRM.less_than_hs.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Less_than_High_School(tf,:)+TRM.hs.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.High_School(tf,:)+TRM.college.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.College(tf,:));
                County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Economic'))       
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Lower(tf,:)+P.Working(tf,:)+P.Middle(tf,:)+P.Upper(tf,:);
                County_Trust_in_Science(ii,:)=(TRS.lower.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Lower(tf,:)+TRS.working.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Working(tf,:)+TRS.middle.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Middle(tf,:)+TRS.upper.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Upper(tf,:));
               County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)+0.5.*(TRS.lower.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Lower(tf,:)+TRS.working.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Working(tf,:)+TRS.middle.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Middle(tf,:)+TRS.upper.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Upper(tf,:));
                County_Trust_in_Science(ii,:)=County_Trust_in_Science(ii,:)./Pop_temp;

                County_Trust_in_Medicine(ii,:)=(TRM.lower.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Lower(tf,:)+TRM.working.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Working(tf,:)+TRM.middle.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Middle(tf,:)+TRM.upper.Great_Deal(ismember(Trust_Year_Data,Data_Year)).*P.Upper(tf,:));
               County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)+0.5.*(TRM.lower.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Lower(tf,:)+TRM.working.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Working(tf,:)+TRM.middle.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Middle(tf,:)+TRM.upper.Only_Some(ismember(Trust_Year_Data,Data_Year)).*P.Upper(tf,:));
                County_Trust_in_Medicine(ii,:)=County_Trust_in_Medicine(ii,:)./Pop_temp;
            end
        end 
    end
        
    end
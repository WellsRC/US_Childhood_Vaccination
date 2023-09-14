function [County_Demo,Data_Year]=Demographics_County(Var_1,County_ID,Rand_Indx)

    load([pwd '\State_Data\County_Data\County_Population_' num2str(Rand_Indx) '.mat']);
    Data_CID=Population.County_ID_Numeric;
    Data_Year=Population.Year_Data;
    if(strcmp(Var_1,'Parental_Age')||strcmp(Var_1,'Under_5_Age'))
        P=Population.Age;
        PS=Population.Sex;
    else
        eval(['P=Population.' Var_1 ';']);
    end
    County_Demo=NaN.*zeros(length(County_ID),length(Data_Year));
    
    if(strcmp(Var_1,'Parental_Age'))
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Range_18_to_34(tf,:)+P.Range_35_to_49(tf,:);                
                P_tot=PS.Male(tf,:)+PS.Female(tf,:);
                County_Demo(ii,:)=Pop_temp./P_tot;
            end
        end
    elseif(strcmp(Var_1,'Under_5_Age'))
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Under_5.Male(tf,:)+P.Under_5.Female(tf,:);
                P_tot=PS.Male(tf,:)+PS.Female(tf,:);
                County_Demo(ii,:)=(Pop_temp)./P_tot;
            end
        end
    elseif(strcmp(Var_1,'Sex'))
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Male(tf,:)+P.Female(tf,:);
                County_Demo(ii,:)=P.Male(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Race'))        
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.White(tf,:)+P.Black(tf,:)+P.Other(tf,:);
                County_Demo(ii,:)=P.White(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Democratic(tf,:)+P.Republican(tf,:)+P.Other(tf,:);
                County_Demo(ii,:)=P.Democratic(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Less_than_High_School(tf,:)+P.High_School(tf,:)+P.College(tf,:);
                County_Demo(ii,:)=P.College(tf,:)./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Economic'))       
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Lower(tf,:)+P.Working(tf,:)+P.Middle(tf,:)+P.Upper(tf,:);
                County_Demo(ii,:)=(P.Upper(tf,:))./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Uninsured_19_under')||strcmp(Var_1,'Household_Children_under_18')||strcmp(Var_1,'Income'))   
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                County_Demo(ii,:)=P(tf,:);
            end
        end 
    end
        
    end
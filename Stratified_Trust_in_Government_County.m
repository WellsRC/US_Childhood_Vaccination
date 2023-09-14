function [County_Trust_in_Government,Data_Year]=Stratified_Trust_in_Government_County(Var_1,County_ID)

    load([pwd '\State_Data\Trust_in_Government_Stratification.mat']);
    load([pwd '\State_Data\County_Data\County_Population.mat']);
    Data_CID=Population.County_ID_Numeric;
    Data_Year=Population.Year_Data;
    eval(['P=Population.' Var_1 ';']);
    eval(['TRS=Trust_in_Government.' Var_1 ';']);
    County_Trust_in_Government=NaN.*zeros(length(County_ID),length(Data_Year));
    
    if(strcmp(Var_1,'Race'))        
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.White(tf,:)+P.Black(tf,:)+P.Other(tf,:);
                County_Trust_in_Government(ii,:)=(TRS.White.*P.White(tf,:)+TRS.Black.*P.Black(tf,:)+TRS.Other.*P.Other(tf,:))./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Democratic(tf,:)+P.Republican(tf,:);
                County_Trust_in_Government(ii,:)=(TRS.Democratic.*P.Democratic(tf,:)+TRS.Republican.*P.Republican(tf,:))./Pop_temp;
            end
        end
    end
        
    end
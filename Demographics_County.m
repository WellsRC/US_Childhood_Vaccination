function [County_R,Data_Year]=Demographics_County(Var_1,County_ID)

    load([pwd '\State_Data\Demographic_Data\County_Population.mat']);
    Data_SID=County_Demo.County_ID;
    Data_Year=County_Demo.Year_Data;
    
    County_R=NaN.*zeros(length(County_ID),length(Data_Year));
    
    if(strcmp(Var_1,'Sex'))
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=County_Demo.Population.Male.Total(tf,:)+County_Demo.Population.Female.Total(tf,:);
                County_R(ii,:)=County_Demo.Population.Male.Total(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Race'))        
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=County_Demo.Population.White(tf,:)+County_Demo.Population.Black(tf,:)+County_Demo.Population.Other(tf,:);
                County_R(ii,:)=County_Demo.Population.White(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=County_Demo.Political.Democratic(tf,:)+County_Demo.Political.Republican(tf,:)+County_Demo.Political.Other(tf,:);
                County_R(ii,:)=County_Demo.Political.Democratic(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=County_Demo.Education.Less_than_High_School(tf,:)+County_Demo.Education.High_School(tf,:)+County_Demo.Education.College(tf,:);
                County_R(ii,:)=County_Demo.Education.College(tf,:)./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Economic'))       
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                Pop_temp=County_Demo.Economic.Lower(tf,:)+County_Demo.Economic.Working(tf,:)+County_Demo.Economic.Middle(tf,:)+County_Demo.Economic.Upper(tf,:);
                County_R(ii,:)=(County_Demo.Economic.Upper(tf,:))./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Uninsured_19_under'))
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                County_R(ii,:)=County_Demo.Percent_Uninsured_Under_19(tf,:);
            end
        end 
    elseif(strcmp(Var_1,'Income'))
        for ii=1:length(County_ID)
            tf=Data_SID == County_ID(ii);
            if(sum(tf)>0)
                County_R(ii,:)=County_Demo.Income(tf,:);
            end
        end         
    end
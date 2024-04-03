function [State_R,Data_Year]=Demographics_State(Var_1,State_ID)

    load([pwd '\State_Data\Demographic_Data\State_Population.mat']);
    Data_SID=State_Demo.State_ID;
    Data_Year=State_Demo.Year_Data;
    
    State_R=NaN.*zeros(length(State_ID),length(Data_Year));
    
    if(strcmp(Var_1,'Sex'))
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=State_Demo.Population.Male.Total(tf,:)+State_Demo.Population.Female.Total(tf,:);
                State_R(ii,:)=State_Demo.Population.Male.Total(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Race'))        
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=State_Demo.Population.White(tf,:)+State_Demo.Population.Black(tf,:)+State_Demo.Population.Other(tf,:);
                State_R(ii,:)=State_Demo.Population.White(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=State_Demo.Political.Democratic(tf,:)+State_Demo.Political.Republican(tf,:)+State_Demo.Political.Other(tf,:);
                State_R(ii,:)=State_Demo.Political.Democratic(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=State_Demo.Education.Less_than_High_School(tf,:)+State_Demo.Education.High_School(tf,:)+State_Demo.Education.College(tf,:);
                State_R(ii,:)=State_Demo.Education.College(tf,:)./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Economic'))       
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=State_Demo.Economic.Lower(tf,:)+State_Demo.Economic.Working(tf,:)+State_Demo.Economic.Middle(tf,:)+State_Demo.Economic.Upper(tf,:);
                State_R(ii,:)=(State_Demo.Economic.Upper(tf,:))./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Uninsured_19_under'))
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                State_R(ii,:)=State_Demo.Percent_Uninsured_Under_19(tf,:);
            end
        end 
    elseif(strcmp(Var_1,'Income'))
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                State_R(ii,:)=State_Demo.Income(tf,:);
            end
        end         
    end
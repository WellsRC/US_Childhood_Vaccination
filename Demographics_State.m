function [State_R,Data_Year]=Demographics_State(Var_1,State_ID)

    load([pwd '\State_Data\Demographic_Data\State_Population.mat']);
    Data_CID=State_Demo.County_ID_Numeric;
    Data_Year=State_Demo.Year_Data;
    eval(['P=State_Demo.' Var_1 ';']);
    
    State_R=NaN.*zeros(length(State_ID),length(Data_Year));
    
    if(strcmp(Var_1,'Sex'))
        for ii=1:length(State_ID)
            tf=Data_CID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Male(tf,:)+P.Female(tf,:);
                State_R(ii,:)=P.Male(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Race'))        
        for ii=1:length(State_ID)
            tf=Data_CID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.White(tf,:)+P.Black(tf,:)+P.Other(tf,:);
                State_R(ii,:)=P.White(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(State_ID)
            tf=Data_CID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Democratic(tf,:)+P.Republican(tf,:)+P.Other(tf,:);
                State_R(ii,:)=P.Democratic(tf,:)./Pop_temp;
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for ii=1:length(State_ID)
            tf=Data_CID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Less_than_High_School(tf,:)+P.High_School(tf,:)+P.College(tf,:);
                State_R(ii,:)=P.College(tf,:)./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Economic'))       
        for ii=1:length(State_ID)
            tf=Data_CID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Lower(tf,:)+P.Working(tf,:)+P.Middle(tf,:)+P.Upper(tf,:);
                State_R(ii,:)=(P.Upper(tf,:))./Pop_temp;
            end
        end 
    elseif(strcmp(Var_1,'Uninsured_19_under')||strcmp(Var_1,'Income'))   
        for ii=1:length(State_ID)
            tf=Data_CID == State_ID(ii);
            if(sum(tf)>0)
                State_R(ii,:)=P(tf,:);
            end
        end 
    end
        
    end
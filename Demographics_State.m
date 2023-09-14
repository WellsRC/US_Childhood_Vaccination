function [State_Demo,Data_Year]=Demographics_State(Var_1,State_ID,Rand_Indx)

    load([pwd '\State_Data\County_Data\County_Population_' num2str(Rand_Indx) '.mat']);
    Data_SID=Population.State_ID;
    Data_Year=Population.Year_Data;
    if(strcmp(Var_1,'Parental_Age')||strcmp(Var_1,'Under_5_Age'))
        P=Population.Age;
    else
        eval(['P=Population.' Var_1 ';']);
    end
    PS=Population.Sex;
    State_Demo=NaN.*zeros(length(State_ID),length(Data_Year));


    if(strcmp(Var_1,'Parental_Age'))
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Range_18_to_34(tf,:)+P.Range_35_to_49(tf,:);                
                P_tot=PS.Male(tf,:)+PS.Female(tf,:);

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;

                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end
    elseif(strcmp(Var_1,'Under_5_Age'))
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                Pop_temp=P.Under_5.Male(tf,:)+P.Under_5.Female(tf,:);
                P_tot=PS.Male(tf,:)+PS.Female(tf,:);

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;              
                
                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end
    elseif(strcmp(Var_1,'Sex'))
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                P_tot=P.Male(tf,:)+P.Female(tf,:);
                Pop_temp=P.Male(tf,:);

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;              
                
                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end
    elseif(strcmp(Var_1,'Race'))        
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                P_tot=P.White(tf,:)+P.Black(tf,:)+P.Other(tf,:);
                Pop_temp=P.White(tf,:);

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;              
                
                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end
    elseif(strcmp(Var_1,'Political'))        
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                P_tot=P.Democratic(tf,:)+P.Republican(tf,:)+P.Other(tf,:);
                Pop_temp=P.Democratic(tf,:);
                P_size=PS.Male(tf,:)+PS.Female(tf,:);

                P_tot=P_tot.*P_size;
                Pop_temp=Pop_temp.*P_size;

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;              
                
                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end
    elseif(strcmp(Var_1,'Education'))       
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                P_tot=P.Less_than_High_School(tf,:)+P.High_School(tf,:)+P.College(tf,:);
                Pop_temp=P.College(tf,:);

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;              
                
                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end 
    elseif(strcmp(Var_1,'Economic'))       
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                P_tot=P.Lower(tf,:)+P.Working(tf,:)+P.Middle(tf,:)+P.Upper(tf,:);
                Pop_temp=P.Upper(tf,:);

                t_nan=isnan(Pop_temp+P_tot);
                Pop_temp(t_nan)=0;
                P_tot(t_nan)=0;              
                
                State_Demo(ii,:)=sum(Pop_temp,1)./sum(P_tot,1);
            end
        end 
    elseif(strcmp(Var_1,'Uninsured_19_under')||strcmp(Var_1,'Household_Children_under_18')||strcmp(Var_1,'Income'))   
        for ii=1:length(State_ID)
            tf=Data_SID == State_ID(ii);
            if(sum(tf)>0)
                P_tot=PS.Male(tf,:)+PS.Female(tf,:);
                Pv=P(tf,:);
                
                t_nan=isnan(Pv+P_tot);
                Pv(t_nan)=0;
                P_tot(t_nan)=0;           

                w=P_tot./repmat(sum(P_tot,1),sum(tf),1);
                State_Demo(ii,:)=sum(Pv.*w,1);
            end
        end 
    end
        
    end
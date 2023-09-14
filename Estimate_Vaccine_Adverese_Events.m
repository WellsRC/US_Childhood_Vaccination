function [County_Factor_v]=Estimate_Vaccine_Adverese_Events(County_ID,Year_Q)

    County_Factor_v=NaN.*zeros(length(County_ID),length(Year_Q));
    
    load([pwd '\State_Data\County_Data\County_Population.mat']);
    Pop_Data_CID=Population.County_ID_Numeric;
    Pop_Data_Year=Population.Year_Data;
    Pop_Data_SID=Population.State_ID;
    
    load([pwd '\State_Data\Adverse_Events_Measles.mat'],'Year_Data','Adverse_Events_Male','Adverse_Events_Female','FIP_State');
    
    State_Male_Pop_Under_5=Population.Age.Under_5.Male;
    State_Female_Pop_Under_5=Population.Age.Under_5.Female;
    
    
    State_Male_Pop=Population.Sex.Male;
    State_Female_Pop=Population.Sex.Female;

    County_Male_Pop_Under_5=Population.Age.Under_5.Male;
    County_Female_Pop_Under_5=Population.Age.Under_5.Female;
       
    County_Male_Pop=Population.Sex.Male;
    County_Female_Pop=Population.Sex.Female;
    
    % Trim based on County_ID
    County_Male_Pop_Under_5=County_Male_Pop_Under_5(ismember(Pop_Data_CID,County_ID),:); % Need to look to see what 'full dataset' matches the query
    County_Female_Pop_Under_5=County_Female_Pop_Under_5(ismember(Pop_Data_CID,County_ID),:); % Need to look to see what 'full dataset' matches the query
    
    
    County_Male_Pop=County_Male_Pop(ismember(Pop_Data_CID,County_ID),:); % Need to look to see what 'full dataset' matches the query
    County_Female_Pop=County_Female_Pop(ismember(Pop_Data_CID,County_ID),:); % Need to look to see what 'full dataset' matches the query
    
    Pop_Data_SID_County=Pop_Data_SID(ismember(Pop_Data_CID,County_ID),:);
    
    
    
    for yy=1:length(Year_Q)
        for ss=1:length(FIP_State)
            tf = FIP_State(ss)== Pop_Data_SID_County;

            if(sum(tf>0))
                temp_m=sum(State_Male_Pop_Under_5(Pop_Data_SID==FIP_State(ss),Year_Q(yy)==Pop_Data_Year),1);
                temp_f=sum(State_Female_Pop_Under_5(Pop_Data_SID==FIP_State(ss),Year_Q(yy)==Pop_Data_Year),1);
                
                VAE_m=Adverse_Events_Male(ss,Year_Data==Year_Q(yy))./temp_m;
                VAE_f=Adverse_Events_Female(ss,Year_Data==Year_Q(yy))./temp_f;
                
                p_m=temp_m./sum(State_Male_Pop(Pop_Data_SID==FIP_State(ss),Year_Q(yy)==Pop_Data_Year),1);
                p_f=temp_f./sum(State_Female_Pop(Pop_Data_SID==FIP_State(ss),Year_Q(yy)==Pop_Data_Year),1);
                
                lambda_m=log(1-VAE_m)./p_m;
                lambda_f=log(1-VAE_f)./p_f;
                
                temp_m=County_Male_Pop_Under_5(tf,Year_Q(yy)==Pop_Data_Year);
                temp_f=County_Female_Pop_Under_5(tf,Year_Q(yy)==Pop_Data_Year);
                                
                p_m=temp_m./County_Male_Pop(tf,Year_Q(yy)==Pop_Data_Year);
                p_f=temp_f./County_Female_Pop(tf,Year_Q(yy)==Pop_Data_Year);
                
                w_m=temp_m./(temp_m+temp_f);
                County_Factor_v(tf,yy)=(w_m.*(1-exp(lambda_m.*p_m))+(1-w_m).*(1-exp(lambda_f.*p_f))).*10^4;
            end            
        end
    end
    
    
end
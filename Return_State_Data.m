function State_Factor_v=Return_State_Data(Var_Name,Year_Q,State_ID)

Immunization_Variables={'All_immunizations','Medical_Exemption','Religious_Exemption','Philosophical_Exemption','DTaP','Polio','MMR','VAR'};

if(strcmp(Var_Name,'Trust_in_Medicine') || strcmp(Var_Name,'Trust_in_Science'))
    load([pwd '\State_Data\Demographic_Data\County_Population.mat']);
    Data_SID=County_Demo.State_ID;
    Data_CID=County_Demo.County_ID;
    Data_Year=County_Demo.Year_Data;
    PS=County_Demo.Sex;
    P_tot=PS.Male(:,Year_Q==Data_Year)+PS.Female(:,Year_Q==Data_Year);
    clearvars PS;
    State_Factor_v=zeros(length(State_ID),1);
    for jj=1:length(State_Factor_v)
        tf= Data_SID == State_ID(jj);
        County_ID_temp= Data_CID(tf);
        County_Factor_v=Return_County_Data(Var_Name,Year_Q,County_ID_temp);
        w=P_tot(tf)./sum(P_tot(tf));
        State_Factor_v(jj)=sum(County_Factor_v.*w);
    end
elseif(sum(strcmp(Var_Name,Immunization_Variables))>0)
    State_Factor_v=State_Immunization_Statistics(Var_Name,Year_Q,State_ID);
end
    
end
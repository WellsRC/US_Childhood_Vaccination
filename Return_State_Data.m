function State_Factor_v=Return_State_Data(Var_Name,Year_Q,State_ID,Rand_Indx,Rand_Trust_S,Rand_Trust_M)

load([pwd '\State_Data\County_Data\County_Population_' num2str(Rand_Indx) '.mat']);
Data_SID=Population.State_ID;
Data_CID=Population.County_ID_Numeric;
Data_Year=Population.Year_Data;
PS=Population.Sex;
P_tot=PS.Male(:,Year_Q==Data_Year)+PS.Female(:,Year_Q==Data_Year);
clearvars PS;
State_Factor_v=zeros(length(State_ID),1);
for jj=1:length(State_Factor_v)
    tf= Data_SID == State_ID(jj);
    County_ID_temp= Data_CID(tf);
    County_Factor_v=Return_County_Data(Var_Name,Year_Q,County_ID_temp,Rand_Indx,Rand_Trust_S,Rand_Trust_M);
    w=P_tot(tf)./sum(P_tot(tf));
    State_Factor_v(jj)=sum(County_Factor_v.*w);
end
    
end
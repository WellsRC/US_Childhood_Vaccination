clear;
clc;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Obtain County and State IDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
[State_ID,County_ID]=Read_ID_Number();

Yr=[2017:2022];

Var_Name={'Trust_in_Medicine','Trust_in_Science'};

Var_Name_Demo={'Sex','Race','Political','Education','Economic','Uninsured_19_under','Income'};


D_State=cell(length(Yr),length(Var_Name_Demo));
X_State=cell(length(Yr),length(Var_Name));

D_County=cell(length(Yr),length(Var_Name_Demo));
X_County=cell(length(Yr),length(Var_Name));

VN={'Trust_in_Medicine','Trust_in_Science','Sex','Race','Political','Education','Economic','Uninsured_19_under','Income'}; 
for yy=1:length(Yr)
       
    for jj=1:length(Var_Name)
        X_State{yy,jj}=Return_State_Data(Var_Name{jj},Yr(yy),State_ID);
        X_County{yy,jj}=Return_County_Data(Var_Name{jj},Yr(yy),County_ID);
    end

    for jj=1:length(Var_Name_Demo)
        [State_Demo,Data_Year]=Demographics_State(Var_Name_Demo{jj},State_ID);
        D_State{yy,jj}=State_Demo(:,Data_Year==Yr(yy));
        [County_Demo,Data_Year]=Demographics_County(Var_Name_Demo{jj},County_ID);
        D_County{yy,jj}=County_Demo(:,Data_Year==Yr(yy));
    end
    
end
xt=[cell2mat(X_State) cell2mat(D_State); cell2mat(X_County) cell2mat(D_County)];
xt=xt(~isnan(sum(xt,2)),:);
clc;
XT=([log(xt(:,1:8)./(1-xt(:,1:8))) log(xt(:,9))]);  
T=[array2table(XT) ];
T.Properties.VariableNames=VN;

writetable(T,['Data_BN_Trust.xlsx'],'Sheet','Data');
    
    A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Income';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(7,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Income';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(7,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Income';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(5,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Economic';'Education';'Income'};
    A={'Race';'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(3,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Economic';'Education';'Income'};
    A={'Sex';'Sex';'Sex'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(3,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN_Trust.xlsx'],'Sheet','Conditions','WriteVariableNames',true);
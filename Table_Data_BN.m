clear;
clc;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Obtain County and State IDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
[State_ID,County_ID]=Read_ID_Number();

Yr=[2017:2022];

Var_Name={'Parental_Trust_in_Medicine','Parental_Trust_in_Science','Trust_in_Medicine','Trust_in_Science'};

Var_Name_Demo={'Sex','Race','Political','Education','Economic','Uninsured_19_under','Income'};


D_State=cell(length(Yr),length(Var_Name_Demo));
X_State=cell(length(Yr),length(Var_Name));

D_County=cell(length(Yr),length(Var_Name_Demo));
X_County=cell(length(Yr),length(Var_Name));

VN={'Parental_Trust_in_Medicine','Parental_Trust_in_Science','Trust_in_Medicine','Trust_in_Science','Sex','Race','Political','Education','Economic','Uninsured_19_under','Income'}; 
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
xt(xt==1)=1-10^(-8);
xt(xt==0)=10^(-8);
xt=xt(~isnan(sum(xt,2)),:);
clc;
XT=([log(xt(:,1:end-1)./(1-xt(:,1:end-1))) log(xt(:,end))]);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Income variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
T=[array2table(XT) ];
T.Properties.VariableNames=VN;

writetable(T,['Data_BN.xlsx'],'Sheet','Data');
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Income variable and set baseline conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Economic';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Economic';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Economic','WriteVariableNames',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Income variable and set conditions for Politcal to
% Trust_In_Science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
   A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Economic';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Economic';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Economic_P2S','WriteVariableNames',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Income variable and set conditions for Politcal to
% Trust_In_Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Economic';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Economic';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Economic_P2M','WriteVariableNames',true);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Income variable and set conditions for Politcal to
% Trust_In_Medicine and Trust in Science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
     A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income';'Income'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Economic';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Economic';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Economic_P2MS','WriteVariableNames',true);

 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Economic variable and set baseline conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
     A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Income';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Income';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Income','WriteVariableNames',true);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Economic variable and set conditions for Politcal to
% Trust_In_Science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
     A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Income';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Income';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];
    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Income_P2S','WriteVariableNames',true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Economic variable and set conditions for Politcal to
% Trust_In_Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
     A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Income';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Income';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Income_P2M','WriteVariableNames',true);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Remove Economic variable and set conditions for Politcal to
% Trust_In_Medicine and Trust in Sceince
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    A={'Sex'};
    B={'Race'};
    Method={'NotAToBOrBToA'};
    FailureMode={'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Trust_in_Science';'Trust_in_Medicine';'Trust_in_Science';'Trust_in_Medicine'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    Method={'AToB';'AToB';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T;table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under';'Trust_in_Science';'Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Science'};
    B={'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic';'Economic'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science';'Parental_Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine';'Parental_Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToB';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Income';'Education';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Income';'Education'};
    A={'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Income';'Education'};
    A={'Sex';'Sex';};
    Method={'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';};
    TemporalOrder=cell(length(A),1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    writetable(T,['Data_BN.xlsx'],'Sheet','Con_Income_P2MS','WriteVariableNames',true);
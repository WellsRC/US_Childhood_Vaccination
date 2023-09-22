clear;
clc;

T_State=readtable("Data_Transformed_Combined_State_Level.xlsx");

D_State=T_State.Vaccine_Disease;

T_State=T_State(strcmp(D_State,'MMR'),5:14);

VN={'Economic','Education','Income','Political','Race','Sex','Trust_in_Medicine','Trust_in_Science','Uninsured_19_under'};
VN_O={'COVID'};

    
    A={'Sex';'Race'};
    B={'COVID';'COVID'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException'};
    TemporalOrder=cell(2,1);

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
    writetable(T,['Bayesian_Network.xlsx'],'Sheet','Conditions','WriteVariableNames',true);
    writetable(T_State,['Bayesian_Network.xlsx'],'Sheet','Data','WriteVariableNames',true);
    

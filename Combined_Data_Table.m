clear;
clc;

T=readtable('Data_Transformed_MMR.xlsx');
T=[T;readtable('Data_Transformed_DTaP.xlsx')];
T=[T;readtable('Data_Transformed_Polio.xlsx')];
T=[T;readtable('Data_Transformed_VAR.xlsx')];

T_State=T(T.County_Level==0,[1:2 4:end]);
T_County=T(T.County_Level==1,[1:2 4:end]);

writetable(T_State,['Data_Transformed_Combined_State_Level.xlsx']);
writetable(T_County,['Data_Transformed_Combined_County_Level.xlsx']);
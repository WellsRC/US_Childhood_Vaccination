clear;
clc;
close all;

S=shaperead([pwd '\State_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));
for ii=1:length(State_FIP)
State_FIP(ii)=str2double(State_FIPc{ii});
end
S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);
County_ID_temp={S.GEOID};
County_ID=zeros(size(County_ID_temp));
for ii=1:length(County_ID)
County_ID(ii)=str2double(County_ID_temp{ii});
end

State_FIPc={S.STATEFP};
County_State_FIP=zeros(size(State_FIPc));
for ii=1:length(County_State_FIP)
County_State_FIP(ii)=str2double(State_FIPc{ii});
end

clearvars -except County_ID

S=shaperead([pwd '\State_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_STATEFP={S.STATEFP};
State_ID=zeros(size(State_STATEFP));

for ii=1:length(State_STATEFP)
  State_ID(ii)=str2double(State_STATEFP{ii});  
end
State_ID=unique(State_ID);
clearvars -except State_ID County_ID
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
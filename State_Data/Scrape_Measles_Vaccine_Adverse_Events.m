clear;
clc;

temp_cd=pwd;
temp_cd=temp_cd(1:end-10);
load([temp_cd 'State_FIP_Mapping.mat']);

T=readtable('Vaccine_Adverse_Events_Measles.xlsx');
tf=~strcmp(T.Notes,'Total');
ta= strcmp(T.AgeCode,'0') | strcmp(T.AgeCode,'1') | strcmp(T.AgeCode,'1-2') | strcmp(T.AgeCode,'3-5');
T=T(tf & ta,2:10);

Name_State=unique(T.State_Territory);
FIP_State=zeros(size(Name_State));

Year_Data=[2017:2022];
Adverse_Events_Male=zeros(length(Name_State),length(Year_Data));
Adverse_Events_Female=zeros(length(Name_State),length(Year_Data));

for ss=1:length(Name_State)
    ts=strcmpi(Name_State{ss},State_FIP_Mapping(:,2));
    if(sum(ts)>0)
        FIP_State(ss)=State_FIP_Mapping{ts,1};
    end
    for yy=1:length(Year_Data)
        ty = T.YearReported == Year_Data(yy);
        ts = strcmp(T.State_Territory,Name_State{ss});
        
        tm = strcmp(T.SexCode,'M');
        tf = strcmp(T.SexCode,'F');
        
        Adverse_Events_Male(ss,yy)=sum(T.EventsReported(ty & ts & tm));
        Adverse_Events_Female(ss,yy)=sum(T.EventsReported(ty & ts & tf));
    end
end

save('Adverse_Events_Measles.mat','Name_State','Year_Data','Adverse_Events_Male','Adverse_Events_Female','FIP_State');
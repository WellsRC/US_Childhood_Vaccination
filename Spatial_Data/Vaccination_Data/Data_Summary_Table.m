clear;
clc;

vac_N={'MMR','DTaP','Polio','VAR'};
for vv=1:4
    T=readtable('County_Vaccination_Data.xlsx','Sheet',vac_N{vv});
    State=unique(T.State);
    Year=zeros(length(State),length(2017:2023));
    
    for ss=1:length(State)
        X=table2array(T(strcmp(State{ss},(T.State)),4:end));
        for yy=2017:2022
            count_c=sum(~isnan(X(:,yy-2016)));
            Year(ss,yy-2016)=count_c;
        end
    end
    
    Table_Data=table(State,Year);
    writetable(Table_Data,[vac_N{vv} '_County_Data_Summary.csv']);
end
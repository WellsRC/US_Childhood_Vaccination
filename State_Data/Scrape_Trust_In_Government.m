clear;
clc;

Sheet_Name={'National','Political','Race'};

Year_Data=[2010:2021];

for ii=1:length(Sheet_Name)
    T=readtable([pwd '\Trust_Government.xlsx'],'Sheet',Sheet_Name{ii},'ReadVariableNames', false);

    Year_Table=table2array(T(1,2:end));
    Trust_Data=table2array(T(2:end,2:end));

    Var_Name=table2cell(T(2:end,1));
    if(length(Var_Name)==1)
        z=log(Trust_Data./(1-Trust_Data));
        temp=pchip(Year_Table,z,Year_Data);
        z_new=1./(1+exp(-temp));
        eval(['Trust_in_Government.' Sheet_Name{ii} '=z_new;']);
    else
        for jj=1:length(Var_Name)           
            z=log(Trust_Data(jj,:)./(1-Trust_Data(jj,:)));
            temp=pchip(Year_Table,z,Year_Data);
            z_new=1./(1+exp(-temp));
            eval(['Trust_in_Government.' Sheet_Name{ii} '.' Var_Name{jj} '=z_new;']); 
        end
    end
end

save('Trust_in_Government_Stratification.mat','Trust_in_Government');
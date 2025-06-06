clear;
clc;

V_MMR=readtable([pwd '\Vaccination_Data\County_Vaccination_Data.xlsx'],'Sheet','MMR');
V_DTaP=readtable([pwd '\Vaccination_Data\County_Vaccination_Data.xlsx'],'Sheet','DTaP');
V_Polio=readtable([pwd '\Vaccination_Data\County_Vaccination_Data.xlsx'],'Sheet','Polio');
V_VAR=readtable([pwd '\Vaccination_Data\County_Vaccination_Data.xlsx'],'Sheet','VAR');

for yy=2017:2023
    T=readtable('County_Data.xlsx','Sheet',['Year_' num2str(yy)]);
    
    for jj=1:height(T)
        tf=str2double(T.GEOID(jj))==V_MMR.CountyFIPS;
        if(sum(tf)>0)
            T.MMR(jj)=table2array(V_MMR(tf,4+(yy-2017)));
        end

        tf=str2double(T.GEOID(jj))==V_DTaP.CountyFIPS;
        if(sum(tf)>0)
            T.DTaP(jj)=table2array(V_DTaP(tf,4+(yy-2017)));
        end

        tf=str2double(T.GEOID(jj))==V_Polio.CountyFIPS;
        if(sum(tf)>0)
            T.POLIO(jj)=table2array(V_Polio(tf,4+(yy-2017)));
        end

        tf=str2double(T.GEOID(jj))==V_VAR.CountyFIPS;
        if(sum(tf)>0)
            T.VAR(jj)=table2array(V_VAR(tf,4+(yy-2017)));
        end
    end
    T=sortrows(T,[1 2]);
    writetable(T,'County_Data.xlsx','Sheet',['Year_' num2str(yy)]);
end
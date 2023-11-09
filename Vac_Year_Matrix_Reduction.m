S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_ID_temp={S.STATEFP};
State_ID=zeros(size(State_ID_temp));

for ii=1:length(State_ID)
  State_ID(ii)=str2double(State_ID_temp{ii});  
end
State_ID=unique(State_ID);
clearvars -except State_ID 
Yr=[2017:2021];
Inqv={'MMR','DTaP','Polio','VAR'};




for dd=1:length(Inqv)
    V=zeros(length(State_ID),length(Yr));
    Inq=Inqv{dd};
    Diff_V=zeros(length(Yr));
    p_V=zeros(length(Yr));
    for yy=1:length(Yr)
        V(:,yy)=State_Immunization_Statistics(Inq,Yr(yy),State_ID);  
    end
%     V=log(V./(1-V));
    for yy=1:length(Yr)
        for zz=1:length(Yr)
            temp=V(:,yy)-V(:,zz);
            Diff_V(yy,zz)=median(temp(~isnan(temp)));
            if(median(temp(~isnan(temp)))>=0)
                [p_V(yy,zz)]=signrank(V(:,yy),V(:,zz),'tail','right');
            else
                [p_V(yy,zz)]=signrank(V(:,yy),V(:,zz),'tail','left');
            end
        end
    end

    C=cell(size(Diff_V));
    Yr_Comp=Yr';
    for yy=1:length(Yr)
        for zz=1:length(Yr)
            if(yy==zz)
                C{yy,zz}='Reference';
            else
                if(p_V(yy,zz)>=0.001)
                    C{yy,zz}=[num2str(100.*Diff_V(yy,zz),'%4.2f%%') '(p = ' num2str(p_V(yy,zz),'%5.4f') ')'];
                else
                    C{yy,zz}=[num2str(100.*Diff_V(yy,zz),'%4.2f%%') '(p < 0.001)'];
                end
            end
        end
    end
T=[table(Yr_Comp) cell2table(C)];
T.Properties.VariableNames={'Year Compared','Baseline 2017','Baseline 2018','Baseline 2019','Baseline 2020','Baseline 2021'};
writetable(T,'Year_Comparison_Uptake.xlsx','Sheet',Inqv{dd})

end
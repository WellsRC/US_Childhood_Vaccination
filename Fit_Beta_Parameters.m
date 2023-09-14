
clear;
clc;
S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
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

clearvars -except County_ID
Yr=[2017:2021];
County_Inc=cell(length(Yr),1);
P_E=cell(length(Yr),1);
Var_Name={'Trust_in_Medicine','Trust_in_Science','Vaccine_Adverse_Events'};
X=cell(length(Yr),length(Var_Name));
Xv=cell(length(Yr),length(Var_Name));

Var_Name_Demo={'Parental_Age','Under_5_Age','Sex','Race','Political','Education','Economic','Household_Children_under_18','Uninsured_19_under','Income'};
D=cell(length(Yr),length(Var_Name_Demo));
Dv=cell(length(Yr),length(Var_Name_Demo));

COVID=cell(length(Yr),1);
COVIDv=cell(length(Yr),1);

VN={'Trust_in_Medicine','Trust_in_Science','Vaccine_Adverse_Events','Parental_Age','Under_5_Age','Sex','Race','Political','Education','Economic','Household_Children_under_18','Uninsured_19_under','Income'};


Inq={'Medical_Exemption','Non_Medical_Exemption','DTaP','Polio','MMR'};
kfv=5;


for SS=1:length(Inq)
    for yy=1:length(Yr)
        if(~strcmp('Non_Medical_Exemption',Inq{SS}))
            temp=County_Immunization_Statistics(Inq{SS},Yr(yy),County_ID);
        else
            temp=County_Immunization_Statistics('Philosophical_Exemption',Yr(yy),County_ID);
            temp=temp+County_Immunization_Statistics('Religious_Exemption',Yr(yy),County_ID);
        end
        County_ID_temp=County_ID(~isnan(temp));
        County_ID_val=County_ID(isnan(temp));
        P_E{yy}=temp(~isnan(temp));
        for jj=1:length(Var_Name)
            X{yy,jj}=Return_County_Data(Var_Name{jj},Yr(yy),County_ID_temp);
            Xv{yy,jj}=Return_County_Data(Var_Name{jj},Yr(yy),County_ID_val);
        end

        for jj=1:length(Var_Name_Demo)
            [County_Demo,Data_Year]=Demographics_County(Var_Name_Demo{jj},County_ID_temp);
            D{yy,jj}=County_Demo(:,Data_Year==Yr(yy));
            [County_Demo,Data_Year]=Demographics_County(Var_Name_Demo{jj},County_ID_val);
            Dv{yy,jj}=County_Demo(:,Data_Year==Yr(yy));
        end
        if(Yr(yy)>=2020)
            COVID{yy}=ones(size(temp(~isnan(temp))));
            COVIDv{yy}=ones(size(temp(isnan(temp))));
        else
            COVID{yy}=zeros(size(temp(~isnan(temp))));
            COVIDv{yy}=zeros(size(temp(isnan(temp))));
        end
    end

    y_t=cell2mat(P_E);
    xt=[cell2mat(X) cell2mat(D) cell2mat(COVID)];
    xv=[cell2mat(Xv) cell2mat(Dv) cell2mat(COVIDv)];
    y_t=y_t(~isnan(sum(xt,2)));
    xt=xt(~isnan(sum(xt,2)),:);
    xt=xt(y_t>0 & y_t<1,:);
    y_t=y_t(y_t>0 & y_t<1);
   
    xv=xv(~isnan(sum(xv,2)),:);
    clc;

    N_Val=round(length(y_t)./kfv);
    IndX=[1:length(y_t)];
    Indx_train=cell(kfv,1);
    Indx_val=cell(kfv,1);
    for jj=1:kfv
        if(jj<kfv)
            Indx_val{jj}=N_Val.*(jj-1)+[1:N_Val];
            Indx_train{jj}=IndX(~ismember(IndX,N_Val.*(jj-1)+[1:N_Val]));
        else            
            Indx_val{jj}=[N_Val.*(jj-1):length(y_t)];
            Indx_train{jj}=IndX(~ismember(IndX,[N_Val.*(jj-1):length(y_t)]));
        end
    end

    x_V=[log(xt(:,1:2)./(1-xt(:,1:2))) log(xt(:,3)) log(xt(:,4:12)./(1-xt(:,4:12))) log(xt(:,13)) xt(:,14)];
    options = optimoptions('ga','PlotFcn', @gaplotbestf,'MaxGenerations',50000,'UseParallel',true);


    [reg_par,fval]=ga(@(x)Obj_Beta_Parameters(x,y_t,x_V),16,[],[],[],[],[-1000.*ones(1,15) -3],[1000.*ones(1,15) 3],[],[],options);
    

    save(['Regression_Beta_' Inq{SS} '.mat'],'reg_par','fval')
end


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


Inq={'Medical_Exemption','Religious_Exemption','Philosophical_Exemption','Religious_and_Philosophical_Exemption','All_immunizations','DTaP','Polio','MMR'};
kfv=5;


for SS=1:length(Inq)
    for yy=1:length(Yr)
        if(~strcmp('Religious_and_Philosophical_Exemption',Inq{SS}))
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

    Y=cell2mat(P_E);
    xt=[cell2mat(X) cell2mat(D) cell2mat(COVID)];
    xv=[cell2mat(Xv) cell2mat(Dv) cell2mat(COVIDv)];
    Y=Y(~isnan(sum(xt,2)));
    xt=xt(~isnan(sum(xt,2)),:);
    xt=xt(Y>0 & Y<1,:);
    Y=Y(Y>0 & Y<1);
   
    xv=xv(~isnan(sum(xv,2)),:);
    clc;

    Z=log(Y./(1-Y));
    N_Val=round(length(Z)./kfv);
    IndX=[1:length(Z)];
    Indx_train=cell(kfv,1);
    Indx_val=cell(kfv,1);
    for jj=1:kfv
        if(jj<kfv)
            Indx_val{jj}=N_Val.*(jj-1)+[1:N_Val];
            Indx_train{jj}=IndX(~ismember(IndX,N_Val.*(jj-1)+[1:N_Val]));
        else            
            Indx_val{jj}=[N_Val.*(jj-1):length(Z)];
            Indx_train{jj}=IndX(~ismember(IndX,[N_Val.*(jj-1):length(Z)]));
        end
    end

    Cov_INDX= xt(:,14);
    XT=([log(xt(:,1:2)./(1-xt(:,1:2))) log(xt(:,3)) log(xt(:,4:12)./(1-xt(:,4:12))) log(xt(:,13))]);
    XV=([log(xv(:,1:2)./(1-xv(:,1:2))) log(xv(:,3)) log(xv(:,4:12)./(1-xv(:,4:12))) log(xv(:,13))]);
    Cov_V= xv(:,14);
    options = optimoptions('ga','PlotFcn', @gaplotbestf);
    F_INC=ga(@(x)Model_Select_Obj(x,Z,XT,Cov_INDX,Indx_train,Indx_val,kfv),13,[],[],[],[],zeros(1,13),ones(1,13),[],1:13,options);
    XVtemp=XV(:,F_INC==1);
    Xtemp=XT(:,F_INC==1);
    Xtemp=[Z Xtemp];

    M_pre=mean(Xtemp(Cov_INDX==0,:),1);
    CVM_pre=cov(Xtemp(Cov_INDX==0,:),1);
    
    M_pan=mean(Xtemp(Cov_INDX==1,:),1);
    CVM_pan=cov(Xtemp(Cov_INDX==1,:),1);

    save(['Distribution_' Inq{SS} '.mat'],'F_INC','VN','M_pre','CVM_pre','CVM_pan','M_pan')
end
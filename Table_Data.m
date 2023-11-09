clear;
clc;
close all;

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

State_FIPc={S.STATEFP};
County_State_FIP=zeros(size(State_FIPc));
for ii=1:length(County_State_FIP)
County_State_FIP(ii)=str2double(State_FIPc{ii});
end

clearvars -except County_ID County_State_FIP

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
clearvars -except State_ID County_ID County_State_FIP
Yr=[2017:2021];

Var_Name={'Trust_in_Medicine','Trust_in_Science'};

Var_Name_Demo={'Sex','Race','Political','Education','Economic','Uninsured_19_under','Income'};


D_State=cell(length(Yr),length(Var_Name_Demo));
X_State=cell(length(Yr),length(Var_Name));
VL_State=cell(length(Yr),2);
P_E_State=cell(length(Yr),1);
ID_State_v=cell(length(Yr),1);
COVID_State=cell(length(Yr),1);
Yr_State=cell(length(Yr),1);

D_County=cell(length(Yr),length(Var_Name_Demo));
X_County=cell(length(Yr),length(Var_Name));
P_E_County=cell(length(Yr),1);
ID_County_v=cell(length(Yr),1);
COVID_County=cell(length(Yr),1);
Yr_County=cell(length(Yr),1);
VL_County=cell(length(Yr),2);


N_Samp=50;
Rand_Indx=randi(1000,N_Samp,1);
Rand_Trust_S=randi(1000,N_Samp,2);
Rand_Trust_M=randi(1000,N_Samp,2);
Inqv={'MMR','DTaP','Polio','VAR'};%
VN={'Vaccine_Disease','ID','County_Level','Year','Vaccine_Uptake','Trust_in_Medicine','Trust_in_Science','Sex','Race','Political','Education','Economic','Uninsured_19_under','Income','COVID','State_Religous_Exemptions','State_Philosophical_Exemptions'};
for kk=1:4  
    for ss=1:N_Samp
        Inq=Inqv{kk};

        YrData_Table=[];
        for yy=1:length(Yr)
            temp=State_Immunization_Statistics(Inq,Yr(yy),State_ID);    
            [RVE,PVE] = Exemption_Timeline(Yr(yy),State_ID);
            State_ID_temp=State_ID(~isnan(temp));
            ID_State_v{yy}=State_ID_temp(:);
            P_E_State{yy}=temp(~isnan(temp));
        
            VL_State{yy,1}=RVE(~isnan(temp));
            VL_State{yy,2}=PVE(~isnan(temp));
            for jj=1:length(Var_Name)
                X_State{yy,jj}=Return_State_Data(Var_Name{jj},Yr(yy),State_ID_temp,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));
            end
        
            for jj=1:length(Var_Name_Demo)
                [State_Demo,Data_Year]=Demographics_State(Var_Name_Demo{jj},State_ID_temp,Rand_Indx(ss));
                D_State{yy,jj}=State_Demo(:,Data_Year==Yr(yy));
            end
            if(Yr(yy)>=2020)
                COVID_State{yy}=ones(size(temp(~isnan(temp))));
            else
                COVID_State{yy}=zeros(size(temp(~isnan(temp))));
            end
            
            Yr_State{yy}=Yr(yy).*ones(size(temp(~isnan(temp))));
        
            [RVE,PVE] = Exemption_Timeline(Yr(yy),County_State_FIP);
        
            temp=County_Immunization_Statistics(Inq,Yr(yy),County_ID);
        
            County_ID_temp=County_ID(~isnan(temp));
            ID_County_v{yy}=County_ID_temp(:);
            P_E_County{yy}=temp(~isnan(temp));
        
        
            VL_County{yy,1}=RVE(~isnan(temp));
            VL_County{yy,2}=PVE(~isnan(temp));
        
            for jj=1:length(Var_Name)
                X_County{yy,jj}=Return_County_Data(Var_Name{jj},Yr(yy),County_ID_temp,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));
            end
        
            for jj=1:length(Var_Name_Demo)
                [County_Demo,Data_Year]=Demographics_County(Var_Name_Demo{jj},County_ID_temp,Rand_Indx(ss));
                D_County{yy,jj}=County_Demo(:,Data_Year==Yr(yy));
            end
            if(Yr(yy)>=2020)
                COVID_County{yy}=ones(size(temp(~isnan(temp))));
            else
                COVID_County{yy}=zeros(size(temp(~isnan(temp))));
            end

            Yr_County{yy}=Yr(yy).*ones(size(temp(~isnan(temp))));
        end
        
        ID=[cell2mat(ID_State_v);cell2mat(ID_County_v)];
        Y=[cell2mat(P_E_State);cell2mat(P_E_County)];
        Pt=[zeros(size(cell2mat(P_E_State)));ones(size(cell2mat(P_E_County)))];
        xt=[cell2mat(X_State) cell2mat(D_State) cell2mat(COVID_State) cell2mat(VL_State);cell2mat(X_County) cell2mat(D_County) cell2mat(COVID_County) cell2mat(VL_County)];

        YrData_Table=[cell2mat(Yr_State);cell2mat(Yr_County)];
        YrData_Table=YrData_Table(~isnan(sum(xt,2)));
        Pt=Pt(~isnan(sum(xt,2)));
        ID=ID(~isnan(sum(xt,2)));
        Y=Y(~isnan(sum(xt,2)));
        xt=xt(~isnan(sum(xt,2)),:);
        Y(Y==1)=1-10^(-8);
        Y(Y==0)=10^(-8);
    %     xt=xt(Y>0 & Y<1 ,:);
    %     Y=Y(Y>0 & Y<1);
        Vac_Dis=cell(size(Y));
        Vac_Dis(:)=Inqv(kk);
        clc;
        Z=log(Y./(1-Y));
        XT=([ID Pt YrData_Table Z log(xt(:,1:8)./(1-xt(:,1:8))) log(xt(:,9)) xt(:,10:12)]);  
        T=[table(Vac_Dis) array2table(XT)];
        T.Properties.VariableNames=VN;
        if(ss==1)
            writetable(T,['Data_Transformed_' Inq '.xlsx'],'Sheet',Inq);
        else
            writetable(T,['Data_Transformed_' Inq '.xlsx'],'Sheet',Inq,'WriteVariableNames',false,'WriteMode','append');
        end
        
    end
end

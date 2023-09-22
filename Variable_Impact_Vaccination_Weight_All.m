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

rng(2023921)

W=readtable('Supplement_Table_Model_Comparison.xlsx','Sheet','Table_All');
W=table2array(W(:,20));
N_Samp=30;
Rand_Indx=randi(1000,N_Samp,1);
Rand_Trust_S=randi(1000,N_Samp,2);
Rand_Trust_M=randi(1000,N_Samp,2);
X_County=zeros(N_Samp,length(County_ID),size(W,2));

% Intercept
X_County(:,:,1)=1;

Inqv={'MMR','DTaP','Polio','VAR'};

Vac_up=NaN.*zeros(length(County_ID),length(Inqv));
Yr=2021;
% COVID
if(Yr>=2020)
    X_County(:,:,2)=1;
end

[RE,PE] = Exemption_Timeline(Yr,County_State_FIP);
X_County(:,:,3)=repmat(PE',N_Samp,1);
X_County(:,:,4)=repmat(RE',N_Samp,1);


State_FIP=unique(County_State_FIP);
Vac_up_State=NaN.*zeros(length(State_FIP),4);
for kk=1:4
    Vac_up_State(:,kk)=State_Immunization_Statistics(Inqv{kk},Yr,State_FIP);
end
for kk=1:4
    Vac_up(:,kk)=County_Immunization_Statistics(Inqv{kk},Yr,County_ID);
end
Var_Name={'Economic','Education','Income','Political','Race','Sex','Trust_in_Medicine','Trust_in_Science','Uninsured_19_under'};

for ss=1:N_Samp       
    for jj=1:length(Var_Name)
        if(strcmp(Var_Name{jj},'Trust_in_Medicine') || strcmp(Var_Name{jj},'Trust_in_Science'))
            x_temp=Return_County_Data(Var_Name{jj},Yr,County_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));
            z_temp=log(x_temp./(1-x_temp));
            X_County(ss,:,jj+4)=z_temp;
        elseif(strcmp(Var_Name{jj},'Income'))
            [County_Demo,Data_Year]=Demographics_County(Var_Name{jj},County_ID,Rand_Indx(ss));
            x_temp=County_Demo(:,Data_Year==Yr);
            z_temp=log(x_temp);
            X_County(ss,:,jj+4)=z_temp;
        else
            [County_Demo,Data_Year]=Demographics_County(Var_Name{jj},County_ID,Rand_Indx(ss));
            x_temp=County_Demo(:,Data_Year==Yr);
            z_temp=log(x_temp./(1-x_temp));
            X_County(ss,:,jj+4)=z_temp;
        end
    end
end

X_County=mean(X_County,1);
X_County=squeeze(real(X_County));
m=1./(1+exp(-X_County(:,11)));
s=1./(1+exp(-X_County(:,12)));
u=1./(1+exp(-X_County(:,13)));
beta_m_to_s=0.1783613435454238; % obtained from bayesian network analysis

load([pwd '\State_Data\County_Data\County_Population_' num2str(randi(1000)) '.mat']);
Data_CID=Population.County_ID_Numeric;
Data_Year=Population.Year_Data;
PS=Population.Sex;
P_tot=PS.Male(:,Yr==Data_Year)+PS.Female(:,Yr==Data_Year);

clear Data_Year PS 
for kk=1:4
    Vac_v=zeros(size(W,1),length(County_ID));
    dvdm_v=zeros(size(W,1),length(County_ID));
    dvds_v=zeros(size(W,1),length(County_ID));
    dvdu_v=zeros(size(W,1),length(County_ID));
    
    beta_v=readtable('County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{kk} ]);
    for ii=1:height(beta_v)
        v=Vac_up(:,kk);
        tc_nan=~isnan(v);
        beta_j=table2array(beta_v(ii,:))';
        y_pred=X_County*(beta_j);
        v_t=v;
        v_t(v==1)=1-10^(-8);
        v_t(v==0)=10^(-8);
        y_temp=log(v_t./(1-v_t));


        for ff=1:length(State_FIP)
            t_fs=State_FIP(ff)==County_State_FIP;
            w_temp=zeros(sum(t_fs),1);
            c_temp=County_ID(t_fs);
            for cc=1:length(w_temp)
                w_temp(cc)=P_tot(c_temp(cc)==Data_CID);
            end
            % Estimate error for vac coverage
            
            w_temp=w_temp./sum(w_temp);
            state_v_temp=log(Vac_up_State(ff,kk)./(1-Vac_up_State(ff,kk)));

            err_func=@(eps_r)state_v_temp-log(((1./(1+exp(-(y_pred(t_fs)'+eps_r))))*w_temp)./(1-((1./(1+exp(-(y_pred(t_fs)'+eps_r))))*w_temp)));

            x0=err_func(0);
            
            % Calc error for state
            if(~isnan(x0))
                err_s=fmincon(@(eps_r)(err_func(eps_r)).^2,x0);
                y_pred(t_fs)=y_pred(t_fs)+err_s;
            end
        end
        
        beta_m=beta_j(11);
        beta_s=beta_j(12);
        beta_u=beta_j(13);

        z_temp=1./(1+exp(-y_pred));
        
        v(~tc_nan)=z_temp(~tc_nan);
         

        Vac_v(ii,:)=v;
        if(beta_m^2+beta_s^2>0)
            dvdm_v(ii,:) = Trust_Medicine_Influence_Uptake(v,m,beta_m,beta_m_to_s,beta_s);
        end
        if(beta_s~=0)
            dvds_v(ii,:) = Trust_Science_Influence_Uptake(v,s,beta_s);
        end
        if(beta_u~=0)
            dvdu_v(ii,:) = Trust_Science_Influence_Uptake(v,u,beta_u);
        end
    end

    dvdm=(W')*dvdm_v;
    dvds=(W')*dvds_v;
    dvdu=(W')*dvdu_v;
    vac_d=(W')*Vac_v;
    save(['Impact_Trust_Medicine_Science_on_Uptake_' Inqv{kk} '_' num2str(Yr) '_Overall_Weight.mat'],'dvds','dvdm','dvdu','vac_d');
end
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

State_FIPc={S.STATEFP};
County_State_FIP=zeros(size(State_FIPc));
for ii=1:length(County_State_FIP)
County_State_FIP(ii)=str2double(State_FIPc{ii});
end

clearvars -except County_ID County_State_FIP

rng(2023921)

W=readtable('Supplement_Table_Model_Comparison.xlsx','Sheet','Table_All');
W=table2array(W(:,16:19));
N_Samp=30;
Rand_Indx=randi(1000,N_Samp,1);
Rand_Trust_S=randi(1000,N_Samp,2);
Rand_Trust_M=randi(1000,N_Samp,2);
X_County=zeros(N_Samp,length(County_ID),size(W,2));

% Intercept
X_County(:,:,1)=1;

Inqv={'MMR','DTaP','Polio','VAR'};

Yr=2021;
% COVID
if(Yr>=2020)
    X_County(:,:,2)=1;
end

[RE,PE] = Exemption_Timeline(Yr,County_State_FIP);
X_County(:,:,3)=repmat(PE',N_Samp,1);
X_County(:,:,4)=repmat(RE',N_Samp,1);


Vac_up=NaN.*zeros(length(County_ID),length(Inqv));
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


vac_vt=linspace(10^(-8),0.99-10^(-8),201);
dx=zeros(1,201);
for jj=1:201
    z=log(vac_vt(jj)/(1-vac_vt(jj)));
    if(jj>1)
        dx(jj)=lsqnonlin(@(x)(1./(1+exp(-(z+x)))-(vac_vt(jj)+0.01)),dx(jj-1),0,25);
    else
        
        dx(jj)=lsqnonlin(@(x)(1./(1+exp(-(z+x)))-(vac_vt(jj)+0.01)),14,0,25);
    end
end

vac95_t=linspace(10^(-8),0.95-10^(-8),201);
dx_95=zeros(1,201);
for jj=1:201
    z=log(vac95_t(jj)/(1-vac95_t(jj)));
    if(jj>1)
        dx_95(jj)=lsqnonlin(@(x)(1./(1+exp(-(z+x)))-(0.95)),dx_95(jj-1),0,25);
    else
        
        dx_95(jj)=lsqnonlin(@(x)(1./(1+exp(-(z+x)))-(0.95)),21.5,0,25);
    end
end


load([pwd '\State_Data\County_Data\County_Population_' num2str(randi(1000)) '.mat']);
Data_CID=Population.County_ID_Numeric;
Data_Year=Population.Year_Data;
PS=Population.Sex;
P_tot=PS.Male(:,Yr==Data_Year)+PS.Female(:,Yr==Data_Year);

clear Data_Year PS 

for kk=1:4
    Vac_v=zeros(size(W,1),length(County_ID));
    dm_v=NaN.*zeros(size(W,1),length(County_ID));
    ds_v=NaN.*zeros(size(W,1),length(County_ID));
    du_v=NaN.*zeros(size(W,1),length(County_ID));

    dm95_v=NaN.*zeros(size(W,1),length(County_ID));
    ds95_v=NaN.*zeros(size(W,1),length(County_ID));
    du95_v=NaN.*zeros(size(W,1),length(County_ID));

    beta_m=NaN.*zeros(size(W,1),1);
    beta_s=NaN.*zeros(size(W,1),1);
    beta_u=NaN.*zeros(size(W,1),1);
    
    beta_v=readtable('County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{kk} ]);
    for ii=1:height(beta_v)

        vt=Vac_up(:,kk);
        tc_nan=~isnan(vt);
        beta_j=table2array(beta_v(ii,:))';
        y_pred=X_County*(beta_j);

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
        
        v=1./(1+exp(-y_pred));
        v(~isnan(vt))=vt(~isnan(vt));
        Vac_v(ii,:)=v;
        dx_t=pchip(vac_vt,dx,v);

        dx95_t=pchip(vac95_t,dx_95,v);
        dx95_t(v>=0.95)=0;

        if(beta_j(11)~=0)
            beta_m(ii)=beta_j(11);
            temp_dX=dx_t./beta_m(ii);
            temp_X=X_County(:,11)+temp_dX;
            dm_v(ii,:)=1./(1+exp(-temp_X))-m;

            temp_dX=dx95_t./beta_m(ii);
            temp_X=X_County(:,11)+temp_dX;
            dm95_v(ii,:)=1./(1+exp(-temp_X))-m;
        end

        if(beta_j(12)~=0)
            beta_s(ii)=beta_j(12);
            temp_dX=dx_t./beta_s(ii);
            temp_X=X_County(:,12)+temp_dX;
            ds_v(ii,:)=1./(1+exp(-temp_X))-s;

            temp_dX=dx95_t./beta_s(ii);
            temp_X=X_County(:,12)+temp_dX;
            ds95_v(ii,:)=1./(1+exp(-temp_X))-s;
        end

        if(beta_j(11)~=0)
            beta_u(ii)=beta_j(13);
            temp_dX=dx_t./beta_u(ii);
            temp_X=X_County(:,13)+temp_dX;
            du_v(ii,:)=1./(1+exp(-temp_X))-u;

            temp_dX=dx95_t./beta_u(ii);
            temp_X=X_County(:,13)+temp_dX;
            du95_v(ii,:)=1./(1+exp(-temp_X))-u;
        end
    end

    wt=W(~isnan(beta_m),kk)';
    wt=wt./sum(wt);
    dm=wt*dm_v(~isnan(beta_m),:);
    dm95=wt*dm95_v(~isnan(beta_m),:);

    wt=W(~isnan(beta_s),kk)';
    wt=wt./sum(wt);
    ds=wt*ds_v(~isnan(beta_s),:);
    ds95=wt*ds95_v(~isnan(beta_s),:);

    wt=W(~isnan(beta_u),kk)';
    wt=wt./sum(wt);
    du=wt*du_v(~isnan(beta_u),:);
    du95=wt*du95_v(~isnan(beta_u),:);
    
    wt=W(:,kk)';
    vac_d=wt*Vac_v;
    save(['Increase_in_Covariate_Required_for_' Inqv{kk} '_' num2str(Yr) '.mat'],'du95','dm95','ds95','du','dm','ds','vac_d');
end
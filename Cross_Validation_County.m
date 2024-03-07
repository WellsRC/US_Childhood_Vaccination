clear;
clc;

% Estimtes the coefficients for the logistic regression model at th estate
% level and then computes the cross-validation at the county level

T_County=readtable("Data_Transformed_Combined_County_Level.xlsx");
T_State=readtable("Data_Transformed_Combined_State_Level.xlsx");



X_State=[T_State.Economic T_State.Education T_State.Income T_State.Political T_State.Race T_State.Trust_in_Medicine T_State.Trust_in_Science T_State.Uninsured_19_under];
X_County=[T_County.Economic T_County.Education T_County.Income T_County.Political T_County.Race T_County.Trust_in_Medicine T_County.Trust_in_Science T_County.Uninsured_19_under];

Y_State=T_State.Vaccine_Uptake;
Y_County=T_County.Vaccine_Uptake;

D_State=T_State.Vaccine_Disease;
D_County=T_County.Vaccine_Disease;

RE_State=T_State.State_Religous_Exemptions;
RE_County=T_County.State_Religous_Exemptions;

PE_State=T_State.State_Philosophical_Exemptions;
PE_County=T_County.State_Philosophical_Exemptions;

COVID_State=T_State.COVID;
COVID_County=T_County.COVID;

T_State_Trim=T_State(:,[1 5:14]);
clear T_County T_State

num_model=2^size(X_State,2);

X_indx=zeros(num_model-1,size(X_State,2));

Cross_Validation_Likelihood=zeros(2.*(num_model-1),5);
Log_Likelihood_M=zeros(2.*(num_model-1),5);
Num_Parameters_M=zeros(2.*(num_model-1),5);
Num_Data_Pts=zeros(2.*(num_model-1),5);
Pandemic_Directly_Impact_Vaccination=cell(2.*(num_model-1),1);
Inqv={'MMR','DTaP','Polio','VAR'};

beta_v=zeros(length(Inqv),2.*(num_model-1),size(X_indx,2)+4);
lb=-300.*ones(1,13);
lb(11:12)=0;
ub=300.*ones(1,13);
ub(3:4)=0;
for jj=1:4
    t_state=strcmp(Inqv{jj},D_State);
    t_county=strcmp(Inqv{jj},D_County);
    
    Num_Data_Pts(:,jj)=sum(t_state);
    for nn=1:num_model-1
        temp_array=flip(decimalToBinaryVector(nn));
        Pandemic_Directly_Impact_Vaccination{nn}='Yes';
        Pandemic_Directly_Impact_Vaccination{nn+(num_model-1)}='No';
        X_indx(nn,1:length(temp_array))=temp_array;

        
        t_covid=double(COVID_State(t_state)==1);
        tc_covid=double(COVID_County(t_county)==1);

        t_PE=double(PE_State(t_state)==1);
        tc_PE=double(PE_County(t_county)==1);

        t_RE=double(RE_State(t_state)==1);
        tc_RE=double(RE_County(t_county)==1);  

        X_temp=X_State(t_state,:);
        X_temp=[t_covid t_PE t_RE X_temp(:,X_indx(nn,:)==1)];
        Y_temp=Y_State(t_state);
        lb_t=lb([1 1 1 1 X_indx(nn,:)]==1);
        ub_t=ub([1 1 1 1 X_indx(nn,:)]==1);
        est_par=zeros(30,length(lb_t));
        nc_est_par=zeros(30,length(lb_t)-1);
        fv=zeros(30,1);
        nc_fv=zeros(30,1);
        for ii=1:30
            [est_par(ii,:),fv(ii)]=lsqnonlin(@(x)(x(1)+X_temp*(x(2:end)')-Y_temp),lb_t+(ub_t-lb_t).*rand(size(lb_t)),lb_t,ub_t);
            [nc_est_par(ii,:),nc_fv(ii)]=lsqnonlin(@(x)(x(1)+X_temp(:,[1 3:end])*(x(2:end)')-Y_temp),lb_t(:,[1 3:end])+(ub_t(:,[1 3:end])-lb_t(:,[1 3:end])).*rand(size(lb_t(:,[1 3:end]))),lb_t(:,[1 3:end]),ub_t(:,[1 3:end]));
        end
        sigma_s=sqrt(min(fv)./length(Y_temp));
        p_c=est_par(fv==min(fv),:);
        p_c=p_c(1,:);
        res=(p_c(1)+X_temp*(p_c(2:end)')-Y_temp);
        beta_v(jj,nn,[1 1 1 1 X_indx(nn,:)]==1)=p_c;
        Log_Likelihood_M(nn,jj)=sum(log(normpdf(res,0,sigma_s)));

        sigma_s=sqrt(min(nc_fv)./length(Y_temp));
        p_nc=nc_est_par(nc_fv==min(nc_fv),:);
        p_nc=p_nc(1,:);
        res=(p_nc(1)+X_temp(:,[1 3:end])*(p_nc(2:end)')-Y_temp);
        beta_v(jj,nn+(num_model-1),[1 0 1 1 X_indx(nn,:)]==1)=p_nc;
        Log_Likelihood_M(nn+(num_model-1),jj)=sum(log(normpdf(res,0,sigma_s)));

        Y_temp=Y_County(t_county);
        X_temp=X_County(t_county,:);
        X_temp=[tc_covid tc_PE tc_RE X_temp(:,X_indx(nn,:)==1)];
        
        y_pred=p_c(1)+X_temp*(p_c(2:end)');
        sigma_s=sqrt(sum((y_pred(:)-Y_temp(:)).^2)./sum(t_county));
        err_term=sum(log(normpdf(y_pred(:)-Y_temp(:),0,sigma_s)));
        Cross_Validation_Likelihood(nn,jj)=err_term;

        y_pred=p_nc(1)+X_temp(:,[1 3:end])*(p_nc(2:end)');
        sigma_s=sqrt(sum((y_pred(:)-Y_temp(:)).^2)./sum(t_county));
        err_term=sum(log(normpdf(y_pred(:)-Y_temp(:),0,sigma_s)));
        Cross_Validation_Likelihood(nn+(num_model-1),jj)=err_term;

        Num_Parameters_M(nn,jj)=length(p_c);
        Num_Parameters_M(nn+(num_model-1),jj)=length(p_nc);

    end
end

Cross_Validation_Likelihood(:,5)=sum(Cross_Validation_Likelihood(:,1:4),2);
Num_Data_Pts(:,5)=sum(Num_Data_Pts(:,1:4),2);
Log_Likelihood_M(:,5)=sum(Log_Likelihood_M(:,1:4),2);
Num_Parameters_M(:,5)=sum(Num_Parameters_M(:,1:4),2);

[AIC_m]=aicbic(Log_Likelihood_M(:),Num_Parameters_M(:));

AIC_m=reshape(AIC_m,size(Log_Likelihood_M));
Scaled_CVE=(repmat(max(Cross_Validation_Likelihood),size(Cross_Validation_Likelihood,1),1)-Cross_Validation_Likelihood)./(repmat(max(Cross_Validation_Likelihood),size(Cross_Validation_Likelihood,1),1)-repmat(min(Cross_Validation_Likelihood),size(Cross_Validation_Likelihood,1),1));

Scaled_AIC=(AIC_m-repmat(min(AIC_m),size(AIC_m,1),1))./(repmat(max(AIC_m),size(AIC_m,1),1)-repmat(min(AIC_m),size(AIC_m,1),1));

distance_M=sqrt(Scaled_CVE.^2+Scaled_AIC.^2);

X_indx=[X_indx;X_indx];

Variables={'Pandemic Directly Impact Vaccination','Economic','Education','Income','Politcal','Race','Sex','Trust in Medicine','Trust in Science','Uninsured under 19','Cross validation (MMR)','Cross validation (DTaP)','Cross validation (IPV)','Cross validation (VAR)','Cross validation (Total)','log-likelihood (MMR)','log-likelihood (DTaP)','log-likelihood (IPV)','log-likelihood (VAR)','log-likelihood (Total)','AIC (MMR)','AIC (DTaP)','AIC (IPV)','AIC (VAR)','AIC (Total)','Scaled distance (MMR)','Scaled distance (DTaP)','Scaled distance (IPV)','Scaled distance (VAR)','Scaled distance (Total)'};
T=[table(Pandemic_Directly_Impact_Vaccination) array2table(X_indx) array2table(Cross_Validation_Likelihood) array2table(Log_Likelihood_M) array2table(AIC_m) array2table(distance_M)];

T.Properties.VariableNames=Variables;

writetable(T,'County_Level_Cross_Validation.xlsx','Sheet','Indicator');

Variables={'Intercept','Pandemic Directly Impact Vaccination','Philosophical Exemptions','Religous Exemptions','Economic','Education','Income','Politcal','Race','Sex','Trust in Medicine','Trust in Science','Uninsured under 19'};
for vv=1:length(Inqv)
    T=array2table(squeeze(beta_v(jj,:,:)));
    T.Properties.VariableNames=Variables;
    writetable(T,'County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
end


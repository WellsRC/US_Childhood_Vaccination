clear;
clc;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Obtain County and State IDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
[State_ID,County_ID,County_State_ID]=Read_ID_Number();

Yr=[2017:2021];
Yr_N=cell(1,length(Yr));
for yy=1:length(Yr)
    Yr_N{yy}=num2str(Yr(yy));
end
Inqv={'MMR','DTaP','Polio','VAR'};
Var_N={'Economic','Education','Income','Political','Race','Trust_in_Medicine','Trust_in_Science','Uninsured_19_under'};
X_State=zeros(length(Yr).*length(State_ID),length(Yr)+length(Var_N));  
X_County=zeros(length(Yr).*length(County_ID),length(Yr)+length(Var_N));  

for yy=1:length(Yr)
    X_State((yy-1).*length(State_ID)+[1:length(State_ID)],yy)=ones(size(X_State((yy-1).*length(State_ID)+[1:length(State_ID)],yy)));
    X_County((yy-1).*length(County_ID)+[1:length(County_ID)],yy)=ones(size(X_County((yy-1).*length(County_ID)+[1:length(County_ID)],yy)));
    for jj=1:length(Var_N)
        if(strcmp(Var_N{jj},'Trust_in_Medicine') || strcmp(Var_N{jj},'Trust_in_Science'))
            X_State((yy-1).*length(State_ID)+[1:length(State_ID)],length(Yr)+jj)=Return_State_Data(Var_N{jj},Yr(yy),State_ID);
            X_County((yy-1).*length(County_ID)+[1:length(County_ID)],length(Yr)+jj)=Return_County_Data(Var_N{jj},Yr(yy),County_ID);
        else
            [State_Demo,Data_Year]=Demographics_State(Var_N{jj},State_ID);
            X_State((yy-1).*length(State_ID)+[1:length(State_ID)],length(Yr)+jj)=State_Demo(:,Data_Year==Yr(yy));
            [County_Demo,Data_Year]=Demographics_County(Var_N{jj},County_ID);
            X_County((yy-1).*length(County_ID)+[1:length(County_ID)],length(Yr)+jj)=County_Demo(:,Data_Year==Yr(yy));
        end
    end
end

X_State=[X_State(:,[1:length(Yr)]) log(X_State(:,length(Yr)+[1 2])./(1-X_State(:,length(Yr)+[1 2]))) log(X_State(:,length(Yr)+[3])) log(X_State(:,length(Yr)+[4:length(Var_N)])./(1-X_State(:,length(Yr)+[4:length(Var_N)])))];
X_County=[X_County(:,[1:length(Yr)])  log(X_County(:,length(Yr)+[1 2])./(1-X_County(:,length(Yr)+[1 2]))) log(X_County(:,length(Yr)+[3])) log(X_County(:,length(Yr)+[4:length(Var_N)])./(1-X_County(:,length(Yr)+[4:length(Var_N)])))];

num_model=2^length(Var_N);

Cross_Validation_Likelihood=zeros((num_model-1),length(Inqv)+1);
Log_Likelihood_M=zeros((num_model-1),length(Inqv)+1);
Num_Parameters_M=zeros((num_model-1),length(Inqv)+1);
Num_Data_Pts=zeros((num_model-1),length(Inqv)+1);
beta_v=zeros(length(Inqv),(num_model-1),2+length(Yr)+length(Var_N));

for dd=1:length(Inqv)
    Y_State=zeros(length(Yr).*length(State_ID),1);    
    Y_County=zeros(length(Yr).*length(County_ID),1);    
    for yy=1:length(Yr)
        [Y_State((yy-1).*length(State_ID)+[1:length(State_ID)])] = State_Immunization_Statistics(Inqv{dd},Yr(yy),State_ID);
        [Y_County((yy-1).*length(County_ID)+[1:length(County_ID)])] = County_Immunization_Statistics(Inqv{dd},Yr(yy),County_ID);
    end
    

    Y_State=log(Y_State./(1-Y_State));
    Y_County=log(Y_County./(1-Y_County));

    RE_State=zeros(length(Yr).*length(State_ID),1);
    RE_County=zeros(length(Yr).*length(County_ID),1);
    PE_State=zeros(length(Yr).*length(State_ID),1);
    PE_County=zeros(length(Yr).*length(County_ID),1);
    
    for yy=1:length(Yr)
        [RE_State((yy-1).*length(State_ID)+[1:length(State_ID)]),PE_State((yy-1).*length(State_ID)+[1:length(State_ID)])] = Exemption_Timeline(Yr(yy),State_ID,Inqv{dd});
        [RE_County((yy-1).*length(County_ID)+[1:length(County_ID)]),PE_County((yy-1).*length(County_ID)+[1:length(County_ID)])] = Exemption_Timeline(Yr(yy),County_State_ID,Inqv{dd});
    end
    
    RE_State=RE_State(~isnan(Y_State) & ~isinf(Y_State)); 
    PE_State=PE_State(~isnan(Y_State) & ~isinf(Y_State));

    RE_County=RE_County(~isnan(Y_County) & ~isinf(Y_County));
    PE_County=PE_County(~isnan(Y_County) & ~isinf(Y_County));

    Z_State=X_State(~isnan(Y_State) & ~isinf(Y_State),:);
    Z_County=X_County(~isnan(Y_County) & ~isinf(Y_County),:);
    
    Y_State=Y_State(~isnan(Y_State) & ~isinf(Y_State));
    Y_County=Y_County(~isnan(Y_County) & ~isinf(Y_County));

    X_indx=zeros(num_model-1,length(Var_N));
       
    lb=-300.*ones(1,2+length(Yr)+length(Var_N));
    lb(2+length(Yr)+[6:7])=0; % Trust lower bound (Assume can only have postive influence on uptake)
    ub=300.*ones(1,2+length(Yr)+length(Var_N));
    ub(1:2)=0;
    
    Num_Data_Pts(:,jj)=length(Y_State);
    for nn=1:num_model-1
        temp_array=flip(decimalToBinaryVector(nn));
        X_indx(nn,1:length(temp_array))=temp_array;

        temp_all=[ones(1,length(Yr)) X_indx(nn,:)];

        X_temp=[RE_State PE_State Z_State(:,temp_all==1)];
        lb_t=lb([1 1 temp_all]==1);
        ub_t=ub([1 1 temp_all]==1);
        est_par=zeros(30,length(lb_t));
        fv=zeros(30,1);
        for ii=1:30
            [est_par(ii,:),fv(ii)]=lsqnonlin(@(x)(X_temp*(x')-Y_State),lb_t+(ub_t-lb_t).*rand(size(lb_t)),lb_t,ub_t);
        end
        sigma_s=sqrt(min(fv)./length(Y_State));
        p_c=est_par(fv==min(fv),:);
        p_c=p_c(1,:);
        res=(X_temp*(p_c')-Y_State);
        beta_v(dd,nn,[1 1 temp_all]==1)=p_c;
        Log_Likelihood_M(nn,dd)=sum(log(normpdf(res,0,sigma_s)));

        X_temp=[RE_County PE_County Z_County(:,temp_all==1)];
        
        y_pred=X_temp*(p_c');
        sigma_s=sqrt(sum((y_pred(:)-Y_County(:)).^2)./length(Y_County));
        err_term=sum(log(normpdf(y_pred(:)-Y_County(:),0,sigma_s)));
        Cross_Validation_Likelihood(nn,dd)=err_term;

        Num_Parameters_M(nn,dd)=length(p_c);

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

Variables={'Economic','Education','Income','Politcal','Race','Trust in Medicine','Trust in Science','Uninsured under 19','Cross validation (MMR)','Cross validation (DTaP)','Cross validation (IPV)','Cross validation (VAR)','Cross validation (Total)','log-likelihood (MMR)','log-likelihood (DTaP)','log-likelihood (IPV)','log-likelihood (VAR)','log-likelihood (Total)','AIC (MMR)','AIC (DTaP)','AIC (IPV)','AIC (VAR)','AIC (Total)','Scaled distance (MMR)','Scaled distance (DTaP)','Scaled distance (IPV)','Scaled distance (VAR)','Scaled distance (Total)'};
T=[array2table(X_indx) array2table(Cross_Validation_Likelihood) array2table(Log_Likelihood_M) array2table(AIC_m) array2table(distance_M)];

T.Properties.VariableNames=Variables;

writetable(T,'County_Level_Cross_Validation.xlsx','Sheet','Indicator');

Variables={'Religous Exemptions','Philosophical Exemptions',Yr_N{:},'Economic','Education','Income','Politcal','Race','Trust in Medicine','Trust in Science','Uninsured under 19'};
for vv=1:length(Inqv)
    T=array2table(squeeze(beta_v(vv,:,:)));
    T.Properties.VariableNames=Variables;
    writetable(T,'County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
end


clear;
clc;
close all;

parpool(48);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Obtain County and State IDS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
[State_ID,County_ID,County_State_ID]=Read_ID_Number();

% Years to run the fitting and CV for
Yr=[2017:2022];

% The vaccines of interrest
Inqv={'MMR','DTaP','Polio','VAR'};
% The covariates to explore
Var_N={'Economic','Education','Income','Political','Race','Parental_Trust_in_Medicine','Parental_Trust_in_Science','Uninsured_19_under'};

% Covariates matrices for state an dcounty
X_State=ones(length(Yr).*length(State_ID),1+length(Var_N));  
X_County=ones(length(Yr).*length(County_ID),1+length(Var_N));  

% Uncertainty in ststae level vaccination
Uncertainty_Weight=zeros(length(Yr).*length(State_ID),2);

% Year of the specified data
Data_Yr_State=zeros(length(Yr).*length(State_ID),1);
Data_Yr_County=zeros(length(Yr).*length(County_ID),1);

% Under age of 5 demographics used as a proxy for the weighting of vaccine
% uptake
[Under_Age_5,Data_Year]=Demographics_County('Under_Age_5',County_ID);
% Trim to the years of interest
Under_Age_5=Under_Age_5(:,ismember(Data_Year,Yr));

% County weights
County_Weight=cell(length(Yr),1);

% Overall trust in science and medicine (not parental)
Trust_Science_County_Overall=zeros(length(Yr).*length(County_ID),1);
Trust_Medicine_County_Overall=zeros(length(Yr).*length(County_ID),1);
for yy=1:length(Yr)
    % Calcualte the demographic weight or the counties
    County_Weight_t=zeros(length(State_ID),length(County_ID));
    for ss=1:length(State_ID)
        tf=County_State_ID==State_ID(ss); % Find the state ID
        County_Weight_t(ss,tf)=Under_Age_5(tf)./sum(Under_Age_5(tf)); % normalize coutnies i nthe state
    end
    County_Weight{yy}=County_Weight_t; % Record the weight for the specified year
    Data_Yr_State((yy-1).*length(State_ID)+[1:length(State_ID)],1)=Yr(yy); % REcord the year
    Data_Yr_County((yy-1).*length(County_ID)+[1:length(County_ID)],1)=Yr(yy); % Record the year
    
    % Obtain the overall level o trust in science and medicine
    Trust_Science_County_Overall((yy-1).*length(County_ID)+[1:length(County_ID)],1)=Return_County_Data('Trust_in_Science',Yr(yy),County_ID);
    Trust_Medicine_County_Overall((yy-1).*length(County_ID)+[1:length(County_ID)],1)=Return_County_Data('Trust_in_Medicine',Yr(yy),County_ID);

    % Obtain the covrariates ofr the model for the specified year
    for jj=1:length(Var_N)
        if(strcmp(Var_N{jj},'Parental_Trust_in_Medicine') || strcmp(Var_N{jj},'Parental_Trust_in_Science'))
            xt=Return_State_Data(Var_N{jj},Yr(yy),State_ID);      
            xt(xt==1)=1-10^(-8);
            xt(xt==0)=10^(-8);
            X_State((yy-1).*length(State_ID)+[1:length(State_ID)],1+jj)=xt;

            xt=Return_County_Data(Var_N{jj},Yr(yy),County_ID);
            xt(xt==1)=1-10^(-8);
            xt(xt==0)=10^(-8);
            X_County((yy-1).*length(County_ID)+[1:length(County_ID)],1+jj)=xt;
        else
            [State_Demo,Data_Year]=Demographics_State(Var_N{jj},State_ID);
            xt=State_Demo(:,Data_Year==Yr(yy));
            xt(xt==1)=1-10^(-8);
            xt(xt==0)=10^(-8);
            X_State((yy-1).*length(State_ID)+[1:length(State_ID)],1+jj)=xt;

            [County_Demo,Data_Year]=Demographics_County(Var_N{jj},County_ID);
            xt=County_Demo(:,Data_Year==Yr(yy));
            xt(xt==1)=1-10^(-8);
            xt(xt==0)=10^(-8);
            X_County((yy-1).*length(County_ID)+[1:length(County_ID)],1+jj)=xt;
        end
    end
end

% Transform the data to be used in the logitic regression model
% X_State=[X_State(:,[1]) X_State(:,1+[1 2]) log(X_State(:,1+[3])) X_State(:,1+[4:length(Var_N)])];
% X_County=[X_County(:,[1])  X_County(:,1+[1 2]) log(X_County(:,1+[3])) X_County(:,1+[4:length(Var_N)])];


X_State=[X_State(:,[1]) log(X_State(:,1+[1 2])./(1-X_State(:,1+[1 2]))) log(X_State(:,1+[3])) log(X_State(:,1+[4:length(Var_N)])./(1-X_State(:,1+[4:length(Var_N)])))];
X_County=[X_County(:,[1]) log(X_County(:,1+[1 2])./(1-X_County(:,1+[1 2]))) log(X_County(:,1+[3])) log(X_County(:,1+[4:length(Var_N)])./(1-X_County(:,1+[4:length(Var_N)])))];
% The number of models to explore
num_model=2^length(Var_N);

% Initialize the output matrices
Cross_Validation_Likelihood=NaN.*zeros((num_model-1),length(Inqv)+1);
Log_Likelihood_M=NaN.*zeros((num_model-1),length(Inqv)+1);
Num_Parameters_M=NaN.*zeros((num_model-1),length(Inqv)+1);
Num_Data_Pts=NaN.*zeros((num_model-1),length(Inqv)+1);
beta_v=zeros(length(Inqv),(num_model-1),2+1+length(Var_N));

options=optimoptions('fmincon','FunctionTolerance',10^(-6),'UseParallel',true,'MaxIterations',10^4);
for dd=1:length(Inqv) % Cycle through the  different vaccines

    % The state and county vaccine uptake
    Y_State=zeros(length(Yr).*length(State_ID),1);    
    Y_County=zeros(length(Yr).*length(County_ID),1);    
    for yy=1:length(Yr)
        [Y_State((yy-1).*length(State_ID)+[1:length(State_ID)])] = State_Immunization_Statistics(Inqv{dd},Yr(yy),State_ID);
        [Y_County((yy-1).*length(County_ID)+[1:length(County_ID)])] = County_Immunization_Statistics(Inqv{dd},Yr(yy),County_ID);
        
        % The uncertainty in the vaccine uptake at the state level for the
        % specified year
        [Uncertainty_Weight((yy-1).*length(State_ID)+[1:length(State_ID)],1),Uncertainty_Weight((yy-1).*length(State_ID)+[1:length(State_ID)],2)] = State_Immunization_Survey_Sample(Yr(yy),State_ID);
    end

    % Adjust the data such that the logit transform can be applied
    Y_State(Y_State==1)=1-10^(-8);
    Y_County(Y_County==1)=1-10^(-8);

    Y_State(Y_State==0)=10^(-8);
    Y_County(Y_County==0)=10^(-8);


    % Obtain the percent sampled
    Per_Sampled=Uncertainty_Weight(:,2);
    
    % The beta paramters used in the analysis
    a_beta=Uncertainty_Weight(:,1).*Uncertainty_Weight(:,2).*Y_State(:);
    b_beta=Uncertainty_Weight(:,1).*Uncertainty_Weight(:,2)-a_beta;
    
    Y_State=log(Y_State./(1-Y_State));
    Y_County=log(Y_County./(1-Y_County));

    % Religuous and philosophical exemptions
    RE_State=zeros(length(Yr).*length(State_ID),1);
    RE_County=zeros(length(Yr).*length(County_ID),1);
    PE_State=zeros(length(Yr).*length(State_ID),1);
    PE_County=zeros(length(Yr).*length(County_ID),1);
    
    % Obtain the exemptions for the vaccine
    for yy=1:length(Yr)
        [RE_State((yy-1).*length(State_ID)+[1:length(State_ID)]),PE_State((yy-1).*length(State_ID)+[1:length(State_ID)])] = Exemption_Timeline(Yr(yy),State_ID,Inqv{dd});
        [RE_County((yy-1).*length(County_ID)+[1:length(County_ID)]),PE_County((yy-1).*length(County_ID)+[1:length(County_ID)])] = Exemption_Timeline(Yr(yy),County_State_ID,Inqv{dd});
    end

    save(['State_County_Data_Cross_Validation_Model_Data_' Inqv{dd} '.mat'],'X_State',"X_County",'RE_State','PE_State','RE_County','PE_County','Data_Yr_State','Data_Yr_County','Var_N','Trust_Science_County_Overall','Trust_Medicine_County_Overall');
    
    % Remove all the data which vaccine uptake is NaN
    RE_State=RE_State(~isnan(Y_State) & ~isinf(Y_State)); 
    PE_State=PE_State(~isnan(Y_State) & ~isinf(Y_State));
    
    % Not remove the data here as need all counties to infer state level
    % coverage
    RE_County_All=RE_County;
    PE_County_All=PE_County;
    Z_County_All=X_County;
    
    % Remove all the data which vaccine uptake is NaN
    RE_County=RE_County(~isnan(Y_County) & ~isinf(Y_County));
    PE_County=PE_County(~isnan(Y_County) & ~isinf(Y_County));

    % Remove all the data which vaccine uptake is NaN
    Z_State=X_State(~isnan(Y_State) & ~isinf(Y_State),:);
    Z_County=X_County(~isnan(Y_County) & ~isinf(Y_County),:);
    
    % Remove all the data which vaccine uptake is NaN
    temp_yr=~isnan(Y_State) & ~isinf(Y_State);

    a_beta=a_beta(~isnan(Y_State) & ~isinf(Y_State));
    b_beta=b_beta(~isnan(Y_State) & ~isinf(Y_State));
    Per_Sampled=Per_Sampled(~isnan(Y_State) & ~isinf(Y_State));
    % Remove all the data which vaccine uptake is NaN
    Y_State=Y_State(~isnan(Y_State) & ~isinf(Y_State));
    Y_County=Y_County(~isnan(Y_County) & ~isinf(Y_County));

    X_indx=zeros(num_model-1,length(Var_N));
       
    % Calibrated the bounds to improve the convergence of the models
    lb=-1.25.*ones(1,2+1+length(Var_N));
    lb(2+1+[6:7])=0; % Trust lower bound (Assume can only have postive influence on uptake)
    ub=1.25.*ones(1,2+1+length(Var_N));
    ub(1:2)=0;

    lb(3)=0;
    ub(3)=20;
    
    Num_Data_Pts(:,dd)=length(Y_State);
    % Run the fitting
    for nn=1:num_model-1
        temp_array=flip(D2BV(nn));
        X_indx(nn,1:length(temp_array))=temp_array;
        if(X_indx(nn,strcmp(Var_N,'Economic')).*X_indx(nn,strcmp(Var_N,'Income'))==0)
            temp_all=[1 X_indx(nn,:)];
    
            X_temp=[RE_State PE_State Z_State(:,temp_all==1)];
            Xc_temp=[RE_County_All PE_County_All Z_County_All(:,temp_all==1)];
            
            % Use past models to improve convergence
            x_sub=[];            
            for sm=1:nn-1
                dX=X_indx(nn,:)-X_indx(sm,:);
                if(min(dX)==0)
                    par_temp=squeeze(beta_v(dd,sm,:))';
                    par_sub=par_temp([1 1 temp_all]==1);
                    x_sub=[x_sub;par_sub];
                end
            end
            
            N_0=5.*10^3+size(x_sub,1);
            lb_t=lb([1 1 temp_all]==1);
            ub_t=ub([1 1 temp_all]==1);

            f_search=zeros(N_0,1);

            if(~isempty(x_sub))
                lb_f=min(x_sub,[],1);
                ub_f=max(x_sub,[],1);
                x0=[x_sub; repmat(lb_t,2.5.*10^3,1)+repmat((ub_t-lb_t),2.5.*10^3,1).*lhsdesign(2.5.*10^3,length(lb_t)); repmat(lb_f,2.5.*10^3,1)+repmat((ub_f-lb_f),2.5.*10^3,1).*lhsdesign(2.5.*10^3,length(lb_f))];
            else
                x0=[repmat(lb_t,N_0,1)+repmat((ub_t-lb_t),N_0,1).*lhsdesign(N_0,length(lb_t))];
            end
            
            parfor ii=1:N_0
                f_search(ii)=Train_Model(x0(ii,:),X_temp,Xc_temp,Y_State,County_Weight,temp_yr,Data_Yr_County,Per_Sampled,a_beta,b_beta);
            end
            x0=[x0 f_search];
            x0=sortrows(x0,size(x0,2),"ascend");

            x0=x0(1:2:10,1:end-1);
            
            est_par=zeros(5,length(lb_t));
            fv=zeros(5,1);
            for ii=1:5
                [est_par(ii,:),fv(ii)]=fmincon(@(x)Train_Model(x,X_temp,Xc_temp,Y_State,County_Weight,temp_yr,Data_Yr_County,Per_Sampled,a_beta,b_beta),x0(ii,:),[],[],[],[],lb_t,ub_t,[],options);
            end

            sigma_s=sqrt(min(fv)./(2.*length(Y_State)));
            % Evalaute goodness of fit
            p_c=est_par(fv==min(fv),:);
            p_c=p_c(1,:);

            Est_State=X_temp*(p_c');

            uy=unique(Data_Yr_County);
            Est_County=[];
            for jj=1:length(County_Weight)
                X=Xc_temp(uy(jj)==Data_Yr_County,:);
                w=County_Weight{jj};
            
                z_temp=X*(p_c');
                v_temp=1./(1+exp(-z_temp));
                v_state_temp=w*v_temp;
                v_state_temp(v_state_temp>=1)=1-10^(-8);
                v_state_temp(v_state_temp<=0)=10^(-8); 
                y_new=log(v_state_temp./(1-v_state_temp));    
                Est_County=[Est_County;y_new];
            end
            
            Est_County=Est_County(temp_yr);
            
            L_State=zeros(size(Est_State));
            L_County=zeros(size(Est_County));
            for ss=1:length(Y_State)
                if(Per_Sampled(ss)<1)
                    NF=betacdf(1-10^(-8),a_beta(ss),b_beta(ss))-betacdf(10^(-8),a_beta(ss),b_beta(ss));
                    L_State(ss)=integral(@(v)betapdf(v,a_beta(ss),b_beta(ss)).*normpdf(Est_State(ss)-log(v./(1-v)),0,sigma_s),10^(-8),1-10^(-8))./NF;
                    L_County(ss)=integral(@(v)betapdf(v,a_beta(ss),b_beta(ss)).*normpdf(Est_County(ss)-log(v./(1-v)),0,sigma_s),10^(-8),1-10^(-8))./NF;
                else
                    L_State(ss)=normpdf(Est_State(ss)-Y_State(ss),0,sigma_s);
                    L_County(ss)=normpdf(Est_County(ss)-Y_State(ss),0,sigma_s);
                end
            end

            beta_v(dd,nn,[1 1 temp_all]==1)=p_c;
            Log_Likelihood_M(nn,dd)=sum(log(L_State))+sum(log(L_County));
    
            % compute the cross valdation
            X_temp=[RE_County PE_County Z_County(:,temp_all==1)];
            
            y_pred=X_temp*(p_c');
            sigma_s=sqrt(sum((y_pred(:)-Y_County(:)).^2)./length(Y_County));
            err_term=sum(log(normpdf(y_pred(:)-Y_County(:),0,sigma_s)));
            Cross_Validation_Likelihood(nn,dd)=err_term;
            Num_Parameters_M(nn,dd)=length(p_c);           
        end

    end
end

% Evalaute all four vaccines together
tf=~isnan(Num_Parameters_M(:,1));

X_indx=X_indx(tf,:);
Cross_Validation_Likelihood=Cross_Validation_Likelihood(tf,:);
Log_Likelihood_M=Log_Likelihood_M(tf,:);
Num_Parameters_M=Num_Parameters_M(tf,:);
Num_Data_Pts=Num_Data_Pts(tf,:);
beta_v=beta_v(:,tf,:);

Cross_Validation_Likelihood(:,5)=sum(Cross_Validation_Likelihood(:,1:4),2);
Num_Data_Pts(:,5)=sum(Num_Data_Pts(:,1:4),2);
Log_Likelihood_M(:,5)=sum(Log_Likelihood_M(:,1:4),2);
Num_Parameters_M(:,5)=sum(Num_Parameters_M(:,1:4),2);

[AIC_m]=aicbic(Log_Likelihood_M(:),Num_Parameters_M(:),Num_Data_Pts(:));

AIC_m=reshape(AIC_m,size(Log_Likelihood_M));
Scaled_CVE=(repmat(max(Cross_Validation_Likelihood),size(Cross_Validation_Likelihood,1),1)-Cross_Validation_Likelihood)./(repmat(max(Cross_Validation_Likelihood),size(Cross_Validation_Likelihood,1),1)-repmat(min(Cross_Validation_Likelihood),size(Cross_Validation_Likelihood,1),1));

Scaled_AIC=(AIC_m-repmat(min(AIC_m),size(AIC_m,1),1))./(repmat(max(AIC_m),size(AIC_m,1),1)-repmat(min(AIC_m),size(AIC_m,1),1));

% Distance to the optimal cross validation and losest AIC models
distance_M=sqrt(Scaled_CVE.^2+Scaled_AIC.^2);

Variables={'Economic','Education','Income','Politcal','Race','Trust in Medicine','Trust in Science','Uninsured under 19','Cross validation (MMR)','Cross validation (DTaP)','Cross validation (IPV)','Cross validation (VAR)','Cross validation (Total)','log-likelihood (MMR)','log-likelihood (DTaP)','log-likelihood (IPV)','log-likelihood (VAR)','log-likelihood (Total)','AIC (MMR)','AIC (DTaP)','AIC (IPV)','AIC (VAR)','AIC (Total)','Scaled distance (MMR)','Scaled distance (DTaP)','Scaled distance (IPV)','Scaled distance (VAR)','Scaled distance (Total)'};
T=[array2table(X_indx) array2table(Cross_Validation_Likelihood) array2table(Log_Likelihood_M) array2table(AIC_m) array2table(distance_M)];

T.Properties.VariableNames=Variables;

writetable(T,'County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet','Indicator');

Variables={'Religous Exemptions','Philosophical Exemptions','Intercept','Economic','Education','Income','Politcal','Race','Trust in Medicine','Trust in Science','Uninsured under 19'};
for vv=1:length(Inqv)
    T=array2table(squeeze(beta_v(vv,:,:)));
    T.Properties.VariableNames=Variables;
    writetable(T,'County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
end


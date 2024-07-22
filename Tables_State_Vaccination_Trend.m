clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load the state id to be analyzed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


[State_ID,~,~]=Read_ID_Number();


% Years to conduct the analysis
Yr=[2017:2022];

% The vaccines we are exploring
Var_Namev={'MMR','DTaP','Polio','VAR'};

% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end

Table_S2=cell(length(Var_Namev),2);

% Cycle through the vaccines in which we are condcuting the analysis
for dd=1:length(Var_Namev)
    
    Table_S2{dd,1}=Var_Namev{dd};

    % Create cell arrays to store results of analysis 
    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest
    
    VC=zeros(length(Yr),length(State_ID));
    Num_Sampled=zeros(length(Yr),length(State_ID));
    % Read the vaccie data for the speciifed years and states
    for yy=1:length(Yr)
        VC(yy,:)=State_Immunization_Statistics(Var_Name,Yr(yy),State_ID); 
        [Num_Sampled(yy,:)] = State_Immunization_Survey_Sample(Yr(yy),State_ID);
    end
    
    dV_dt=NaN.*zeros(length(State_ID),1);
    dV_dt_U=NaN.*zeros(length(State_ID),10^3);
    for ss=1:length(State_ID)
        a_beta=VC(:,ss).*Num_Sampled(:,ss);
        b_beta=(1-VC(:,ss)).*Num_Sampled(:,ss);

        Yr_trim=Yr(~isnan(a_beta))-2016;
        VC_trim=VC(~isnan(a_beta),ss);
        b_beta_trim=b_beta(~isnan(a_beta));
        a_beta_trim=a_beta(~isnan(a_beta));
        
        max_poly=length(Yr_trim)-2;
        if(max_poly>0)
            X=Yr_trim(:);
            L=zeros(max_poly,1);
            par=cell(max_poly,1);
            lb0=min(VC_trim)-0.05;
            lb0=log(lb0./(1-lb0));
            ub0=min(max(VC_trim)+0.05,0.999);
            ub0=log(ub0./(1-ub0));
            x0=[log(mean(VC_trim)./(1-mean(VC_trim))) 0;log(median(VC_trim)./(1-median(VC_trim))) 0; ];
            V_temp=zeros(length(a_beta_trim),10^6);
            for ii=1:length(a_beta_trim)
                V_temp(ii,:)=betarnd(a_beta_trim(ii),b_beta_trim(ii),10^6,1);
            end
            XS=repmat(X,1,10^6);
            for nn=1:max_poly                
                mdl_fit=fitlm(XS(:),log(V_temp(:)./(1-V_temp(:))),[0:nn]');
                x0=[x0; mdl_fit.Coefficients.Estimate'];
                options=optimoptions('ga','UseParallel',true,'InitialPopulationMatrix',x0);
                [x_fmin]=ga(@(x)Objective_Function_Polynomial_Trend(x,a_beta_trim,b_beta_trim,Yr_trim),nn+1,[],[],[],[],[lb0 -5.*ones(1,nn)],[ub0 5.*ones(1,nn)],[],[],options);
                [par{nn},L(nn)]=fmincon(@(x)Objective_Function_Polynomial_Trend(x,a_beta_trim,b_beta_trim,Yr_trim),x_fmin,[],[],[],[],[lb0 -10.*ones(1,nn)],[ub0 10.*ones(1,nn)]);
                x0=[x0;par{nn}];
                x0=[x0 zeros(size(x0,1),1)];
            end
            [aics,bic,ic]=aicbic(-L,1+[1:max_poly],length(Yr_trim));
            f_AIC=ic.aicc==min(ic.aicc);
            par_State=par{f_AIC};
            par_State_0=par_State;
            Z=sum(par_State.*(Yr(end)-2016).^([1:(length(par_State))]-1));
            V=1./(1+exp(-Z));

            N_rand=10^7;
            dV_dt(ss)=exp(-Z).*V.^2.*sum([par_State(2:end)].*(Yr(end)-2016).^([1:(length(par_State(2:end)))]-1));
            x_Samp=repmat(par_State,N_rand,1).*(1+0.4*(0.5-rand(N_rand,length(par_State))));
            L_w=zeros(N_rand,1);
            parfor ww=1:N_rand
                L_w(ww)=-Objective_Function_Polynomial_Trend(x_Samp(ww,:),a_beta_trim,b_beta_trim,Yr_trim);
            end
            wt=exp(L_w-max(L_w))./sum(exp(L_w-max(L_w)));
            w=cumsum(wt);
            test_Samp=zeros(10^3,length(par_State_0));          
            for jj=1:10^3
                f_indx=find(rand(1)<w,1);
                par_State=x_Samp(f_indx,:);
                test_Samp(jj,:)=x_Samp(f_indx,:);
                Z=sum(par_State.*(Yr(end)-2016).^([1:(length(par_State))]-1));
                V=1./(1+exp(-Z));
                dV_dt_U(ss,jj)=exp(-Z).*V.^2.*sum([par_State(2:end)].*(Yr(end)-2016).^([1:(length(par_State(2:end)))]-1));
            end
            test=0;
        end

    end
end

Table_S2=cell2table(Table_S2);
Table_S2.Properties.VariableNames={'Vaccine','Proportion with decrease in uptake'};
writetable(Table_S2,'Tables_Supplement_Text.xlsx','Sheet','Table_S2');
clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load the state id to be analyzed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


[State_ID,~,~]=Read_ID_Number();


% Years to conduct the analysis
Yr=[2017:2022];

% The vaccines we are exploring
Var_Namev={'MMR','DTaP','Polio','VAR','All'};

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
N_Samp=10^6;
dV_dt=NaN.*zeros(length(State_ID),length(Var_Namev));
UdV_dt=NaN.*zeros(length(State_ID),length(Var_Namev),N_Samp);
% Cycle through the vaccines in which we are condcuting the analysis
for dd=1:length(Var_Namev)-1
    
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
    
    
    for ss=1:length(State_ID)
        a_beta=VC(:,ss).*Num_Sampled(:,ss);
        b_beta=(1-VC(:,ss)).*Num_Sampled(:,ss);

        Yr_trim=Yr(~isnan(a_beta))-2017;
        VC_trim=VC(~isnan(a_beta),ss);
        b_beta_trim=b_beta(~isnan(a_beta));
        a_beta_trim=a_beta(~isnan(a_beta));
        
        max_poly=length(Yr_trim)-2;
        if(max_poly>0)
            X=Yr_trim(:);
            L=zeros(max_poly,1);
            par=cell(max_poly,1);
            x0=[log(mean(VC_trim)./(1-mean(VC_trim))) 0;log(median(VC_trim)./(1-median(VC_trim))) 0; ];
            V_temp=zeros(length(a_beta_trim),N_Samp);
            for ii=1:length(a_beta_trim)
                V_temp(ii,:)=betarnd(a_beta_trim(ii),b_beta_trim(ii),N_Samp,1);
            end
            for nn=1:max_poly                
                v_t=(a_beta_trim-1)./(a_beta_trim+b_beta_trim-2);
                x_fmin=flip(polyfit((Yr_trim),log(v_t./(1-v_t)),nn));
                [par{nn},L(nn)]=fmincon(@(x)Objective_Function_Polynomial_Trend(x,a_beta_trim,b_beta_trim,Yr_trim),x_fmin,[],[],[],[],[-10 -10.*ones(1,nn)],[10 10.*ones(1,nn)]);
            end
            [aics,bic,ic]=aicbic(-L,1+[1:max_poly],length(Yr_trim));
            f_AIC=ic.aicc==min(ic.aicc);
            par_State=par{f_AIC};
            par_State_0=par_State;
            Z=sum(par_State.*(Yr(end)-2017).^([1:(length(par_State))]-1));
            V=1./(1+exp(-Z));

            dV_dt(ss,dd)=exp(-Z).*V.^2.*sum([par_State(2:end)].*(Yr(end)-2017).^([1:(length(par_State(2:end)))]-1));
            
            Yr_end=Yr(end);
            parfor nn=1:N_Samp
                par_State=flip(polyfit(Yr_trim,log(V_temp(:,nn)./(1-V_temp(:,nn))),length(par_State_0)-1));
                Z=sum(par_State.*(Yr_end-2017).^([1:(length(par_State))]-1));
                V=1./(1+exp(-Z));
                UdV_dt(ss,dd,nn)=exp(-Z).*V.^2.*sum([par_State(2:end)].*(Yr_end-2017).^([1:(length(par_State(2:end)))]-1));
            end
        end

    end
end

for dd=1:length(Var_Namev)-1
    per_decline=mean(dV_dt(:,dd)<0);
    
    un_per_decline=prctile(mean(squeeze(UdV_dt(:,dd,:))<0,1),[2.5 97.5]);
    Table_S2{dd,2}=[ num2str(per_decline,'%4.3f') ' (' num2str(un_per_decline(1),'%4.3f') char(8211) num2str(un_per_decline(2),'%4.3f') ')'];
end

dd=length(Var_Namev);
Table_S2{dd,1}=Var_Namev{dd};
per_decline=mean(sum(dV_dt<0,2)==4);
utemp_All=mean(squeeze(sum(UdV_dt<0,2))==4,1);
un_per_decline=prctile(utemp_All,[2.5 97.5]);
Table_S2{dd,2}=[ num2str(per_decline,'%4.3f') ' (' num2str(un_per_decline(1),'%4.3f') char(8211) num2str(un_per_decline(2),'%4.3f') ')'];

Table_S2=cell2table(Table_S2);
Table_S2.Properties.VariableNames={'Vaccine','Proportion with projected decrease'};
writetable(Table_S2,'Tables_Supplement_Text.xlsx','Sheet','Table_S2');
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parental Trust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[State_ID,~,~]=Read_ID_Number();

Yr=[2017:2022];
load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Medicine_Stratification.mat'])
Nat_Medicine=Trust_in_Medicine.National.Great_Deal+0.5.*Trust_in_Medicine.National.Only_Some;
Nat_Medicine=Nat_Medicine(ismember(Trust_Year_Data,Yr));

load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Medicine_Error_Stratification.mat']);
Err_M=Trust_in_Medicine_Error.National.Great_Deal+0.5.*Trust_in_Medicine_Error.National.Only_Some;
Err_M=Err_M(ismember(Trust_Year_Data,Yr));

beta_M=zeros(length(Nat_Medicine),2);
for ii=1:length(Nat_Medicine)
    b_beta=@(x)((x-1)-Nat_Medicine(ii).*(x-2))./Nat_Medicine(ii);
    [par,fval]=fmincon(@(x)sum([Err_M(ii).^2-x.*b_beta(x)./((x+b_beta(x)).^2.*(x+b_beta(x)+1))].^2),[10],[],[],[],[],[1],[100]);
    
    beta_M(ii,:)=[par b_beta(par)];
end

load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Science_Stratification.mat'])
Nat_Science=Trust_in_Science.National.Great_Deal+0.5.*Trust_in_Science.National.Only_Some;
Nat_Science=Nat_Science(ismember(Trust_Year_Data,Yr));

load([pwd '/Spatial_Data/Trust_Science_Medicine/Trust_in_Science_Error_Stratification.mat']);

Err_S=Trust_in_Science_Error.National.Great_Deal+0.5.*Trust_in_Science_Error.National.Only_Some;
Err_S=Err_S(ismember(Trust_Year_Data,Yr));

beta_S=zeros(length(Nat_Science),2);
for ii=1:length(Nat_Science)
    b_beta=@(x) ((x-1)-Nat_Science(ii).*(x-2))./Nat_Science(ii);
    [par,fval]=fmincon(@(x)sum([Err_S(ii).^2-x.*b_beta(x)./((x+b_beta(x)).^2.*(x+b_beta(x)+1))].^2),[10],[],[],[],[],[1],[100]);
    
    beta_S(ii,:)=[par b_beta(par)];
end

% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end

Var_Namev={'Parental_Trust_in_Medicine','Parental_Trust_in_Science'};

Measure={'Trust','Proportion of states below National','Extent of trust below national','Proportion of states trust declined','Extent of decline in trust'};

Table_2=cell(5.*length(Var_Namev),length(Yr)+2);

for dd=1:length(Var_Namev)
    if(strcmp(Var_Namev{dd},'Parental_Trust_in_Science'))
        Nat_Trust=Nat_Science;
        beta_Trust=beta_S;
    else
        Nat_Trust=Nat_Medicine;
        beta_Trust=beta_M;
    end
    

    Table_2{dd,2}=Var_Namev{dd};
    Table_2{dd+length(Var_Namev),2}=Var_Namev{dd};
    Table_2{dd+2.*length(Var_Namev),2}=Var_Namev{dd};
    Table_2{dd+3.*length(Var_Namev),2}=Var_Namev{dd};
    Table_2{dd+4.*length(Var_Namev),2}=Var_Namev{dd};

    for ss=1:5
        Table_2{dd+(ss-1).*length(Var_Namev),1}=Measure{ss};
    end

    % Create cell arrays to store results of analysis 
    V_Table=cell(length(Yr),length(Yr));
    Slope_Table=cell(length(Yr),length(Yr));
    Raw_Slope_Table=cell(length(Yr)-1,length(Yr)-1);
    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest

    N_Samp=10^3;
    
    for yy=1:length(Yr)
        Trust=squeeze(Return_State_Trust_Data_Randomized(Var_Name,Yr(yy),State_ID,N_Samp));   
        t_n=~isnan(Trust);
        n=sum(~isnan(sum(Trust,2)));
        Table_2{dd,2+yy}=[ num2str(100.*mean(Trust(t_n)),'%3.1f') '% (' num2str(100.*min(Trust(t_n)),'%3.1f') '%' char(8211) num2str(100.*max(Trust(t_n)),'%3.1') '%) (n = ' num2str(n) ')'];
        Nat_rnd=betarnd(beta_Trust(yy,1),beta_Trust(yy,2),1,N_Samp);
        p_Nat=zeros(length(State_ID),1);
        effect_size_Nat=zeros(length(State_ID),N_Samp);
        for jj=1:length(State_ID)
            par_m=betafit(Trust(jj,:));
            effect_size_Nat(jj,:)=Nat_rnd-Trust(jj,:);
            p_Nat(jj)=integral(@(x)betapdf(x,par_m(1),par_m(2)).*betacdf(x,beta_Trust(yy,1),beta_Trust(yy,2)),0,1);
        end

        samp_Nat=repmat(p_Nat,1,10^6)-rand(length(p_Nat),10^6);
        samp_Nat(samp_Nat>0)=1;
        samp_Nat(samp_Nat<0)=0;
        
        mean_samp=mean(samp_Nat,1);
        lb_samp=prctile(mean_samp,2.5);
        ub_samp=prctile(mean_samp,97.5);

        Table_2{dd+length(Var_Namev),2+yy}=[ num2str(mean(p_Nat),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

        lb_samp=prctile(100.*effect_size_Nat(:),2.5);
        ub_samp=prctile(100.*effect_size_Nat(:),97.5);
        mean_samp=mean(100.*effect_size_Nat(:));
        Table_2{dd+2.*length(Var_Namev),2+yy}=[ num2str(mean_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];
        
        if(yy==1)
            Table_2{dd+3.*length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Table_2{dd+4.*length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Trust_Past=Trust;
        else
            effect_size_decrease=Trust_Past-Trust;
            p_decrease=NaN.*zeros(length(State_ID),1);
            for pp=1:length(p_decrease)
                par_past=betafit(Trust_Past(jj,:));
                par_t=betafit(Trust(jj,:));
                p_decrease(pp)=integral(@(v)betapdf(v,par_past(1),par_past(2)).*betacdf(v,par_t(1),par_t(2)),0,1);
            end
            t_n=~isnan(p_decrease);
            n=sum(t_n);
            p_decrease_trim=p_decrease(t_n);

            samp_decrease=repmat(p_decrease_trim,1,10^6)-rand(length(p_decrease_trim),10^6);
            samp_decrease(samp_decrease>0)=1;
            samp_decrease(samp_decrease<0)=0;
            
            mean_samp=mean(samp_decrease,1);
            lb_samp=prctile(mean_samp,2.5);
            ub_samp=prctile(mean_samp,97.5);
            
            Table_2{dd+3.*length(Var_Namev),2+yy}=[ num2str(mean(p_decrease_trim),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

            effect_size_decrease=effect_size_decrease(~isnan(effect_size_decrease));
            effect_size_decrease=effect_size_decrease(:);

            lb_samp=100.*prctile(effect_size_decrease,2.5);
            ub_samp=100.*prctile(effect_size_decrease,97.5);
            mean_samp=100.*mean(effect_size_decrease);

            Table_2{dd+4.*length(Var_Namev),2+yy}=[ num2str(mean_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];

            Trust_Past=Trust;
        end
    end
end
Table_2=cell2table(Table_2);
writetable(Table_2,'Tables_Main_Text.xlsx','Sheet','Table_2');

clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parental Trust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[State_ID,~,~]=Read_ID_Number();

Yr=[2017:2022];
% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end

Var_Namev={'Parental_Trust_in_Science','Parental_Trust_in_Medicine'};

Measure={'Trust','Proportion of states trust declined','Extent of decline in trust','Probability of initial decent'};

Table_2=cell(4.*length(Var_Namev),length(Yr)+2);
options=optimoptions('fmincon','FunctionTolerance',10^(-9),'MaxFunctionEvaluations',10^4,'MaxIterations',10^5);
for dd=1:length(Var_Namev)    

    Table_2{dd,2}=Var_Namev{dd};
    Table_2{dd+length(Var_Namev),2}=Var_Namev{dd};
    Table_2{dd+2.*length(Var_Namev),2}=Var_Namev{dd};
    Table_2{dd+3.*length(Var_Namev),2}=Var_Namev{dd};

    for ss=1:4
        Table_2{dd+(ss-1).*length(Var_Namev),1}=Measure{ss};
    end

    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest

    N_Samp=10^3;
    Trust_Temporal=zeros(length(State_ID),length(Yr),N_Samp);
    for yy=1:length(Yr)
        Trust=squeeze(Return_State_Trust_Data_Randomized(Var_Name,Yr(yy),State_ID,N_Samp));   
        Trust_Temporal(:,yy,:)=Trust;
        t_n=~isnan(Trust);
        n=sum(~isnan(sum(Trust,2)));
        Table_2{dd,2+yy}=[ num2str(100.*mean(Trust(t_n)),'%3.1f') '% (' num2str(100.*min(Trust(t_n)),'%3.1f') '%' char(8211) num2str(100.*max(Trust(t_n)),'%3.1f') '%) (n = ' num2str(n) ')'];
        
        if(yy==1)
            Table_2{dd+length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Table_2{dd+2.*length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Trust_Past=Trust;
        else
            effect_size_decrease=Trust_Past-Trust;
            p_decrease=NaN.*zeros(length(State_ID),1);
            for pp=1:length(p_decrease)
                par_past=betafit(Trust_Past(pp,:));
                par_t=betafit(Trust(pp,:));
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
            
            Table_2{dd+length(Var_Namev),2+yy}=[ num2str(mean(p_decrease_trim),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

            effect_size_decrease=effect_size_decrease(t_n,:);
            
            med_samp=median(100.*effect_size_decrease(:));
            lb_samp=prctile(100.*effect_size_decrease(:),2.5);
            ub_samp=prctile(100.*effect_size_decrease(:),97.5);
            

            Table_2{dd+2.*length(Var_Namev),2+yy}=[ num2str(med_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];

            Trust_Past=Trust;
        end
    end
    
    p_decline=zeros(N_Samp,length(Yr));
    m_decline=zeros(N_Samp,length(Yr));  
    w_decline=zeros(N_Samp,length(Yr));
    for nn=1:N_Samp
        temp_samp=squeeze(Trust_Temporal(:,:,nn));
        AIC_temp=zeros(1,length(Yr));
        for yp=1:length(Yr)
            if(yp==1)
                lb=[-1/(max(Yr)-min(Yr)) 0];
                ub=[0 1];
                m=min((median(temp_samp(:,end))-median(temp_samp(:,1)))./(Yr(end)-Yr(1)),-0.0001);
                x0=[m median(temp_samp(:,1))];
                k=2;
            elseif(yp==length(Yr))                
                lb=[0 0];
                ub=[1/(max(Yr)-min(Yr)) 1];
                m=max((median(temp_samp(:,end))-median(temp_samp(:,1)))./(Yr(end)-Yr(1)),0.0001);
                x0=[m median(temp_samp(:,end))];
                k=2;
            else
                lb=[0 -1/(max(Yr)-Yr(yp)) 0];
                ub=[1/(Yr(yp)-min(Yr)) 0 1];
                m1=max((median(temp_samp(:,yp))-median(temp_samp(:,1)))./(Yr(end)-Yr(1)),0.0001);
                m2=min((median(temp_samp(:,end))-median(temp_samp(:,yp)))./(Yr(end)-Yr(1)),-0.0001);
                x0=[m1 m2 median(temp_samp(:,yp))];
                k=3;
            end
            [~,fval]=fmincon(@(x)Objective_PW(x,Yr(yp),Yr,temp_samp),x0,[],[],[],[],lb,ub,[],options);
            AIC_temp(yp)=aicbic(-fval,k);
        end
        AIC_temp=AIC_temp-min(AIC_temp);
        p_decline(nn,:)=exp(-AIC_temp./2)./sum(exp(-AIC_temp./2));
    end
    m_samp=mean(p_decline,1);
    bs_p_decline=zeros(10^4,length(Yr));
    for zz=1:10^4
        bs_p_decline(zz,:)=mean(p_decline(randi(N_Samp,500,1),:),1);
    end
    lb_samp=prctile(bs_p_decline,2.5);
    ub_samp=prctile(bs_p_decline,97.5);
    
    for yy=1:length(Yr)
        Table_2{dd+3.*length(Var_Namev),2+yy}=[ num2str(m_samp(yy),'%4.3f') ' (' num2str(lb_samp(yy),'%4.3f')  char(8211) num2str(ub_samp(yy),'%4.3f') ')'];
    end

end
Table_2=cell2table(Table_2);

Table_2.Properties.VariableNames={'Measure','Trust',['2017' char(8211) '18'],['2018' char(8211) '19'],['2019' char(8211) '20'],['2020' char(8211) '21'],['2021' char(8211) '22'],['2022' char(8211) '23']};
writetable(Table_2,'Tables_Main_Text.xlsx','Sheet','Table_2');


clear;
clc;
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Overall Trust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[State_ID,~,~]=Read_ID_Number();

Yr=[2017:2022];

% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end

Var_Namev={'Trust_in_Science','Trust_in_Medicine'};

Measure={'Trust','Proportion of states trust declined','Extent of decline in trust','Probability of initial decent'};

Table_S3=cell(4.*length(Var_Namev),length(Yr)+2);
options=optimoptions('fmincon','FunctionTolerance',10^(-9),'MaxFunctionEvaluations',10^4,'MaxIterations',10^5);
for dd=1:length(Var_Namev)
    

    Table_S3{dd,2}=Var_Namev{dd};
    Table_S3{dd+length(Var_Namev),2}=Var_Namev{dd};
    Table_S3{dd+2.*length(Var_Namev),2}=Var_Namev{dd};
    Table_S3{dd+3.*length(Var_Namev),2}=Var_Namev{dd};

    for ss=1:4
        Table_S3{dd+(ss-1).*length(Var_Namev),1}=Measure{ss};
    end

    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest

    N_Samp=10^3;
    Trust_Temporal=zeros(length(State_ID),length(Yr),N_Samp);
    for yy=1:length(Yr)
        Trust=squeeze(Return_State_Trust_Data_Randomized(Var_Name,Yr(yy),State_ID,N_Samp));   
        Trust_Temporal(:,yy,:)=Trust;
        t_n=~isnan(Trust);
        n=sum(~isnan(sum(Trust,2)));
        Table_S3{dd,2+yy}=[ num2str(100.*mean(Trust(t_n)),'%3.1f') '% (' num2str(100.*min(Trust(t_n)),'%3.1f') '%' char(8211) num2str(100.*max(Trust(t_n)),'%3.1f') '%) (n = ' num2str(n) ')'];
        
        if(yy==1)
            Table_S3{dd+length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Table_S3{dd+2.*length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Trust_Past=Trust;
        else
            effect_size_decrease=Trust_Past-Trust;
            p_decrease=NaN.*zeros(length(State_ID),1);
            for pp=1:length(p_decrease)
                par_past=betafit(Trust_Past(pp,:));
                par_t=betafit(Trust(pp,:));
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
            
            Table_S3{dd+length(Var_Namev),2+yy}=[ num2str(mean(p_decrease_trim),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

            effect_size_decrease=effect_size_decrease(t_n,:);
            
            med_samp=median(100.*effect_size_decrease(:));
            lb_samp=prctile(100.*effect_size_decrease(:),2.5);
            ub_samp=prctile(100.*effect_size_decrease(:),97.5);
            

            Table_S3{dd+2.*length(Var_Namev),2+yy}=[ num2str(med_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];

            Trust_Past=Trust;
        end
    end
    
    p_decline=zeros(N_Samp,length(Yr));
    for nn=1:N_Samp
        temp_samp=squeeze(Trust_Temporal(:,:,nn));
        AIC_temp=zeros(1,length(Yr));
        for yp=1:length(Yr)
            if(yp==1)
                lb=[-1/(max(Yr)-min(Yr)) 0];
                ub=[0 1];
                m=min((median(temp_samp(:,end))-median(temp_samp(:,1)))./(Yr(end)-Yr(1)),-0.0001);
                x0=[m median(temp_samp(:,1))];
                k=2;
            elseif(yp==length(Yr))                
                lb=[0 0];
                ub=[1/(max(Yr)-min(Yr)) 1];
                m=max((median(temp_samp(:,end))-median(temp_samp(:,1)))./(Yr(end)-Yr(1)),0.0001);
                x0=[m median(temp_samp(:,end))];
                k=2;
            else
                lb=[0 -1/(max(Yr)-Yr(yp)) 0];
                ub=[1/(Yr(yp)-min(Yr)) 0 1];
                m1=max((median(temp_samp(:,yp))-median(temp_samp(:,1)))./(Yr(end)-Yr(1)),0.0001);
                m2=min((median(temp_samp(:,end))-median(temp_samp(:,yp)))./(Yr(end)-Yr(1)),-0.0001);
                x0=[m1 m2 median(temp_samp(:,yp))];
                k=3;
            end
            [~,fval]=fmincon(@(x)Objective_PW(x,Yr(yp),Yr,temp_samp),x0,[],[],[],[],lb,ub,[],options);
            AIC_temp(yp)=aicbic(-fval,k);
        end
        AIC_temp=AIC_temp-min(AIC_temp);
        p_decline(nn,:)=exp(-AIC_temp./2)./sum(exp(-AIC_temp./2));
    end
    m_samp=mean(p_decline,1);
    bs_p_decline=zeros(10^4,length(Yr));
    for zz=1:10^4
        bs_p_decline(zz,:)=mean(p_decline(randi(N_Samp,500,1),:),1);
    end
    lb_samp=prctile(bs_p_decline,2.5);
    ub_samp=prctile(bs_p_decline,97.5);
    
    for yy=1:length(Yr)
        Table_S3{dd+3.*length(Var_Namev),2+yy}=[ num2str(m_samp(yy),'%4.3f') ' (' num2str(lb_samp(yy),'%4.3f')  char(8211) num2str(ub_samp(yy),'%4.3f') ')'];
    end

end
Table_S3=cell2table(Table_S3);

Table_S3.Properties.VariableNames={'Measure','Trust',['2017' char(8211) '18'],['2018' char(8211) '19'],['2019' char(8211) '20'],['2020' char(8211) '21'],['2021' char(8211) '22'],['2022' char(8211) '23']};
writetable(Table_S3,'Tables_Supplement_Text.xlsx','Sheet','Table_S3');

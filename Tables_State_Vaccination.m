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

Table_1=cell(5.*length(Var_Namev),length(Yr)+2);

Measure={'Vaccine uptake','Proportion of states below 95%','Extent of uptake below 95%','Proportion of states uptake declined','Extent of decline in uptake'};
% Cycle through the vaccines in which we are condcuting the analysis
for dd=1:length(Var_Namev)
    
    Table_1{dd,2}=Var_Namev{dd};
    Table_1{dd+length(Var_Namev),2}=Var_Namev{dd};
    Table_1{dd+2.*length(Var_Namev),2}=Var_Namev{dd};
    Table_1{dd+3.*length(Var_Namev),2}=Var_Namev{dd};
    Table_1{dd+4.*length(Var_Namev),2}=Var_Namev{dd};

    for ss=1:5
        Table_1{dd+(ss-1).*length(Var_Namev),1}=Measure{ss};
    end

    % Create cell arrays to store results of analysis 
    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest
    
    % Read the vaccie data for the speciifed years and states
    for yy=1:length(Yr)
        VC=State_Immunization_Statistics(Var_Name,Yr(yy),State_ID); 
        t_n=~isnan(VC);
        n=sum(t_n);
        Table_1{dd,2+yy}=[ num2str(100.*mean(VC(t_n)),'%3.1f') '% (' num2str(100.*min(VC(t_n)),'%3.1f') '%' char(8211) num2str(100.*max(VC(t_n)),'%3.1f') '%) (n = ' num2str(n) ')'];

        [Num_Sampled,Per_Surveyed] = State_Immunization_Survey_Sample(Yr(yy),State_ID);

        a_beta=VC.*Num_Sampled;
        b_beta=(1-VC).*Num_Sampled;

        
        t_n=~isnan(a_beta+b_beta);
        a_beta_trim=a_beta(t_n);
        b_beta_trim=b_beta(t_n);
        Per_Surveyed_trim=Per_Surveyed(t_n);
        VC_trim=VC(t_n);
        n=sum(t_n);
        effect_size_95=zeros(n,10^6);
        for ss=1:n
            if(Per_Surveyed_trim(ss)<1)
                effect_size_95(ss,:)=0.95-betarnd(a_beta_trim(ss),b_beta_trim(ss),1,10^6);
            else
                effect_size_95(ss,:)=0.95-VC_trim(ss);
            end
        end
        p_95=betacdf(0.95,a_beta_trim,b_beta_trim);
        p_95(Per_Surveyed_trim==1)=double(VC_trim(Per_Surveyed_trim==1)<0.95);
        samp_95=repmat(p_95,1,10^6)-rand(length(p_95),10^6);
        samp_95(samp_95>0)=1;
        samp_95(samp_95<0)=0;
        
        mean_samp=mean(samp_95,1);
        lb_samp=prctile(mean_samp,2.5);
        ub_samp=prctile(mean_samp,97.5);
        
        Table_1{dd+length(Var_Namev),2+yy}=[ num2str(mean(p_95),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

        med_samp=median(100.*effect_size_95(:));
        lb_samp=prctile(100.*effect_size_95(:),2.5);
        ub_samp=prctile(100.*effect_size_95(:),97.5);
        
        Table_1{dd+2.*length(Var_Namev),2+yy}=[ num2str(med_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];

        if(yy==1)
            Table_1{dd+3.*length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            Table_1{dd+4.*length(Var_Namev),2+yy}=[char(8212) char(8212) char(8212)];
            a_beta_past=a_beta;
            b_beta_past=b_beta;
            Per_Surveyed_past=Per_Surveyed;
        else
            effect_size_decrease=NaN.*zeros(length(a_beta),10^6);
            p_decrease=NaN.*zeros(length(a_beta),1);
            for pp=1:length(p_decrease)
                if(~isnan(a_beta(pp)+a_beta_past(pp)))
                    if(Per_Surveyed(pp)<1 && Per_Surveyed_past(pp)<1)
                        p_decrease(pp)=integral(@(v)betapdf(v,a_beta_past(pp),b_beta_past(pp)).*betacdf(v,a_beta(pp),b_beta(pp)),0,1);
                    elseif (Per_Surveyed_past(pp)<1)
                        p_decrease(pp)=1-betacdf(a_beta(pp)./(a_beta(pp)+b_beta(pp)),a_beta_past(pp),b_beta_past(pp));
                    elseif (Per_Surveyed(pp)<1)
                        p_decrease(pp)=betacdf(a_beta_past(pp)./(a_beta_past(pp)+b_beta_past(pp)),a_beta(pp),b_beta(pp));
                    else
                        p_decrease(pp)=double(a_beta_past(pp)./(a_beta_past(pp)+b_beta_past(pp))>a_beta(pp)./(a_beta(pp)+b_beta(pp)));
                    end
                end
                effect_size_decrease(pp,:)=betarnd(a_beta_past(pp),b_beta_past(pp),1,10^6)-betarnd(a_beta(pp),b_beta(pp),1,10^6);
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
            
            Table_1{dd+3.*length(Var_Namev),2+yy}=[ num2str(mean(p_decrease_trim),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

            effect_size_decrease_trim=effect_size_decrease(t_n,:);

            med_samp=median(100.*effect_size_decrease_trim(:));
            lb_samp=prctile(100.*effect_size_decrease_trim(:),2.5);
            ub_samp=prctile(100.*effect_size_decrease_trim(:),97.5);

            Table_1{dd+4.*length(Var_Namev),2+yy}=[ num2str(med_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];

            a_beta_past=a_beta;
            b_beta_past=b_beta;
            Per_Surveyed_past=Per_Surveyed;
        end
    end
end

Table_1=cell2table(Table_1);
Table_1.Properties.VariableNames={'Measure','Vaccine',['2017' char(8211) '18'],['2018' char(8211) '19'],['2019' char(8211) '20'],['2020' char(8211) '21'],['2021' char(8211) '22'],['2022' char(8211) '23']};
writetable(Table_1,'Tables_Main_Text.xlsx','Sheet','Table_1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplement Table comparing uptake across the different years
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Table_S1=cell(length(Var_Namev).*length(Yr),length(Yr)+2);

for dd=1:length(Var_Namev)
    for yy=1:length(Yr)

        Table_S1{yy+(dd-1).*length(Yr),1}=Var_Namev{dd};
        Table_S1{yy+(dd-1).*length(Yr),2}=[num2str(Yr(yy)) char(8211) num2str(Yr(yy)-1999)];
    end
    
    for yy=1:length(Yr)-1
        VC_Ref=State_Immunization_Statistics(Var_Namev{dd},Yr(yy),State_ID); 
        [Num_Sampled_Ref,Per_Surveyed_Ref] = State_Immunization_Survey_Sample(Yr(yy),State_ID);
        a_beta_Ref=VC_Ref.*Num_Sampled_Ref;
        b_beta_Ref=(1-VC_Ref).*Num_Sampled_Ref;
        
        Vac_Ref=NaN.*zeros(length(State_ID),10^6);
        for ss=1:length(State_ID)
            if(~isnan(a_beta_Ref(ss)))
                if(Per_Surveyed_Ref(ss)<1)
                    Vac_Ref(ss,:)=betarnd(a_beta_Ref(ss),b_beta_Ref(ss),1,10^6);
                else
                    Vac_Ref(ss,:)=Vac_Ref(ss);
                end
            end
        end

        for zz=(yy+1):length(Yr)
            VC_Comp=State_Immunization_Statistics(Var_Namev{dd},Yr(zz),State_ID); 
            [Num_Sampled_Comp,Per_Surveyed_Comp] = State_Immunization_Survey_Sample(Yr(zz),State_ID);
            a_beta_Comp=VC_Comp.*Num_Sampled_Comp;
            b_beta_Comp=(1-VC_Comp).*Num_Sampled_Comp;
            
            Vac_Comp=NaN.*zeros(length(State_ID),10^6);
            for ss=1:length(State_ID)
                if(~isnan(a_beta_Comp(ss)))
                    if(Per_Surveyed_Comp(ss)<1)
                        Vac_Comp(ss,:)=betarnd(a_beta_Comp(ss),b_beta_Comp(ss),1,10^6);
                    else
                        Vac_Comp(ss,:)=Vac_Comp(ss);
                    end
                end
            end

            effect_size_decrease=NaN.*zeros(length(b_beta_Comp),10^6);
            p_decrease=NaN.*zeros(length(b_beta_Comp),1);
            for pp=1:length(p_decrease)
                if(~isnan(a_beta_Ref(pp)+a_beta_Comp(pp)))
                    if(Per_Surveyed_Ref(pp)<1 && Per_Surveyed_Comp(pp)<1)
                        p_decrease(pp)=integral(@(v)betapdf(v,a_beta_Ref(pp),b_beta_Ref(pp)).*betacdf(v,a_beta_Comp(pp),b_beta_Comp(pp)),0,1);
                    elseif (Per_Surveyed_Ref(pp)<1)
                        p_decrease(pp)=1-betacdf(a_beta(pp)./(a_beta(pp)+b_beta(pp)),a_beta_Ref(pp),b_beta_Ref(pp));
                    elseif (Per_Surveyed_Comp(pp)<1)
                        p_decrease(pp)=betacdf(a_beta_Ref(pp)./(a_beta_Ref(pp)+b_beta_Ref(pp)),a_beta_Comp(pp),b_beta_Comp(pp));
                    else
                        p_decrease(pp)=double(a_beta_Ref(pp)./(a_beta_Ref(pp)+b_beta_Ref(pp))>a_beta_Comp(pp)./(a_beta_Comp(pp)+b_beta_Comp(pp)));
                    end
                    effect_size_decrease(pp,:)=betarnd(a_beta_Ref(pp),b_beta_Ref(pp),1,10^6)-betarnd(a_beta_Comp(pp),b_beta_Comp(pp),1,10^6);
                end
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
            
            Table_S1{yy+(dd-1).*length(Yr),2+zz}=[ num2str(mean(p_decrease_trim),'%4.3f') ' (' num2str(lb_samp,'%4.3f') char(8211) num2str(ub_samp,'%4.3f') ') (n = ' num2str(n) ')'];

            effect_size_decrease=effect_size_decrease(~isnan(effect_size_decrease));
            effect_size_decrease=effect_size_decrease(:);

            lb_samp=100.*prctile(effect_size_decrease,2.5);
            ub_samp=100.*prctile(effect_size_decrease,97.5);
            med_samp=100.*median(effect_size_decrease);

            Table_S1{zz+(dd-1).*length(Yr),2+yy}=[ num2str(med_samp,'%3.1f') '% (' num2str(lb_samp,'%3.1f') '%' char(8211) num2str(ub_samp,'%3.1f') '%) (n = ' num2str(n) ')'];
            
        end
    end
end


Table_S1=cell2table(Table_S1);
Table_S1.Properties.VariableNames={'Vaccine','Reference Year',['2017' char(8211) '18'],['2018' char(8211) '19'],['2019' char(8211) '20'],['2020' char(8211) '21'],['2021' char(8211) '22'],['2022' char(8211) '23']};
writetable(Table_S1,'Tables_Supplement_Text.xlsx','Sheet','Table_S1');
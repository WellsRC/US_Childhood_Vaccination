clear;
clc;
close all;


T=readtable('Bayesian_Network.xlsx','Sheet','Summary');
Sheet_AIC=T.Sheet(T.delta_AIC==0);

T=readtable('Bayesian_Network.xlsx','Sheet',Sheet_AIC{:},'Range','B7:M20');

v_name=T.Variable;
temp_beta_psci=T.ParentalTrustInScience(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';
temp_beta_pmed=T.ParentalTrustInMedicine(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';

temp_beta_sci=T.TrustInScience(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';
temp_beta_med=T.TrustInMedicine(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';


v_name=v_name(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}));

[~,County_ID,~]=Read_ID_Number();

[W,Inqv]=Return_Model_Weights();

Variables={'Trust in Medicine','Trust in Science'};
dT=[0:0.005:0.05];
Z_mean=zeros(4,length(Variables),length(dT));
Z_median=zeros(4,length(Variables),length(dT));
Z_lb1=zeros(4,length(Variables),length(dT));
Z_ub1=zeros(4,length(Variables),length(dT));
Z_lb2=zeros(4,length(Variables),length(dT));
Z_ub2=zeros(4,length(Variables),length(dT));

per_decrease=zeros(4,length(Variables),length(dT));

TM_mean=zeros(4,length(Variables),length(dT));
TM_median=zeros(4,length(Variables),length(dT));
TM_lb1=zeros(4,length(Variables),length(dT));
TM_ub1=zeros(4,length(Variables),length(dT));
TM_lb2=zeros(4,length(Variables),length(dT));
TM_ub2=zeros(4,length(Variables),length(dT));

TS_mean=zeros(4,length(Variables),length(dT));
TS_median=zeros(4,length(Variables),length(dT));
TS_lb1=zeros(4,length(Variables),length(dT));
TS_ub1=zeros(4,length(Variables),length(dT));
TS_lb2=zeros(4,length(Variables),length(dT));
TS_ub2=zeros(4,length(Variables),length(dT));

N_Samp=10^4;

Year_inq=2022;

for vv=1:4
    
    load(['State_County_Data_Cross_Validation_Model_Data_' Inqv{vv} '.mat'],"X_County",'RE_County','PE_County','Data_Yr_County','Trust_Science_County_Overall','Trust_Medicine_County_Overall');
    
    X_County=X_County(Data_Yr_County==Year_inq,:);
    RE_County=RE_County(Data_Yr_County==Year_inq);
    PE_County=PE_County(Data_Yr_County==Year_inq);

    Trust_Science_County_Overall=Trust_Science_County_Overall(Data_Yr_County==Year_inq);
    Trust_Medicine_County_Overall=Trust_Medicine_County_Overall(Data_Yr_County==Year_inq);
    
    C=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
    M=table2array(C);
    w_c=cumsum(W{vv});

    r=rand(N_Samp,1);
    Indx=zeros(N_Samp,1);

    for ii=1:length(r)
        Indx(ii)=find(r(ii)<=w_c, 1 );
    end
    Mt=M(Indx,:);

    for ct=1:length(dT)
        new_sci=Trust_Science_County_Overall+dT(ct);
        new_med=Trust_Medicine_County_Overall+dT(ct);
            
        old_sci=Trust_Science_County_Overall;
        old_med=Trust_Medicine_County_Overall;

        dS=log(new_sci./(1-new_sci))-log(old_sci./(1-old_sci));
        dM=log(new_med./(1-new_med))-log(old_med./(1-old_med));

        for ii=1:length(Variables)
            T_Old=[RE_County PE_County X_County(:,1:end)];
            if(strcmp(Variables{ii},'Trust in Science'))
                temp_dM=temp_beta_med(strcmp(v_name,'Trust in Science')).*dS;
                if(temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine'))~=0)
                    temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*temp_dM;
                    temp_dpM=temp_med-X_County(:,7);
                    temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*temp_dM+temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine')).*temp_dpM;
                else
                    temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*temp_dM;
                    temp_dpS=temp_sci-X_County(:,8);
                    temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*temp_dM+temp_beta_pmed(strcmp(v_name,'Parental Trust in Science')).*temp_dpS;
                end                
            else
                temp_dS=temp_beta_sci(strcmp(v_name,'Trust in Medicine')).*dM;
                if(temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine'))~=0)
                    temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*dM;
                    temp_dpM=temp_med-X_County(:,7);
                    temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*dM+temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine')).*temp_dpM;
                else
                    temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*dM;
                    temp_dpS=temp_sci-X_County(:,8);
                    temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*dM+temp_beta_pmed(strcmp(v_name,'Parental Trust in Science')).*temp_dpS;
                end  
            end
            
            trust_med_parental=1./(1+exp(-temp_med))-1./(1+exp(-X_County(:,7)));
            trust_sci_parental=1./(1+exp(-temp_sci))-1./(1+exp(-X_County(:,8)));

            T_New=[RE_County PE_County X_County(:,1:6) temp_med temp_sci X_County(:,9)];

            dv=100*(1./(1+exp(-Mt*(T_New')))-1./(1+exp(-Mt*(T_Old'))));

            per_decrease(vv,ii,ct)=mean(dv(:)<0);
            
            Z_mean(vv,ii,ct)=mean(dv(:),1);
            Z_median(vv,ii,ct)=median(dv(:),1);
            Z_lb1(vv,ii,ct)=prctile(dv(:),25,1);
            Z_ub1(vv,ii,ct)=prctile(dv(:),75,1);
            Z_lb2(vv,ii,ct)=prctile(dv(:),2.5,1);
            Z_ub2(vv,ii,ct)=prctile(dv(:),97.5,1);

            TM_mean(vv,ii,ct)=100.*mean(trust_med_parental(:),1);
            TM_median(vv,ii,ct)=100.*median(trust_med_parental(:),1);
            TM_lb1(vv,ii,ct)=100.*prctile(trust_med_parental(:),25,1);
            TM_ub1(vv,ii,ct)=100.*prctile(trust_med_parental(:),75,1);
            TM_lb2(vv,ii,ct)=100.*prctile(trust_med_parental(:),2.5,1);
            TM_ub2(vv,ii,ct)=100.*prctile(trust_med_parental(:),97.5,1);

            TS_mean(vv,ii,ct)=100.*mean(trust_sci_parental(:),1);
            TS_median(vv,ii,ct)=100.*median(trust_sci_parental(:),1);
            TS_lb1(vv,ii,ct)=100.*prctile(trust_sci_parental(:),25,1);
            TS_ub1(vv,ii,ct)=100.*prctile(trust_sci_parental(:),75,1);
            TS_lb2(vv,ii,ct)=100.*prctile(trust_sci_parental(:),2.5,1);
            TS_ub2(vv,ii,ct)=100.*prctile(trust_sci_parental(:),97.5,1);
        end
    end
end


Inqv_t={'MMR','DTaP','IPV','VAR'};
figure('units','normalized','outerposition',[0.1 0.1 0.5 0.8]);
for vv=1:4
    subplot('Position',[0.1+0.495.*rem(vv-1,2),0.61-0.5.*floor(vv/3),0.385,0.355]);
    lb=squeeze(Z_lb1(vv,1,:))';
    ub=squeeze(Z_ub1(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(Z_lb2(vv,1,:))';
    ub=squeeze(Z_ub2(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(Z_mean(vv,1,:));
    plot(dT,m,'color',hex2rgb('#063852'),'LineWidth',2)
    

    fprintf(['Magnitude of increase in vaccine uptake for trust in medicine for ' Inqv_t{vv} ':' num2str(m(end),'%3.2f') '%% (' num2str(Z_lb2(vv,1,end),'%3.2f') '-' num2str(Z_ub2(vv,1,end),'%3.2f') ')\n'])

    lb=squeeze(Z_lb1(vv,2,:))';
    ub=squeeze(Z_ub1(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(Z_lb2(vv,2,:))';
    ub=squeeze(Z_ub2(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(Z_mean(vv,2,:));
    plot(dT,m,'color',hex2rgb('#F0810F'),'LineWidth',2)
    fprintf(['Magnitude of increase in vaccine uptake for trust in science for ' Inqv_t{vv} ':' num2str(m(end),'%3.2f') '%% (' num2str(Z_lb2(vv,2,end),'%3.2f') '-' num2str(Z_ub2(vv,2,end),'%3.2f') ')\n'])
    fprintf(['Probability of decrease in vaccine uptake for trust in science for ' Inqv_t{vv} ':' num2str(per_decrease(vv,2,end)) '\n'])
    plot(dT,zeros(size(dT)),'k-.','LineWidth',1.5)

    title(Inqv_t{vv})
    box off;
    set(gca,'LineWidth',2,'tickdir','out','YTick',[-1:5],'Fontsize',14,'XTick',[0:0.01:0.05],'XMinorTick','on')
    xtickangle(45);
    ylim([-1 3]);
    xlim([0 0.05]);
    ytickformat('percentage')
    ylabel('Change in vaccine uptake','FontSize',18)
    xlabel('Change in trust','FontSize',18)
    text(-0.25,1.05,char(64+vv),'Fontsize',24,'Units','normalized');
    text(0.01,0.9,Variables{1},'color',hex2rgb('#063852'),'Fontsize',18,'Units','normalized');
    text(0.01,0.98,Variables{2},'color',hex2rgb('#F0810F'),'Fontsize',18,'Units','normalized');

end


print(gcf,['Figure3.png'],'-dpng','-r600');
print(gcf,['Figure3.tiff'],'-dtiff','-r600');



Inqv_t={'MMR','DTaP','IPV','VAR'};
figure('units','normalized','outerposition',[0.1 0.1 0.5 0.8]);
for vv=1:4
    subplot('Position',[0.1+0.495.*rem(vv-1,2),0.61-0.5.*floor(vv/3),0.385,0.355]);
    lb=squeeze(TM_lb1(vv,1,:))';
    ub=squeeze(TM_ub1(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(TM_lb2(vv,1,:))';
    ub=squeeze(TM_ub2(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(TM_mean(vv,1,:));
    plot(dT,m,'color',hex2rgb('#063852'),'LineWidth',2)

    lb=squeeze(TS_lb1(vv,1,:))';
    ub=squeeze(TS_ub1(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(TS_lb2(vv,1,:))';
    ub=squeeze(TS_ub2(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(TS_mean(vv,1,:));
    plot(dT,m,'color',hex2rgb('#F0810F'),'LineWidth',2)

    plot(dT,zeros(size(dT)),'k-.','LineWidth',1.5)

    title(Inqv_t{vv})
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[0:0.01:0.05],'XMinorTick','on')
    xtickangle(45);
%     ylim([-1 3]);
    xlim([0 0.05]);
    ytickformat('percentage')
    ylabel('Change in vaccine uptake','FontSize',18)
    xlabel('Change in trust medicine','FontSize',18)
    text(-0.25,1.05,char(64+vv),'Fontsize',24,'Units','normalized');
    text(0.01,0.9,Variables{1},'color',hex2rgb('#063852'),'Fontsize',18,'Units','normalized');
    text(0.01,0.98,Variables{2},'color',hex2rgb('#F0810F'),'Fontsize',18,'Units','normalized');
end


print(gcf,['Figure_Trust_Med.png'],'-dpng','-r600');


Inqv_t={'MMR','DTaP','IPV','VAR'};
figure('units','normalized','outerposition',[0.1 0.1 0.5 0.8]);
for vv=1:4
    subplot('Position',[0.1+0.495.*rem(vv-1,2),0.61-0.5.*floor(vv/3),0.385,0.355]);
    lb=squeeze(TM_lb1(vv,2,:))';
    ub=squeeze(TM_ub1(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(TM_lb2(vv,2,:))';
    ub=squeeze(TM_ub2(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(TS_mean(vv,2,:));
    plot(dT,m,'color',hex2rgb('#063852'),'LineWidth',2)

    lb=squeeze(TS_lb1(vv,2,:))';
    ub=squeeze(TS_ub1(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(TS_lb2(vv,2,:))';
    ub=squeeze(TS_ub2(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(TS_mean(vv,2,:));
    plot(dT,m,'color',hex2rgb('#F0810F'),'LineWidth',2)

    plot(dT,zeros(size(dT)),'k-.','LineWidth',1.5)

    title(Inqv_t{vv})
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',[0:0.01:0.05],'XMinorTick','on')
    xtickangle(45);
%     ylim([-1 3]);
    xlim([0 0.05]);
    ytickformat('percentage')
    ylabel('Change in vaccine uptake','FontSize',18)
    xlabel('Change in trust in science','FontSize',18)
    text(-0.25,1.05,char(64+vv),'Fontsize',24,'Units','normalized');
    text(0.01,0.9,Variables{1},'color',hex2rgb('#063852'),'Fontsize',18,'Units','normalized');
    text(0.01,0.98,Variables{2},'color',hex2rgb('#F0810F'),'Fontsize',18,'Units','normalized');
end


print(gcf,['Figure_Trust_Sci.png'],'-dpng','-r600');


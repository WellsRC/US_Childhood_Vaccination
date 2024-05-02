% clear;
% clc;
% close all;
% 
% 
% T=readtable('Bayesian_Network.xlsx','Sheet','Summary');
% Sheet_AIC=T.Sheet(T.delta_AIC==0);
% 
% T=readtable('Bayesian_Network.xlsx','Sheet',Sheet_AIC{:},'Range','B7:M20');
% 
% v_name=T.Variable;
% temp_beta_psci=T.ParentalTrustInScience(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';
% temp_beta_pmed=T.ParentalTrustInMedicine(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';
% 
% temp_beta_sci=T.TrustInScience(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';
% temp_beta_med=T.TrustInMedicine(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}))';
% 
% 
% v_name=v_name(ismember(v_name,{'Parental Trust in Medicine';'Parental Trust in Science';'Trust in Medicine';'Trust in Science'}));
% 
% [~,County_ID,~]=Read_ID_Number();
% 
% [W,Inqv]=Return_Model_Weights();
% 
% Variables={'Trust in Medicine','Trust in Science'};
% dT=[0:0.005:0.05];
% Z_mean=zeros(4,length(Variables),length(dT));
% Z_median=zeros(4,length(Variables),length(dT));
% Z_lb1=zeros(4,length(Variables),length(dT));
% Z_ub1=zeros(4,length(Variables),length(dT));
% Z_lb2=zeros(4,length(Variables),length(dT));
% Z_ub2=zeros(4,length(Variables),length(dT));
% 
% N_Samp=10^4;
% 
% Year_Inq=2022;
% 
% 
% Vac_Nam_v={'MMR','DTaP','Polio','VAR'};
% Vac_Title_v={'measles','pertussis','polio','varicella'};
% 
% R0=[7 11 4 4];
% k=[0.23 0.4364 6.661 1];
% 
% eps_v=[0.99 0.85 0.9 0.92];
% paralysis_polio=1/1000;
% % https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-023-15846-x/figures/1
% % per_contact_outsidehome=1-4.829268292682927/24.289099526066355;
% 
% %https://www.cdc.gov/vaccines/pubs/pinkbook/pert.html
% % Expected cases in home
% Ex_Home=4.829268292682927.*0.8;
% % Adjust R0 for pertussis to be secondary cases outside the home
% R0(strcmp(Vac_Nam_v,'DTaP'))=R0(strcmp(Vac_Nam_v,'DTaP'))-Ex_Home;
% 
%  load([pwd '\Spatial_Data\Demographic_Data\County_Population.mat']);
% 
% Pop_County=County_Demo.Population.Total;
% Pop_County=Pop_County(:,County_Demo.Year_Data==Year_Inq);
% Pop_County=repmat(Pop_County',N_Samp,1);
% clear County_Demo;
% 
% for vv=1:4
%     
%     load(['State_County_Data_Cross_Validation_Model_Data_' Inqv{vv} '.mat'],"X_County",'RE_County','PE_County','Data_Yr_County','Trust_Science_County_Overall','Trust_Medicine_County_Overall');
%     
%     X_County=X_County(Data_Yr_County==Year_Inq,:);
%     RE_County=RE_County(Data_Yr_County==Year_Inq);
%     PE_County=PE_County(Data_Yr_County==Year_Inq);
% 
%     Trust_Science_County_Overall=Trust_Science_County_Overall(Data_Yr_County==Year_Inq);
%     Trust_Medicine_County_Overall=Trust_Medicine_County_Overall(Data_Yr_County==Year_Inq);
%     
%     C=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
%     M=table2array(C);
%     w_c=cumsum(W{vv});
% 
%     r=rand(N_Samp,1);
%     Indx=zeros(N_Samp,1);
% 
%     for ii=1:length(r)
%         Indx(ii)=find(r(ii)<=w_c, 1 );
%     end
%     Mt=M(Indx,:);
% 
%     for ct=1:length(dT)
%         new_sci=Trust_Science_County_Overall+dT(ct);
%         new_med=Trust_Medicine_County_Overall+dT(ct);
%             
%         old_sci=Trust_Science_County_Overall;
%         old_med=Trust_Medicine_County_Overall;
% 
%         dS=log(new_sci./(1-new_sci))-log(old_sci./(1-old_sci));
%         dM=log(new_med./(1-new_med))-log(old_med./(1-old_med));
% 
%         for ii=1:length(Variables)
%             T_Old=[RE_County PE_County X_County(:,1:end)];
%             if(strcmp(Variables{ii},'Trust in Science'))
%                 temp_dM=temp_beta_med(strcmp(v_name,'Trust in Science')).*dS;
%                 if(temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine'))~=0)
%                     temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*temp_dM;
%                     temp_dpM=temp_med-X_County(:,7);
%                     temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*temp_dM+temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine')).*temp_dpM;
%                 else
%                     temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*temp_dM;
%                     temp_dpS=temp_sci-X_County(:,8);
%                     temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*temp_dM+temp_beta_pmed(strcmp(v_name,'Parental Trust in Science')).*temp_dpS;
%                 end                
%             else
%                 temp_dS=temp_beta_sci(strcmp(v_name,'Trust in Medicine')).*dM;
%                 if(temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine'))~=0)
%                     temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*dM;
%                     temp_dpM=temp_med-X_County(:,7);
%                     temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*dM+temp_beta_psci(strcmp(v_name,'Parental Trust in Medicine')).*temp_dpM;
%                 else
%                     temp_sci=X_County(:,8)+temp_beta_psci(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_psci(strcmp(v_name,'Trust in Medicine')).*dM;
%                     temp_dpS=temp_sci-X_County(:,8);
%                     temp_med=X_County(:,7)+temp_beta_pmed(strcmp(v_name,'Trust in Science')).*temp_dS+temp_beta_pmed(strcmp(v_name,'Trust in Medicine')).*dM+temp_beta_pmed(strcmp(v_name,'Parental Trust in Science')).*temp_dpS;
%                 end  
%             end
%             
%             T_New=[RE_County PE_County X_County(:,1:6) temp_med temp_sci X_County(:,9)];
% 
%             v_new=(1./(1+exp(-Mt*(T_New')))); ...
%             v_old=(1./(1+exp(-Mt*(T_Old'))));
%             
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%             % Trust in medicine
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%             Reff_old=R0(vv).*(1-eps_v(vv).*v_old);
%             Reff_new=R0(vv).*(1-eps_v(vv).*v_new);
%             if(strcmp(Vac_Nam_v{vv},'Polio'))
%                 Ex_Case=1./(1-Reff_old);
%                 t_r=find(Reff_old>=1);
%                 for rr=1:length(t_r)
%                     %https://www.jstor.org/stable/26166762?seq=2
%                     S0=(1-eps_v(vv).*v_old(t_r(rr)));
%                     [s_inf]=lsqnonlin(@(x)log(x/S0)-R0(vv).*(x./S0-1),S0.*0.6,0,S0);
%                     Ex_Case(t_r(rr))=Pop_County(t_r(rr)).*(1-s_inf./S0);
%                 end
%         
%                 prob_old=1-(1-paralysis_polio.*(1-eps_v(vv).*v_old)).^Ex_Case;
% 
%                 Ex_Case=1./(1-Reff_new);
%                 t_r=find(Reff_new>=1);
%                 for rr=1:length(t_r)
%                     %https://www.jstor.org/stable/26166762?seq=2
%                     S0=(1-eps_v(vv).*v_new(t_r(rr)));
%                     [s_inf]=lsqnonlin(@(x)log(x/S0)-R0(vv).*(x./S0-1),S0.*0.6,0,S0);
%                     Ex_Case(t_r(rr))=Pop_County(t_r(rr)).*(1-s_inf./S0);
%                 end
%         
%                 prob_new=1-(1-paralysis_polio.*(1-eps_v(vv).*v_new)).^Ex_Case;
%             elseif(strcmp(Vac_Nam_v{vv},'DTaP'))
%                 p=(1+Reff_old./k(vv)).^(-1);
%                 % 3 cases that overlap and not inside the home
%                 prob_old=(1-nbincdf(1,k(vv),p))+ nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p));
% 
%                 p=(1+Reff_new./k(vv)).^(-1);
%                 % 3 cases that overlap and not inside the home
%                 prob_new=(1-nbincdf(1,k(vv),p))+ nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p));
% 
%             elseif(strcmp(Vac_Nam_v{vv},'MMR'))
%                 % https://www.cdc.gov/measles/cases-outbreaks.html
%                 % https://www.cdc.gov/vaccines/pubs/surv-manual/chpt07-measles.html
%                 % 3 or more related cases
%                 p=(1+Reff_old./k(vv)).^(-1);
%                 prob_old=(1-nbincdf(1,k(vv),p))+ nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p));
% 
%                 p=(1+Reff_new./k(vv)).^(-1);
%                 prob_new=(1-nbincdf(1,k(vv),p))+ nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p));
%             elseif(strcmp(Vac_Nam_v{vv},'VAR'))
%                 %https://www.cdc.gov/chickenpox/outbreaks/manual.html
%                 % At least 5 epidemiologically linked cases (i.e. index needs to
%                 % infect at least 4 or 4 additional cases (5 cases in total)
%                 
%                 p=(1+Reff_old./k(vv)).^(-1);
%                 prob_old=(1-nbincdf(3,k(vv),p));
%                 prob_old=prob_old+ nbinpdf(3,k(vv),p).*((1-nbincdf(0,k(vv),p)).^3+3.*nbinpdf(0,k(vv),p).*(1-nbincdf(0,k(vv),p)).^2+3.*nbinpdf(0,k(vv),p).^2.*(1-nbincdf(0,k(vv),p)));
%                 prob_old=prob_old+ nbinpdf(2,k(vv),p).*((1-nbincdf(0,k(vv),p)).^2+2.*nbinpdf(0,k(vv),p).*((1-nbincdf(1,k(vv),p))+nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p))));
%                 prob_old=prob_old+ nbinpdf(1,k(vv),p).*((1-nbincdf(2,k(vv),p))+nbinpdf(2,k(vv),p).*((1-nbincdf(0,k(vv),p)).^2+2.*nbinpdf(0,k(vv),p).*(1-nbincdf(0,k(vv),p)))+nbinpdf(1,k(vv),p).*((1-nbincdf(1,k(vv),p))+nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p))));       
% 
% 
%                 p=(1+Reff_new./k(vv)).^(-1);
%                 prob_new=(1-nbincdf(3,k(vv),p));
%                 prob_new=prob_new+ nbinpdf(3,k(vv),p).*((1-nbincdf(0,k(vv),p)).^3+3.*nbinpdf(0,k(vv),p).*(1-nbincdf(0,k(vv),p)).^2+3.*nbinpdf(0,k(vv),p).^2.*(1-nbincdf(0,k(vv),p)));
%                 prob_new=prob_new+ nbinpdf(2,k(vv),p).*((1-nbincdf(0,k(vv),p)).^2+2.*nbinpdf(0,k(vv),p).*((1-nbincdf(1,k(vv),p))+nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p))));
%                 prob_new=prob_new+ nbinpdf(1,k(vv),p).*((1-nbincdf(2,k(vv),p))+nbinpdf(2,k(vv),p).*((1-nbincdf(0,k(vv),p)).^2+2.*nbinpdf(0,k(vv),p).*(1-nbincdf(0,k(vv),p)))+nbinpdf(1,k(vv),p).*((1-nbincdf(1,k(vv),p))+nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p))));       
% 
%             end
% 
%             dv=prob_new-prob_old;
%             Z_mean(vv,ii,ct)=100.*mean(dv(:),1);
%             Z_median(vv,ii,ct)=100.*median(dv(:),1);
%             Z_lb1(vv,ii,ct)=100.*prctile(dv(:),25,1);
%             Z_ub1(vv,ii,ct)=100.*prctile(dv(:),75,1);
%             Z_lb2(vv,ii,ct)=100.*prctile(dv(:),2.5,1);
%             Z_ub2(vv,ii,ct)=100.*prctile(dv(:),97.5,1);
%         end
% 
%     end
% end


Inqv_t={'MMR','DTaP','IPV','VAR'};
figure('units','normalized','outerposition',[0.1 0.1 0.65 0.8]);
for vv=1:4
    subplot('Position',[0.1+0.495.*rem(vv-1,2),0.61-0.5.*floor(vv/3),0.39,0.355]);
    lb=squeeze(Z_lb1(vv,1,:))';
    ub=squeeze(Z_ub1(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(Z_lb2(vv,1,:))';
    ub=squeeze(Z_ub2(vv,1,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#063852'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(Z_mean(vv,1,:));
    plot(dT,m,'color',hex2rgb('#063852'),'LineWidth',2); hold on;

    lb=squeeze(Z_lb1(vv,2,:))';
    ub=squeeze(Z_ub1(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    lb=squeeze(Z_lb2(vv,2,:))';
    ub=squeeze(Z_ub2(vv,2,:))';
    patch([dT flip(dT)],[lb flip(ub)],hex2rgb('#F0810F'),'FaceAlpha',0.2,'LineStyle','none'); hold on
    m=squeeze(Z_mean(vv,2,:));
    plot(dT,m,'color',hex2rgb('#F0810F'),'LineWidth',2)

    plot(dT,zeros(size(dT)),'k-.','LineWidth',1.5)

    title(Inqv_t{vv})
    box off;
    set(gca,'LineWidth',2,'tickdir','out','YTick',[-3:1],'Fontsize',14,'XTick',[0:0.01:0.05],'XMinorTick','on')
    xtickangle(45);
    ylim([-3 1]);
    xlim([0 0.05]);
    ytickformat('percentage')
    ylabel({'Change in probability','of an outbreak'},'FontSize',18)
    xlabel('Change in trust','FontSize',18)
    text(-0.25,1.05,char(64+vv),'Fontsize',24,'Units','normalized');
    text(0.01,0.98,Variables{1},'color',hex2rgb('#063852'),'Fontsize',18,'Units','normalized');
    text(0.01,0.9,Variables{2},'color',hex2rgb('#F0810F'),'Fontsize',18,'Units','normalized');
end


print(gcf,['Figure_S1.png'],'-dpng','-r600');
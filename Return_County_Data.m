function County_Factor_v=Return_County_Data(Var_Name,Year_Q,County_ID,Rand_Indx,Rand_Trust_S,Rand_Trust_M)

Immunization_Variables={'All_immunizations','Medical_Exemption','Religious_Exemption','Philosophical_Exemption','DTaP','Polio','MMR','VAR'};
County_Factor_v=NaN.*zeros(length(County_ID),1);
if(sum(strcmp(Var_Name,Immunization_Variables))>0)
    County_Factor_v=County_Immunization_Statistics(Var_Name,Year_Q,County_ID);
elseif(strcmp(Var_Name,'Household_Children_under_18'))
    [County_Demo,Data_Year]=Demographics_County('Household_Children_under_18',County_ID,Rand_Indx);
    z_temp=log(County_Demo./(1-County_Demo));
    for jj=1:length(County_ID)
        z_new=pchip(Data_Year,z_temp(jj,:),Year_Q);
        County_Factor_v(jj)=1./(1+exp(-z_new));
    end        
elseif(strcmp(Var_Name,'Uninsured_19_under'))
    [County_Demo,Data_Year]=Demographics_County('Uninsured_19_under',County_ID,Rand_Indx);
    z_temp=log(County_Demo./(1-County_Demo));
    for jj=1:length(County_ID)
        z_new=pchip(Data_Year,z_temp(jj,:),Year_Q);
        County_Factor_v(jj)=1./(1+exp(-z_new));
    end        
elseif(strcmp(Var_Name,'MMR_School'))
    [County_Demo,Data_Year]=Demographics_County('Political',County_ID,Rand_Indx);
    z_temp=log(County_Demo./(1-County_Demo));
    for jj=1:length(County_ID)
        z_new=pchip(Data_Year,z_temp(jj,:),Year_Q);
        County_Factor_v(jj)=1./(1+exp(-z_new));
    end
    vb_demo=1./(1+exp(-pchip([2019 2022],log([0.12 0.11]./(1-[0.12 0.11])),Year_Q)));
    vb_rep=1./(1+exp(-pchip([2019 2022],log([0.20 0.44]./(1-[0.20 0.44])),Year_Q)));
    County_Factor_v=vb_demo.*County_Factor_v+vb_rep.*(1-County_Factor_v);
elseif(strcmp(Var_Name,'Trust_in_Medicine'))
    load('Estimate_LR_Trust_Science_Trust_Medicine.mat','beta_z_Medicine','Factor_S');
    beta_z=beta_z_Medicine(Rand_Trust_M(1),:);
    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},County_ID,Rand_Indx,Rand_Trust_S(2),Rand_Trust_M(2));

    X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));

    for jj=1:length(Factor_S)        
        [~,County_Trust_in_Medicine_v,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},County_ID,Rand_Indx,Rand_Trust_S(2),Rand_Trust_M(2));
        X_t(jj,:,:)=County_Trust_in_Medicine_v;
        for yy=1:length(Data_Year)
            tt=squeeze(X_t(jj,:,yy));
            X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
        end
    end
    [~,County_Trust_in_Medicine_v]=County_Trust_Overall(beta_z,X_t);
    
    for ii=1:length(County_ID)
        z_t=log(County_Trust_in_Medicine_v(ii,:)./(1-County_Trust_in_Medicine_v(ii,:)));
        z_new=pchip(Data_Year,z_t,Year_Q);
        t_new=1./(1+exp(-z_new));
        County_Factor_v(ii)=t_new;
    end 
elseif(strcmp(Var_Name,'Trust_in_Science'))
    load('Estimate_LR_Trust_Science_Trust_Medicine.mat','beta_z_Science','Factor_S');
    beta_z=beta_z_Science(Rand_Trust_S(1),:);
    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},County_ID,Rand_Indx,Rand_Trust_S(2),Rand_Trust_M(2));

    X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));

    for jj=1:length(Factor_S)        
        [County_Trust_in_Science_v,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},County_ID,Rand_Indx,Rand_Trust_S(2),Rand_Trust_M(2));
        X_t(jj,:,:)=County_Trust_in_Science_v;
        for yy=1:length(Data_Year)
            tt=squeeze(X_t(jj,:,yy));
            X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
        end
    end
    [~,County_Trust_in_Science_v]=County_Trust_Overall(beta_z,X_t);
    
    for ii=1:length(County_ID)
        z_t=log(County_Trust_in_Science_v(ii,:)./(1-County_Trust_in_Science_v(ii,:)));
        z_new=pchip(Data_Year,z_t,Year_Q);
        t_new=1./(1+exp(-z_new));
        County_Factor_v(ii)=t_new;
    end 
end
% elseif(strcmp(Var_Name,'COVID_Vaccination_Hesitancy'))
%    load([pwd '\State_Data\COVID_Vaccine_Hesitant_County.mat'],'COVID_Vac'); 
%    hs=COVID_Vac.strongly_hesitant+0.5.*COVID_Vac.hesitant_unsure;
%    for jj=1:length(County_Factor_v)
%        tf=COVID_Vac.fips==County_ID(jj);
%        County_Factor_v(jj)=mean(hs(tf));
%    end
% elseif(strcmp(Var_Name,'MMR_Benefit_Political'))
%     [County_Demo,Data_Year]=Demographics_County('Political',County_ID,Rand_Indx);
%     z_temp=log(County_Demo./(1-County_Demo));
%     for jj=1:length(County_ID)
%         z_new=pchip(Data_Year,z_temp(jj,:),Year_Q);
%         County_Factor_v(jj)=1./(1+exp(-z_new));
%     end
%     vb_demo=1./(1+exp(-pchip([2019 2022],log([0.88 0.91]./(1-[0.88 0.91])),Year_Q)));
%     vb_rep=1./(1+exp(-pchip([2019 2022],log([0.89 0.83]./(1-[0.89 0.83])),Year_Q)));
%     County_Factor_v=vb_demo.*County_Factor_v+vb_rep.*(1-County_Factor_v);
% elseif(strcmp(Var_Name,'MMR_Benefit_COVID_Vaccination'))
%    if(Year_Q==2020)
%         load([pwd '\State_Data\County_Data\COVID_County_Uptake.mat'],'fip_2020','Vac_Cov_2020')
%         temp_sid=str2double(fip_2020); 
%         for jj=1:length(County_ID)
%             tf= temp_sid== County_ID(jj);
%             if(sum(tf)>0)
%                 County_Factor_v(jj)=max(Vac_Cov_2020(tf));
%             end
%         end
%    elseif(Year_Q==2021)
%        load([pwd '\State_Data\County_Data\COVID_County_Uptake.mat'],'fip_2021','Vac_Cov_2021')
%         temp_sid=str2double(fip_2021); 
%         for jj=1:length(County_ID)
%             tf= temp_sid== County_ID(jj);
%             if(sum(tf)>0)
%                 County_Factor_v(jj)=max(Vac_Cov_2021(tf));
%             end
%         end
%    else
%        load([pwd '\State_Data\County_Data\COVID_County_Uptake.mat'],'fip_2022','Vac_Cov_2022')
%        temp_sid=str2double(fip_2022); 
%         for jj=1:length(County_ID)
%             tf= temp_sid== County_ID(jj);
%             if(sum(tf)>0)
%                 County_Factor_v(jj)=max(Vac_Cov_2022(tf)./100);
%             end
%         end
%    end
%     County_Factor_v=0.91.*County_Factor_v+0.7.*(1-County_Factor_v);
% elseif(strcmp(Var_Name,'Political_COVID_Skeptic'))
%     load([pwd '\State_Data\County_Precision_Health_2022.mat'],'County_Health_Factor_Political','Data_CID','Factor_S');        
%     for jj=1:length(County_ID)
%         County_Factor_v(jj)=County_Health_Factor_Political(Data_CID==County_ID(jj),strcmp('COVID Skeptic',Factor_S));
%     end
% elseif(strcmp(Var_Name,'Race_COVID_Skeptic'))
%     load([pwd '\State_Data\County_Precision_Health_2022.mat'],'County_Health_Factor_Race','Data_CID','Factor_S');
%     for jj=1:length(County_ID)
%         County_Factor_v(jj)=County_Health_Factor_Race(Data_CID==County_ID(jj),strcmp('COVID Skeptic',Factor_S));
%     end
% elseif(strcmp(Var_Name,'Political_System_Distruster'))
%     load([pwd '\State_Data\County_Precision_Health_2022.mat'],'County_Health_Factor_Political','Data_CID','Factor_S');        
%     for jj=1:length(County_ID)
%         County_Factor_v(jj)=County_Health_Factor_Political(Data_CID==County_ID(jj),strcmp('System Distruster',Factor_S));
%     end
% elseif(strcmp(Var_Name,'Race_System_Distruster'))
%     load([pwd '\State_Data\County_Precision_Health_2022.mat'],'County_Health_Factor_Race','Data_CID','Factor_S');
%     for jj=1:length(County_ID)
%         County_Factor_v(jj)=County_Health_Factor_Race(Data_CID==County_ID(jj),strcmp('System Distruster',Factor_S));
%     end
% elseif(strcmp(Var_Name,'Parental_Trust_in_Medicine'))
%     load('Estimate_LR_Trust_Medicine_Age.mat','beta_z','Factor_S');
%     [~,Data_Year]=Stratified_Trust_in_Medicine_County(Factor_S{1},County_ID,Rand_Indx);
% 
%     X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));
% 
%     for jj=1:length(Factor_S)        
%         [County_Trust_in_Medicine_v,Data_Year]=Stratified_Trust_in_Medicine_County(Factor_S{jj},County_ID,Rand_Indx);
%         X_t(jj,:,:)=County_Trust_in_Medicine_v;
%         for yy=1:length(Data_Year)
%             tt=squeeze(X_t(jj,:,yy));
%             X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
%         end
%     end
%     [~,County_Trust_in_Medicine_v]=County_Trust_Overall(beta_z,X_t);
%     
%     for ii=1:length(County_ID)
%         z_t=log(County_Trust_in_Medicine_v(ii,:)./(1-County_Trust_in_Medicine_v(ii,:)));
%         z_new=pchip(Data_Year,z_t,Year_Q);
%         t_new=1./(1+exp(-z_new));
%         County_Factor_v(ii)=t_new;
%     end 
% elseif(strcmp(Var_Name,'Parental_Trust_in_Science'))
%     load('Estimate_LR_Trust_Science_Age.mat','beta_z','Factor_S');
%     [~,Data_Year]=Stratified_Trust_in_Science_County(Factor_S{1},County_ID,Rand_Indx);
% 
%     X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));
% 
%     for jj=1:length(Factor_S)        
%         [County_Trust_in_Science_v,Data_Year]=Stratified_Trust_in_Science_County(Factor_S{jj},County_ID,Rand_Indx);
%         X_t(jj,:,:)=County_Trust_in_Science_v;
%         for yy=1:length(Data_Year)
%             tt=squeeze(X_t(jj,:,yy));
%             X_t(jj,isnan(tt),yy)=median(tt(~isnan(tt)));
%         end
%     end
%     [~,County_Trust_in_Science_v]=County_Trust_Overall(beta_z,X_t);
%     
%     for ii=1:length(County_ID)
%         z_t=log(County_Trust_in_Science_v(ii,:)./(1-County_Trust_in_Science_v(ii,:)));
%         z_new=pchip(Data_Year,z_t,Year_Q);
%         t_new=1./(1+exp(-z_new));
%         County_Factor_v(ii)=t_new;
%     end 
% elseif(strcmp(Var_Name,'Vaccine_Adverse_Events'))
%     [County_Factor_v]=Estimate_Vaccine_Adverese_Events(County_ID,Year_Q);
% elseif(strcmp(Var_Name,'Primary Physician')||strcmp(Var_Name,'Nurses')||strcmp(Var_Name,'Doctors')||strcmp(Var_Name,'Healthcare System')||strcmp(Var_Name,'Pharmaceutical Companies')||strcmp(Var_Name,'Government Health Agencies')||strcmp(Var_Name,'Treatment recommendations')||strcmp(Var_Name,'Book follow-up'))
%     [County_Factor_v]=Stratified_Trust_in_Healthcare_2021(Var_Name,County_ID,Rand_Indx);
% end
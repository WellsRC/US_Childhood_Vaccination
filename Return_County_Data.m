function County_Factor_v=Return_County_Data(Var_Name,Year_Q,County_ID)

Immunization_Variables={'All_immunizations','Medical_Exemption','Religious_Exemption','Philosophical_Exemption','DTaP','Polio','MMR','VAR'};
County_Factor_v=NaN.*zeros(length(County_ID),1);
if(sum(strcmp(Var_Name,Immunization_Variables))>0)
    County_Factor_v=County_Immunization_Statistics(Var_Name,Year_Q,County_ID);
elseif(strcmp(Var_Name,'Trust_in_Medicine'))
    load('Estimate_LR_Trust_Science_Trust_Medicine.mat','beta_z_Medicine','Factor_S');
    beta_z=beta_z_Medicine;
    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},County_ID);

    X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));

    for jj=1:length(Factor_S)        
        [~,County_Trust_in_Medicine_v,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},County_ID);
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
    beta_z=beta_z_Science;
    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},County_ID);

    X_t=zeros(length(Factor_S),length(County_ID),length(Data_Year));

    for jj=1:length(Factor_S)        
        [County_Trust_in_Science_v,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{jj},County_ID);
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
end
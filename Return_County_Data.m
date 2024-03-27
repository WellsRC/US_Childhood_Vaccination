function County_Factor_v=Return_County_Data(Var_Name,Year_Q,County_ID)

Immunization_Variables={'All_immunizations','Medical_Exemption','Religious_Exemption','Philosophical_Exemption','DTaP','Polio','MMR','VAR'};

if(sum(strcmp(Var_Name,Immunization_Variables))>0)
    County_Factor_v=County_Immunization_Statistics(Var_Name,Year_Q,County_ID);
elseif(strcmp(Var_Name,'Trust_in_Medicine'))
    [county_weight]=Return_Population_Weight_County();

    load('Parameters_Trust_In_Medicine.mat','beta_z_Medicine','Factor_S');
    pop_interest.level='County';
    pop_interest.ID=County_ID;

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
    
    County_Factor_v=Overall_State_County_Trust(county_weight,X_t,beta_z_Medicine,pop_interest,Year_Q);    
       
elseif(strcmp(Var_Name,'Trust_in_Science'))
    [county_weight]=Return_Population_Weight_County();

    load('Parameters_Trust_In_Science.mat','beta_z_Science','Factor_S');
    pop_interest.level='County';
    pop_interest.ID=County_ID;

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

    County_Factor_v=Overall_State_County_Trust(county_weight,X_t,beta_z_Science,pop_interest,Year_Q);    
    
end
end
function State_Factor_v=Return_State_Trust_Data_Randomized(Var_Name,Year_Q,State_ID,Samp_Size)

if(strcmp(Var_Name,'Trust_in_Medicine'))
    [county_weight]=Return_Population_Weight_County();

    load('Parameters_Trust_In_Medicine.mat','beta_z_Medicine','Factor_M');
    pop_interest.level='State';
    pop_interest.ID=State_ID;

    temp_County_ID=zeros(sum(ismember(county_weight.State_ID,State_ID)),1);
    counter_state=1;
    for ss=1:length(State_ID)
        tf=county_weight.State_ID==State_ID(ss);
        temp_County_ID(counter_state:(counter_state+sum(tf)-1))=county_weight.County_ID(tf);
        counter_state=counter_state+sum(tf);
    end

    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_M{1},temp_County_ID);

    X_t=zeros(length(Factor_M),length(temp_County_ID),length(Data_Year),Samp_Size);

    for jj=1:length(Factor_M)        
        [~,County_Trust_in_Medicine_v,~]=Stratified_Trust_in_Science_Medicine_County_Random_Sample(Factor_M{jj},temp_County_ID,Samp_Size);
        X_t(jj,:,:,:)=County_Trust_in_Medicine_v;
    end

    State_Factor_v=zeros(length(State_ID),length(Year_Q),Samp_Size);
    for ss=1:Samp_Size
        State_Factor_v(:,:,ss)=Overall_State_County_Trust(county_weight,squeeze(X_t(:,:,:,ss)),beta_z_Medicine,pop_interest,Year_Q);  
    end
        
elseif strcmp(Var_Name,'Trust_in_Science')
    [county_weight]=Return_Population_Weight_County();

    load('Parameters_Trust_In_Science.mat','beta_z_Science','Factor_S');
    pop_interest.level='State';
    pop_interest.ID=State_ID;

    temp_County_ID=zeros(sum(ismember(county_weight.State_ID,State_ID)),1);
    counter_state=1;
    for ss=1:length(State_ID)
        tf=county_weight.State_ID==State_ID(ss);
        temp_County_ID(counter_state:(counter_state+sum(tf)-1))=county_weight.County_ID(tf);
        counter_state=counter_state+sum(tf);
    end
    
    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},temp_County_ID);

    X_t=zeros(length(Factor_S),length(temp_County_ID),length(Data_Year),Samp_Size);

    for jj=1:length(Factor_S)        
        [County_Trust_in_Science_v,~,~]=Stratified_Trust_in_Science_Medicine_County_Random_Sample(Factor_S{jj},temp_County_ID,Samp_Size);
        X_t(jj,:,:,:)=County_Trust_in_Science_v;
    end
    
    State_Factor_v=zeros(length(State_ID),length(Year_Q),Samp_Size);
    for ss=1:Samp_Size
        State_Factor_v(:,:,ss)=Overall_State_County_Trust(county_weight,squeeze(X_t(:,:,:,ss)),beta_z_Science,pop_interest,Year_Q);  
    end 
elseif(strcmp(Var_Name,'Parental_Trust_in_Medicine'))
    [county_weight]=Return_Population_Weight_County();
    county_weight.Trust_Computation=county_weight.Trust_Computation(:,:,1:2,:,:);
    load('Parameters_Trust_In_Medicine.mat','beta_z_Medicine','Factor_M');
    pop_interest.level='State';
    pop_interest.ID=State_ID;

    temp_County_ID=zeros(sum(ismember(county_weight.State_ID,State_ID)),1);
    counter_state=1;
    for ss=1:length(State_ID)
        tf=county_weight.State_ID==State_ID(ss);
        temp_County_ID(counter_state:(counter_state+sum(tf)-1))=county_weight.County_ID(tf);
        counter_state=counter_state+sum(tf);
    end

    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_M{1},temp_County_ID);

    X_t=zeros(length(Factor_M),length(temp_County_ID),length(Data_Year),Samp_Size);

    for jj=1:length(Factor_M)        
        [~,County_Trust_in_Medicine_v,~]=Stratified_Trust_in_Science_Medicine_County_Random_Sample(Factor_M{jj},temp_County_ID,Samp_Size);
        X_t(jj,:,:,:)=County_Trust_in_Medicine_v;
    end
    
    State_Factor_v=zeros(length(State_ID),length(Year_Q),Samp_Size);
    for ss=1:Samp_Size
        State_Factor_v(:,:,ss)=Overall_State_County_Trust_Parental(county_weight,squeeze(X_t(:,:,:,ss)),beta_z_Medicine,pop_interest,Year_Q);  
    end
        
elseif strcmp(Var_Name,'Parental_Trust_in_Science')
    [county_weight]=Return_Population_Weight_County();
    county_weight.Trust_Computation=county_weight.Trust_Computation(:,:,1:2,:,:);
    load('Parameters_Trust_In_Science.mat','beta_z_Science','Factor_S');
    pop_interest.level='State';
    pop_interest.ID=State_ID;

    temp_County_ID=zeros(sum(ismember(county_weight.State_ID,State_ID)),1);
    counter_state=1;
    for ss=1:length(State_ID)
        tf=county_weight.State_ID==State_ID(ss);
        temp_County_ID(counter_state:(counter_state+sum(tf)-1))=county_weight.County_ID(tf);
        counter_state=counter_state+sum(tf);
    end
    
    [~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_S{1},temp_County_ID);

    X_t=zeros(length(Factor_S),length(temp_County_ID),length(Data_Year),Samp_Size);

    for jj=1:length(Factor_S)        
        [County_Trust_in_Science_v,~,~]=Stratified_Trust_in_Science_Medicine_County_Random_Sample(Factor_S{jj},temp_County_ID,Samp_Size);
        X_t(jj,:,:,:)=County_Trust_in_Science_v;
    end
    

    State_Factor_v=zeros(length(State_ID),length(Year_Q),Samp_Size);
    for ss=1:Samp_Size
        State_Factor_v(:,:,ss)=Overall_State_County_Trust_Parental(county_weight,squeeze(X_t(:,:,:,ss)),beta_z_Science,pop_interest,Year_Q);  
    end  
    
end
function [Trust_in_Medicine_State,Parental_Trust_in_Medicine_State,Trust_in_Science_State,Parental_Trust_in_Science_State,Trust_in_Medicine_County,Parental_Trust_in_Medicine_County,Trust_in_Science_County,Parental_Trust_in_Science_County,temp_County_ID]=Return_Trust_Data_Randomized_BN(Year_Q,State_ID,Samp_Size)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trust in Medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[county_weight]=Return_Population_Weight_County();

load('Parameters_Trust_In_Medicine.mat','beta_z_Medicine','Factor_M');
pop_interest.level='State';
pop_interest.ID=State_ID;

load('Parameters_Trust_In_Science.mat','beta_z_Science');

temp_County_ID=zeros(sum(ismember(county_weight.State_ID,State_ID)),1);
counter_state=1;
for ss=1:length(State_ID)
    tf=county_weight.State_ID==State_ID(ss);
    temp_County_ID(counter_state:(counter_state+sum(tf)-1))=county_weight.County_ID(tf);
    counter_state=counter_state+sum(tf);
end

cpop_interest.level='County';
cpop_interest.ID=temp_County_ID;

[~,~,Data_Year]=Stratified_Trust_in_Science_Medicine_County(Factor_M{1},temp_County_ID);

S_t=zeros(length(Factor_M),length(temp_County_ID),length(Data_Year),Samp_Size);
M_t=zeros(length(Factor_M),length(temp_County_ID),length(Data_Year),Samp_Size);

for jj=1:length(Factor_M)        
    [County_Trust_in_Science_v,County_Trust_in_Medicine_v,~]=Stratified_Trust_in_Science_Medicine_County_Random_Sample(Factor_M{jj},temp_County_ID,Samp_Size);
    M_t(jj,:,:,:)=County_Trust_in_Medicine_v;
    S_t(jj,:,:,:)=County_Trust_in_Science_v;
end

Trust_in_Medicine_State=zeros(length(State_ID),length(Year_Q),Samp_Size);
Parental_Trust_in_Medicine_State=zeros(length(State_ID),length(Year_Q),Samp_Size);

Trust_in_Science_State=zeros(length(State_ID),length(Year_Q),Samp_Size);
Parental_Trust_in_Science_State=zeros(length(State_ID),length(Year_Q),Samp_Size);

Trust_in_Medicine_County=zeros(length(temp_County_ID),length(Year_Q),Samp_Size);
Parental_Trust_in_Medicine_County=zeros(length(temp_County_ID),length(Year_Q),Samp_Size);

Trust_in_Science_County=zeros(length(temp_County_ID),length(Year_Q),Samp_Size);
Parental_Trust_in_Science_County=zeros(length(temp_County_ID),length(Year_Q),Samp_Size);

for ss=1:Samp_Size
    Trust_in_Medicine_State(:,:,ss)=Overall_State_County_Trust(county_weight,squeeze(M_t(:,:,:,ss)),beta_z_Medicine,pop_interest,Year_Q); 
    Parental_Trust_in_Medicine_State(:,:,ss)=Overall_State_County_Trust_Parental(county_weight,squeeze(M_t(:,:,:,ss)),beta_z_Medicine,pop_interest,Year_Q);  

    Trust_in_Science_State(:,:,ss)=Overall_State_County_Trust(county_weight,squeeze(S_t(:,:,:,ss)),beta_z_Science,pop_interest,Year_Q); 
    Parental_Trust_in_Science_State(:,:,ss)=Overall_State_County_Trust_Parental(county_weight,squeeze(S_t(:,:,:,ss)),beta_z_Science,pop_interest,Year_Q);  


    Trust_in_Medicine_County(:,:,ss)=Overall_State_County_Trust(county_weight,squeeze(M_t(:,:,:,ss)),beta_z_Medicine,cpop_interest,Year_Q); 
    Parental_Trust_in_Medicine_County(:,:,ss)=Overall_State_County_Trust_Parental(county_weight,squeeze(M_t(:,:,:,ss)),beta_z_Medicine,cpop_interest,Year_Q);  

    Trust_in_Science_County(:,:,ss)=Overall_State_County_Trust(county_weight,squeeze(S_t(:,:,:,ss)),beta_z_Science,cpop_interest,Year_Q); 
    Parental_Trust_in_Science_County(:,:,ss)=Overall_State_County_Trust_Parental(county_weight,squeeze(S_t(:,:,:,ss)),beta_z_Science,cpop_interest,Year_Q);  

end
      
end
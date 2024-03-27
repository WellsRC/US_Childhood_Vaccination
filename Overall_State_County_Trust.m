function Overall_Trust = Overall_State_County_Trust(county_weight,X_t,beta_all,pop_interest,yr_interest)

Trust_Stratified=Trust_Stratefied_County(county_weight,X_t,beta_all);

if(strcmp(pop_interest.level,'State'))
    ID=county_weight.State_ID;
else
    ID=county_weight.County_ID;
end

Overall_Trust=zeros(length(pop_interest.ID),length(county_weight.year));

for jj=1:length(pop_interest.ID)
    id_temp=pop_interest.ID(jj)==ID;
    Overall_Trust(jj,:)=sum(county_weight.Trust_Computation(id_temp,:,:,:,:).*Trust_Stratified(id_temp,:,:,:,:),[1 3 4 5])./sum(county_weight.Trust_Computation(id_temp,:,:,:,:),[1 3 4 5]);
end

Overall_Trust=Overall_Trust(:,ismember(county_weight.year,yr_interest));
end


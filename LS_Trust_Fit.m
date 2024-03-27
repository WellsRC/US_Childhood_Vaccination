function F=LS_Trust_Fit(x,Z,X_t,county_weight,indx,opt_a)


beta_temp=reshape(x,length(x)./(1+size(X_t,1)),1+size(X_t,1));

beta_all=zeros(24,4);
for jj=1:length(indx)
    beta_all(indx(jj),:)=beta_temp(jj,:);
end
Trust_Stratified=Trust_Stratefied_County(county_weight,X_t,beta_all);

[Trust]=Trust_Categories(county_weight,Trust_Stratified);

F=100.*[Z.white-log(Trust.White./(1-Trust.White));
Z.black-log(Trust.Black./(1-Trust.Black));
Z.other-log(Trust.Other./(1-Trust.Other));
Z.male-log(Trust.Male./(1-Trust.Male));
Z.female-log(Trust.Female./(1-Trust.Female));
Z.Age_18_34-log(Trust.Age_18_34./(1-Trust.Age_18_34));
Z.Age_35_49-log(Trust.Age_35_49./(1-Trust.Age_35_49));
Z.Age_50_64-log(Trust.Age_50_64./(1-Trust.Age_50_64));
Z.Age_65_plus-log(Trust.Age_65_plus./(1-Trust.Age_65_plus));
Z.national-log(Trust.National./(1-Trust.National))];

F=F(:);

F(isnan(F) | isinf(F))=10^6;
if(opt_a)
    F=sqrt(sum(F.^2));
end

end
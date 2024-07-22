function F=LS_Trust_Fit(x,Y_t,Err,X_t,county_weight,indx)


beta_temp=reshape(x,length(x)./(1+size(X_t,1)),1+size(X_t,1));

beta_all=zeros(24,4);
for jj=1:length(indx)
    beta_all(indx(jj),:)=beta_temp(jj,:);
end
Trust_Stratified=Trust_Stratefied_County(county_weight,X_t,beta_all);

[Trust]=Trust_Categories(county_weight,Trust_Stratified);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% Race
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% White
L_W=log(normpdf(Y_t.White,Trust.White,Err.White));

% Black
L_B=log(normpdf(Y_t.Black,Trust.Black,Err.Black));

% Other
L_O=log(normpdf(Y_t.Other,Trust.Other,Err.Other));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% Sex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% Male
L_M=log(normpdf(Y_t.Male,Trust.Male,Err.Male));

% Black
L_F=log(normpdf(Y_t.Female,Trust.Female,Err.Female));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% Age
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
% Age_18_34
L_18_34=log(normpdf(Y_t.Age_18_34,Trust.Age_18_34,Err.Age_18_34));

% Age_35_49
L_35_49=log(normpdf(Y_t.Age_35_49,Trust.Age_35_49,Err.Age_35_49));

% Age_50_64
L_50_64=log(normpdf(Y_t.Age_50_64,Trust.Age_50_64,Err.Age_50_64));

% Age_65_plus
L_65_plus=log(normpdf(Y_t.Age_65_plus,Trust.Age_65_plus,Err.Age_65_plus));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% National
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L_National=log(normpdf(Y_t.National,Trust.National,Err.National));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Total Likelihood
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F=sum(L_W(:))+sum(L_B(:))+sum(L_O(:))+sum(L_M(:))+sum(L_F(:))+sum(L_18_34(:))+sum(L_35_49(:))+sum(L_50_64(:))+sum(L_65_plus(:))+sum(L_National(:));

% Since optimization looks for minimum and we want to max likelihood
F=-F;

end
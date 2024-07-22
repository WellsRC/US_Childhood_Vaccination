function L=Objective_Function_Polynomial_Trend(x,a_beta_trim,b_beta_trim,Yr_trim)

Z=zeros(size(Yr_trim));

for ii=1:length(x)
    Z=Z+x(ii).*Yr_trim.^(ii-1);
end

V=1./(1+exp(-Z));

L=-sum(log(betapdf(V(:),a_beta_trim(:),b_beta_trim(:))));
end
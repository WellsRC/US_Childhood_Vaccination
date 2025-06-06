function v = Estimated_County_Vaccine_Uptake(beta_X,X)

z=[ones(size(X,1),1) X]*beta_X(:);
v=1./(1+exp(-z));

end


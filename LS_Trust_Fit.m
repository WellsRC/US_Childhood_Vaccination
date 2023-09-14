function F=LS_Trust_Fit(x,Z_t,X_t,w_c)

beta_z=x;
[Z_est,~]=National_Level_Confidence(beta_z,w_c,X_t);
F=Z_t(:)-Z_est(:);


end
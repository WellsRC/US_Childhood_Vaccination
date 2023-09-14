function [Z_est,V_est]=National_Level_Confidence(beta_z,w_c,X_t)


[~,v_t]=County_Trust_Overall(beta_z,X_t);

V_est=sum(v_t.*w_c,1);
Z_est=log(V_est./(1-V_est));

end
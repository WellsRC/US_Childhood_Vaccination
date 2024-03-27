function [z_t,v_t]=Compute_County_Trust_Stratified(beta_z,X_t)
    z_t=beta_z(1).*ones(size(X_t,2),size(X_t,3));
    for jj=1:size(X_t,1)
       z_t=z_t+beta_z(1+jj).*squeeze(X_t(jj,:,:)); 
    end

    v_t=1./(1+exp(-z_t));
end
function dvdm = Trust_Medicine_Influence_Uptake(v,m,beta_m,beta_ms,beta_s)
    dvdm=(beta_s.*beta_ms+beta_m).*(v(:).*(1-v(:))./(m(:).*(1-m(:))));
end


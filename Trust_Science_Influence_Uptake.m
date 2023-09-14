function dvds = Trust_Science_Influence_Uptake(v,s,beta_s)
    dvds=beta_s.*(v(:).*(1-v(:))./(s(:).*(1-s(:))));
end


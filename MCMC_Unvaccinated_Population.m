function Number_Unvaccinated_Samp=MCMC_Unvaccinated_Population(Total_Unvaccinated,Total_Population,indx_Population)
    
    
    dX=Total_Population-floor(Total_Population);
    q=Total_Unvaccinated./sum(Total_Population);
    dV=2.*q.*rand(size(dX)).*dX;
    Int_Total_Unvaccinated=floor(Total_Unvaccinated-sum(dV));

    res_v=Total_Unvaccinated-Int_Total_Unvaccinated;
    scf=res_v./sum(dV);
    Number_Unvaccinated_Samp=scf.*dV(:);

    samp_pop=randsample(indx_Population,Int_Total_Unvaccinated);
    [N] = histcounts(samp_pop,[0.5:length(Total_Population)+0.5]);
    Number_Unvaccinated_Samp=Number_Unvaccinated_Samp(:)+N(:);
end
function F = Objective_Function_Cluster_Circle(e_par,d,Number_Unvaccinated,Total_Population)
r=10.^e_par(1);

% ee which points fall within the radius of the circle
f_region=d<=r;

c_z=sum(Number_Unvaccinated(f_region));
n_z=sum(Total_Population(f_region));

c_out=sum(Number_Unvaccinated(~f_region));
n_out=sum(Total_Population(~f_region));

c_tot=sum(Number_Unvaccinated);
n_tot=sum(Total_Population);

if(c_z/n_z>c_out/n_out)
    LL=c_z.*(log(c_z)-log(n_z))+(n_z-c_z).*(log((n_z-c_z))-log(n_z))+c_out.*(log(c_out)-log(n_out))+(n_out-c_out).*(log((n_out-c_out))-log(n_out));
else
    LL=c_tot.*log(c_tot)+(n_tot-c_tot).*log(n_tot-c_tot)-n_tot.*log(n_tot);
end

F=-LL;
end


function F = Objective_Function_Cluster_Cylinder(e_par,d,Number_Unvaccinated,Total_Population)
r=10.^e_par(1);
if(length(e_par)>2)
    time_0=e_par(2);
    time_end=e_par(3);
else
    time_0=1;
    time_end=e_par(end);
end
% ee which points fall within the radius of the circle
f_region=d<=r;

c_z=sum(Number_Unvaccinated(f_region,:),1);
n_z=sum(Total_Population(f_region,:),1);

c_z=sum(c_z(time_0:time_end));
n_z=sum(n_z(time_0:time_end));

c_tot=sum(Number_Unvaccinated);
n_tot=sum(Total_Population);

c_out=c_tot-c_z;
n_out=n_tot-n_z;

if(c_z/n_z>c_out/n_out)
    LL=c_z.*(log(c_z)-log(n_z))+(n_z-c_z).*(log((n_z-c_z))-log(n_z))+c_out.*(log(c_out)-log(n_out))+(n_out-c_out).*(log((n_out-c_out))-log(n_out));
else
    LL=c_tot.*log(c_tot)+(n_tot-c_tot).*log(n_tot-c_tot)-n_tot.*log(n_tot);
end

F=-LL;
end


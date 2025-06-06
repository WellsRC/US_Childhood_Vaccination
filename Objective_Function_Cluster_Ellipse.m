function F = Objective_Function_Cluster_Ellipse(e_par,geo_Lon,geo_Lat,Pop_Lon,Pop_Lat,Number_Unvaccinated,Total_Population)
a=10.^e_par(1);
b=10.^e_par(2);
theta_rot=e_par(3);
x0=e_par(4);
y0=e_par(5);

[p_in,p_on]=inpolygon(x0,y0,geo_Lon,geo_Lat);
if(p_in||p_on)
    [x_new,y_new] = Unvaccinated_Patch(a,b,theta_rot,x0,y0);
    [p_in,p_on]=inpolygon(Pop_Lon,Pop_Lat,x_new,y_new);
    
    x=double(p_in|p_on);
    
    c_z=sum(Number_Unvaccinated(x==1));
    n_z=sum(Total_Population(x==1));
    
    c_out=sum(Number_Unvaccinated(x==0));
    n_out=sum(Total_Population(x==0));
    
    c_tot=sum(Number_Unvaccinated);
    n_tot=sum(Total_Population);

    if(c_z/n_z>c_out/n_out)
        LL=c_z.*(log(c_z)-log(n_z))+(n_z-c_z).*(log((n_z-c_z))-log(n_z))+c_out.*(log(c_out)-log(n_out))+(n_out-c_out).*(log((n_out-c_out))-log(n_out));
    else
        LL=c_tot.*log(c_tot)+(n_tot-c_tot).*log(n_tot-c_tot)-n_tot.*log(n_tot);
    end

    F=-LL;
else
    F=Inf;
end
end


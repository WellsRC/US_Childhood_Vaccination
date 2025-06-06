function [x_new,y_new,poly_new] = Unvaccinated_Patch(a,b,theta_rot,x0,y0)
theta_p=linspace(0,2*pi,1001);
x=a.*cos(theta_p(:));
y=b.*sin(theta_p(:));
temp=[x y]*[cos(theta_rot) sin(theta_rot); -sin(theta_rot) cos(theta_rot)];
x_new=temp(:,1)+x0;
y_new=temp(:,2)+y0;

poly_new=polyshape(x_new,y_new);
end


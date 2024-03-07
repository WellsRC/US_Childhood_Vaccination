function V_lin=Construct_Line(pts,Yr,Yr_ref)

V_lin=zeros(size(Yr));
m1=(pts(2)-pts(1))./(Yr_ref-Yr(1));
m2=(pts(3)-pts(2))./(Yr(end)-Yr_ref);

y1=m1.*(Yr(Yr<=Yr_ref)-Yr(1))+pts(1);
y2=m2.*(Yr(Yr>Yr_ref)-Yr_ref)+pts(2);

V_lin(Yr<=Yr_ref)=y1;
V_lin(Yr>Yr_ref)=y2;

end
function [m_slope,pts]=Estimate_Slopes(Yr,V,Yr_ref)

[pts]=fmincon(@(x)mean((V-Construct_Line(x,Yr,Yr_ref)).^2),[V(1) V(Yr==Yr_ref) V(end)],[],[],[],[],[0 0 0],[1 1 1]);

m_slope=[(pts(2)-pts(1))./(Yr_ref-Yr(1)) (pts(3)-pts(2))./(Yr(end)-Yr_ref)];

end
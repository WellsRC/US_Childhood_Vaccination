function V_lin=Construct_Line(m_slope,peak_pt,Yr,Yr_ref)

V_lin=zeros(size(Yr));

y1=m_slope(1).*(Yr(Yr<=Yr_ref)-Yr_ref)+peak_pt;
y2=m_slope(2).*(Yr(Yr>Yr_ref)-Yr_ref)+peak_pt;

V_lin(Yr<=Yr_ref)=y1;
V_lin(Yr>Yr_ref)=y2;

end
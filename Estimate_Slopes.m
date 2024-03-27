function J=Estimate_Slopes(par_est,V,Yr)

m_slope=reshape(par_est(1:2.*size(V,1)),size(V,1),2);
peak_point=reshape(par_est(2.*size(V,1)+[1:size(V,1)]),size(V,1),1);
Year_Inflection=par_est(end);

J=zeros(size(V));
for jj=1:size(V,1)
    J(jj,:)=Construct_Line(m_slope(jj,:),peak_point(jj),Yr,Year_Inflection)-V(jj,:);
end
J(isnan(J))=0;
end
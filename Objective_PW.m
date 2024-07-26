function L=Objective_PW(x,Yp,Yr,trust_samp)

if(length(x)==2)
    m=x(1);
    b=x(2);

    T=m.*(Yr-Yp)+b;
else
    m1=x(1);
    m2=x(2);
    b=x(3);

    T=m1.*(Yr-Yp)+b;
    T(Yr>Yp)=m2.*(Yr(Yr>Yp)-Yp)+b;
end

T(T<=10^(-16))=10^(-16);
T(T>=1-10^(-16))=1-10^(-16);

std_est=std(log(trust_samp./(1-trust_samp)),1);

L=zeros(size(trust_samp));
z=log(trust_samp./(1-trust_samp));
for ss=1:size(trust_samp,1)
    L(ss,:)=log(normpdf(z(ss,:),log(T./(1-T)),std_est));
end

L=-sum(L(:));



end
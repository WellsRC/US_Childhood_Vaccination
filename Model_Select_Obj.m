function F=Model_Select_Obj(x,Z,XT,Cov_INDX,Indx_train,Indx_val,kfv)
Xtemp=XT(:,x==1);
Xtemp=[Z Xtemp];
F2=zeros(kfv,1);
for kk=1:kfv
    Y_T=Xtemp(Indx_train{kk},:);
    COVID_T=Cov_INDX(Indx_train{kk});

    Y_V=Xtemp(Indx_val{kk},:);
    COVID_V=Cov_INDX(Indx_val{kk});
    
    M_pre=mean(Y_T(COVID_T==0,:),1);
    M_pan=mean(Y_T(COVID_T==1,:),1);

    C_pre=cov(Y_T(COVID_T==0,:),1);
    C_pan=cov(Y_T(COVID_T==1,:),1);

    Y_V_pre=Y_V(COVID_V==0,:);
    Y_V_pan=Y_V(COVID_V==1,:);

    F2(kk)=sum(log(mvnpdf(Y_V_pre,M_pre,C_pre)))+sum(log(mvnpdf(Y_V_pan,M_pan,C_pan)));

end

F=-mean(F2);


end
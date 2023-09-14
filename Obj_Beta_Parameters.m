function L=Obj_Beta_Parameters(x,y_t,x_V)

beta_v=x(1:15)';

X=[ones(length(y_t),1) x_V];
a=10.^x(16);
b=exp(-X*beta_v);

L=-sum(log(betapdf(y_t(:),a,b)));

end
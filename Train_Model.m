function F=Train_Model(x,X_temp,Xc_temp,Y_State,County_Weight,temp_yr,Data_Yr_County,Per_Sampled,a_beta,b_beta)

Est_State=X_temp*(x');

uy=unique(Data_Yr_County);
Est_County=[];
for jj=1:length(County_Weight)
    X=Xc_temp(uy(jj)==Data_Yr_County,:);
    w=County_Weight{jj};

    z_temp=X*(x');
    v_temp=1./(1+exp(-z_temp));
    v_state_temp=w*v_temp;
    v_state_temp(v_state_temp>=1)=1-10^(-8);
    v_state_temp(v_state_temp<=0)=10^(-8); 
    y_new=log(v_state_temp./(1-v_state_temp));    
    Est_County=[Est_County;y_new];
end

Est_County=Est_County(temp_yr);

F_State=zeros(size(Est_State));
F_County=zeros(size(Est_County));
for ss=1:length(Y_State)
    if(Per_Sampled(ss)<1)
        NF=betacdf(1-10^(-8),a_beta(ss),b_beta(ss))-betacdf(10^(-8),a_beta(ss),b_beta(ss));
        F_State(ss)=integral(@(v)betapdf(v,a_beta(ss),b_beta(ss)).*((Est_State(ss)-log(v./(1-v))).^2),10^(-8),1-10^(-8))./NF;
        F_County(ss)=integral(@(v)betapdf(v,a_beta(ss),b_beta(ss)).*((Est_County(ss)-log(v./(1-v))).^2),10^(-8),1-10^(-8))./NF;
    else
        F_State(ss)=(Est_State(ss)-Y_State(ss)).^2;
        F_County(ss)=(Est_County(ss)-Y_State(ss)).^2;
    end
end

F=sum([F_County(:);F_State(:)]);
end
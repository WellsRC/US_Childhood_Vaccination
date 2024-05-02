function F=Train_Model(x,X_temp,Xc_temp,Y_State,County_Weight,temp_yr,Data_Yr_County)

F_State=X_temp*(x')-Y_State;

uy=unique(Data_Yr_County);
F_County=[];
for jj=1:length(County_Weight)
    X=Xc_temp(uy(jj)==Data_Yr_County,:);
    w=County_Weight{jj};

    z_temp=X*(x');
    v_temp=1./(1+exp(-z_temp));
    v_state_temp=w*v_temp;
    v_state_temp(v_state_temp>=1)=1-10^(-8);
    v_state_temp(v_state_temp<=0)=10^(-8); 
    y_new=log(v_state_temp./(1-v_state_temp));    
    F_County=[F_County;y_new];
end

F_County=F_County(temp_yr);

F_County=F_County-Y_State;

F=[F_County(:);F_State(:)];
end
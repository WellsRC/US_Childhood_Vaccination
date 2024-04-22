function F=Train_Model(x,X_temp,Xc_temp,Y_State,County_Weight,temp_yr,Data_Yr_County)

F_State=X_temp*(x')-Y_State;

uy=unique(Data_Yr_County);
F_County=[];
for jj=1:length(County_Weight)
    X=Xc_temp(uy(jj)==Data_Yr_County,:);
    w=County_Weight{jj};
    F_County=[F_County;w*(X*(x'))];
end

F_County=F_County(temp_yr);

F_County=F_County-Y_State;

F=[F_County(:);F_State(:)];
end
function F=Objective_Weights(x,Y,Yo)
sj=sum(repmat(x,1,size(Y,2)).*(repmat(Yo,1,size(Y,2))-Y)).^2;

F=sum(sj);
end
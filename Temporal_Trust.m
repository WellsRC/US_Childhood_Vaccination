clear;
clc;
% 
% S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
% State_FIPc={S.STATEFP};
% State_FIP=zeros(size(State_FIPc));
% for ii=1:length(State_FIP)
% State_FIP(ii)=str2double(State_FIPc{ii});
% end
% 
% S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);
% County_ID_temp={S.GEOID};
% County_ID=zeros(size(County_ID_temp));
% for ii=1:length(County_ID)
%     County_ID(ii)=str2double(County_ID_temp{ii});
% end
% 
% 
% clearvars -except County_ID
% 
% 
% N_Samp=30;
% Rand_Indx=randi(1000,N_Samp,1);
% Rand_Trust_S=randi(1000,N_Samp,2);
% Rand_Trust_M=randi(1000,N_Samp,2);
% 
% Yr=[2010:2021];
% 
% 
% Trust_Science=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% Trust_Medicine=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% Political=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% Economic=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% Income=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% Race=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% Sex=NaN.*ones(length(County_ID),length(Yr),N_Samp);
% 
% parfor ss=1:N_Samp
%     [County_Demo,Data_Year]=Demographics_County('Political',County_ID,Rand_Indx(ss));
%     Political(:,:,ss)=County_Demo(:,ismember(Data_Year,Yr));
%     
%     [County_Demo,Data_Year]=Demographics_County('Economic',County_ID,Rand_Indx(ss));
%     Economic(:,:,ss)=County_Demo(:,ismember(Data_Year,Yr));
%     
%     [County_Demo,Data_Year]=Demographics_County('Income',County_ID,Rand_Indx(ss));
%     Income(:,:,ss)=County_Demo(:,ismember(Data_Year,Yr));
% 
%     [County_Demo,Data_Year]=Demographics_County('Race',County_ID,Rand_Indx(ss));
%     Race(:,:,ss)=County_Demo(:,ismember(Data_Year,Yr));
% 
%     [County_Demo,Data_Year]=Demographics_County('Sex',County_ID,Rand_Indx(ss));
%     Sex(:,:,ss)=County_Demo(:,ismember(Data_Year,Yr));
% end
% 
% for yy=1:length(Yr)
%     parfor ss=1:N_Samp
%         Trust_Science(:,yy,ss)=Return_County_Data('Trust_in_Science',Yr(yy),County_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));
%         Trust_Medicine(:,yy,ss)=Return_County_Data('Trust_in_Medicine',Yr(yy),County_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));
%     end
%     
% end
% 
% Political=mean(Political,3);
% Economic=mean(Economic,3);
% Income=mean(Income,3);
% Race=mean(Race,3);
% Sex=mean(Sex,3);
% 
% Trust_Science=mean(Trust_Science,3);
% Trust_Medicine=mean(Trust_Medicine,3);
% 
% save('Temp_Save_County_Trust_2010_2021.mat')

load('Temp_Save_County_Trust_2010_2021.mat')
ZM=log(Trust_Medicine./(1-Trust_Medicine));
ZS=log(Trust_Science./(1-Trust_Science));

X1=log(Economic./(1-Economic));
X2=log(Income);
X3=log(Race./(1-Race));
X4=log(Sex./(1-Sex));
X5=log(Political./(1-Political));
T_indx=repmat(Yr,size(ZM,1),1);

ZM=ZM(:);
X1=X1(:);
X2=X2(:);
X3=X3(:);
X4=X4(:);
T_indx=T_indx(:);

t_n = ~isinf(ZM) & ~isinf(X1) & ~isinf(X2) & ~isinf(X3) & ~isinf(X4) & ~isinf(X4);

ZM=ZM(t_n);
ZS=ZS(t_n);
X1=X1(t_n);
X2=X2(t_n);
X3=X3(t_n);
X4=X4(t_n);
X5=X5(t_n);
T_indx=T_indx(t_n);

mdl_med=fitlm([X1(T_indx<=2019) X2(T_indx<=2019) X3(T_indx<=2019) X4(T_indx<=2019)],ZM(T_indx<=2019));

YM=predict(mdl_med,[X1(T_indx>2019) X2(T_indx>2019) X3(T_indx>2019) X4(T_indx>2019)]);

dt=T_indx(T_indx>2019);
F=1./(1+exp(-YM));
O=1./(1+exp(-ZM(T_indx>2019)));
dYM=(F-O)./F;

mdl_sci=fitlm([X3(T_indx<=2019) X5(T_indx<=2019) ZM(T_indx<=2019)],ZS(T_indx<=2019));

YS=predict(mdl_sci,[X3(T_indx>2019) X5(T_indx>2019) YM]);

F=1./(1+exp(-YS));
O=1./(1+exp(-ZS(T_indx>2019)));
dYS=(F-O)./F;

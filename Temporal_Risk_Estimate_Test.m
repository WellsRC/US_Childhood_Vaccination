clear;

S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);


County_ID_temp={S.GEOID};
County_ID=zeros(size(County_ID_temp));

for ii=1:length(County_ID)
  County_ID(ii)=str2double(County_ID_temp{ii});  
end

Var_Plot='Trust_in_Science';

Nat_Avg=zeros(13,1);
Nat_std=zeros(13,1);
for yy=2010:2022
    Raw_County_Factor_Plot=Return_County_Data(Var_Plot,yy,County_ID);
    [~,~,~,~,Nat_Avg(yy-2009),Nat_std(yy-2009)]=Bounds_Plot_Colour(Var_Plot,yy,County_ID,Raw_County_Factor_Plot);
end

x=linspace(0,1,10001);
for xx=1:13
    plot(x,normcdf(x,Nat_Avg(xx),Nat_std(xx))); hold on
end
clear;
clc;

County_S=shaperead([pwd '\Spatial_Data\Demographic_Data\Shapefile\cb_2023_us_county_20m.shp'],'UseGeoCoords',true);
Geo_Pop=readtable([pwd '\Spatial_Data\Age_5_to_9_Grid_2023.csv']);

State_FIPc={County_S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
    State_FIP(ii)=str2double(State_FIPc{ii});
end

County_S=County_S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

r=zeros(length(County_S),1);
lon_c=zeros(length(County_S),1);
lat_c=zeros(length(County_S),1);
x=1.5:0.01:2.9;

Tot_Pop=sum(Geo_Pop.Age_5_to_9);
parfor ii=1:length(County_S)
    poly_county=polyshape(County_S(ii).Lon,County_S(ii).Lat,"Simplify",false);
    [lon_c(ii),lat_c(ii)]=centroid(poly_county);
    d=deg2sm(distance(Geo_Pop.Y,Geo_Pop.X,lat_c(ii),lon_c(ii)));
    f_test=zeros(141,1);
    for kk=1:141
        f_test(kk)=(log10(0.05.*Tot_Pop)-log10(sum(Geo_Pop.Age_5_to_9(d<=10.^x(kk))))).^2;
    end
    r(ii)=min(x(f_test==min(f_test)));
end
r=10.^r;

save('Cluster_Center_Radius_2023.mat','r','lat_c','lon_c');




function [Table_Main,Table_Radar_Plot] = Cluster_Properties(Vac,Num_Clusters)

% load(['Likelihood_Clusters_2023_' Vac '.mat'],'est_r','lat_c','lon_c','lambda');

% [~,indx_cluster]=sort(lambda(:,1),'descend');
% lat_c=lat_c(indx_cluster);
% lon_c=lon_c(indx_cluster);
% lambda=lambda(indx_cluster,:);
% est_r=est_r(indx_cluster);
% 
% lat=lat_c(1:Num_Clusters);
% lon=lon_c(1:Num_Clusters);
% Radius=est_r(1:Num_Clusters);
% lambda_stat=lambda(1:Num_Clusters,1);
% p_value=zeros(Num_Clusters,1);
% 
% for cc=1:Num_Clusters
%     p_value(cc)=sum(lambda_stat(cc)>=lambda(cc,:))./length(lambda(cc,:));
% end

lambda_stat=zeros(Num_Clusters,1);
p_value=zeros(Num_Clusters,1);

Population=zeros(Num_Clusters,1);
Unvaccinated_Population=zeros(Num_Clusters,1);
Vaccination_Coverage=zeros(Num_Clusters,1);

MMR_Religious_Exemption=NaN.*zeros(Num_Clusters,1);
MMR_Philosophical_Exemption=NaN.*zeros(Num_Clusters,1);
Other_Religious_Exemption=NaN.*zeros(Num_Clusters,1);
Other_Philosophical_Exemption=NaN.*zeros(Num_Clusters,1);
Population_5_to_9=NaN.*zeros(Num_Clusters,1);
Population_20_to_24=NaN.*zeros(Num_Clusters,1);
Population_25_to_29=NaN.*zeros(Num_Clusters,1);
Population_30_to_34=NaN.*zeros(Num_Clusters,1);
Population_35_to_39=NaN.*zeros(Num_Clusters,1);
Population_40_to_44=NaN.*zeros(Num_Clusters,1);

Education_Less_Grade_9=NaN.*zeros(Num_Clusters,1);
Education_Grade_9_12=NaN.*zeros(Num_Clusters,1);
Education_HS_Grad=NaN.*zeros(Num_Clusters,1);
Education_Some_College=NaN.*zeros(Num_Clusters,1);
Education_Associate_Degree=NaN.*zeros(Num_Clusters,1);
Education_Bachelor_Degree=NaN.*zeros(Num_Clusters,1);
Education_Grad_Prof_Degree=NaN.*zeros(Num_Clusters,1);

PIR_Under_50=NaN.*zeros(Num_Clusters,1);
PIR_50_74=NaN.*zeros(Num_Clusters,1);
PIR_75_99=NaN.*zeros(Num_Clusters,1);
PIR_100_124=NaN.*zeros(Num_Clusters,1);
PIR_125_149=NaN.*zeros(Num_Clusters,1);
PIR_150_174=NaN.*zeros(Num_Clusters,1);
PIR_175_184=NaN.*zeros(Num_Clusters,1);
PIR_185_199=NaN.*zeros(Num_Clusters,1);
PIR_200_299=NaN.*zeros(Num_Clusters,1);
PIR_300_399=NaN.*zeros(Num_Clusters,1);
PIR_400_499=NaN.*zeros(Num_Clusters,1);
PIR_500_over=NaN.*zeros(Num_Clusters,1);

Median_Income_Family=NaN.*zeros(Num_Clusters,1);

GINI_Index=NaN.*zeros(Num_Clusters,1);

Population_White=NaN.*zeros(Num_Clusters,1);
Population_African_American=NaN.*zeros(Num_Clusters,1);
Population_AI_AN=NaN.*zeros(Num_Clusters,1);
Population_Asian=NaN.*zeros(Num_Clusters,1);
Population_NH_PI=NaN.*zeros(Num_Clusters,1);

Uninsured=NaN.*zeros(Num_Clusters,1);
Private_insured=NaN.*zeros(Num_Clusters,1);
Public_insured=NaN.*zeros(Num_Clusters,1);

Rural_Urban_Continum_Code=NaN.*zeros(Num_Clusters,1);

load('Cluster_Center_Radius_2023.mat','r','lat_c','lon_c');
r_indx=randsample(length(r),Num_Clusters);
Radius=rand(Num_Clusters,1).*r(r_indx);
lat=lat_c(r_indx);
lon=lon_c(r_indx);

S=shaperead([pwd '\Spatial_Data\Demographic_Data\Shapefile\cb_2023_us_county_20m.shp'],'UseGeoCoords',true);
Grid_Data=readtable([pwd '\Spatial_Data\Grid_Population_Properties_2023.csv']);

 % Determine the number of unaccinatd individuals in eac hgrid point
if(strcmp(Vac,'MMR'))
    Number_Unvaccinated=Grid_Data.Z.*Grid_Data.Population_5_to_9.*(1-Grid_Data.MMR_Vaccine_Uptake);
    Number_Vaccinated=Grid_Data.Z.*Grid_Data.Population_5_to_9.*(Grid_Data.MMR_Vaccine_Uptake);
end
Total_Population=Grid_Data.Z.*Grid_Data.Population_5_to_9;
Cluster=cell(Num_Clusters,1);
for cc=1:Num_Clusters
    d=deg2sm(distance(Grid_Data.Y,Grid_Data.X,lat(cc),lon(cc)));
    Population(cc)=round(sum(Total_Population(d<=Radius(cc))));
    Unvaccinated_Population(cc)=round(sum(Number_Unvaccinated(d<=Radius(cc))));
    Vaccination_Coverage(cc)=round(100.*sum(Number_Vaccinated(d<=Radius(cc)))./sum(Total_Population(d<=Radius(cc))),1);
    Cluster{cc}=char(64+cc);

    MMR_Religious_Exemption(cc)=sum(Grid_Data.MMR_Religious_Exemption(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    MMR_Philosophical_Exemption(cc)=sum(Grid_Data.MMR_Philosophical_Exemption(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Other_Religious_Exemption(cc)=sum(Grid_Data.Other_Religious_Exemption(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Other_Philosophical_Exemption(cc)=sum(Grid_Data.Other_Philosophical_Exemption(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));

    Population_5_to_9(cc)=sum(Grid_Data.Population_5_to_9(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_20_to_24(cc)=sum(Grid_Data.Population_20_to_24(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_25_to_29(cc)=sum(Grid_Data.Population_25_to_29(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_30_to_34(cc)=sum(Grid_Data.Population_30_to_34(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_35_to_39(cc)=sum(Grid_Data.Population_35_to_39(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_40_to_44(cc)=sum(Grid_Data.Population_40_to_44(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    
    Education_Less_Grade_9(cc)=sum(Grid_Data.Education_Less_Grade_9(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Education_Grade_9_12(cc)=sum(Grid_Data.Education_Grade_9_12(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Education_HS_Grad(cc)=sum(Grid_Data.Education_HS_Grad(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Education_Some_College(cc)=sum(Grid_Data.Education_Some_College(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Education_Associate_Degree(cc)=sum(Grid_Data.Education_Associate_Degree(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Education_Bachelor_Degree(cc)=sum(Grid_Data.Education_Bachelor_Degree(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Education_Grad_Prof_Degree(cc)=sum(Grid_Data.Education_Grad_Prof_Degree(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
   
    PIR_Under_50(cc)=sum(Grid_Data.PIR_Under_50(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_50_74(cc)=sum(Grid_Data.PIR_50_74(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_75_99(cc)=sum(Grid_Data.PIR_75_99(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_100_124(cc)=sum(Grid_Data.PIR_100_124(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_125_149(cc)=sum(Grid_Data.PIR_125_149(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_150_174(cc)=sum(Grid_Data.PIR_150_174(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_175_184(cc)=sum(Grid_Data.PIR_175_184(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_185_199(cc)=sum(Grid_Data.PIR_185_199(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_200_299(cc)=sum(Grid_Data.PIR_200_299(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_300_399(cc)=sum(Grid_Data.PIR_300_399(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_400_499(cc)=sum(Grid_Data.PIR_400_499(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    PIR_500_over(cc)=sum(Grid_Data.PIR_500_over(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
  
    Median_Income_Family(cc)=sum(Grid_Data.Median_Income_Family(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    
    GINI_Index(cc)=sum(Grid_Data.GINI_Index(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    
    Population_White(cc)=sum(Grid_Data.Population_White(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_African_American(cc)=sum(Grid_Data.Population_African_American(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_AI_AN(cc)=sum(Grid_Data.Population_AI_AN(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_Asian(cc)=sum(Grid_Data.Population_Asian(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Population_NH_PI(cc)=sum(Grid_Data.Population_NH_PI(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    
    Uninsured(cc)=sum(Grid_Data.Uninsured(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Private_insured(cc)=sum(Grid_Data.Private_insured(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    Public_insured(cc)=sum(Grid_Data.Public_insured(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
    
    Rural_Urban_Continum_Code(cc)=sum(Grid_Data.Rural_Urban_Continum_Code(d<=Radius(cc)).*Grid_Data.Z(d<=Radius(cc)))./sum(Grid_Data.Z(d<=Radius(cc)));
end

County=cell(Num_Clusters,1);
for ss=1:length(S)
    [p_in,p_on]=inpolygon(lon,lat,S(ss).Lon,S(ss).Lat);
    County(p_in|p_on)={[S(ss).NAME ', ' S(ss).STATE_NAME]};
end

Radius=round(Radius,1);
p_value=round(p_value,3);
lambda_stat=round(lambda_stat);

Table_Main=table(Cluster,County,Radius,Population,Vaccination_Coverage,Unvaccinated_Population,lambda_stat,p_value);
Table_Radar_Plot=table(Cluster,County,Radius,Population,Vaccination_Coverage,MMR_Religious_Exemption,MMR_Philosophical_Exemption,Other_Religious_Exemption,Other_Philosophical_Exemption,Population_5_to_9,Population_20_to_24,Population_25_to_29,Population_30_to_34,Population_35_to_39,Population_40_to_44,Education_Less_Grade_9,Education_Grade_9_12,Education_HS_Grad,Education_Some_College,Education_Associate_Degree,Education_Bachelor_Degree,Education_Grad_Prof_Degree,PIR_Under_50,PIR_50_74,PIR_75_99,PIR_100_124,PIR_125_149,PIR_150_174,PIR_175_184,PIR_185_199,PIR_200_299,PIR_300_399,PIR_400_499,PIR_500_over,Median_Income_Family,GINI_Index,Population_White,Population_African_American,Population_AI_AN,Population_Asian,Population_NH_PI,Uninsured,Private_insured,Public_insured,Rural_Urban_Continum_Code);
end


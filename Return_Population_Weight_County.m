function [county_weight]=Return_Population_Weight_County()

load([pwd '\Spatial_Data\Demographic_Data\County_Population.mat']);

county_weight.County_ID=County_Demo.County_ID;
county_weight.State_ID=County_Demo.State_ID;
county_weight.year=County_Demo.Year_Data;

county_weight.Trust_Computation=zeros(length(county_weight.County_ID),length(county_weight.year),4,2,3);

county_weight.Trust_Computation(:,:,1,1,1)=County_Demo.Population.Male.White.Age_18_34;
county_weight.Trust_Computation(:,:,1,2,1)=County_Demo.Population.Female.White.Age_18_34;

county_weight.Trust_Computation(:,:,1,1,2)=County_Demo.Population.Male.Black.Age_18_34;
county_weight.Trust_Computation(:,:,1,2,2)=County_Demo.Population.Female.Black.Age_18_34;

county_weight.Trust_Computation(:,:,1,1,3)=County_Demo.Population.Male.Other.Age_18_34;
county_weight.Trust_Computation(:,:,1,2,3)=County_Demo.Population.Female.Other.Age_18_34;


county_weight.Trust_Computation(:,:,2,1,1)=County_Demo.Population.Male.White.Age_35_49;
county_weight.Trust_Computation(:,:,2,2,1)=County_Demo.Population.Female.White.Age_35_49;

county_weight.Trust_Computation(:,:,2,1,2)=County_Demo.Population.Male.Black.Age_35_49;
county_weight.Trust_Computation(:,:,2,2,2)=County_Demo.Population.Female.Black.Age_35_49;

county_weight.Trust_Computation(:,:,2,1,3)=County_Demo.Population.Male.Other.Age_35_49;
county_weight.Trust_Computation(:,:,2,2,3)=County_Demo.Population.Female.Other.Age_35_49;


county_weight.Trust_Computation(:,:,3,1,1)=County_Demo.Population.Male.White.Age_50_64;
county_weight.Trust_Computation(:,:,3,2,1)=County_Demo.Population.Female.White.Age_50_64;

county_weight.Trust_Computation(:,:,3,1,2)=County_Demo.Population.Male.Black.Age_50_64;
county_weight.Trust_Computation(:,:,3,2,2)=County_Demo.Population.Female.Black.Age_50_64;

county_weight.Trust_Computation(:,:,3,1,3)=County_Demo.Population.Male.Other.Age_50_64;
county_weight.Trust_Computation(:,:,3,2,3)=County_Demo.Population.Female.Other.Age_50_64;


county_weight.Trust_Computation(:,:,4,1,1)=County_Demo.Population.Male.White.Age_65_plus;
county_weight.Trust_Computation(:,:,4,2,1)=County_Demo.Population.Female.White.Age_65_plus;

county_weight.Trust_Computation(:,:,4,1,2)=County_Demo.Population.Male.Black.Age_65_plus;
county_weight.Trust_Computation(:,:,4,2,2)=County_Demo.Population.Female.Black.Age_65_plus;

county_weight.Trust_Computation(:,:,4,1,3)=County_Demo.Population.Male.Other.Age_65_plus;
county_weight.Trust_Computation(:,:,4,2,3)=County_Demo.Population.Female.Other.Age_65_plus;
end
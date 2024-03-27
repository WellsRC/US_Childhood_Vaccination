function [Trust]=Trust_Categories(county_weight,Trust_Stratified)


% county_weight.Trust_Computation(:,:,1,1,1)=County_Demo.Population.Male.White.Age_18_34;
%county_weight.Trust_Computation(:,:,1,2,1)=County_Demo.Population.Female.White.Age_18_34;

%county_weight.Trust_Computation(:,:,1,1,2)=County_Demo.Population.Male.Black.Age_18_34;
%county_weight.Trust_Computation(:,:,1,2,2)=County_Demo.Population.Female.Black.Age_18_34;

%county_weight.Trust_Computation(:,:,1,1,3)=County_Demo.Population.Male.Other.Age_18_34;
%county_weight.Trust_Computation(:,:,1,2,3)=County_Demo.Population.Female.Other.Age_18_34;

%county_weight.Trust_Computation(:,:,2,1,1)=County_Demo.Population.Male.White.Age_35_49;
%county_weight.Trust_Computation(:,:,2,2,1)=County_Demo.Population.Female.White.Age_35_49;

%county_weight.Trust_Computation(:,:,2,1,2)=County_Demo.Population.Male.Black.Age_35_49;
%county_weight.Trust_Computation(:,:,2,2,2)=County_Demo.Population.Female.Black.Age_35_49;

%county_weight.Trust_Computation(:,:,2,1,3)=County_Demo.Population.Male.Other.Age_35_49;
%county_weight.Trust_Computation(:,:,2,2,3)=County_Demo.Population.Female.Other.Age_35_49;


%county_weight.Trust_Computation(:,:,3,1,1)=County_Demo.Population.Male.White.Age_50_64;
%county_weight.Trust_Computation(:,:,3,2,1)=County_Demo.Population.Female.White.Age_50_64;

%county_weight.Trust_Computation(:,:,3,1,2)=County_Demo.Population.Male.Black.Age_50_64;
%county_weight.Trust_Computation(:,:,3,2,2)=County_Demo.Population.Female.Black.Age_50_64;

%county_weight.Trust_Computation(:,:,3,1,3)=County_Demo.Population.Male.Other.Age_50_64;
%county_weight.Trust_Computation(:,:,3,2,3)=County_Demo.Population.Female.Other.Age_50_64;


%county_weight.Trust_Computation(:,:,4,1,1)=County_Demo.Population.Male.White.Age_65_plus;
%county_weight.Trust_Computation(:,:,4,2,1)=County_Demo.Population.Female.White.Age_65_plus;

%county_weight.Trust_Computation(:,:,4,1,2)=County_Demo.Population.Male.Black.Age_65_plus;
%county_weight.Trust_Computation(:,:,4,2,2)=County_Demo.Population.Female.Black.Age_65_plus;

%county_weight.Trust_Computation(:,:,4,1,3)=County_Demo.Population.Male.Other.Age_65_plus;
%county_weight.Trust_Computation(:,:,4,2,3)=County_Demo.Population.Female.Other.Age_65_plus;

Trust.National=sum(county_weight.Trust_Computation.*Trust_Stratified,[1 3 4 5])./sum(county_weight.Trust_Computation,[1 3 4 5]);

Trust.Age_18_34=sum(county_weight.Trust_Computation(:,:,1,:,:).*Trust_Stratified(:,:,1,:,:),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,1,:,:),[1 3 4 5]);
Trust.Age_35_49=sum(county_weight.Trust_Computation(:,:,2,:,:).*Trust_Stratified(:,:,2,:,:),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,2,:,:),[1 3 4 5]);
Trust.Age_50_64=sum(county_weight.Trust_Computation(:,:,3,:,:).*Trust_Stratified(:,:,3,:,:),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,3,:,:),[1 3 4 5]);
Trust.Age_65_plus=sum(county_weight.Trust_Computation(:,:,4,:,:).*Trust_Stratified(:,:,4,:,:),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,4,:,:),[1 3 4 5]);

Trust.White=sum(county_weight.Trust_Computation(:,:,:,:,1).*Trust_Stratified(:,:,:,:,1),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,:,:,1),[1 3 4 5]);
Trust.Black=sum(county_weight.Trust_Computation(:,:,:,:,2).*Trust_Stratified(:,:,:,:,2),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,:,:,2),[1 3 4 5]);
Trust.Other=sum(county_weight.Trust_Computation(:,:,:,:,3).*Trust_Stratified(:,:,:,:,3),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,:,:,3),[1 3 4 5]);

Trust.Male=sum(county_weight.Trust_Computation(:,:,:,1,:).*Trust_Stratified(:,:,:,1,:),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,:,1,:),[1 3 4 5]);
Trust.Female=sum(county_weight.Trust_Computation(:,:,:,2,:).*Trust_Stratified(:,:,:,2,:),[1 3 4 5])./sum(county_weight.Trust_Computation(:,:,:,2,:),[1 3 4 5]);

end
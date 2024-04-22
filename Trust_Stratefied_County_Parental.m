function Trust_Stratified=Trust_Stratefied_County_Parental(county_weight,X_t,beta_all)


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

Trust_Stratified=zeros(size(county_weight.Trust_Computation));
for ss=1:2
    for rr=1:3
        for aa=1:2
            cc=ss+2.*(rr-1)+6.*(aa-1);
            beta_z=beta_all(cc,:);
            [~,v_t]=Compute_County_Trust_Stratified(beta_z,X_t);
            Trust_Stratified(:,:,aa,ss,rr)=v_t;
        end
    end
end

end
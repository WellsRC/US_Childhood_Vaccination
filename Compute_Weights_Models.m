clear;
clc;

T=readtable('County_Level_Cross_Validation.xlsx','Sheet','Indicator');

% MMR

x=(max(T.CrossValidation_MMR_)-T.CrossValidation_MMR_)./(max(T.CrossValidation_MMR_)-min(T.CrossValidation_MMR_));
y=(T.AIC_MMR_-min(T.AIC_MMR_))./(max(T.AIC_MMR_)-min(T.AIC_MMR_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_MMR=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));

% DTaP
x=(max(T.CrossValidation_DTaP_)-T.CrossValidation_DTaP_)./(max(T.CrossValidation_DTaP_)-min(T.CrossValidation_DTaP_));
y=(T.AIC_DTaP_-min(T.AIC_DTaP_))./(max(T.AIC_DTaP_)-min(T.AIC_DTaP_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_DTaP=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));
% IPV
x=(max(T.CrossValidation_IPV_)-T.CrossValidation_IPV_)./(max(T.CrossValidation_IPV_)-min(T.CrossValidation_IPV_));
y=(T.AIC_IPV_-min(T.AIC_IPV_))./(max(T.AIC_IPV_)-min(T.AIC_IPV_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_IPV=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));
% VAR
x=(max(T.CrossValidation_VAR_)-T.CrossValidation_VAR_)./(max(T.CrossValidation_VAR_)-min(T.CrossValidation_VAR_));
y=(T.AIC_VAR_-min(T.AIC_VAR_))./(max(T.AIC_VAR_)-min(T.AIC_VAR_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_VAR=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));
% Total
x=(max(T.CrossValidation_Total_)-T.CrossValidation_Total_)./(max(T.CrossValidation_Total_)-min(T.CrossValidation_Total_));
y=(T.AIC_Total_-min(T.AIC_Total_))./(max(T.AIC_Total_)-min(T.AIC_Total_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_Total=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));


%% Compute the pdf wieghts
d=sqrt(4.*0.01./pi);
lambda_d=fmincon(@(z)10.^6.*(integral(@(x)exp(-z.*x.^2),0,d)/integral(@(x)exp(-z.*x.^2),0,sqrt(2))-0.99).^2,295,[],[],[],[],10,1000);
pdf_dist=@(dist) exp(-lambda_d.*dist.^2)/integral(@(x)exp(-lambda_d.*x.^2),0,sqrt(2));

Weight_MMR=pdf_dist(Distance_Optimal_MMR)./sum(pdf_dist(Distance_Optimal_MMR));
Weight_DTaP=pdf_dist(Distance_Optimal_DTaP)./sum(pdf_dist(Distance_Optimal_DTaP));
Weight_IPV=pdf_dist(Distance_Optimal_IPV)./sum(pdf_dist(Distance_Optimal_IPV));
Weight_VAR=pdf_dist(Distance_Optimal_VAR)./sum(pdf_dist(Distance_Optimal_VAR));
Weight_Total=pdf_dist(Distance_Optimal_Total)./sum(pdf_dist(Distance_Optimal_Total));
T=T(:,1:10);
T=[T table(Distance_Optimal_MMR,Distance_Optimal_DTaP,Distance_Optimal_IPV,Distance_Optimal_VAR,Distance_Optimal_Total,Weight_MMR,Weight_DTaP,Weight_IPV,Weight_VAR,Weight_Total)];

writetable(T,'Supplement_Table_Model_Comparison.xlsx','Sheet','Table_All');

T_sorted=sortrows(T,width(T),'descend');
writetable(T_sorted,'Supplement_Table_Model_Comparison.xlsx','Sheet','Table_All_Sorted');

X=T(:,1:10);
X.PandemicDirectlyImpactVaccination=double(strcmp(X.PandemicDirectlyImpactVaccination,'Yes'));
X.Trust_Medicine_or_Science=min(X.TrustInMedicine+X.TrustInScience,1);
VN=X.Properties.VariableNames;
X=table2array(X);
Vaccine={'MMR';'DTaP';'IPV';'VAR';'All'};
W=zeros(length(Vaccine),size(X,2));
weight_model=[T.Weight_MMR T.Weight_DTaP T.Weight_IPV T.Weight_VAR T.Weight_Total]';

for jj=1:length(Vaccine)
    W(jj,:)=weight_model(jj,:)*X;
end

T_W=[table(Vaccine) array2table(W)];
T_W.Properties.VariableNames(2:end)=VN;

writetable(T_W,'Supplement_Table_Model_Comparison.xlsx','Sheet','Weights');



W=cell(4,1);
W{1}=Weight_MMR';
W{2}=Weight_DTaP';
W{3}=Weight_IPV';
W{4}=Weight_VAR';
Z=zeros(4,13);
Inqv={'MMR','DTaP','Polio','VAR'};
for vv=1:4
    C=readtable('County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);


    Z(vv,:)=W{vv}*table2array(C);

end
Vaccine=Vaccine(1:end-1);
Variables={'Vaccine','Intercempt','Pandemic Directly Impact Vaccination','Philosophical Exemptions','Religous Exemptions','Economic','Education','Income','Politcal','Race','Sex','Trust in Medicine','Trust in Science','Uninsured under 19'};
T_C=[table(Vaccine) array2table(Z)];
T_C.Properties.VariableNames=Variables;

writetable(T_C,'Supplement_Table_Model_Comparison.xlsx','Sheet','Weighted_Coefficients');

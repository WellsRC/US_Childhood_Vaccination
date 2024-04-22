function [W,Vaccine]=Return_Model_Weights()


T=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet','Indicator');

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


%% Compute the pdf wieghts


Vaccine={'MMR','DTaP','Polio','VAR'};
d=sqrt(4.*0.01./pi);
lambda_d=fmincon(@(z)10.^6.*(integral(@(x)exp(-z.*x.^2),0,d)/integral(@(x)exp(-z.*x.^2),0,sqrt(2))-0.99).^2,295,[],[],[],[],10,1000);
pdf_dist=@(dist) exp(-lambda_d.*dist.^2)/integral(@(x)exp(-lambda_d.*x.^2),0,sqrt(2));

Weight_MMR=pdf_dist(Distance_Optimal_MMR)./sum(pdf_dist(Distance_Optimal_MMR));
Weight_DTaP=pdf_dist(Distance_Optimal_DTaP)./sum(pdf_dist(Distance_Optimal_DTaP));
Weight_IPV=pdf_dist(Distance_Optimal_IPV)./sum(pdf_dist(Distance_Optimal_IPV));
Weight_VAR=pdf_dist(Distance_Optimal_VAR)./sum(pdf_dist(Distance_Optimal_VAR));

W{1}=Weight_MMR';
W{2}=Weight_DTaP';
W{3}=Weight_IPV';
W{4}=Weight_VAR';

end
clear;
clc;

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
% Total
x=(max(T.CrossValidation_Total_)-T.CrossValidation_Total_)./(max(T.CrossValidation_Total_)-min(T.CrossValidation_Total_));
y=(T.AIC_Total_-min(T.AIC_Total_))./(max(T.AIC_Total_)-min(T.AIC_Total_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_Total=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));


%% Compute the pdf wieghts
d=sqrt(4.*0.01./pi);
lambda_d=fmincon(@(z)10.^6.*(integral(@(x)exp(-z.*x.^2),0,d)/integral(@(x)exp(-z.*x.^2),0,sqrt(2))-0.99).^2,260,[],[],[],[],10,1000);
pdf_dist=@(dist) exp(-lambda_d.*dist.^2)/integral(@(x)exp(-lambda_d.*x.^2),0,sqrt(2));

Weight_MMR=pdf_dist(Distance_Optimal_MMR)./sum(pdf_dist(Distance_Optimal_MMR));
Weight_DTaP=pdf_dist(Distance_Optimal_DTaP)./sum(pdf_dist(Distance_Optimal_DTaP));
Weight_IPV=pdf_dist(Distance_Optimal_IPV)./sum(pdf_dist(Distance_Optimal_IPV));
Weight_VAR=pdf_dist(Distance_Optimal_VAR)./sum(pdf_dist(Distance_Optimal_VAR));
Weight_Total=pdf_dist(Distance_Optimal_Total)./sum(pdf_dist(Distance_Optimal_Total));
T=T(:,1:8);
T=[T table(Distance_Optimal_MMR,Distance_Optimal_DTaP,Distance_Optimal_IPV,Distance_Optimal_VAR,Distance_Optimal_Total,Weight_MMR,Weight_DTaP,Weight_IPV,Weight_VAR,Weight_Total)];

writetable(T,'Supplement_Table_Model_Comparison.xlsx','Sheet','Table_All');

T_sorted=sortrows(T,width(T),'descend');
writetable(T_sorted,'Supplement_Table_Model_Comparison.xlsx','Sheet','Table_All_Sorted');

X=T(:,1:8);
X.Trust_Medicine_or_Science=min(X.TrustInMedicine+X.TrustInScience,1);
X=[X(:,1:7) X(:,9) X(:,8)];
VN=X.Properties.VariableNames;
X=table2array(X);
Vaccine={'MMR';'DTaP';'IPV';'VAR';'All'};
W=zeros(length(Vaccine),size(X,2));
weight_model=[T.Weight_MMR T.Weight_DTaP T.Weight_IPV T.Weight_VAR T.Weight_Total]';

for jj=1:length(Vaccine)
    W(jj,:)=weight_model(jj,:)*X;
end

WT=cell(size(W));
for ii=1:size(W,1)
    for jj=1:size(W,2)
        if(W(ii,jj)>=0.001)
            WT{ii,jj}=num2str(W(ii,jj),'%4.3f');
        else
            WT{ii,jj}={'<0.001'};
        end
    end
end

T_W=[table(Vaccine) array2table(W)];
T_W.Properties.VariableNames(2:end)=VN;
Variable=table(VN');
Variable.Properties.VariableNames={'Variable'};
Table_3=[Variable cell2table(WT')];
Table_3.Properties.VariableNames={'Variable',Vaccine{:}};
writetable(T_W,'Supplement_Table_Model_Comparison.xlsx','Sheet','Weights');
writetable(Table_3,'Tables_Main_Text.xlsx','Sheet','Table_3');


C=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet',['Coefficients_MMR' ]);

W=cell(4,1);
W{1}=Weight_MMR';
W{2}=Weight_DTaP';
W{3}=Weight_IPV';
W{4}=Weight_VAR';
Z=zeros(4,width(C));
Z_lb=zeros(4,width(C));
Z_ub=zeros(4,width(C));
Inqv={'MMR','DTaP','Polio','VAR'};
for vv=1:4
    C=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
    M=table2array(C);

    Z(vv,:)=W{vv}*M;
    w_c=cumsum(W{vv})./sum(W{vv});
    Indx=zeros(10^4,1);
    r=rand(10^4,1);
    for ii=1:length(r)
        Indx(ii)=find(r(ii)<=w_c, 1 );
    end
    Mt=M(Indx,:);
    Z_lb(vv,:)=prctile(Mt,2.5);
    Z_ub(vv,:)=prctile(Mt,97.5);
end

Zt=cell(4,width(C));
for vv=1:4
    for jj=1:width(C)
        Zt{vv,jj}=[num2str(Z(vv,jj),'%4.3f') '(' num2str(Z_lb(vv,jj),'%4.3f') char(8211) num2str(Z_ub(vv,jj),'%4.3f') ')'];
    end
end
temp_VN=C.Properties.VariableNames;
Vaccine=Vaccine(1:end-1);
Variables={'Vaccine',temp_VN{:}};
T_C=[table(Vaccine) cell2table(Zt)];
T_C.Properties.VariableNames=Variables;

writetable(T_C,'Supplement_Table_Model_Comparison.xlsx','Sheet','Weighted_Coefficients');

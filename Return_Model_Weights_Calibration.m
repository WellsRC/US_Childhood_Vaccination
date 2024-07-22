function [W,Vaccine]=Return_Model_Weights_Calibration(prct_arc)


T=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet','Indicator');

% All

x=(max(T.CrossValidation_Total_)-T.CrossValidation_Total_)./(max(T.CrossValidation_Total_)-min(T.CrossValidation_Total_));
y=(T.AIC_Total_-min(T.AIC_Total_))./(max(T.AIC_Total_)-min(T.AIC_Total_));

d_xy=sqrt(x.^2+y.^2);
f_opt=d_xy==min(d_xy);

X_opt=[x(f_opt) y(f_opt)];
Distance_Optimal_Total=sqrt(sum(([x y]-repmat(X_opt,height(T),1)).^2,2));

%% Compute the pdf wieghts


Vaccine={'Total'};

d=sqrt(4.*(1-prct_arc)./pi);
x0=linspace(-12,2.9,10001);
fval=zeros(1,10001);
for mm=1:10001
    fval(mm)=(integral(@(x)exp(-10.^x0(mm).*x.^2),0,d)/integral(@(x)exp(-10.^x0(mm).*x.^2),0,sqrt(2))-prct_arc).^2;
end
x0=x0(fval==min(fval));

options=optimoptions("fmincon",'FunctionTolerance',10^(-16),'MaxFunctionEvaluations',10^(4),'MaxIterations',10^6,'StepTolerance',10^(-8));
lambda_d=10.^fmincon(@(z)(10.^8.*(integral(@(x)exp(-10.^z.*x.^2),0,d)/integral(@(x)exp(-10.^z.*x.^2),0,sqrt(2))-prct_arc).^2),x0,[],[],[],[],-12,3,[],options);
pdf_dist=@(dist) exp(-lambda_d.*dist.^2)/integral(@(x)exp(-lambda_d.*x.^2),0,sqrt(2));

W=pdf_dist(Distance_Optimal_Total)./sum(pdf_dist(Distance_Optimal_Total));

end
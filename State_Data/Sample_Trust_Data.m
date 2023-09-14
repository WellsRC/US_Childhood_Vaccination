function [great_deal_new,only_some_new,hardly_any_new]=Sample_Trust_Data(T,T_Err,Year_Table,Trust_Year_Data,N_Samp)
% Hardly any
temp=T.hardly_any;
temp_err=T_Err.hardly_any;
z_obs=zeros(N_Samp,length(temp));

options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-10),'MaxFunctionEvaluations',1000,'MaxIterations',2500,'StepTolerance',10^(-8));
for jj=1:length(temp)
    if(temp_err(jj)>0)
        temp_std=lsqnonlin(@(z)([(norminv(0.025,temp(jj),z)-(temp(jj)-temp_err(jj)));(norminv(0.975,temp(jj),z)-(temp(jj)+temp_err(jj)))]),temp_err(jj),[],[],options);
        z_obs(:,jj)=normrnd(temp(jj),temp_std,N_Samp,1);
    else
        z_obs(:,jj)=temp(jj);
    end
end
z_obs=z_obs./100;
z_obs=log(z_obs./(1-z_obs));

z_new=NaN.*zeros(N_Samp,length(Trust_Year_Data));

for ss=1:N_Samp
    z_new(ss,ismember(Trust_Year_Data,Year_Table))=z_obs(ss,ismember(Year_Table,Trust_Year_Data));
    % Cannot have the pandemic influence any trend for years less than 2020
    z_new(ss,Trust_Year_Data<2020)=pchip(Year_Table(Year_Table<2020),z_obs(ss,Year_Table<2020),Trust_Year_Data(Trust_Year_Data<2020)); 
    % Interpolate the missing data over the pandemic based on all new
    % approximations of misisng data prior to the pandmeic and observed
    % during pandemic
    z_new(ss,isnan(z_new(ss,:)))=pchip(Trust_Year_Data(~isnan(z_new(ss,:))),z_new(ss,~isnan(z_new(ss,:))),Trust_Year_Data(isnan(z_new(ss,:))));       
end
% scale to 0 and 1
hardly_any_new=real(1./(1+exp(-z_new)));

% only some
temp=T.only_some;
temp_err=T_Err.only_some;
z_obs=zeros(N_Samp,length(temp));

options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-10),'MaxFunctionEvaluations',1000,'MaxIterations',2500,'StepTolerance',10^(-8));
for jj=1:length(temp)
    if(temp_err(jj)>0)
        temp_std=lsqnonlin(@(z)([(norminv(0.025,temp(jj),z)-(temp(jj)-temp_err(jj)));(norminv(0.975,temp(jj),z)-(temp(jj)+temp_err(jj)))]),temp_err(jj),[],[],options);
        z_obs(:,jj)=normrnd(temp(jj),temp_std,N_Samp,1);
    else
        z_obs(:,jj)=temp(jj);
    end
end
z_obs=z_obs./100;
z_obs=log(z_obs./(1-z_obs));

z_new=NaN.*zeros(N_Samp,length(Trust_Year_Data));

for ss=1:N_Samp
    z_new(ss,ismember(Trust_Year_Data,Year_Table))=z_obs(ss,ismember(Year_Table,Trust_Year_Data));
    % Cannot have the pandemic influence any trend for years less than 2020
    z_new(ss,Trust_Year_Data<2020)=pchip(Year_Table(Year_Table<2020),z_obs(ss,Year_Table<2020),Trust_Year_Data(Trust_Year_Data<2020)); 
    % Interpolate the missing data over the pandemic based on all new
    % approximations of misisng data prior to the pandmeic and observed
    % during pandemic
    z_new(ss,isnan(z_new(ss,:)))=pchip(Trust_Year_Data(~isnan(z_new(ss,:))),z_new(ss,~isnan(z_new(ss,:))),Trust_Year_Data(isnan(z_new(ss,:))));       
end
% scale to 0 and 1
only_some_new=real(1./(1+exp(-z_new)));

% great deal
temp=T.great_deal;
temp_err=T_Err.great_deal;
z_obs=zeros(N_Samp,length(temp));

options = optimoptions(@lsqnonlin,'FunctionTolerance',10^(-10),'MaxFunctionEvaluations',1000,'MaxIterations',2500,'StepTolerance',10^(-8));
for jj=1:length(temp)
    if(temp_err(jj)>0)
        temp_std=lsqnonlin(@(z)([(norminv(0.025,temp(jj),z)-(temp(jj)-temp_err(jj)));(norminv(0.975,temp(jj),z)-(temp(jj)+temp_err(jj)))]),temp_err(jj),[],[],options);
        z_obs(:,jj)=normrnd(temp(jj),temp_std,N_Samp,1);
    else
        z_obs(:,jj)=temp(jj);
    end
end
z_obs=z_obs./100;
z_obs=log(z_obs./(1-z_obs));

z_new=NaN.*zeros(N_Samp,length(Trust_Year_Data));

for ss=1:N_Samp
    z_new(ss,ismember(Trust_Year_Data,Year_Table))=z_obs(ss,ismember(Year_Table,Trust_Year_Data));
    % Cannot have the pandemic influence any trend for years less than 2020
    z_new(ss,Trust_Year_Data<2020)=pchip(Year_Table(Year_Table<2020),z_obs(ss,Year_Table<2020),Trust_Year_Data(Trust_Year_Data<2020)); 
    % Interpolate the missing data over the pandemic based on all new
    % approximations of misisng data prior to the pandmeic and observed
    % during pandemic
    z_new(ss,isnan(z_new(ss,:)))=pchip(Trust_Year_Data(~isnan(z_new(ss,:))),z_new(ss,~isnan(z_new(ss,:))),Trust_Year_Data(isnan(z_new(ss,:))));       
end

% scale to 0 and 1
great_deal_new=real(1./(1+exp(-z_new)));
end
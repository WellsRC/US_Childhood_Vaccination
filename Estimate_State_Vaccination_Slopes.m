clear;
clc;

S=shaperead([pwd '\State_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
  State_FIP(ii)=str2double(State_FIPc{ii});  
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_ID_temp={S.STATEFP};
State_ID=zeros(size(State_ID_temp));

for ii=1:length(State_ID)
  State_ID(ii)=str2double(State_ID_temp{ii});  
end
State_ID=unique(State_ID);
State_ID=State_ID(~ismember(State_ID,[11 30]));
clearvars -except State_ID 
Yr=[2017:2022];

Var_Namev={'MMR','DTaP','Polio','VAR'};

for dd=1:length(Var_Namev)
    V=zeros(length(State_ID),length(Yr));

    Var_Name=Var_Namev{dd};
    for yy=1:length(Yr)
        V(:,yy)=State_Immunization_Statistics(Var_Name,Yr(yy),State_ID); 
    end
    lb=[-0.01.*ones(1,length(State_ID)) -0.15.*ones(1,length(State_ID)) zeros(1,length(State_ID)) 2019];
    ub=[ 0.05.*ones(1,length(State_ID)) 0.01.*ones(1,length(State_ID)) ones(1,length(State_ID)) 2020+11/12]; % Upper bound for year is based on PEW trend https://www.pewresearch.org/science/2023/11/14/confidence-in-scientists-medical-scientists-and-other-groups-and-institutions-in-society/
    
    NS=5*10^3;
    fval=zeros(NS,1);
    par_est=zeros(NS,length(lb));
    ls=lhsdesign(NS,length(lb));
    x0=repmat(lb,NS,1)+repmat(ub-lb,NS,1).*ls;
    options=optimoptions('lsqnonlin','FunctionTolerance',10^(-8),'MaxFunctionEvaluations',10^4,'MaxIterations',10^5,'StepTolerance',10^(-8));
    parfor jj=1:NS
        [par_est(jj,:),fval(jj)]=lsqnonlin(@(x)Estimate_Slopes(x,V,Yr),x0(jj,:),lb,ub,options);
    end
    par_est=par_est(min(fval)==fval,:);

    m_slope=reshape(par_est(1:2.*length(State_ID)),length(State_ID),2);
    peak_point=reshape(par_est(2.*length(State_ID)+[1:length(State_ID)]),length(State_ID),1);
    Year_Inflection=par_est(end);
    save(['Estimated_Slopes_State_' Var_Name '.mat'],"m_slope",'peak_point',"Year_Inflection","State_ID");
end
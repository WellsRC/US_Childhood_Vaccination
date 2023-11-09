clear;
clc;
close all;

clear;
clc;
S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

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
clearvars -except State_ID

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


%% Compute the pdf wieghts


Vaccine={'MMR';'DTaP';'IPV';'VAR'};
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
Z_mean=zeros(4,9);
Z_median=zeros(4,9);
Z_lb1=zeros(4,9);
Z_ub1=zeros(4,9);
Z_lb2=zeros(4,9);
Z_ub2=zeros(4,9);
N_Samp=10^4;
Inqv={'MMR','DTaP','Polio','VAR'};
Variables={'Intercempt','Pandemic Directly Impact Vaccination','Philosophical Exemptions','Religous Exemptions','Economic','Education','Income','Politcal','Race','Sex','Trust in Medicine','Trust in Science','Uninsured under 19'};
Variables=Variables(:);
T_State=readtable("Data_Transformed_Combined_State_Level.xlsx");
for vv=1:4
    Z=T_State.Vaccine_Uptake(strcmp(T_State.Vaccine_Disease,Inqv{vv}));
    X_State_t=[T_State.Economic(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Education(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Income(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Political(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Race(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Sex(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Trust_in_Medicine(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Trust_in_Science(strcmp(T_State.Vaccine_Disease,Inqv{vv})) T_State.Uninsured_19_under(strcmp(T_State.Vaccine_Disease,Inqv{vv}))];
    temp=1./(1+exp(-X_State_t))+0.01; % Assume a 1% increase of unit change
    temp(:,3)=exp(X_State_t(:,3))+1000; % Roughly 1% of the maximum
    X_State=log(temp./(1-temp));
    X_State(:,3)=log(temp(:,3));
    
    RE_State=T_State.State_Religous_Exemptions(strcmp(T_State.Vaccine_Disease,Inqv{vv}));
    PE_State=T_State.State_Philosophical_Exemptions(strcmp(T_State.Vaccine_Disease,Inqv{vv}));
    COVID_State=T_State.COVID(strcmp(T_State.Vaccine_Disease,Inqv{vv}));

    clear temp

    
    C=readtable('County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
    M=table2array(C);
    w_c=cumsum(W{vv});

    r=rand(N_Samp,1);
    Indx=zeros(N_Samp,1);

    for ii=1:length(r)
        Indx(ii)=find(r(ii)<=w_c, 1 );
    end
    Mt=M(Indx,:);
    ES=zeros(N_Samp,9);
    for ii=1:9
        T_Old=[ones(size(COVID_State)) COVID_State PE_State RE_State X_State_t(:,1:end)];
        if(ii==1)
            T_New=[ones(size(COVID_State)) COVID_State PE_State RE_State X_State(:,1) X_State_t(:,2:end)];
        elseif(ii==9)
            T_New=[ones(size(COVID_State)) COVID_State PE_State RE_State X_State_t(:,1:end-1) X_State(:,9)];
        else
            T_New=[ones(size(COVID_State)) COVID_State PE_State RE_State X_State_t(:,1:(ii-1)) X_State(:,ii) X_State_t(:,(ii+1):end)];
        end
        dv=100*(1./(1+exp(-Mt*(T_New')))-1./(1+exp(-Mt*(T_Old'))));
    
        Z_mean(vv,ii)=mean(dv(:),1);
        Z_median(vv,ii)=median(dv(:),1);
        Z_lb1(vv,ii)=prctile(dv(:),25,1);
        Z_ub1(vv,ii)=prctile(dv(:),75,1);
        Z_lb2(vv,ii)=prctile(dv(:),2.5,1);
        Z_ub2(vv,ii)=prctile(dv(:),97.5,1);
    end

end


Inqv_t={'MMR','DTaP','IPV','VAR'};
Variables=Variables(5:end);
figure('units','normalized','outerposition',[0.1 0.1 0.7 0.8]);
for vv=1:4
    subplot('Position',[0.16+0.495.*rem(vv-1,2),0.61-0.5.*floor(vv/3),0.325,0.355]);
    [~,indxs]=sort(Z_mean(vv,:));
    yt=Variables(indxs);
    for ii=1:length(indxs)
        plot([Z_lb2(vv,indxs(ii)) Z_ub2(vv,indxs(ii))] ,[ii ii],'k','LineWidth',2); hold on
        patch([Z_lb1(vv,indxs(ii)) Z_lb1(vv,indxs(ii)) Z_ub1(vv,indxs(ii)) Z_ub1(vv,indxs(ii))] ,ii+[-0.15 0.15 0.15 -0.15],'k','LineStyle','none','FaceAlpha',0.3); 
        scatter(Z_mean(vv,indxs(ii)),ii,60,'kd','filled');        
    end
    plot(zeros(length(indxs)+2,1),[0:(length(indxs)+1)],'-.','color',[0.5 0.5 0.5],'LineWidth',1.5);    
    ylim([0 length(indxs)+1])
    xlim([-1.5 0.5])
    title(Inqv_t{vv})
    box off;
    set(gca,'LineWidth',2,'tickdir','out','YTick',[1:length(indxs)],'YTickLabel',yt,'Fontsize',14,'XTick',[-1.5:0.5:0.5],'XMinorTick','on')
    xtickangle(0);
    xtickformat('percentage')
    ylabel('External factor','FontSize',18)
    xlabel('Coefficient value','FontSize',18)
    text(-0.475,1.025,char(64+vv),'Fontsize',24,'Units','normalized');
end
print(gcf,['Figure3.png'],'-dpng','-r600');
print(gcf,['Figure3.tiff'],'-dtiff','-r600');
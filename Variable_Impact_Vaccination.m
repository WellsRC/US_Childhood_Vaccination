clear;
clc;

T_State=readtable("Data_Transformed_Combined_State_Level.xlsx");

X_State=[T_State.Economic T_State.Education T_State.Income T_State.Political T_State.Race T_State.Sex T_State.Trust_in_Medicine T_State.Trust_in_Science T_State.Uninsured_19_under];

Y_State=T_State.Vaccine_Uptake;

TS_State=T_State.Trust_in_Science;

D_State=T_State.Vaccine_Disease;

RE_State=T_State.State_Religous_Exemptions;

PE_State=T_State.State_Philosophical_Exemptions;

COVID_State=T_State.COVID;

X_indx=[1	0	1	0	1	0	1	1	0];
S_indx=[0	0	0	1	1	0	1	0	0];


Inqv={'MMR','DTaP','Polio','VAR'};
Vac_Name={'MMR','DTaP','IPV','VAR'};
VN={'Economic','Education','Income','Political','Race','Sex','Trust_in_Medicine','Trust_in_Science','Uninsured_19_under'};

% Trust in science was impacted by covid-19 pandemic and that is the period
% we are looking at

science_ts=COVID_State==1;
X_temp=X_State(science_ts,:);
X_temp=X_temp(:,S_indx==1);
Y_temp=TS_State(science_ts);
mdl_temp= fitlm(X_temp,Y_temp);
beta_ms=mdl_temp.Coefficients.Estimate(end);

Var_Name=VN(X_indx==1);
Beta_Coeff=NaN.*zeros(length(Inqv),sum(X_indx)+1);
Beta_Coeff_Strat=NaN.*zeros(length(Inqv),2,2,sum(X_indx)+1);
Beta_Coeff_Stratp=NaN.*zeros(length(Inqv),2,2,sum(X_indx)+1);

mdl_v=cell(4,2,2);



% COVID-19 had no direct imapct on vaccination No filtering based on time
for jj=1:4
    t_state=strcmp(Inqv{jj},D_State);
    X_temp=X_State(t_state,:);
    X_temp=X_temp(:,X_indx==1);
    Y_temp=Y_State(t_state);
    mdl_temp= fitlm(X_temp,Y_temp);
    Beta_Coeff(jj,:)=mdl_temp.Coefficients.Estimate;
    for pp=0:1
        t_PE=PE_State==pp;

        for rr=0:1
            t_RE=RE_State==rr;

            t_indx=t_state  & t_PE & t_RE;

            if(sum(t_indx)>0 )
                X_temp=X_State(t_indx,:);
                X_temp=X_temp(:,X_indx==1);
                Y_temp=Y_State(t_indx);
                mdl_temp= fitlm(X_temp,Y_temp);
                Beta_Coeff_Strat(jj,pp+1,rr+1,:)=mdl_temp.Coefficients.Estimate;
                Beta_Coeff_Stratp(jj,pp+1,rr+1,:)=mdl_temp.Coefficients.pValue;
                mdl_v{jj,pp+1,rr+1}=mdl_temp;
            end
        end

    end
end

No_Exemptions=cell(4.*sum(X_indx),1);
Only_Religous_Exemptions=cell(4.*sum(X_indx),1);
Religous_and_Philosophical_Exemptions=cell(4.*sum(X_indx),1);
Variable=cell(4.*sum(X_indx),1);
Vaccine=cell(4.*sum(X_indx),1);

for jj=1:4
    Variable([1:sum(X_indx)]+sum(X_indx).*(jj-1))=VN(X_indx==1);
    Vaccine([1:sum(X_indx)]+sum(X_indx).*(jj-1))=Vac_Name(jj);
    No_E=squeeze(Beta_Coeff_Strat(jj,1,1,2:end));
    ORE=squeeze(Beta_Coeff_Strat(jj,1,2,2:end));
    RPE=squeeze(Beta_Coeff_Strat(jj,2,2,2:end));

    No_Ep=squeeze(Beta_Coeff_Stratp(jj,1,1,2:end));
    OREp=squeeze(Beta_Coeff_Stratp(jj,1,2,2:end));
    RPEp=squeeze(Beta_Coeff_Stratp(jj,2,2,2:end));
    
    for kk=1:sum(X_indx)
        No_Exemptions{kk+sum(X_indx).*(jj-1)}=[ num2str(No_E(kk),'%4.3f') ' (p=' num2str(No_Ep(kk),'%3.2e') ')'];
        Only_Religous_Exemptions{kk+sum(X_indx).*(jj-1)}=[ num2str(ORE(kk),'%4.3f') ' (p=' num2str(OREp(kk),'%3.2e') ')'];
        Religous_and_Philosophical_Exemptions{kk+sum(X_indx).*(jj-1)}=[ num2str(RPE(kk),'%4.3f') ' (p=' num2str(RPEp(kk),'%3.2e') ')'];
    end
end

T=table(Vaccine,Variable,No_Exemptions,Only_Religous_Exemptions,Religous_and_Philosophical_Exemptions);

writetable(T,'Table_Regression_Coefficient_Main_Text.csv')

S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));
for ii=1:length(State_FIP)
    State_FIP(ii)=str2double(State_FIPc{ii});
end
S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);
County_ID_temp={S.GEOID};
County_ID=zeros(size(County_ID_temp));
for ii=1:length(County_ID)
    County_ID(ii)=str2double(County_ID_temp{ii});
end

State_FIPc={S.STATEFP};
County_State_FIP=zeros(size(State_FIPc));
for ii=1:length(County_State_FIP)
    County_State_FIP(ii)=str2double(State_FIPc{ii});
end

clearvars -except County_ID County_State_FIP S Beta_Coeff_Strat Var_Name mdl_v beta_ms

Yr=2021;


N_Samp=30;
Rand_Indx=randi(1000,N_Samp,1);
Rand_Trust_S=randi(1000,N_Samp,2);
Rand_Trust_M=randi(1000,N_Samp,2);

Inqv={'MMR','DTaP','Polio','VAR'};%
X_County=zeros(length(County_ID),length(Var_Name),N_Samp);
v=zeros(length(Inqv),length(County_ID),N_Samp);

m=zeros(length(County_ID),N_Samp);
s=zeros(length(County_ID),N_Samp);



[RVE,PVE] = Exemption_Timeline(Yr,County_State_FIP);

for kk=1:length(Inqv)
    v(kk,:,:)=repmat(County_Immunization_Statistics(Inqv{kk},Yr,County_ID),1,N_Samp);
end

beta_s=zeros(length(Inqv),length(County_ID));
beta_m=zeros(length(Inqv),length(County_ID));

for ss=1:N_Samp
    for vv=1:length(Var_Name)
        if strcmp(Var_Name{vv},'Trust_in_Medicine')
            var_temp=Return_County_Data(Var_Name{vv},Yr,County_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:)); 
            m(:,ss)=var_temp;
            X_County(:,vv,ss)=log(var_temp./(1-var_temp));
        elseif strcmp(Var_Name{vv},'Trust_in_Science')
            var_temp=Return_County_Data(Var_Name{vv},Yr,County_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));      
            s(:,ss)=var_temp;
            X_County(:,vv,ss)=log(var_temp./(1-var_temp));
        elseif strcmp(Var_Name{vv},'Income')
            [County_Demo,Data_Year]=Demographics_County(Var_Name{vv},County_ID,Rand_Indx(ss));
            var_temp=County_Demo(:,Data_Year==Yr);
            X_County(:,vv,ss)=log(var_temp);
        else
            [County_Demo,Data_Year]=Demographics_County(Var_Name{vv},County_ID,Rand_Indx(ss));
            var_temp=County_Demo(:,Data_Year==Yr);
            X_County(:,vv,ss)=log(var_temp./(1-var_temp));
        end
    end
    for kk=1:length(Inqv)
        for pp=0:1
            for rr=0:1
                beta_s(kk,RVE==rr  & PVE==pp)=Beta_Coeff_Strat(kk,pp+1,rr+1,find(strcmp(Var_Name,'Trust_in_Science'))+1);
                beta_m(kk,RVE==rr  & PVE==pp)=Beta_Coeff_Strat(kk,pp+1,rr+1,find(strcmp(Var_Name,'Trust_in_Medicine'))+1);
                t_nan=isnan(squeeze(v(kk,:,ss))') & RVE==rr  & PVE==pp;
                if(sum(t_nan)>0)
                    X_temp=X_County(t_nan,:,ss);
                    v_temp=predict(mdl_v{kk,pp+1,rr+1},X_temp);
                    v(kk,t_nan,ss)=1./(1+exp(-v_temp));
                end
            end
        end        
    end
end
m= mean(m,2);
s= mean(s,2);

close all;

U_State_FIP=unique(County_State_FIP);
load('State_FIP_Mapping_Acronym.mat');

Vac_Nam={'MMR','DTaP','IPV','VAR'};
for kk=1:4
    v_cov=real(mean(v(kk,:,:),3));
    beta_m_d=beta_m(kk,:);
    beta_s_d=beta_s(kk,:);
    dvdm = Trust_Medicine_Influence_Uptake(v_cov(:),m(:),beta_m_d(:),beta_ms,beta_s_d(:));
    dvds = Trust_Science_Influence_Uptake(v_cov(:),s(:),beta_s_d(:));


    State_dvdm=zeros(size(U_State_FIP));
    State_dvds=zeros(size(U_State_FIP));

    for jj=1:length(U_State_FIP)
        tf=County_State_FIP==U_State_FIP(jj);
        temp=dvdm(tf);
        State_dvdm(jj)=median(temp(~isnan(temp)));
        temp=dvds(tf);
        State_dvds(jj)=median(temp(~isnan(temp)));
    end
    
    [~,S_m_indx]=sort(State_dvdm);
    [~,S_s_indx]=sort(State_dvds);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Trust in medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    Sorted_U_State_FIP=U_State_FIP(S_m_indx);
    State_dvdm=State_dvdm(S_m_indx);

    x_h=[-1.025:0.05:1.025];
    C=[0.4 0 0;0.9 0.9 0.9; 0 0 0.4];
    
    xc=[-max(abs(dvdm)) 0 max(abs(dvdm))];
    
    figure('units','normalized','outerposition',[0.1 0.1 0.7 0.5]);
    subplot('Position',[0.115,0.223,0.875,0.745])
    plot(linspace(-1,length(Sorted_U_State_FIP)+1,101),zeros(101,1),'k-.','LineWidth',1.5); hold on
    XTL=cell(size(Sorted_U_State_FIP));
    temp_FIP=[State_FIP_Mapping{:,1}];
    for jj=1:length(Sorted_U_State_FIP)
        tg=temp_FIP==Sorted_U_State_FIP(jj);
        XTL{jj}=State_FIP_Mapping{tg,3};
        tf=County_State_FIP==Sorted_U_State_FIP(jj);
        x_county_p=dvdm(tf);
        n_h=histcounts(x_county_p,x_h);
        for ss=1:length(x_h)-1
            if(n_h(ss)>0)
                tp=x_county_p>=x_h(ss) & x_county_p<x_h(ss+1);
                dxx=linspace(-0.2,0.2,n_h(ss)+2);
                dxx=dxx(2:end-1);                
                scatter(jj+dxx,x_county_p(tp),10,interp1(xc,C,x_county_p(tp)),'filled'); hold on;
            end
        end
    end
    ylim(round([xc(1) xc(3)],1))
    xlim([0.65 length(Sorted_U_State_FIP)+0.35] )
    box off;
    set(gca,'LineWidth',2,'TickDir','out','Fontsize',16,'XTick',[1:length(Sorted_U_State_FIP)],'XTickLabel',XTL)
    xlabel('State','Fontsize',18)
    ylabel({'Impact of trust in medicine',['on ' Vac_Nam{kk} ' uptake']},'Fontsize',18)
    text(-0.123,1,char(63+2.*(kk)),'Units','normalized','Fontsize',26)
% 
%     fold_c=dvdm./dvds;
    print(gcf,['Impact_Trust_Medicine_Vac_' Inqv{kk} '.png'],'-dpng','-r600');
     figure('units','normalized','outerposition',[0.2 0.2 0.5 0.5]);
     ax=usamap('conus');
    
    framem off; gridm off; mlabel off; plabel off;
    ax.Position=[-0.35,-0.15,1.14,1.14];
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;
    
    % Create the colour bar
    subplot('Position',[0.8,0.03,0.016827731092438,0.95]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 1]);    
    ymin=3;
    dy=2/(1+sqrt(5));
    for ii=1:length(dx)-1
        patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(xc,C,min(xc)+(max(xc)-min(xc)).*dx(ii)),'LineStyle','none');
    end
    
    
    dx_t=(xc-min(xc))./(max(xc)-min(xc));
    for mm=1:length(xc)
        text(ymin,dx_t(mm),num2str(xc(mm),'%4.3f'),'HorizontalAlignment','center','Fontsize',16);
    end
    text(ymin+4.35,0.5,{'Impact of trust in medicine',['on ' Vac_Nam{kk} ' uptake']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    
    
    ax.Position=[-0.18,-0.15,1.14,1.14];
    
    NS=length(County_ID);
    
    CC_county=ones(length(County_ID),3);
    
    for ii=1:length(County_ID)
        if(~isnan(dvdm(ii)))
            CC_county(ii,:)=interp1(xc,C,dvdm(ii));
        else
            CC_county(ii,:)=[0.7 0.7 0.7];
        end
    end
        
        
    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
    % title(ax,[num2str(Year_Plot)],'Units','Normalized','Position',[0.5 0.9 0],'Fontsize',26)
    
    geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;

    text(-46.5,0.99,char(64+2.*(kk)),'Units','normalized','Fontsize',26)
    print(gcf,['Impact_Trust_Medicine_Vac_Map_' Inqv{kk} '.png'],'-dpng','-r600');
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Trust in science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    Sorted_U_State_FIP=U_State_FIP(S_s_indx);
    State_dvds=State_dvds(S_s_indx);

    x_h=[-1.025:0.05:1.025];
    C=[0.4 0 0;0.9 0.9 0.9; 0 0 0.4];
    
    xc=[-max(abs(dvds)) 0 max(abs(dvds))];
    
    figure('units','normalized','outerposition',[0.1 0.1 0.7 0.5]);
    subplot('Position',[0.115,0.223,0.875,0.745])
    plot(linspace(-1,length(Sorted_U_State_FIP)+1,101),zeros(101,1),'k-.','LineWidth',1.5); hold on
    XTL=cell(size(Sorted_U_State_FIP));
    temp_FIP=[State_FIP_Mapping{:,1}];
    for jj=1:length(Sorted_U_State_FIP)
        tg=temp_FIP==Sorted_U_State_FIP(jj);
        XTL{jj}=State_FIP_Mapping{tg,3};
        tf=County_State_FIP==Sorted_U_State_FIP(jj);
        x_county_p=dvds(tf);
        n_h=histcounts(x_county_p,x_h);
        for ss=1:length(x_h)-1
            if(n_h(ss)>0)
                tp=x_county_p>=x_h(ss) & x_county_p<x_h(ss+1);
                dxx=linspace(-0.2,0.2,n_h(ss)+2);
                dxx=dxx(2:end-1);                
                scatter(jj+dxx,x_county_p(tp),10,interp1(xc,C,x_county_p(tp)),'filled'); hold on;
            end
        end
    end
    if(round(xc(1),1)<round(xc(3),1))
        ylim(round([xc(1) xc(3)],1))
    else
        ylim(round([xc(1) xc(3)],3))
    end
    xlim([0.65 length(Sorted_U_State_FIP)+0.35] )
    box off;
    set(gca,'LineWidth',2,'TickDir','out','Fontsize',16,'XTick',[1:length(Sorted_U_State_FIP)],'XTickLabel',XTL)
    xlabel('State','Fontsize',18)
    ylabel({'Impact of trust in science',['on ' Vac_Nam{kk} ' uptake']},'Fontsize',18)
    text(-0.123,1,char(63+2.*(kk)),'Units','normalized','Fontsize',26)
% 
%     fold_c=dvdm./dvds;
    print(gcf,['Impact_Trust_Science_Vac_' Inqv{kk} '.png'],'-dpng','-r600');
     figure('units','normalized','outerposition',[0.2 0.2 0.5 0.5]);
     ax=usamap('conus');
    
    framem off; gridm off; mlabel off; plabel off;
    ax.Position=[-0.35,-0.15,1.14,1.14];
    
    states = shaperead('usastatelo', 'UseGeoCoords', true);
    geoshow(ax, states,'Facecolor','none','LineWidth',0.5); hold on;
    
    % Create the colour bar
    subplot('Position',[0.8,0.03,0.016827731092438,0.95]);
    dx=linspace(0,1,1001);
    xlim([0 1]);
    ylim([0 1]);    
    ymin=3;
    dy=2/(1+sqrt(5));
    for ii=1:length(dx)-1
        patch([0 0 dy dy],[dx(ii) dx(ii+1) dx(ii+1) dx(ii)],interp1(xc,C,min(xc)+(max(xc)-min(xc)).*dx(ii)),'LineStyle','none');
    end
    
    
    dx_t=(xc-min(xc))./(max(xc)-min(xc));
    for mm=1:length(xc)
        text(ymin,dx_t(mm),num2str(xc(mm),'%4.3f'),'HorizontalAlignment','center','Fontsize',16);
    end
    text(ymin+4.35,0.5,{'Impact of trust in science',['on ' Vac_Nam{kk} ' uptake']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
    axis off;    
    
    ax.Position=[-0.18,-0.15,1.14,1.14];
    
    NS=length(County_ID);
    
    CC_county=ones(length(County_ID),3);
    
    for ii=1:length(County_ID)
        if(~isnan(dvds(ii)))
            CC_county(ii,:)=interp1(xc,C,dvds(ii));
        else
            CC_county(ii,:)=[0.7 0.7 0.7];
        end
    end       
        
    
    CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county});
    % title(ax,[num2str(Year_Plot)],'Units','Normalized','Position',[0.5 0.9 0],'Fontsize',26)
    
    geoshow(ax,S,'SymbolSpec',CM,'LineStyle','None'); 
    
    geoshow(ax, states,'Facecolor','none','LineWidth',1.5); hold on;

    text(-46.5,0.99,char(64+2.*(kk)),'Units','normalized','Fontsize',26)
    print(gcf,['Impact_Trust_Science_Vac_Map_' Inqv{kk} '.png'],'-dpng','-r600');
end


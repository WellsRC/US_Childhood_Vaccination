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
Yr=[2017:2021];
Scenario={'Overall';'No exemptions';'Any exemption';'Only religious exemptions';'Religious and philosophical exemptions'};



N_Samp=50;
Rand_Indx=randi(1000,N_Samp,1);
Rand_Trust_S=randi(1000,N_Samp,2);
Rand_Trust_M=randi(1000,N_Samp,2);

Var_Namev={'Trust_in_Science','Trust_in_Medicine'};
for dd=1:length(Var_Namev)
    V=zeros(length(State_ID),length(Yr),N_Samp);
    RE=zeros(length(State_ID),length(Yr));
    PE=zeros(length(State_ID),length(Yr));
    m_slope=zeros(length(State_ID),2);
    Var_Name=Var_Namev{dd};
    for yy=1:length(Yr)
        parfor ss=1:N_Samp
            if strcmp(Var_Name,'Trust_in_Medicine')
                V(:,yy,ss)=Return_State_Data(Var_Name,Yr(yy),State_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:)); 
%                 V(:,yy,ss)=log(var_temp./(1-var_temp));
            elseif strcmp(Var_Name,'Trust_in_Science')
                V(:,yy,ss)=Return_State_Data(Var_Name,Yr(yy),State_ID,Rand_Indx(ss),Rand_Trust_S(ss,:),Rand_Trust_M(ss,:));      
%                 V(:,yy,ss)=log(var_temp./(1-var_temp));
            end
        end
    end
    V=squeeze(median(V,3));
    for yy=1:length(Yr)  
        [RE(:,yy),PE(:,yy)] = Exemption_Timeline(Yr(yy),State_ID);
    end

    for ss=1:length(State_ID)
        for mm=1:2
            if(mm==1)
                test_m=polyfit(Yr(Yr<=2019),V(ss,Yr<=2019),1);
                m_slope(ss,mm)=test_m(1);
            else
                test_m=polyfit(Yr(Yr>=2019),V(ss,Yr>=2019),1);
                m_slope(ss,mm)=test_m(1);
            end
        end
    end
    Pre_pandemic=zeros(size(Scenario));
    Pandemic=zeros(size(Scenario));
    Pandemic_Effect=zeros(size(Scenario));
    
    V0=V(:,Yr<2020);
    Pre_pandemic(1)=median(V0(~isnan(V0)));
    V1=V(:,Yr>=2020);
    Pandemic(1)=median(V1(~isnan(V1)));
    [Pandemic_Effect(1)]=ranksum(V0(:),V1(:),'tail','left');

    V0=V(:,Yr<2020);
    V0=V0(:);
    R_temp=RE(:,Yr<2020);
    R_temp=R_temp(:);
    P_temp=PE(:,Yr<2020);
    P_temp=P_temp(:);
    V0=V0(R_temp==1 | P_temp==1);
    Pre_pandemic(3)=median(V0(~isnan(V0)));

    V1=V(:,Yr>=2020);
    V1=V1(:);
    R_temp=RE(:,Yr>=2020);
    R_temp=R_temp(:);
    P_temp=PE(:,Yr>=2020);
    P_temp=P_temp(:);
    V1=V1(R_temp==1 | P_temp==1);
    Pandemic(3)=median(V1(~isnan(V1)));
    [Pandemic_Effect(3)]=ranksum(V0,V1,'tail','left');
    
    Rv=[0 1 1];
    Pv=[0 0 1];
    Inx=[2 4 5];
    for ii=1:length(Rv)
        V0=V(:,Yr<2020);
        V0=V0(:);
        R_temp=RE(:,Yr<2020);
        R_temp=R_temp(:);
        P_temp=PE(:,Yr<2020);
        P_temp=P_temp(:);
        V0=V0(R_temp==Rv(ii) & P_temp==Pv(ii));
        Pre_pandemic(Inx(ii))=median(V0(~isnan(V0)));

        V1=V(:,Yr>=2020);
        V1=V1(:);
        R_temp=RE(:,Yr>=2020);
        R_temp=R_temp(:);
        P_temp=PE(:,Yr>=2020);
        P_temp=P_temp(:);
        V1=V1(R_temp==Rv(ii) & P_temp==Pv(ii));
        Pandemic(Inx(ii))=median(V1(~isnan(V1)));
        [Pandemic_Effect(Inx(ii))]=ranksum(V0,V1,'tail','left');
    end
    Pre_pandemic=[num2str(Pre_pandemic,'%.4f')];
    Pandemic=[num2str(Pandemic,'%.4f')];
    t_p=Pandemic_Effect<0.001;
    Pandemic_Effect=[num2str(Pandemic_Effect,'p = %.3f')];
    Pandemic_Effect(t_p,:)=repmat('p < 0.001',sum(t_p),1);
    T1=table(Scenario,Pre_pandemic,Pandemic,Pandemic_Effect);
    
    writetable(T1,'Table_1_Trust_Dynamics.xlsx','Sheet',Var_Name)


    Pre_pandemic=zeros(size(Scenario));
    Pandemic=zeros(size(Scenario));
    Pandemic_Effect=zeros(size(Scenario));
    
    V0=m_slope(:,1);
    Pre_pandemic(1)=median(V0(~isnan(V0)));
    V1=m_slope(:,2);
    Pandemic(1)=median(V1(~isnan(V1)));
    d_mslope=m_slope(:,1)-m_slope(:,2);
    [Pandemic_Effect(1)]=signrank(d_mslope,0,'tail','right');

    V0=m_slope(:,1);
    V0=V0(:);
    R_temp=RE(:,Yr==2019);
    R_temp=R_temp(:);
    P_temp=PE(:,Yr==2019);
    P_temp=P_temp(:);
    V0=V0(R_temp==1 | P_temp==1);
    Pre_pandemic(3)=median(V0(~isnan(V0)));

    V1=m_slope(:,2);
    V1=V1(:);
    R_temp=RE(:,Yr==2020);
    R_temp=R_temp(:);
    P_temp=PE(:,Yr==2020);
    P_temp=P_temp(:);
    V1=V1(R_temp==1 | P_temp==1);
    Pandemic(3)=median(V1(~isnan(V1)));
    d_mslope=m_slope(R_temp==1 | P_temp==1,1)-m_slope(R_temp==1 | P_temp==1,2);
    [Pandemic_Effect(3)]=signrank(d_mslope,0,'tail','right');
    Rv=[0 1 1];
    Pv=[0 0 1];
    Inx=[2 4 5];
    for ii=1:length(Rv)
        V0=m_slope(:,1);
        V0=V0(:);
        R_temp=RE(:,Yr==2019);
        R_temp=R_temp(:);
        P_temp=PE(:,Yr==2019);
        P_temp=P_temp(:);
        V0=V0(R_temp==Rv(ii) & P_temp==Pv(ii));
        Pre_pandemic(Inx(ii))=median(V0(~isnan(V0)));

        V1=m_slope(:,2);
        V1=V1(:);
        R_temp=RE(:,Yr==2020);
        R_temp=R_temp(:);
        P_temp=PE(:,Yr==2020);
        P_temp=P_temp(:);
        V1=V1(R_temp==Rv(ii) & P_temp==Pv(ii));
        Pandemic(Inx(ii))=median(V1(~isnan(V1)));
        d_mslope=m_slope(R_temp==Rv(ii) & P_temp==Pv(ii),1)-m_slope(R_temp==Rv(ii) & P_temp==Pv(ii),2);
        [Pandemic_Effect(Inx(ii))]=signrank(d_mslope,0,'tail','right');
    end
    Pre_pandemic=[num2str(Pre_pandemic,'%1.2e')];
    Pandemic=[num2str(Pandemic,'%1.2e')];    
    t_p=Pandemic_Effect<0.001;
    Pandemic_Effect=[num2str(Pandemic_Effect,'p = %.3f')];
    Pandemic_Effect(t_p,:)=repmat('p < 0.001',sum(t_p),1);
    T1=table(Scenario,Pre_pandemic,Pandemic,Pandemic_Effect);

    writetable(T1,'Table_2_Trust_Dynamics.xlsx','Sheet',Var_Name)
end


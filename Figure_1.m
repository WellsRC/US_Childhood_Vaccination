clear;
clc;
close all;
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
Inqv={'MMR','DTaP','Polio','VAR'};
Inqvt={'MMR','DTaP','IPV','VAR'};
C=[hex2rgb('#000000');
    hex2rgb('#4daf4a');
    hex2rgb('#e41a1c');
    hex2rgb('#377eb8');
    hex2rgb('#984ea3');];
sym={'s','p','d','<','o'};

figure('units','normalized','outerposition',[0.1 0.1 0.7 0.9]);
for dd=1:length(Inqv)

    LP=zeros(length(Scenario),length(Yr));

    V=zeros(length(State_ID),length(Yr));
    RE=zeros(length(State_ID),length(Yr));
    PE=zeros(length(State_ID),length(Yr));
    m_slope=zeros(length(State_ID),2);
    Inq=Inqv{dd};
    for yy=1:length(Yr)
        V(:,yy)=State_Immunization_Statistics(Inq,Yr(yy),State_ID);    
        [RE(:,yy),PE(:,yy)] = Exemption_Timeline(Yr(yy),State_ID);
    end

%     V=real(log(V./(1-V)));
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
    V_Pivot=zeros(size(Scenario));
    VB=V(:,Yr==2019);
    
    V_Pivot(1)=median(VB(~isnan(VB)));
    V0=m_slope(:,1);
    Pre_pandemic(1)=median(V0(~isnan(V0)));
    V1=m_slope(:,2);
    Pandemic(1)=median(V1(~isnan(V1)));

    V0=m_slope(:,1);
    V0=V0(:);
    R_temp=RE(:,Yr==2019);
    R_temp=R_temp(:);
    P_temp=PE(:,Yr==2019);
    P_temp=P_temp(:);
    V0=V0(R_temp==1 | P_temp==1);
    Pre_pandemic(3)=median(V0(~isnan(V0)));

    VBt=VB(R_temp==1 | P_temp==1);
    V_Pivot(3)=median(VBt(~isnan(VBt)));

    V1=m_slope(:,2);
    V1=V1(:);
    R_temp=RE(:,Yr==2020);
    R_temp=R_temp(:);
    P_temp=PE(:,Yr==2020);
    P_temp=P_temp(:);
    V1=V1(R_temp==1 | P_temp==1);
    Pandemic(3)=median(V1(~isnan(V1)));

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

        VBt=VB(R_temp==Rv(ii) & P_temp==Pv(ii));
        V_Pivot(Inx(ii))=median(VBt(~isnan(VBt)));

        V1=m_slope(:,2);
        V1=V1(:);
        R_temp=RE(:,Yr==2020);
        R_temp=R_temp(:);
        P_temp=PE(:,Yr==2020);
        P_temp=P_temp(:);
        V1=V1(R_temp==Rv(ii) & P_temp==Pv(ii));
        Pandemic(Inx(ii))=median(V1(~isnan(V1)));
    end

    
    subplot('Position',[0.085+0.495.*rem(dd-1,2),0.67-0.48.*floor(dd/3),0.4,0.30]);
    
    xtl={['2017' char(8212) '18'],['2018' char(8212) '19'],['2019' char(8212) '20'],['2020' char(8212) '21'],['2021' char(8212) '22']};
    for ii=1:length(Scenario)
        x=[0:4];
        y=zeros(5,1);
        b=V_Pivot(ii)-Pre_pandemic(ii).*2;
        y(1:3)=Pre_pandemic(ii).*x(1:3)+b;
        b=V_Pivot(ii)-Pandemic(ii).*2;
        y(4:5)=Pandemic(ii).*x(4:5)+b;
        plot(x,100.*y,['-' sym{ii}],'Color',C(ii,:),'LineWidth',2,'MarkerSize',8,'MarkerFaceColor',C(ii,:)); hold on;
    end
    ylim([90 100]);
    grid on;
    title(Inqvt{dd})
    ytickformat('percentage');
    box off;
    set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',x,'XTicklabel',xtl);
    xtickangle(90);
    
    ylabel('Vaccine uptake','FontSize',18)
    xlabel('School year','FontSize',18)

    text(-0.2,1,char(64+dd),'Fontsize',24,'Units','normalized');
    if(dd==4)
        legend({'Overall','None','Any','Religious','Religious & Philisophical'},'Position',[0.27484940605081,0.010586318006062,0.475903605997383,0.02844140998197],'NumColumns',5,'Fontsize',16)
    end
end


print(gcf,['Figure1.png'],'-dpng','-r600');
print(gcf,['Figure1.tiff'],'-dtiff','-r600');



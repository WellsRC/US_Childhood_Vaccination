function Bar_Chart_Impact_Trust_and_Uninsured_Overall_Weight(Vac_Nam)
clc;
close all;

S=shaperead([pwd '\State_Data\County_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));
for ii=1:length(State_FIP)
State_FIP(ii)=str2double(State_FIPc{ii});
end
S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));
County_ID_temp={S.GEOID};
County_ID=zeros(size(County_ID_temp));
for ii=1:length(County_ID)
    County_ID(ii)=str2double(County_ID_temp{ii});
    State_FIP(ii)=str2double(State_FIPc{ii});
end

USFIP=unique(State_FIP);

if(strcmp(Vac_Nam,'IPV'))
    load(['Impact_Trust_Medicine_Science_on_Uptake_Polio_2021_Overall_Weight.mat'],'dvds','dvdm','dvdu','vac_d');
else
    load(['Impact_Trust_Medicine_Science_on_Uptake_' Vac_Nam '_2021_Overall_Weight.mat'],'dvds','dvdm','dvdu','vac_d');
end

load('State_FIP_Mapping_Acronym.mat');
Yr=2021;

load([pwd '\State_Data\County_Data\County_Population_' num2str(randi(1000)) '.mat']);
Data_CID=Population.County_ID_Numeric;
Data_Year=Population.Year_Data;
PS=Population.Sex;
P_tot=PS.Male(:,Yr==Data_Year)+PS.Female(:,Yr==Data_Year);

clear Data_Year PS 

med_vac_USFIP=zeros(size(USFIP));

for jj=1:length(USFIP)
    tf=(USFIP(jj)==State_FIP) & (~isnan(vac_d));
    tm=ismember(Data_CID,County_ID(tf));
    med_vac_USFIP(jj)=vac_d(tf)*P_tot(tm)./sum(P_tot(tm));
end

[~,sort_V]=sort(med_vac_USFIP);

USFIP=USFIP(sort_V);

XAL=cell(size(USFIP));
State_Name=cell(size(USFIP));
x_temp=[State_FIP_Mapping{:,1}];
for ii=1:length(USFIP)
    XAL{ii}=State_FIP_Mapping{x_temp==USFIP(ii),3};
    State_Name{ii}=State_FIP_Mapping{x_temp==USFIP(ii),2};
end

dvdu=-dvdu;

% dvdu(dvdu>=0.5)=0.5-10^(-8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
% Trust in medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
      C_uptake=[hex2rgb('#543005');
hex2rgb('#8c510a');
hex2rgb('#bf812d');
hex2rgb('#dfc27d');
hex2rgb('#f6e8c3');
hex2rgb('#35978f')];
    c_indx_uptake=[1:size(C_uptake,1)];
c_bound_uptake=[0 80;
         80 85;
         85 90;
         90 93;
         93 95;
         95 101]./100;

C_med=[hex2rgb('#f1eef6');
hex2rgb('#bdc9e1');
hex2rgb('#74a9cf');
hex2rgb('#0570b0');];
c_indx_med=[1:size(C_med,1)];
c_bound_med=[0 0.005;
             0.005 0.01;
             0.01 0.015;
             0.015 0.02];

C_sci=[hex2rgb('#ffffcc');
hex2rgb('#c2e699');
hex2rgb('#78c679');
hex2rgb('#31a354');
hex2rgb('#006837');];
c_indx_sci=[1:size(C_sci,1)];
c_bound_sci=[0 0.03;
             0.03 0.06;
             0.06 0.09;
             0.09 0.12;
             0.12 0.15;];


C_ins=[hex2rgb('#f2f0f7');
hex2rgb('#cbc9e2');
hex2rgb('#9e9ac8');
hex2rgb('#756bb1');
hex2rgb('#54278f');];
c_indx_ins=[1:size(C_ins,1)];
c_bound_ins=[0 0.1;
             0.1 0.2;
             0.2 0.3;
             0.3 0.4;
             0.4 0.5;];

     figure('units','normalized','outerposition',[0 0.075 1 1]);

        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot uptake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    subplot('Position',[0.06 0.57 0.435 0.4]);
        
    bb=zeros(length(USFIP),1);
    for jj=1:length(USFIP)        
        tf=(USFIP(jj)==State_FIP) & (~isnan(vac_d));
        tm=ismember(Data_CID,County_ID(tf));      
        bb(jj)=vac_d(tf)*P_tot(tm)./sum(P_tot(tm));
    end
    b=bar([1:length(USFIP)],100.*bb,'LineStyle','none');
    b.FaceColor="flat";
    for ii=1:length(USFIP)
        b.CData(ii,:)=C_uptake(c_indx_uptake(bb(ii)>=c_bound_uptake(:,1) & bb(ii)<c_bound_uptake(:,2)),:);
    end
    set(gca,'LineWidth',2,'Tickdir','out','XTick',[1:length(USFIP)],'XTickLabel',XAL,'YTick',[70:5:100],'Fontsize',14);
    ytickformat('percentage');
    ylim([70 100]);
    xlim([0.25 length(USFIP)+0.75])
    box off;
    ylabel([Vac_Nam ' uptake'],'Fontsize',20)
    xlabel(['State'],'Fontsize',20)
    text(-0.132,1,'A','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   subplot('Position',[0.56 0.57 0.435 0.4]);

   bb=zeros(length(USFIP),1);
    for jj=1:length(USFIP)        
        tf=(USFIP(jj)==State_FIP) & (~isnan(dvdm));
        tm=ismember(Data_CID,County_ID(tf));      
        bb(jj)=dvdm(tf)*P_tot(tm)./sum(P_tot(tm));
    end
    b=bar([1:length(USFIP)],bb,'LineStyle','none');
    b.FaceColor="flat";
    for ii=1:length(USFIP)
        b.CData(ii,:)=C_med(c_indx_med(bb(ii)>=c_bound_med(:,1) & bb(ii)<c_bound_med(:,2)),:);%interp1(x_med,C_med,bb(ii));
    end
    
    set(gca,'LineWidth',2,'Tickdir','out','XTick',[1:length(USFIP)],'XTickLabel',XAL,'Fontsize',14);
    xlim([0.25 length(USFIP)+0.75])
    box off;
    ylabel(['Elasticity of trust in medicine'],'Fontsize',20)
    xlabel(['State'],'Fontsize',20)

    fprintf('===================================================================================== \n');
    fprintf('Trust in medicine \n');
    fprintf('===================================================================================== \n');
    [~,indx_m]=sort(bb,'descend');
    for ii=1:3
        fprintf(['Rank ' num2str(ii) ': ' State_Name{indx_m(ii)} '\n']);
    end
    for ii=(length(USFIP)-2):length(USFIP)        
        fprintf(['Rank ' num2str(ii) ': ' State_Name{indx_m(ii)} '\n']);
    end
    text(-0.132,1,'B','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    subplot('Position',[0.06 0.085 0.435 0.4]);
    bb=zeros(length(USFIP),1);
    for jj=1:length(USFIP)        
        tf=(USFIP(jj)==State_FIP) & (~isnan(dvds));
        tm=ismember(Data_CID,County_ID(tf));      
        bb(jj)=dvds(tf)*P_tot(tm)./sum(P_tot(tm));
    end
    b=bar([1:length(USFIP)],bb,'LineStyle','none');
    b.FaceColor="flat";
    for ii=1:length(USFIP)
        b.CData(ii,:)=C_sci(c_indx_sci(bb(ii)>=c_bound_sci(:,1) & bb(ii)<c_bound_sci(:,2)),:);%interp1(x_sci,C_sci,bb(ii));
    end
    
    set(gca,'LineWidth',2,'Tickdir','out','XTick',[1:length(USFIP)],'XTickLabel',XAL,'Fontsize',14);
    xlim([0.25 length(USFIP)+0.75])
    box off;
    ylabel(['Elasticity of trust in science'],'Fontsize',20)
    xlabel(['State'],'Fontsize',20)

    fprintf('===================================================================================== \n');
    fprintf('Trust in science \n');
    fprintf('===================================================================================== \n');
    [~,indx_m]=sort(bb,'descend');
    for ii=1:3
        fprintf(['Rank ' num2str(ii) ': ' State_Name{indx_m(ii)} '\n']);
    end
    for ii=(length(USFIP)-2):length(USFIP)        
        fprintf(['Rank ' num2str(ii) ': ' State_Name{indx_m(ii)} '\n']);
    end
text(-0.132,1,'C','FontSize',32,'Units','normalized');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot insurance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  subplot('Position',[0.56 0.085 0.435 0.4]);
    bb=zeros(length(USFIP),1);
    for jj=1:length(USFIP)        
        tf=(USFIP(jj)==State_FIP) & (~isnan(dvdu));
        tm=ismember(Data_CID,County_ID(tf));      
        bb(jj)=dvdu(tf)*P_tot(tm)./sum(P_tot(tm));
    end
    bb(bb>=0.5)=0.5-10^(-8);
    b=bar([1:length(USFIP)],bb,'LineStyle','none');
    b.FaceColor="flat";
    for ii=1:length(USFIP)
        b.CData(ii,:)=C_ins(c_indx_ins(bb(ii)>=c_bound_ins(:,1) & bb(ii)<c_bound_ins(:,2)),:);%interp1(x_ins,C_ins,bb(ii));
    end
    ytl=cell(6,1);
    for jj=1:5
        ytl{jj}=num2str(0.1.*(jj-1));
    end
    ytl{6}=['0.50 +'];
    set(gca,'LineWidth',2,'Tickdir','out','XTick',[1:length(USFIP)],'XTickLabel',XAL,'Fontsize',14,'YTick',[0:0.1:0.5],'Yticklabel',ytl);
    xlim([0.25 length(USFIP)+0.75])
    box off;
    ylabel(['Elasticity of proportion insured'],'Fontsize',20)
    xlabel(['State'],'Fontsize',20)

    fprintf('===================================================================================== \n');
    fprintf('Insurance \n');
    fprintf('===================================================================================== \n');
    [~,indx_m]=sort(bb,'descend');
    for ii=1:3
        fprintf(['Rank ' num2str(ii) ': ' State_Name{indx_m(ii)} '\n']);
    end
    for ii=(length(USFIP)-2):length(USFIP)        
        fprintf(['Rank ' num2str(ii) ': ' State_Name{indx_m(ii)} '\n']);
    end
text(-0.132,1,'D','FontSize',32,'Units','normalized');
print(gcf,['Bar_' Vac_Nam '_Overall_Weight.png'],'-dpng','-r600');
end
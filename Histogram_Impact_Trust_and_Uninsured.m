function Histogram_Impact_Trust_and_Uninsured(Vac_Nam)
clc;
close all;

if(strcmp(Vac_Nam,'IPV'))
    load(['Impact_Trust_Medicine_Science_on_Uptake_Polio_2021.mat'],'dvds','dvdm','dvdu','vac_d');
else
    load(['Impact_Trust_Medicine_Science_on_Uptake_' Vac_Nam '_2021.mat'],'dvds','dvdm','dvdu','vac_d');
end
dvdu=-dvdu; % Want to examine the increase in insurance not an increase in the proportion uninsured
dvdu(dvdu>0.5)=0.5;
vac_d=real(vac_d);
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

C_med=[hex2rgb('#fff7fb');
hex2rgb('#ece7f2');
hex2rgb('#d0d1e6');
hex2rgb('#a6bddb');
hex2rgb('#74a9cf');
hex2rgb('#3690c0');
hex2rgb('#0570b0');
hex2rgb('#045a8d');
hex2rgb('#023858');];
x_med=linspace(0,0.02,size(C_med,1));

C_sci=[hex2rgb('#ffffe5');
hex2rgb('#f7fcb9');
hex2rgb('#d9f0a3');
hex2rgb('#addd8e');
hex2rgb('#78c679');
hex2rgb('#41ab5d');
hex2rgb('#238443');
hex2rgb('#006837');
hex2rgb('#004529');];
x_sci=linspace(0,0.1,size(C_sci,1));

C_ins=[hex2rgb('#fff7f3');
hex2rgb('#fde0dd');
hex2rgb('#fcc5c0');
hex2rgb('#fa9fb5');
hex2rgb('#f768a1');
hex2rgb('#dd3497');
hex2rgb('#ae017e');
hex2rgb('#7a0177');
hex2rgb('#49006a');];
x_ins=linspace(0,0.5,size(C_ins,1));

     figure('units','normalized','outerposition',[0 0.075 1 1]);

      
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot uptake
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   
subplot('Position',[0.06,0.6,0.43,0.36]);

n=histcounts(vac_d,[0.35:0.01:1]);
xc=[0.355:0.01:0.995];
b=bar(100.*xc,n,'LineStyle','none');
b.FaceColor = 'flat';
for ii=1:length(n)
    b.CData(ii,:)=C_uptake(c_indx_uptake(xc(ii)>=c_bound_uptake(:,1) & xc(ii)<c_bound_uptake(:,2)),:);
end
xlim([35 100])
ylim([0 ceil(max(n)./100).*100])
set(gca,'LineWidth',2,'TickDir','out','Xtick',100.*[0.35:0.05:1],'FontSize',18,'YTick',[0:100:ceil(max(n)./100).*100])
xtickformat('percentage')
box off;
xlabel([Vac_Nam ' uptake'],'FontSize',20)
ylabel(['Count'],'FontSize',20)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot medicine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
subplot('Position',[0.55,0.6,0.43,0.36]);


n=histcounts(dvdm,[0:0.001:0.02]);
xc=[0.0005:0.001:0.0195];
b=bar(xc,n,'LineStyle','none');
b.FaceColor = 'flat';
for ii=1:length(n)
    b.CData(ii,:)=interp1(x_med,C_med,xc(ii));
end
xlim([0 0.02])
ylim([0 ceil(max(n)./100).*100])
set(gca,'LineWidth',2,'TickDir','out','Xtick',[0:0.005:0.02],'FontSize',18,'YTick',[0:100:ceil(max(n)./100).*100])
box off;
xlabel(['Impact of increasing trust in medicine'],'FontSize',20)
ylabel(['Count'],'FontSize',20)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot science
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
subplot('Position',[0.06,0.1,0.43,0.36]);

n=histcounts(dvds,[0:0.005:0.1]);
xc=[0.0025:0.005:0.0975];
b=bar(xc,n,'LineStyle','none');
b.FaceColor = 'flat';
for ii=1:length(n)
    b.CData(ii,:)=interp1(x_sci,C_sci,xc(ii));
end
xlim([0 0.1])
ylim([0 ceil(max(n)./100).*100])
set(gca,'LineWidth',2,'TickDir','out','Xtick',[0:0.01:0.1],'FontSize',18,'YTick',[0:100:ceil(max(n)./100).*100])
box off;
xlabel(['Impact of increasing trust in science'],'FontSize',20)
ylabel(['Count'],'FontSize',20)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot insurance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
subplot('Position',[0.55,0.1,0.43,0.36]);

n=histcounts(dvdu,[0:0.01:0.5]);
xc=[0.005:0.01:0.495];
b=bar(xc,n,'LineStyle','none');
b.FaceColor = 'flat';
for ii=1:length(n)
    b.CData(ii,:)=interp1(x_ins,C_ins,xc(ii));
end
xlim([0 0.5])
ylim([0 ceil(max(n)./100).*100])
XTL=cell(length([0:0.05:0.5]),1);
for ii=1:length(XTL)
    if(ii<length(XTL))
        XTL{ii}=num2str(0.05.*(ii-1));
    else
        XTL{ii}=[num2str(0.05.*(ii-1)) '+'];
    end
end

set(gca,'LineWidth',2,'TickDir','out','Xtick',[0:0.05:0.5],'FontSize',18,'XTickLabel',XTL,'YTick',[0:100:ceil(max(n)./100).*100])
box off;
xlabel(['Impact of increasing proportion insured'],'FontSize',20)
ylabel(['Count'],'FontSize',20)
print(gcf,['Histogram_' Vac_Nam '.png'],'-dpng','-r600');
end
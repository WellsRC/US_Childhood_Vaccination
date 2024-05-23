clear;
clc;
close all;

T=readtable('Bayesian_Network.xlsx','Sheet','Summary');
Sheet_AIC=T.Sheet(T.delta_AIC==0);

T=readtable('Bayesian_Network.xlsx','Sheet',Sheet_AIC{:},'Range','B7:M20');

A=table2array(T(3:end,2:end));
N=T.Variable(3:end);

G=digraph(A,N);

xx=[-100 -1;
    -1 -0.75;
    -0.75 -0.5;
    -0.5 -0.25;
    -0.25 -0.01;
    -0.01  0;
    0 0.01
    0.01 0.25
    0.25 0.5
    0.5 0.75
    0.75 1
    1 100];

Cx=[hex2rgb('#67000d');
hex2rgb('#a50f15');
hex2rgb('#cb181d');
hex2rgb('#ef3b2c');
hex2rgb('#fb6a4a');
hex2rgb('#fc9272');

hex2rgb('#9ecae1');
hex2rgb('#6baed6');
hex2rgb('#4292c6');
hex2rgb('#2171b5');
hex2rgb('#08519c');
hex2rgb('#08306b')];

CE=zeros(length(G.Edges.Weight),3);

temp=cell(length(G.Edges.Weight),1);
for ii=1:length(G.Edges.Weight)
    tf=G.Edges.Weight(ii)>xx(:,1) & G.Edges.Weight(ii)<=xx(:,2);
    CE(ii,:)=Cx(tf,:);
    if(abs(G.Edges.Weight(ii))<0.01)
        temp{ii}='<0.01';
    else
        temp{ii}=num2str(abs(round(G.Edges.Weight(ii),2)));
    end
end

figure('units','normalized','outerposition',[0 0 1 1]);

plot(G,'EdgeColor',CE,'LineWidth',2,'Marker','s','Markersize',10,'NodeFontSize',18,'ArrowSize',12,'NodeColor','k','EdgeLabel',temp,'EdgeFontsize',18,'EdgeLabelColor',CE,'Layout','layered','Sinks',[4 5],'Sources',[7 8])
axis off
box off

print(gcf,['Bayesian_Network_Trust.png'],'-dpng','-r600');
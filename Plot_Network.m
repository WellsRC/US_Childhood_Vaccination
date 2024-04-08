clear;
clc;
close all;

p=0.01;
T=readtable('Network_Trust.xlsx','Sheet',['p=' num2str(p) ]);

A=table2array(T(:,2:end));
N=T.Variable;

G=digraph(A,N);

xx=[-max(abs(G.Edges.Weight)) -10^(-16) 10^(-16) max(abs(G.Edges.Weight))];
Cx=[hex2rgb('#ca0020');
hex2rgb('#f4a582');
hex2rgb('#92c5de');
hex2rgb('#0571b0')];

CE=zeros(length(G.Edges.Weight),3);

temp=cell(length(G.Edges.Weight),1);
for ii=1:length(G.Edges.Weight)
    CE(ii,:)=interp1(xx,Cx,G.Edges.Weight(ii));
    if(abs(G.Edges.Weight(ii))<0.01)
        temp{ii}='<0.01';
    else
        temp{ii}=num2str(abs(round(G.Edges.Weight(ii),2)));
    end
end

figure('units','normalized','outerposition',[0 0 1 1]);

plot(G,'EdgeColor',CE,'LineWidth',2,'Marker','s','Markersize',10,'NodeFontSize',20,'ArrowSize',12,'NodeColor','k','EdgeLabel',temp,'EdgeFontsize',12,'EdgeLabelColor',CE,'Layout','layered','Direction','right','Sinks',[7 8])
axis off
box off

print(gcf,['Network_Trust_p=' num2str(p) '.png'],'-dpng','-r600');
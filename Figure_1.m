
clear;
clc;
close all;


[State_ID,~,~]=Read_ID_Number();

Yr=[2017:2022];
Inqv={'MMR','DTaP','Polio','VAR','Parental_Trust_in_Science','Parental_Trust_in_Medicine'};
Title_Name={'MMR','DTaP','IPV','VAR','Trust in Science','Trust in Medicine'};
xtl={['2017' char(8212) '18'],['2018' char(8212) '19'],['2019' char(8212) '20'],['2020' char(8212) '21'],['2021' char(8212) '22'],['2022' char(8212) '23']};

figure('units','normalized','outerposition',[0.1 0.05 0.7 1]);
for dd=1:length(Inqv)


    Y=zeros(length(State_ID),length(Yr));
    if(~strcmp(Inqv{dd},'Parental_Trust_in_Science') && ~strcmp(Inqv{dd},'Parental_Trust_in_Medicine'))
        for yy=1:length(Yr)
            Y(:,yy)=State_Immunization_Statistics(Inqv{dd},Yr(yy),State_ID);    
        end
    else
        for yy=1:length(Yr)
            Y(:,yy)=Return_State_Data(Inqv{dd},Yr(yy),State_ID);    
        end
    end
        
    subplot('Position',[0.085+0.5.*rem(dd-1,2),0.72-0.295.*floor((dd-1)./2),0.4,0.245]);
    
    for ii=1:length(Yr)
        patch(Yr(ii)+[-0.4 -0.4 0.4 0.4],100.*prctile(Y(:,ii),[2.5 97.5 97.5 2.5]),'k','FaceAlpha',0.2,'LineStyle','none'); hold on
        patch(Yr(ii)+[-0.4 -0.4 0.4 0.4],100.*prctile(Y(:,ii),[25 75 75 25]),'k','FaceAlpha',0.3,'LineStyle','none'); hold on
        plot(Yr(ii)+[-0.4 0.4],100.*prctile(Y(:,ii),[50 50]),'k','LineWidth',2);
    end
    xlim([Yr(1)-0.5 Yr(end)+0.5])
    grid on;
    title(Title_Name{dd})
    ytickformat('percentage');
    box off;
    if(dd>=5)
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',Yr,'XTicklabel',xtl);
        xtickangle(90);
        xlabel('School year','FontSize',18)
    else
        set(gca,'LineWidth',2,'tickdir','out','Fontsize',14,'XTick',Yr,'XTicklabel',[]);
    end

    if(~strcmp(Inqv{dd},'Parental_Trust_in_Science') && ~strcmp(Inqv{dd},'Parental_Trust_in_Medicine'))
        ylabel('Vaccine uptake','FontSize',18)
        ylim([80 100]);
    else
        ylabel('Level of trust','FontSize',18)
        ylim([50 80]);
    end    

    text(-0.2,1.075,char(64+dd),'Fontsize',24,'Units','normalized');
end


print(gcf,['Figure1.png'],'-dpng','-r600');
print(gcf,['Figure1.tiff'],'-dtiff','-r600');



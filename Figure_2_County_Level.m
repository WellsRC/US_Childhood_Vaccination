clear;
clc;
close all;


[~,County_ID,~]=Read_ID_Number();

[W,Inqv]=Return_Model_Weights();

Variables={'Trust in Medicine','Trust in Science','Uninsured'};
Z_mean=zeros(4,length(Variables));
Z_median=zeros(4,length(Variables));
Z_lb1=zeros(4,length(Variables));
Z_ub1=zeros(4,length(Variables));
Z_lb2=zeros(4,length(Variables));
Z_ub2=zeros(4,length(Variables));
N_Samp=10^4;

Year_inq=2022;

for vv=1:4
    
    load(['State_County_Data_Cross_Validation_Model_Data_' Inqv{vv} '.mat'],"X_County",'RE_County','PE_County','Data_Yr_County');
    
    X_County=X_County(Data_Yr_County==Year_inq,:);
    RE_County=RE_County(Data_Yr_County==Year_inq);
    PE_County=PE_County(Data_Yr_County==Year_inq);

    
    temp=1./(1+exp(-X_County))+0.01; % Assume a 1% increase of unit change
    temp(temp>=1)=1-10^(-8);
    temp(:,4)=exp(X_County(:,4))+1000; % Roughly 1% of the maximum
    Z_County_Altered=log(temp./(1-temp));
    Z_County_Altered(:,4)=log(temp(:,4));
    Z_County_Altered(:,1)=ones(size(Z_County_Altered(:,1)));

    C=readtable('County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Inqv{vv} ]);
    M=table2array(C);
    w_c=cumsum(W{vv});

    r=rand(N_Samp,1);
    Indx=zeros(N_Samp,1);

    for ii=1:length(r)
        Indx(ii)=find(r(ii)<=w_c, 1 );
    end
    Mt=M(Indx,:);
    for ii=1:length(Variables)
        T_Old=[RE_County PE_County X_County(:,1:end)];
        if(strcmp(Variables{ii},'Trust in Science'))
            b_0=X_County(:,7)-0.491305085.*X_County(:,8); % Functino of trust in medicne and trust in science
            temp_trust_in_med=b_0+0.491305085.*Z_County_Altered(:,8); % new estimate for trust in medicne based off the change in trust in science
            T_New=[RE_County PE_County X_County(:,1:6) temp_trust_in_med Z_County_Altered(:,8) X_County(:,9)];
        elseif(ii==1)
            T_New=[RE_County PE_County X_County(:,1:6) Z_County_Altered(:,7) X_County(:,8:9)];
        elseif(ii==3)
            T_New=[RE_County PE_County X_County(:,1:8) Z_County_Altered(:,9)];
        end
%         else
%             T_New=[RE_County PE_County X_County(:,1:ii) Z_County_Altered(:,ii+1) X_County(:,(ii+2):end)];
%         end
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
    xlim([-1.25 0.5])
    title(Inqv_t{vv})
    box off;
    set(gca,'LineWidth',2,'tickdir','out','YTick',[1:length(indxs)],'YTickLabel',yt,'Fontsize',14,'XTick',[-1.25:0.25:0.5],'XMinorTick','on')
    xtickangle(0);
    xtickformat('percentage')
    ylabel('External factor','FontSize',18)
    xlabel('Change in vaccine uptake','FontSize',18)
    text(-0.475,1.025,char(64+vv),'Fontsize',24,'Units','normalized');
end
print(gcf,['Figure2_County.png'],'-dpng','-r600');
print(gcf,['Figure2_County.tiff'],'-dtiff','-r600');
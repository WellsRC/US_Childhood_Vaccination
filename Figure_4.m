function Figure_4(Year_Inq)
clc;
close all;

S=shaperead([pwd '\Spatial_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
    State_FIP(ii)=str2double(State_FIPc{ii});
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);


load([pwd '\Spatial_Data\Demographic_Data\County_Population.mat']);
Tot_Pop=County_Demo.Population.Age_under_5(:,County_Demo.Year_Data==Year_Inq);

wgs84 = wgs84Ellipsoid("km");
people_km2=zeros(size(S));

for ii=1:length(S)
    area_c=sum(areaint(S(ii).Lat,S(ii).Lon,wgs84));
    people_km2(ii) = Tot_Pop(ii)./area_c;
end

med_den=median(people_km2);

people_km2=log(people_km2)./log(med_den);
rel_r=0.16/1.66;

[~,County_ID,~]=Read_ID_Number();

T_County_Info=readtable([pwd '\Spatial_Data\Vaccination_Data\County_Vaccination_Data.xlsx']);
T_County_Info=T_County_Info(:,1:3);

Vac_Nam_v={'MMR','DTaP','Polio','VAR'};
Vac_Title_v={'measles','pertussis','polio','varicella'};
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5710408/#note-POI170042-1-s
% R0=5.7 for measles among kids 2-11
R0=[7 11 4 4];
k=[0.23 0.4364 6.661 1];

% https://www.pnas.org/doi/full/10.1073/pnas.1616438114 median is 4.75 for
% pertussis us this to scale k
% https://www.nature.com/articles/nature04153#Sec5
%https://link.springer.com/article/10.1186/s12916-016-0637-z
% https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004138#sec007
% https://academic.oup.com/jid/article/229/4/1097/7246204
% https://www.cdc.gov/mmwr/preview/mmwrhtml/mm5441a6.htm
%https://academic.oup.com/mbe/article/34/11/2982/3952784?login=false
% https://pubmed.ncbi.nlm.nih.gov/36265851/
%https://www.sciencedirect.com/science/article/pii/S0264410X07008134?casa_token=TJckYau8ZtwAAAAA:smBPsEDwJC252PblBg0RRsTbpVZttvCVvEoOtdvRp6m62U1_BY81fQ60xOYCl1YKuQLf00BtyKM
%https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1002105




% https://www.dshs.texas.gov/sites/default/files/IDCU/investigation/electronic/EAIDG/2023/Pertussis.pdf
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3234395/ (one paralytic % case)
% https://www.cdc.gov/mmwr/volumes/71/wr/mm7133e2.htm


% Efficacy
eps_v=[0.99 0.85 0.9 0.92];
% https://www.cdc.gov/vaccines/pubs/pinkbook/meas.html
% https://www.cdc.gov/vaccines/pubs/pinkbook/pert.html
%https://www.cdc.gov/vaccines/pubs/pinkbook/polio.html
%https://www.cdc.gov/vaccines/pubs/pinkbook/varicella.html

% https://www.cdc.gov/polio/what-is-polio/index.htm
paralysis_polio=1/1000;
% https://bmcpublichealth.biomedcentral.com/articles/10.1186/s12889-023-15846-x/figures/1
% per_contact_outsidehome=1-4.829268292682927/24.289099526066355;

%https://www.cdc.gov/vaccines/pubs/pinkbook/pert.html
% Expected cases in home
Ex_Home=4.829268292682927.*0.8;
% Adjust R0 for pertussis to be secondary cases outside the home
R0(strcmp(Vac_Nam_v,'DTaP'))=R0(strcmp(Vac_Nam_v,'DTaP'))-Ex_Home;

 load([pwd '\Spatial_Data\Demographic_Data\County_Population.mat']);

Pop_County=County_Demo.Population.Total;
Pop_County=Pop_County(:,County_Demo.Year_Data==Year_Inq);
clear County_Demo;

p_outbreak_all=zeros(length(County_ID),4);
for vv=1:4
    [Vac_Uptake] = County_Immunization_Statistics(Vac_Nam_v{vv},Year_Inq,County_ID);
    Vac_Uptake(isnan(Vac_Uptake))=Approximated_County_Immunization_Statistics(Vac_Nam_v{vv},Year_Inq,County_ID(isnan(Vac_Uptake)));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    % Trust in medicine
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
    R0s=R0(vv)+R0(vv).*rel_r.*people_km2;
    Reff=R0s.*(1-eps_v(vv).*Vac_Uptake);
    if(strcmp(Vac_Nam_v{vv},'Polio'))
        Ex_Case=1./(1-Reff);
        t_r=find(Reff>=1);
        for rr=1:length(t_r)
            %https://www.jstor.org/stable/26166762?seq=2
            S0=(1-eps_v(vv).*Vac_Uptake(t_r(rr)));
            [s_inf]=lsqnonlin(@(x)log(x/S0)-R0(vv).*(x./S0-1),S0.*0.6,0,S0);
            Ex_Case(t_r(rr))=Pop_County(t_r(rr)).*(1-s_inf./S0);
        end

        prob_o=1-(1-paralysis_polio.*(1-eps_v(vv).*Vac_Uptake)).^Ex_Case;
    elseif(strcmp(Vac_Nam_v{vv},'DTaP'))
        p=(1+Reff./k(vv)).^(-1);
        % 3 cases that overlap and not inside the home
        prob_o=(1-nbincdf(1,k(vv),p))+ nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p));
    elseif(strcmp(Vac_Nam_v{vv},'MMR'))
        % https://www.cdc.gov/measles/cases-outbreaks.html
        % https://www.cdc.gov/vaccines/pubs/surv-manual/chpt07-measles.html
        % 3 or more related cases
        p=(1+Reff./k(vv)).^(-1);
        prob_o=(1-nbincdf(1,k(vv),p))+ nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p));
    elseif(strcmp(Vac_Nam_v{vv},'VAR'))
        %https://www.cdc.gov/chickenpox/outbreaks/manual.html
        % At least 5 epidemiologically linked cases (i.e. index needs to
        % infect at least 4 or 4 additional cases (5 cases in total)
        
        p=(1+Reff./k(vv)).^(-1);
        prob_o=(1-nbincdf(3,k(vv),p));
        prob_o=prob_o+ nbinpdf(3,k(vv),p).*((1-nbincdf(0,k(vv),p)).^3+3.*nbinpdf(0,k(vv),p).*(1-nbincdf(0,k(vv),p)).^2+3.*nbinpdf(0,k(vv),p).^2.*(1-nbincdf(0,k(vv),p)));
        prob_o=prob_o+ nbinpdf(2,k(vv),p).*((1-nbincdf(0,k(vv),p)).^2+2.*nbinpdf(0,k(vv),p).*((1-nbincdf(1,k(vv),p))+nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p))));
        prob_o=prob_o+ nbinpdf(1,k(vv),p).*((1-nbincdf(2,k(vv),p))+nbinpdf(2,k(vv),p).*((1-nbincdf(0,k(vv),p)).^2+2.*nbinpdf(0,k(vv),p).*(1-nbincdf(0,k(vv),p)))+nbinpdf(1,k(vv),p).*((1-nbincdf(1,k(vv),p))+nbinpdf(1,k(vv),p).*(1-nbincdf(0,k(vv),p))));       
    end
    C_outbreak=[hex2rgb('#ffffff'); % 0 to 0.01
hex2rgb('#ffffcc');
hex2rgb('#ffeda0');
hex2rgb('#fed976');
hex2rgb('#feb24c');
hex2rgb('#fd8d3c');
hex2rgb('#fc4e2a');
hex2rgb('#e31a1c');
hex2rgb('#bd0026');
hex2rgb('#800026'); % 0.40 to 0.45
hex2rgb('#662225');]; % 0.45 to 0.50+

        c_indx_uptake=[1:size(C_outbreak,1)];
    c_bound_outbreak=[0 0.01;
             0.01 0.05;
             0.05 0.1;
             0.1 0.15;
             0.15 0.20;
             0.20 0.25;
             0.25 0.30;
             0.3 0.35
             0.35 0.40;
             0.40 0.45
             0.45 1];
    
    
    switch vv
        case 1
            figure('units','normalized','outerposition',[0 0.075 1 1]);
             ax1=usamap('conus');
        
            framem off; gridm off; mlabel off; plabel off;
            ax1.Position=[-0.3,0.4,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax1, states,'Facecolor','none','LineWidth',0.5); hold on;
        case 2
            ax2=usamap('conus');
            
            framem off; gridm off; mlabel off; plabel off;
            ax2.Position=[1.7,0.4,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax2, states,'Facecolor','none','LineWidth',0.5); hold on;
        case 3
            ax3=usamap('conus');
            
            framem off; gridm off; mlabel off; plabel off;
            ax3.Position=[-0.3,-0.1,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax3, states,'Facecolor','none','LineWidth',0.5); hold on;
        case 4
            ax4=usamap('conus');
            
            framem off; gridm off; mlabel off; plabel off;
            ax4.Position=[1.7,-0.1,0.6,0.6];
            
            states = shaperead('usastatelo', 'UseGeoCoords', true);
            geoshow(ax4, states,'Facecolor','none','LineWidth',0.5); hold on;
    end

    
        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Uptake: colour bar
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    switch vv
        case 1
            subplot('Position',[0.41,0.525,0.01,0.45]);
        case 2
            subplot('Position',[0.885,0.525,0.01,0.45]);
        case 3
            subplot('Position',[0.41,0.025,0.01,0.45]);            
        case 4
            subplot('Position',[0.885,0.025,0.01,0.45]);
    end

        xlim([0 1]);
        ylim([0 max(c_indx_uptake)]);    
        ymin=2.25;
        dy=2/(1+sqrt(5));
        for ii=1:length(c_indx_uptake)
            patch([0 0 dy dy],c_indx_uptake(ii)-[1 0 0 1],C_outbreak(ii,:),'LineStyle','none');
        end
        
        
        for mm=1:length(c_indx_uptake)
            text(ymin,mm-1,[num2str(100.*c_bound_outbreak(mm,1),'%3.0f') '%'],'HorizontalAlignment','center','Fontsize',16);
        end
        text(ymin,length(c_indx_uptake),[num2str(50,'%3.0f') '+%'],'HorizontalAlignment','center','Fontsize',16);
        text(ymin+2.5,max(c_indx_uptake)./2,{['Probability of ' Vac_Title_v{vv} ' outbreak']},'HorizontalAlignment','center','Fontsize',18,'Rotation',270);
        axis off;    
        text(-40,1,char(64+vv),'FontSize',32,'Units','normalized');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % relocate maps
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
        NS=length(County_ID);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Store the colours to be plotted
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CC_county_outbreak=ones(length(County_ID),3);
        
        for ii=1:length(County_ID)
            if(~isnan(prob_o(ii)))
                CC_county_outbreak(ii,:)=C_outbreak(c_indx_uptake(prob_o(ii)>=c_bound_outbreak(:,1) & prob_o(ii)<c_bound_outbreak(:,2)),:);
            else
                CC_county_outbreak(ii,:)=[0.7 0.7 0.7];
            end
    
        end
            
            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Plot uptake
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        CM=makesymbolspec('Polygon',{'INDEX',[1 NS],'FaceColor',CC_county_outbreak});
        switch vv
            case 1
                geoshow(ax1,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax1, states,'Facecolor','none','LineWidth',1.5); hold on;
            case 2
                geoshow(ax2,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax2, states,'Facecolor','none','LineWidth',1.5); hold on;
            case 3
                geoshow(ax3,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax3, states,'Facecolor','none','LineWidth',1.5); hold on;
            case 4
                geoshow(ax4,S,'SymbolSpec',CM,'LineStyle','None'); 
                geoshow(ax4, states,'Facecolor','none','LineWidth',1.5); hold on;
        end

        p_outbreak_all(:,vv)=prob_o;
end

ax1.Position=[-0.075,0.425,0.6,0.6];
ax2.Position=[0.4,0.425,0.6,0.6];
ax3.Position=[-0.075,-0.075,0.6,0.6];
ax4.Position=[0.4,-0.075,0.6,0.6];

print(gcf,['Figure4.png'],'-dpng','-r600');
print(gcf,['Figure4.tiff'],'-dtiff','-r600');


for vv=1:4
    t_max=find(p_outbreak_all(:,vv)==max(p_outbreak_all(:,vv)));
    fprintf(['County with maximum probability of outbreak for ' Vac_Title_v{vv} ':' num2str(County_ID(t_max)) '\n' ]);
    
    temp_p=NaN.*zeros(height(T_County_Info),1);
    for cc=1:height(T_County_Info)
        t_cid=find(T_County_Info.CountyFIPS(cc)==County_ID);
        if(~isempty(t_cid))
            temp_p(cc)=p_outbreak_all(t_cid,vv);    
        end
    end

    if(strcmp(Vac_Title_v{vv},'measles'))
        T_County_Info.Measles=temp_p;
    elseif(strcmp(Vac_Title_v{vv},'pertussis'))        
        T_County_Info.Pertussis=temp_p;
    elseif(strcmp(Vac_Title_v{vv},'polio'))                
        T_County_Info.Polio=temp_p;
    elseif(strcmp(Vac_Title_v{vv},'varicella'))        
        T_County_Info.Varicella=temp_p;
    end
end

writetable(T_County_Info,'Probability_of_Outbreaks.xlsx');

    t_max=find(prod(p_outbreak_all,2)==max(prod(p_outbreak_all,2)));
    fprintf(['County with maximum probability of outbreak for all:' num2str(County_ID(t_max)) '\n']);

end
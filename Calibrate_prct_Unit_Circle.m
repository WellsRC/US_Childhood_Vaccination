clear;
clc;

Calibrateion_lambda_d=true(1);
S=shaperead([pwd '/Spatial_Data/Demographic_Data/cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
State_FIPc={S.STATEFP};
State_FIP=zeros(size(State_FIPc));

for ii=1:length(State_FIP)
    State_FIP(ii)=str2double(State_FIPc{ii});
end

S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);

[~,County_ID,~]=Read_ID_Number();

Year_Inq=[2017:2022];

temp_VN={'MMR','DTaP','Polio','VAR'};
Vac_Title_v={'MMR','DTaP','IPV','VAR'};
NSamp=10^5;

prct_arc_v=0.85:-0.01:0.75;

p95v=zeros(length(prct_arc_v),length(Year_Inq),length(temp_VN));
cibnds=zeros(length(prct_arc_v),length(Year_Inq),length(temp_VN));

for vv=1:4
    Vac_Nam_v=temp_VN{vv};

    for yy=1:length(Year_Inq)
        [Vac_Uptake_Data] = County_Immunization_Statistics(Vac_Nam_v,Year_Inq(yy),County_ID);        

        for pp=1:length(prct_arc_v)
            prct_arc=prct_arc_v(pp);
            [Avg_Model_Vac_Uptake,All_Model_Vac_Uptake]=Approximated_County_Immunization_Statistics(Vac_Nam_v,Year_Inq(yy),County_ID(~isnan(Vac_Uptake_Data)),prct_arc,Calibrateion_lambda_d);
            All_Model_Vac_Uptake=squeeze(All_Model_Vac_Uptake);
    
            County_ID_All=County_ID;
    
            County_ID=County_ID(~isnan(Vac_Uptake_Data));
            Vac_Uptake_Data=Vac_Uptake_Data(~isnan(Vac_Uptake_Data));
                
            p_95=zeros(size(Vac_Uptake_Data));
            cibnds_temp=0;
            for ii=1:length(Vac_Uptake_Data)
                bnds=prctile(All_Model_Vac_Uptake(ii,:),[2.5 97.5]);
                cibnds_temp=cibnds_temp+diff(bnds);
                p_95(ii)=bnds(1)<=Vac_Uptake_Data(ii) & Vac_Uptake_Data(ii)<=bnds(2);
            end
    
            p95v(pp,yy,vv)=mean(p_95);
            cibnds(pp,yy,vv)=cibnds_temp./length(Vac_Uptake_Data);
        end
    end
end
S=shaperead([pwd '\State_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);

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
Yr=[2017:2022];
Scenario={'Overall';'No exemptions';'Any exemption';'Only religious exemptions';'Religious and philosophical exemptions'};

Var_Namev={'Trust_in_Science','Trust_in_Medicine'};
for dd=1:length(Var_Namev)
    figure(dd)
    V=zeros(length(State_ID),length(Yr));
    RE=zeros(length(State_ID),length(Yr));
    PE=zeros(length(State_ID),length(Yr));
    m_slope=zeros(length(State_ID),2);
    Var_Name=Var_Namev{dd};
    for yy=1:length(Yr)
        V(:,yy)=Return_State_Data(Var_Name,Yr(yy),State_ID); 
    end

    for yy=1:length(Yr)  
        [RE(:,yy),PE(:,yy)] = Exemption_Timeline(Yr(yy),State_ID,'Other');
    end
    
    Yr_ref=2019; % Reference year for the slopes
    for ss=1:length(State_ID)
        [~,pts]=Estimate_Slopes(Yr,V(ss,:),Yr_ref);
        subplot(7,7,ss);
        yp=Construct_Line(pts,Yr,Yr_ref);
        plot(Yr,yp,'b','LineWidth',2);
        hold on;
        scatter(Yr,V(ss,:),10,'r','filled');
    end
end
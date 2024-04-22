function [State_ID,County_ID,County_State_ID]=Read_ID_Number()

    S=shaperead([pwd '\Spatial_Data\Demographic_Data\cb_2018_us_county_500k.shp'],'UseGeoCoords',true);
    State_FIPc={S.STATEFP};
    State_FIP=zeros(size(State_FIPc));
    
    for ii=1:length(State_FIP)
        State_FIP(ii)=str2double(State_FIPc{ii});
    end

    S=S(State_FIP~=2 & State_FIP~=15 & State_FIP<60);
    

    State_STATEFP={S.STATEFP};

    County_ID_temp={S.GEOID};
    County_ID=zeros(size(County_ID_temp));
    County_State_ID=zeros(size(County_ID_temp));

    for ii=1:length(County_ID)
        County_ID(ii)=str2double(County_ID_temp{ii});
        County_State_ID(ii)=str2double(State_STATEFP{ii});
    end

    State_STATEFP=unique({S.STATEFP});
    State_ID=zeros(size(State_STATEFP));
    
    for ii=1:length(State_STATEFP)
      State_ID(ii)=str2double(State_STATEFP{ii});  
    end
end
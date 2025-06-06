clear;
clc;

states = shaperead([pwd '\Spatial_Data\Demographic_Data\Shapefile\cb_2023_us_county_20m.shp'], 'UseGeoCoords', true);

temp_states = shaperead('usastatelo', 'UseGeoCoords', true);
US_bdr=polyshape(temp_states(1).Lat,temp_states(1).Lon,'Simplify',false);
for jj=2:length(temp_states)
    US_bdr=union(US_bdr,polyshape(temp_states(jj).Lat,temp_states(jj).Lon,'Simplify',false));
end

s= rmholes(US_bdr);
s = rmslivers(s,10.^(-4));
US_bdr = geoshape(s.Vertices(:,1), s.Vertices(:,2));

temp_lat{1}=find(strcmp({states.STUSPS},'ME')|strcmp({states.STUSPS},'VT')|strcmp({states.STUSPS},'NH')|strcmp({states.STUSPS},'MA')|strcmp({states.STUSPS},'RI')|strcmp({states.STUSPS},'CT')|strcmp({states.STUSPS},'NY')|strcmp({states.STUSPS},'PA')|strcmp({states.STUSPS},'NJ'));

temp_lat{2}=find(strcmp({states.STUSPS},'DE')|strcmp({states.STUSPS},'MD')|strcmp({states.STUSPS},'WV')|strcmp({states.STUSPS},'VA')|strcmp({states.STUSPS},'KY')|strcmp({states.STUSPS},'NC')|strcmp({states.STUSPS},'TN')|strcmp({states.STUSPS},'AR')|strcmp({states.STUSPS},'OK')|strcmp({states.STUSPS},'SC')|strcmp({states.STUSPS},'GA')|strcmp({states.STUSPS},'AL')|strcmp({states.STUSPS},'MS')|strcmp({states.STUSPS},'LA')|strcmp({states.STUSPS},'TX')|strcmp({states.STUSPS},'FL'));

temp_lat{3}=find(strcmp({states.STUSPS},'ND')|strcmp({states.STUSPS},'MN')|strcmp({states.STUSPS},'WI')|strcmp({states.STUSPS},'MI')|strcmp({states.STUSPS},'SD')|strcmp({states.STUSPS},'IA')|strcmp({states.STUSPS},'IL')|strcmp({states.STUSPS},'IN')|strcmp({states.STUSPS},'OH')|strcmp({states.STUSPS},'NE')|strcmp({states.STUSPS},'KS')|strcmp({states.STUSPS},'MO'));

temp_lat{4}=find(strcmp({states.STUSPS},'WA')|strcmp({states.STUSPS},'MT')|strcmp({states.STUSPS},'OR')|strcmp({states.STUSPS},'ID')|strcmp({states.STUSPS},'WY')|strcmp({states.STUSPS},'CA')|strcmp({states.STUSPS},'NV')|strcmp({states.STUSPS},'UT')|strcmp({states.STUSPS},'CO')|strcmp({states.STUSPS},'AZ')|strcmp({states.STUSPS},'NM'));

for dd=1:4
    close all;
    figure('units','normalized','outerposition',[0.1 0.05 0.6 1])
    
    ax1=usamap('conus');
    geoshow(states,'LineWidth',0.25,'FaceColor',hex2rgb('#6FB98F'),'EdgeColor',hex2rgb('#004445'));
    view(3)
    
    ax1.Position=[-0.0078    0.4354    1.0156    0.7318];
    framem off; gridm off; mlabel off; plabel off;
    hold on;
    
    
    
    CF=repmat(hex2rgb('#4CB5F5'),length(states),1);
    CF(temp_lat{dd},:)=repmat(hex2rgb('#2C7873'),length(temp_lat{dd}),1);
    
    CE=repmat(hex2rgb('#336B87'),length(states),1);
    CE(temp_lat{dd},:)=repmat(hex2rgb('#021C1E'),length(temp_lat{dd}),1);
    CM=makesymbolspec('Polygon',{'INDEX',[1 length(states)],'FaceColor',CF,'EdgeColor',CE});
    
    for ss=1:101
     ax2=usamap('conus');
     geoshow(ax2,states,'SymbolSpec',CM,'LineStyle','None','FaceAlpha',0.05); hold on
     if(ss==1)
        geoshow(ax2,US_bdr,'LineWidth',2,'Color',hex2rgb('#336B87')); 
     end
    
    view(3)
    
    ax2.Position=[-0.0078    0.105+0.04.*(ss-1)./100    1.0156    0.7318];
    framem off; gridm off; mlabel off; plabel off;
    end
    
    
     ax2=usamap('conus');
    geoshow(ax2,states,'SymbolSpec',CM,'LineWidth',0.25,'FaceAlpha',1); 
    view(3)
    
    ax2.Position=[-0.0078    0.15    1.0156    0.7318];
    framem off; gridm off; mlabel off; plabel off;
    
    exportgraphics(gcf, ['Figure_Validation_1_' char(64+dd) '.pdf']);
end



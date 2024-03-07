function [county_weight,year_weight,state_ID_weight,county_ID_weight,US_weight]=Return_Population_Weight_County()

load([pwd '\State_Data\Demographic_Data\County_Population.mat']);

USID=unique(County_Demo.State_ID);

state_ID_weight=County_Demo.State_ID;
county_ID_weight=County_Demo.County_ID;

county_weight=County_Demo.Sex.Male+County_Demo.Sex.Female;

year_weight=County_Demo.Year_Data;

US_weight=county_weight;
for ii=1:length(year_weight)
    temp_n=county_weight(:,ii);
    temp_n(isnan(temp_n))=0;
    US_weight(:,ii)=temp_n./sum(temp_n);
end

for jj=1:length(year_weight)
    for ii=1:length(USID)
        tf=state_ID_weight == USID(ii);
        county_weight(tf,jj)=county_weight(tf,jj)./sum(county_weight(tf,jj));
    end
end
end
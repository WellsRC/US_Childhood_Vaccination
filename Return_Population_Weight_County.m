function [county_weight,year_weight,state_ID_weight,county_ID_weight,US_weight]=Return_Population_Weight_County(Rand_Indx)

load([pwd '\State_Data\County_Data\County_Population_' num2str(Rand_Indx) '.mat']);

USID=unique(Population.State_ID);

state_ID_weight=Population.State_ID;
county_ID_weight=Population.County_ID_Numeric;

county_weight=Population.Sex.Male+Population.Sex.Female;

year_weight=Population.Year_Data;

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
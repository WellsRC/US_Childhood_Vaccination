function F = Objective_Function_Coverage(x,County_Data,State_Data,filter_county,filter_state)

beta_X=x(1:end-2);
sigma_county=10.^x(end-1);
sigma_state=10.^x(end);

v_county = Estimated_County_Vaccine_Uptake(beta_X,County_Data.X);
v_state = zeros(height(State_Data),1);

u_year=unique(State_Data.Year);

for yy=1:length(u_year)
    tf=State_Data.Year==u_year(yy);
    year_County=County_Data.Year==u_year(yy);
    v_state(tf) = Estimated_State_Vaccine_Uptake(v_county(year_County),County_Data.Under_5(year_County),County_Data.State_FIP(year_County),State_Data.State_FIP(tf));
end

% Compute the county-level coverage for all time and space
L_county=normpdf(log(County_Data.Vaccine_Uptake(:)./(1-County_Data.Vaccine_Uptake(:))),log(v_county(:)./(1-v_county(:))),sigma_county);
L_county(County_Data.Vaccine_Uptake(:)==1)=v_county(County_Data.Vaccine_Uptake(:)==1);
L_county(County_Data.Vaccine_Uptake(:)==0)=1-v_county(County_Data.Vaccine_Uptake(:)==0);

L_county=log(L_county(filter_county & ~isnan(County_Data.Vaccine_Uptake(:))));

L_state=zeros(height(State_Data),1);

% for ss=1:length(L_state)
%     L_state(ss)=log(integral(@(z)betapdf(z,State_Data.a_Beta_Parameters_Vaccine_Uptake(ss),State_Data.b_Beta_Parameters_Vaccine_Uptake(ss)).*normpdf(log(z./(1-z)),log(v_state(ss)./(1-v_state(ss))),sigma_state),10^(-8),1-10^(-8)));
% end
for ss=1:length(L_state)
    z=betastat(State_Data.a_Beta_Parameters_Vaccine_Uptake(ss),State_Data.b_Beta_Parameters_Vaccine_Uptake(ss));
    L_state(ss)=log(normpdf(log(z./(1-z)),log(v_state(ss)./(1-v_state(ss))),sigma_state));
end

L_state=L_state(filter_state);

F=-sum(L_county(:)) -sum(L_state(:));

end


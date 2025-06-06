% clear;
% clc;
% % parpool(6);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Vaccination data to explore
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% 
% [County_Data,State_Data] = Load_Data('MMR');
% 
% county_data_estimate=find(isnan(County_Data.Vaccine_Uptake));
% county_data_indx=find(~isnan(County_Data.Vaccine_Uptake));
% state_data_indx=1:height(State_Data);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % Model index for fitting
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Model_Var=false(2^8,45);
% 
% Var_Names={'Age','Race','Income','Gini_Index','Health_Insurance','Education','Poverty_Income_Ratio','Rural_Urban_Code'};
% 
% Model_Var(:,[1 2])=true;
% 
% temp_var=false(8,45);
% temp_var(1,3:7)=true;
% temp_var(2,8:12)=true;
% temp_var(3,13)=true;
% temp_var(4,14)=true;
% temp_var(5,15:17)=true;
% temp_var(6,18:24)=true;
% temp_var(7,25:36)=true;
% temp_var(8,37:45)=true;
% 
% bin_model=dec2bin([0:2^8-1]',8)=='1';
% [~,srt_indx]=sort(sum(bin_model,2),'ascend');
% bin_model=bin_model(srt_indx,:);
% 
% for ii=1:2^8
%     temp_overall=false(1,45);
%     for jj=1:8
%         if(bin_model(ii,jj))
%             temp_overall=temp_overall|temp_var(jj,:);
%         end
%     end
%     Model_Var(ii,:)=Model_Var(ii,:) | temp_overall;
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Model Fit
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% model_num=95;
% County_Data_model=County_Data;
% County_Data_model.X=County_Data_model.X(:,Model_Var(model_num,:));
% 
% lb=-20.*ones(1,sum(Model_Var(model_num,:))+3);
% lb(end-1:end)=-1;
% ub=20.*ones(1,sum(Model_Var(model_num,:))+3);
% ub(end-1:end)=1;
% 
% opts_ps=optimoptions('particleswarm','MaxIterations',25,'FunctionTolerance',10^(-6),'PlotFcn','pswplotbestf','UseParallel',true);
% 
% par_0=zeros(10,length(lb));
% for ss=1:10
%     par_0(ss,:)=particleswarm(@(x)Objective_Function_Coverage(x,County_Data_model,State_Data,county_data_indx,state_data_indx),length(lb),lb,ub,opts_ps);
% end
% 
% opts_ga=optimoptions("ga","PlotFcn",'gaplotbestf','UseParallel',true,"MaxGenerations",50,"FunctionTolerance",10^(-9),'CrossoverFcn','crossoverheuristic','MigrationInterval',25,'SelectionFcn',{@selectiontournament,8},'PopulationSize',250,'InitialPopulationMatrix',par_0);
% [par_est]=ga(@(x)Objective_Function_Coverage(x,County_Data_model,State_Data,county_data_indx,state_data_indx),length(lb),[],[],[],[],lb,ub,[],[],opts_ga);
% 
% opts_pats=optimoptions('patternsearch','UseParallel',true,"PlotFcn",'psplotbestf','FunctionTolerance',10^(-12),'MaxIterations',750,'StepTolerance',10^(-9),'MaxFunctionEvaluations',10^4,'Cache','on');
% [par_final,f_final]=patternsearch(@(x)Objective_Function_Coverage(x,County_Data_model,State_Data,county_data_indx,state_data_indx),par_est,[],[],[],[],lb,ub,[],opts_pats);
% 

beta_X=par_final(1:end-2);
v_county_est = Estimated_County_Vaccine_Uptake(beta_X,County_Data_model.X);

v_county=County_Data.Vaccine_Uptake;
v_county(county_data_estimate)=v_county_est(county_data_estimate);

MMR_Vaccine_Uptake=v_county;
Year=County_Data.Year;
State=County_Data.State;
County=County_Data.County;
GEOID=County_Data.GEOID;

T=table(Year,State,County,GEOID,MMR_Vaccine_Uptake);

writetable(T,'Raw_and_Inferred_County_Uptake.xlsx','Sheet','MMR');




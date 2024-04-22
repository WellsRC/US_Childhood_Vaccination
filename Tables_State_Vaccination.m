clear;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Load the state id to be analyzed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


[State_ID,~,~]=Read_ID_Number();


% Years to conduct the analysis
Yr=[2017:2022];

% The vaccines we are exploring
Var_Namev={'MMR','DTaP','Polio','VAR'};

% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end


Per_Negative_2023=NaN.*zeros(length(State_ID),length(Var_Namev));

% Cycle through the vaccines in which we are condcuting the analysis
for dd=1:length(Var_Namev)

    % Create cell arrays to store results of analysis 
    V_Table=cell(length(Yr),length(Yr));
    Slope_Table=cell(length(Yr),length(Yr));
    Raw_Slope_Table=cell(length(Yr)-1,length(Yr)-1);
    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest

    % Array for the vaccine uptake 
    V=zeros(length(State_ID),length(Yr));
    
    % Read the vaccie data for the speciifed years and states
    for yy=1:length(Yr)
        V(:,yy)=State_Immunization_Statistics(Var_Name,Yr(yy),State_ID); 
        vt=V(:,yy);
        vt=vt(~isnan(V(:,yy)));
        pv=signrank(V(:,yy),0.95,'tail','left');
        if(pv<0.001)
            V_Table{yy,yy}=[ num2str(median(100.*vt),'%3.1f') '% (p<0.001)'];
        else
            V_Table{yy,yy}=[ num2str(median(100.*vt),'%3.1f') '% (p=' num2str(pv,'%4.3f') ')'];
        end
    end
    
    for yy=1:(length(Yr)-1)
        for jj=(yy+1):length(Yr)
            v_temp=V(:,jj)-V(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=ranksum(V(:,yy),V(:,jj),'tail','right');
            if(pv<0.001)
                V_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p<0.001)'];
            else
                V_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
    end

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
    % Compute sope based off a polynomial
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555

    % An array to specfiy the size of the slopes being computed 
    State_Poly_Slope=NaN.*zeros(length(State_ID),length(Yr));

    for jj=1:length(State_ID)
        % Conducting AIC model selection to evalaute which size of
        % polynomial to select
        AICs=zeros(sum(~isnan(V(jj,:)))-2,1);
        % Select the years in which we do not have NaN values 
        t=Yr(~isnan(V(jj,:)));
        % pull data that is not NaN to be fit to
        y=V(jj,~isnan(V(jj,:)));

        % Fi the different polynomials
        for pp=1:length(AICs)
           p=polyfit(t,y,pp); % Fit polynomial of size pp
           rs=polyval(p,t)-y; % Compute the residual
           std_est=sqrt(mean(rs.^2)); % Estimate the standard deviation based on the residual (This value is how it is computed in fitlm in order to compute the log-likelihood)
           L=sum(log(normpdf(y,polyval(p,t),std_est))); % compute the log-lilelihood
           AICs(pp)=aicbic(L,length(p)); % compute the AIC score
        end
        if(~isempty(AICs)) % Ensure that AIC is not empty
            pt=polyfit(t,y,find(AICs==min(AICs))); % Fit the polynmial based on the AIC socore
            np=[find(AICs==min(AICs)):-1:1]; % Vector used in computing the derivative
            qt=np.*pt(1:end-1); % Compute the coefficients for the deriviative in order to evalaute the slope for each ear
            State_Poly_Slope(jj,:)=polyval(qt,Yr); % Compute the slope at each year
        end
    end
    
    
    for yy=1:length(Yr)
        vt=State_Poly_Slope(:,yy);
        t_nan=~isnan(vt);
        vt=vt(~isnan(vt));
        pv=signrank(vt,0,'tail','left');
        if(pv<0.001)
            Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%4.3f')  '% (p<0.001)'];
        else
            Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%4.3f')  '% (p=' num2str(pv,'%4.3f') ')'];
        end
        for jj=(yy+1):length(Yr)
            v_temp=State_Poly_Slope(:,jj)-State_Poly_Slope(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=ranksum(State_Poly_Slope(:,yy),State_Poly_Slope(:,jj),'tail','right');
            if(pv<0.001)
                Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%4.3f') '% (p<0.001)'];
            else
                Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%4.3f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
        if(yy==length(Yr))
            t_neg=double(vt<0);
            Per_Negative_2023(t_nan,dd)=t_neg;
            
        end
    end
    
%     save(['Polynomial_Slope_State_' Var_Name '.mat'],'State_Poly_Slope');
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Conduct analysis on the state-level vaccine annual slope
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Raw_Slope=diff(V,[],2);

%     save(['Raw_Slope_State_' Var_Name '.mat'],'Raw_Slope');

    for yy=1:length(Yr)-1
        vt=Raw_Slope(:,yy);
        vt=vt(~isnan(vt));
        pv=signrank(vt,0,'tail','left');
        if(pv<0.001)
            Raw_Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p<0.001)'];
        else
            Raw_Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p=' num2str(pv,'%4.3f') ')'];
        end
        for jj=(yy+1):length(Yr)-1
            v_temp=Raw_Slope(:,jj)-Raw_Slope(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=ranksum(Raw_Slope(:,yy),Raw_Slope(:,jj),'tail','right');
            if(pv<0.001)
                Raw_Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p<0.001)'];
            else
                Raw_Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
    end

    Vaccine_Uptake=[table(Year) cell2table(V_Table)];
    Vaccine_Uptake.Properties.VariableNames={'Years' Year{:}};

    writetable(Vaccine_Uptake,'Comparison_Vaccine_Uptake.xlsx','Sheet',Var_Name);

    Poly_Slope=[table(Year) cell2table(Slope_Table)];
    Poly_Slope.Properties.VariableNames={'Years' Year{:}};

    writetable(Poly_Slope,'Comparison_Change_Vaccine_Uptake_Polynomial.xlsx','Sheet',Var_Name);

    Data_Slope=[table(Year_Raw) cell2table(Raw_Slope_Table)];
    Data_Slope.Properties.VariableNames={'Years' Year_Raw{:}};

    writetable(Data_Slope,'Comparison_Change_Vaccine_Uptake_Data.xlsx','Sheet',Var_Name);
end
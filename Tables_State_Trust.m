clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parental Trust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[State_ID,~,~]=Read_ID_Number();

Yr=[2017:2022];
load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Medicine_Stratification.mat'])
Nat_Medicine=Trust_in_Medicine.National.Great_Deal+0.5.*Trust_in_Medicine.National.Only_Some;
Nat_Medicine=Nat_Medicine(ismember(Trust_Year_Data,Yr));
load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Science_Stratification.mat'])
Nat_Science=Trust_in_Science.National.Great_Deal+0.5.*Trust_in_Science.National.Only_Some;
Nat_Science=Nat_Science(ismember(Trust_Year_Data,Yr));

% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end

Var_Namev={'Parental_Trust_in_Medicine','Parental_Trust_in_Science'};

Table_2=cell(3.*length(Var_Namev),length(Yr)+1);

for dd=1:length(Var_Namev)
    if(strcmp(Var_Namev{dd},'Parental_Trust_in_Science'))
        Nat_Trust=Nat_Science;
    else
        Nat_Trust=Nat_Medicine;
    end
    

    Table_2{dd,1}=Var_Namev{dd};
    Table_2{dd+length(Var_Namev),1}=Var_Namev{dd};
    Table_2{dd+2.*length(Var_Namev),1}=Var_Namev{dd};

    % Create cell arrays to store results of analysis 
    V_Table=cell(length(Yr),length(Yr));
    Slope_Table=cell(length(Yr),length(Yr));
    Raw_Slope_Table=cell(length(Yr)-1,length(Yr)-1);
    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest


    Trust=zeros(length(State_ID),length(Yr));
    
    for yy=1:length(Yr)
        Trust(:,yy)=Return_State_Data(Var_Name,Yr(yy),State_ID);   
        vt=Trust(:,yy);
        vt=vt(~isnan(Trust(:,yy)));
        pv=signrank(Trust(:,yy),Nat_Trust(yy),'tail','left');
        if(pv<0.001)
            V_Table{yy,yy}=[ num2str(median(100.*vt),'%3.1f') '% (p<0.001)'];
            Table_2{dd,1+yy}=[ num2str(median(100.*vt),'%3.1f') '% (p<0.001)'];
        else
            V_Table{yy,yy}=[ num2str(median(100.*vt),'%3.1f') '% (p=' num2str(pv,'%4.3f') ')'];
            Table_2{dd,1+yy}=[ num2str(median(100.*vt),'%3.1f') '% (p=' num2str(pv,'%4.3f') ')'];
        end
    end
    
    for yy=1:(length(Yr)-1)
        for jj=(yy+1):length(Yr)
            v_temp=Trust(:,jj)-Trust(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=signrank(v_temp,0,'tail','left');
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
        AICs=zeros(sum(~isnan(Trust(jj,:)))-2,1);
        % Select the years in which we do not have NaN values 
        t=Yr(~isnan(Trust(jj,:)));
        % pull data that is not NaN to be fit to
        y=Trust(jj,~isnan(Trust(jj,:)));

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
        vt=vt(~isnan(vt));
        pv=signrank(vt,0,'tail','left');
        if(pv<0.001)
            Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%4.3f')  '% (p<0.001)'];
            Table_2{dd+2.*length(Var_Namev),1+yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p<0.001)'];
        else
            Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%4.3f')  '% (p=' num2str(pv,'%4.3f') ')'];
            Table_2{dd+2.*length(Var_Namev),1+yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p=' num2str(pv,'%4.3f') ')'];
        end
        for jj=(yy+1):length(Yr)
            v_temp=State_Poly_Slope(:,jj)-State_Poly_Slope(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=signrank(v_temp,0,'tail','left');
            if(pv<0.001)
                Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%4.3f') '% (p<0.001)'];
            else
                Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%4.3f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
    end

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Conduct analysis on the state-level vaccine annual slope
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Raw_Slope=diff(Trust,[],2);

    for yy=1:length(Yr)-1
        vt=Raw_Slope(:,yy);
        vt=vt(~isnan(vt));
        pv=signrank(vt,0,'tail','left');
        if(pv<0.001)
            Raw_Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p<0.001)'];
            Table_2{dd+1.*length(Var_Namev),2+yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p<0.001)'];
        else
            Raw_Slope_Table{yy,yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p=' num2str(pv,'%4.3f') ')'];
            Table_2{dd+1.*length(Var_Namev),2+yy}=[ num2str(median(100.*vt),'%3.2f')  '% (p=' num2str(pv,'%4.3f') ')'];
        end
        for jj=(yy+1):length(Yr)-1
            v_temp=Raw_Slope(:,jj)-Raw_Slope(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=signrank(v_temp,0,'tail','left');
            if(pv<0.001)
                Raw_Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p<0.001)'];
            else
                Raw_Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
    end

    Trust=[table(Year) cell2table(V_Table)];
    Trust.Properties.VariableNames={'Years' Year{:}};

    writetable(Trust,'Comparison_Parental_Trust.xlsx','Sheet',Var_Name);

    Poly_Slope=[table(Year) cell2table(Slope_Table)];
    Poly_Slope.Properties.VariableNames={'Years' Year{:}};

    writetable(Poly_Slope,'Comparison_Change_Parental_Trust_Polynomial.xlsx','Sheet',Var_Name);

    Data_Slope=[table(Year_Raw) cell2table(Raw_Slope_Table)];
    Data_Slope.Properties.VariableNames={'Years' Year_Raw{:}};

    writetable(Data_Slope,'Comparison_Change_Parental_Trust_Data.xlsx','Sheet',Var_Name);
end

Table_2=cell2table(Table_2);
Table_2.Properties.VariableNames={'Vaccine' Year{:}};
writetable(Table_2,'Tables_Main_Text.xlsx','Sheet','Table_2');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Overall Trust
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clc;

[State_ID,~,~]=Read_ID_Number();

Yr=[2017:2022];
load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Medicine_Stratification.mat'])
Nat_Medicine=Trust_in_Medicine.National.Great_Deal+0.5.*Trust_in_Medicine.National.Only_Some;
Nat_Medicine=Nat_Medicine(ismember(Trust_Year_Data,Yr));
load([pwd '\Spatial_Data\Trust_Science_Medicine\Trust_in_Science_Stratification.mat'])
Nat_Science=Trust_in_Science.National.Great_Deal+0.5.*Trust_in_Science.National.Only_Some;
Nat_Science=Nat_Science(ismember(Trust_Year_Data,Yr));

% Create table row labels 
Year=cell(length(Yr),1);
for yy=1:length(Yr)
    Year{yy}=[num2str(Yr(yy))];
end

Year_Raw=cell(length(Yr)-1,1);
for yy=1:length(Yr)-1
    Year_Raw{yy}=[num2str(Yr(yy+1)) ' - ' num2str(Yr(yy))];
end

Var_Namev={'Trust_in_Science','Trust_in_Medicine'};

for dd=1:length(Var_Namev)
    if(strcmp(Var_Namev{dd},'Trust_in_Science'))
        Nat_Trust=Nat_Science;
    else
        Nat_Trust=Nat_Medicine;
    end

    % Create cell arrays to store results of analysis 
    V_Table=cell(length(Yr),length(Yr));
    Slope_Table=cell(length(Yr),length(Yr));
    Raw_Slope_Table=cell(length(Yr)-1,length(Yr)-1);
    Var_Name=Var_Namev{dd}; % Read the specified vaccine of interest


    Trust=zeros(length(State_ID),length(Yr));
    
    for yy=1:length(Yr)
        Trust(:,yy)=Return_State_Data(Var_Name,Yr(yy),State_ID);   
        vt=Trust(:,yy);
        vt=vt(~isnan(Trust(:,yy)));
        pv=signrank(Trust(:,yy),Nat_Trust(yy),'tail','left');
        if(pv<0.001)
            V_Table{yy,yy}=[ num2str(median(100.*vt),'%3.1f') '% (p<0.001)'];
        else
            V_Table{yy,yy}=[ num2str(median(100.*vt),'%3.1f') '% (p=' num2str(pv,'%4.3f') ')'];
        end
    end
    
    for yy=1:(length(Yr)-1)
        for jj=(yy+1):length(Yr)
            v_temp=Trust(:,jj)-Trust(:,yy);
            v_temp=v_temp(~isnan(v_temp));
            pv=signrank(v_temp,0,'tail','left');
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
        AICs=zeros(sum(~isnan(Trust(jj,:)))-2,1);
        % Select the years in which we do not have NaN values 
        t=Yr(~isnan(Trust(jj,:)));
        % pull data that is not NaN to be fit to
        y=Trust(jj,~isnan(Trust(jj,:)));

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
            pv=signrank(v_temp,0,'tail','left');
            if(pv<0.001)
                Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%4.3f') '% (p<0.001)'];
            else
                Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%4.3f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
    end

     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Conduct analysis on the state-level vaccine annual slope
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Raw_Slope=diff(Trust,[],2);

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
            pv=signrank(v_temp,0,'tail','left');
            if(pv<0.001)
                Raw_Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p<0.001)'];
            else
                Raw_Slope_Table{yy,jj}=[ num2str(median(100.*v_temp),'%3.2f') '% (p=' num2str(pv,'%4.3f') ')'];
            end
        end
    end

    Trust=[table(Year) cell2table(V_Table)];
    Trust.Properties.VariableNames={'Years' Year{:}};

    writetable(Trust,'Comparison_Trust.xlsx','Sheet',Var_Name);

    Poly_Slope=[table(Year) cell2table(Slope_Table)];
    Poly_Slope.Properties.VariableNames={'Years' Year{:}};

    writetable(Poly_Slope,'Comparison_Change_Trust_Polynomial.xlsx','Sheet',Var_Name);

    Data_Slope=[table(Year_Raw) cell2table(Raw_Slope_Table)];
    Data_Slope.Properties.VariableNames={'Years' Year_Raw{:}};

    writetable(Data_Slope,'Comparison_Change_Trust_Data.xlsx','Sheet',Var_Name);
end

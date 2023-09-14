function [County_Trust_in_Healthcare]=Stratified_Trust_in_Healthcare_2021(Var_1,County_ID)
    %https://www.norc.org/PDFs/ABIM%20Foundation/20210520_NORC_ABIM_Foundation_Trust%20in%20Healthcare_Part%201.pdf
    Year_Survey=2021;
    load([pwd '\State_Data\County_Data\County_Population.mat']);
    Data_CID=Population.County_ID_Numeric;
    Data_Year=Population.Year_Data;
    P_Age=Population.Age;
    P_Race=Population.Race;
    P_Education=Population.Education;
    P_Economic=Population.Economic;
    
    case_A=false;
    County_Trust_in_Healthcare=NaN.*zeros(length(County_ID),1);
    w_his=17.1./(17.1+6.3); % Weight of the hispanic population vs Asian
    w_Some_College=0.5; % Assumed to be 50% as there was no specification in the dataset
    if(strcmp(Var_1,'Primary Physician'))
        m_age=[59 74 84 90]./100;        
        m_race=[82 71 (w_his.*68+(1-w_his).*79)]./100;
        m_economic=[66 75 86 89]./100;
        
        case_A=true;
    elseif(strcmp(Var_1,'Nurses'))
        m_age=[80 84 87 88]./100;        
        m_education=[71 79 (w_Some_College.*87+(1-w_Some_College).*92)]./100;   
        m_race=[88 77 (w_his.*79+(1-w_his).*88)]./100;
        m_economic=[78 86 88 90]./100;       
    elseif(strcmp(Var_1,'Doctors'))
        m_age=[77 83 84 90]./100;        
        m_education=[70 80 (w_Some_College.*86+(1-w_Some_College).*90)]./100;   
        m_race=[87 78 (w_his.*76+(1-w_his).*91)]./100;
        m_economic=[75 84 90 90]./100;       
    elseif(strcmp(Var_1,'Healthcare System'))
        m_age=[54 57 62 77]./100;        
        m_education=[59 62 (w_Some_College.*64+(1-w_Some_College).*67)]./100;   
        m_race=[66 62 (w_his.*55+(1-w_his).*72)]./100;
        m_economic=[61 62 68 64]./100;       
    elseif(strcmp(Var_1,'Pharmaceutical Companies'))
        m_age=[29 31 31 42]./100;        
        m_education=[39 39 (w_Some_College.*31+(1-w_Some_College).*31)]./100;   
        m_race=[34 37 (w_his.*32+(1-w_his).*42)]./100;
        m_economic=[41 32 33 30]./100;       
    elseif(strcmp(Var_1,'Government Health Agencies'))
        m_age=[51 59 57 56]./100;        
        m_education=[49 51 (w_Some_College.*51+(1-w_Some_College).*67)]./100;   
        m_race=[55 58 (w_his.*51+(1-w_his).*75)]./100;
        m_economic=[53 51 62 59]./100;       
    elseif(strcmp(Var_1,'Treatment recommendations'))
        m_age=[64 77 87 90]./100;        
        m_education=[68 76 (w_Some_College.*80+(1-w_Some_College).*89)]./100;   
        m_race=[85 74 (w_his.*71+(1-w_his).*81)]./100;
        m_economic=[75 78 87 84]./100;       
    elseif(strcmp(Var_1,'Book follow-up'))
        m_age=[53 71 81 90]./100;        
        m_education=[62 72 (w_Some_College.*73+(1-w_Some_College).*84)]./100;   
        m_race=[79 72 (w_his.*66+(1-w_his).*78)]./100;
        m_economic=[72 70 81 81]./100;       
    end
    
    if(case_A)
        beta_age=log(m_age./(1-m_age));
        beta_race=log(m_race./(1-m_race));
        beta_economic=log(m_economic./(1-m_economic));

        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_Age=[P_Age.Range_18_to_34(tf,Data_Year==Year_Survey) P_Age.Range_35_to_49(tf,Data_Year==Year_Survey) P_Age.Range_50_to_64(tf,Data_Year==Year_Survey) P_Age.Range_65_and_older(tf,Data_Year==Year_Survey)];
                Pop_Race=[P_Race.White(tf,Data_Year==Year_Survey) P_Race.Black(tf,Data_Year==Year_Survey) P_Race.Other(tf,Data_Year==Year_Survey)];
                Pop_Economic=[P_Economic.Lower(tf,Data_Year==Year_Survey) P_Economic.Working(tf,Data_Year==Year_Survey) P_Economic.Middle(tf,Data_Year==Year_Survey) P_Economic.Upper(tf,Data_Year==Year_Survey)];

                Pop_Age=Pop_Age./sum(Pop_Age);
                Pop_Race=Pop_Race./sum(Pop_Race);
                Pop_Economic=Pop_Economic./sum(Pop_Economic);

                v_Age=1./(1+exp(-sum(Pop_Age.*beta_age)));
                v_Race=1./(1+exp(-sum(Pop_Race.*beta_race)));
                v_Economic=1./(1+exp(-sum(Pop_Economic.*beta_economic)));

                County_Trust_in_Healthcare(ii)=mean([v_Age v_Race v_Economic]);
            end
        end
    else
        beta_age=log(m_age./(1-m_age));
        beta_race=log(m_race./(1-m_race));
        beta_education=log(m_education./(1-m_education));
        beta_economic=log(m_economic./(1-m_economic));

        for ii=1:length(County_ID)
            tf=Data_CID == County_ID(ii);
            if(sum(tf)>0)
                Pop_Age=[P_Age.Range_18_to_34(tf,Data_Year==Year_Survey) P_Age.Range_35_to_49(tf,Data_Year==Year_Survey) P_Age.Range_50_to_64(tf,Data_Year==Year_Survey) P_Age.Range_65_and_older(tf,Data_Year==Year_Survey)];
                Pop_Race=[P_Race.White(tf,Data_Year==Year_Survey) P_Race.Black(tf,Data_Year==Year_Survey) P_Race.Other(tf,Data_Year==Year_Survey)];
                Pop_Education=[P_Education.Less_than_High_School(tf,Data_Year==Year_Survey) P_Education.High_School(tf,Data_Year==Year_Survey) P_Education.College(tf,Data_Year==Year_Survey)];
                Pop_Economic=[P_Economic.Lower(tf,Data_Year==Year_Survey) P_Economic.Working(tf,Data_Year==Year_Survey) P_Economic.Middle(tf,Data_Year==Year_Survey) P_Economic.Upper(tf,Data_Year==Year_Survey)];

                Pop_Age=Pop_Age./sum(Pop_Age);
                Pop_Race=Pop_Race./sum(Pop_Race);
                Pop_Education=Pop_Education./sum(Pop_Education);
                Pop_Economic=Pop_Economic./sum(Pop_Economic);

                v_Age=1./(1+exp(-sum(Pop_Age.*beta_age)));
                v_Race=1./(1+exp(-sum(Pop_Race.*beta_race)));
                v_Education=1./(1+exp(-sum(Pop_Education.*beta_education)));
                v_Economic=1./(1+exp(-sum(Pop_Economic.*beta_economic)));

                County_Trust_in_Healthcare(ii)=mean([v_Age v_Race v_Education v_Economic]);
            end
        end
    end
        
end
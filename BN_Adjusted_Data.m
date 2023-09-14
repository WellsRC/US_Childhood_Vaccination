clear;
clc;

T_State=readtable("Data_Transformed_Combined_State_Level.xlsx");

X_State=[T_State.Economic T_State.Education T_State.Income T_State.Political T_State.Race T_State.Sex T_State.Trust_in_Medicine T_State.Trust_in_Science T_State.Uninsured_19_under];

Y_State=T_State.Vaccine_Uptake;

D_State=T_State.Vaccine_Disease;

RE_State=T_State.State_Religous_Exemptions;

PE_State=T_State.State_Philosophical_Exemptions;

COVID_State=T_State.COVID;

T_State_Trim=T_State(:,[1 5:14]);
clear T_County T_State


Inqv={'MMR','DTaP','Polio','VAR'};

lb=-300.*ones(1,13);
lb(11:12)=0;
ub=300.*ones(1,13);
lb(3:4)=0;

T=readtable('County_Level_Cross_Validation.xlsx');
CVE=table2array(T(:,11:14));
f_min=zeros(4,1);
for mm=1:4
    f_min(mm)=find(CVE(:,mm)==min(CVE(:,mm)));
end
PDIVF=T.PandemicDirectlyImpactVaccination;
XF=table2array(T(:,2:10));

for nn=1:max(f_min)
    lb_t=lb([1 1 1 1 XF(nn,:)]==1);
    ub_t=ub([1 1 1 1 XF(nn,:)]==1);

    for jj=1:4
        t_state=strcmp(Inqv{jj},D_State);
        
        t_covid=double(COVID_State(t_state)==1);

        t_PE=double(PE_State(t_state)==1);

        t_RE=double(RE_State(t_state)==1);
        
        X_temp=X_State(t_state,:);
        X_temp=[t_covid t_PE t_RE X_temp(:,XF(nn,:)==1)];
        Y_temp=Y_State(t_state);
        fv=zeros(100,1);
        if(strcmp(PDIVF{nn},'Yes'))

            est_par=zeros(100,length(lb_t));
            for ii=1:100
                [est_par(ii,:),fv(ii)]=lsqnonlin(@(x)(x(1)+X_temp*(x(2:end)')-Y_temp),lb_t+(ub_t-lb_t).*rand(size(lb_t)));
            end
        else       
            est_par=zeros(100,length(lb_t)-1);
            for ii=1:100     
                [est_par(ii,:),fv(ii)]=lsqnonlin(@(x)(x(1)+X_temp(:,[1 3:end])*(x(2:end)')-Y_temp),lb_t(:,[1 3:end])+(ub_t(:,[1 3:end])-lb_t(:,[1 3:end])).*rand(size(lb_t(:,[1 3:end]))));
            end
        end
        p_c=est_par(fv==min(fv),:);
        p_c=p_c(1,:);
        if(strcmp(PDIVF{nn},'Yes'))
            temp_r=[t_covid t_PE t_RE]*(p_c(2:4)');            
        else
            temp_r=[t_PE t_RE]*(p_c(2:3)');
        end

        Vaccine_Uptake=Y_temp-temp_r;
        if(jj==1)
            T_new=[T_State_Trim(t_state,:) table(Vaccine_Uptake)];
        else
            T_new=[T_new;T_State_Trim(t_state,:) table(Vaccine_Uptake)];
        end
    end
    writetable(T_new,['Adjusted_Data_Model_Rank_' num2str(nn) '.xlsx'],'Sheet','Data');
end
%'COVID','State_Religous_Exemptions','State_Philosophical_Exemptions','Vaccine_Disease','Partition',Vaccine_Uptake
VN={'Economic','Education','Income','Political','Race','Sex','Trust_in_Medicine','Trust_in_Science','Uninsured_19_under'};
VN_O={'COVID','Vaccine_Disease'};
for jj=1:max(f_min)
    A=cell(length(VN)+length(VN_O),1);
    B=cell(length(VN)+length(VN_O),1);
    Method=cell(length(VN)+length(VN_O),1);
    FailureMode=cell(length(VN)+length(VN_O),1);
    TemporalOrder=cell(length(VN)+length(VN_O),1);

    for vv=1:length(VN)
        A{vv}=VN{vv};
        FailureMode{vv}='ThrowException';
        B{vv}='Vaccine_Uptake';
        if(XF(jj,vv)==1)
            Method{vv}='AToB';
        else
            Method{vv}='NotAToBOrBToA';
        end
    end
    for ss=1:length(VN_O)
        if(strcmp(VN_O{ss},'COVID'))
            Method{length(VN)+ss}='NotAToBOrBToA';
        else
            Method{length(VN)+ss}='AToB';
        end
        A{length(VN)+ss}=VN_O{ss};
        FailureMode{length(VN)+ss}='ThrowException';
        B{length(VN)+ss}='Vaccine_Uptake';
    end
    T=table(A,B,Method,FailureMode,TemporalOrder);

    
    A=cell(length(VN)+length(VN_O)-1,1);
    B=cell(length(VN)+length(VN_O)-1,1);
    Method=cell(length(VN)+length(VN_O)-1,1);
    FailureMode=cell(length(VN)+length(VN_O)-1,1);
    TemporalOrder=cell(length(VN)+length(VN_O)-1,1);
    
    for vv=1:length(VN)
        A{vv}=VN{vv};
        FailureMode{vv}='ThrowException';
        B{vv}='Vaccine_Disease';
        Method{vv}='NotAToBOrBToA';
    end
    for ss=1:(length(VN_O)-1)
        Method{length(VN)+ss}='NotAToBOrBToA';
        A{length(VN)+ss}=VN_O{ss};
        FailureMode{length(VN)+ss}='ThrowException';
        B{length(VN)+ss}='Vaccine_Disease';
    end
    
    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Sex';'Race'};
    B={'COVID';'COVID';'COVID';'COVID'};
    Method={'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA';'NotAToBOrBToA'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(4,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    A={'Economic';'Education';'Income';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science';'Trust_in_Science'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(7,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Income';'Political';'Race';'Sex';'Uninsured_19_under'};
    B={'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine';'Trust_in_Medicine'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(7,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    A={'Economic';'Education';'Income';'Race';'Sex'};
    B={'Political';'Political';'Political';'Political';'Political'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(5,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];


    B={'Economic';'Education';'Income'};
    A={'Race';'Race';'Race'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(3,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];

    B={'Economic';'Education';'Income'};
    A={'Sex';'Sex';'Sex'};
    Method={'AToBIfExists';'AToBIfExists';'AToBIfExists'};
    FailureMode={'ThrowException';'ThrowException';'ThrowException'};
    TemporalOrder=cell(3,1);

    T=[T; table(A,B,Method,FailureMode,TemporalOrder)];
    writetable(T,['Adjusted_Data_Model_Rank_' num2str(jj) '.xlsx'],'Sheet','Conditions','WriteVariableNames',true);
end
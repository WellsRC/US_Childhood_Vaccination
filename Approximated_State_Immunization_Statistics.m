function V=Approximated_State_Immunization_Statistics(Vac,Yr,Inq_State_ID)

    [State_ID,~,~]=Read_ID_Number();
    V=zeros(length(State_ID),length(Yr));
    
    load(['State_County_Data_Cross_Validation_Model_Data_' Vac '.mat'],'X_State','RE_State','PE_State','Data_Yr_State');
    
    C=readtable('County_Level_Cross_Validation.xlsx','Sheet',['Coefficients_' Vac ]);
    M=table2array(C);
    [W,Inqv]=Return_Model_Weights();
    w_c=cumsum(W{strcmp(Vac,Inqv)});
    
    N_Samp=10^4;

    r=rand(N_Samp,1);
    Indx=zeros(N_Samp,1);
    
    for ii=1:length(r)
        Indx(ii)=find(r(ii)<=w_c, 1 );
    end
    Mt=M(Indx,:);
    for yy=1:length(Yr)
        T_New=[RE_State(Data_Yr_State==Yr(yy)) PE_State(Data_Yr_State==Yr(yy)) X_State(Data_Yr_State==Yr(yy),:)];
        test_v=1./(1+exp(-Mt*(T_New')));
        V(:,yy)=mean(test_v,1);
    end

    V=V(ismember(State_ID,Inq_State_ID),:);
end
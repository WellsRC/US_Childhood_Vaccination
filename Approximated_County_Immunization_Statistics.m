function [V,V_All]=Approximated_County_Immunization_Statistics(Vac,Yr,Inq_County_ID,N_Samp)

    [~,County_ID,~]=Read_ID_Number();
    V=zeros(length(County_ID),length(Yr));
    
    load(['State_County_Data_Cross_Validation_Model_Data_' Vac '.mat'],'X_County','RE_County','PE_County','Data_Yr_County');
    
    C=readtable('County_Level_Cross_Validation_Parental_Trust.xlsx','Sheet',['Coefficients_' Vac ]);
    M=table2array(C);
    [W,Inqv]=Return_Model_Weights();
    w_c=cumsum(W{strcmp(Vac,Inqv)});
    
    V_All=zeros(length(Yr),length(County_ID),N_Samp);

    r=rand(N_Samp,1);
    Indx=zeros(N_Samp,1);
    
    for ii=1:length(r)
        Indx(ii)=find(r(ii)<=w_c, 1 );
    end
    Mt=M(Indx,:);
    for yy=1:length(Yr)
        T_New=[RE_County(Data_Yr_County==Yr(yy)) PE_County(Data_Yr_County==Yr(yy)) X_County(Data_Yr_County==Yr(yy),:)];
        test_v=1./(1+exp(-Mt*(T_New')));
        V_All(yy,:,:)=test_v';
        V(:,yy)=mean(test_v,1);
    end

    V=V(ismember(County_ID,Inq_County_ID),:);
    V_All=V_All(:,ismember(County_ID,Inq_County_ID),:);
end
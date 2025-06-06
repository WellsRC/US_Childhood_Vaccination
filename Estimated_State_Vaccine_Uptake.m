function v = Estimated_State_Vaccine_Uptake(v_county,pop_county,State_FIPs_county,State_FIP)

v=zeros(length(State_FIP),1);
for ii=1:length(State_FIP)
    tf=State_FIPs_county==State_FIP(ii);
    v(ii)=sum(v_county(tf).*pop_county(tf))./sum(pop_county(tf));
end

end
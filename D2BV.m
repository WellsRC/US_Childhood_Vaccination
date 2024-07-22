function BV = D2BV(D)

if(D>0)
    length_BV=floor(log2(D))+1;
else
    length_BV=1;
end
BV=zeros(1,length_BV);

for nn=(length_BV-1):-1:0
    rem_D=D-2.^nn;
    if(rem_D>=0) && (D>0)
        BV(length_BV-nn)=1;
        D=D-2.^nn;
    end

end


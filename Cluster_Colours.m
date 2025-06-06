function [CC,mk]=Cluster_Colours(n)


if(n>5)
    CC=[hex2rgb('#a6cee3')
hex2rgb('#1f78b4')
hex2rgb('#b2df8a')
hex2rgb('#33a02c')
hex2rgb('#fb9a99')
hex2rgb('#e31a1c')
hex2rgb('#fdbf6f')
hex2rgb('#ff7f00')
hex2rgb('#cab2d6')
hex2rgb('#6a3d9a')
hex2rgb('#ffff99')
hex2rgb('#b15928')];
    if(n>size(CC,1))
        CC=interp1([1:size(CC,1)],CC,linspace(1,size(CC,1),n));
    else
        CC=CC(1:n,:);
    end
else
    CC=[hex2rgb('#ff3131')
hex2rgb('#e2e52f')
hex2rgb('#6ae52f')
hex2rgb('#00fdfd')
hex2rgb('#ce51ff')];

    CC=CC(1:n,:);
end

 mkv={'o','square','diamond','^','pentagram'};
if(n>5)
    mk=cell(n,1);
    for jj=1:n
        mk{jj}=mkv{rem(jj-1,5)+1};
    end
else
    mk=mkv(1:n);
end

end
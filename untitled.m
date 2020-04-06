s=0:1e-3:1; i=0;
for R0=2.5:0.1:4.5
    k=find(s-exp(-R0*(1-s))>=0,1);
    i=i+1; z(i)=s(k);
end
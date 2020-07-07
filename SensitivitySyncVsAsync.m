T=readtable("v.csv");
M=table2array(T);

x=100-M(:,1);
figure(1);
plot(x,smooth(M(:,2),7),x,smooth(M(:,3),7),x,smooth(M(:,4),7),x,smooth(M(:,5),7));

for k=1:4
    i=k+1;
    y(k)=100*(M(1,i)-M(end,i))/M(1,i);
end
y


T=readtable("t.csv");
N=table2array(T);

x=100-N(:,1);
figure(2);
plot(x,smooth(N(:,2),7),x,smooth(N(:,3),7),x,smooth(N(:,4),7),x,smooth(N(:,5),7));

for k=1:4
    i=k+1;
    z(k)=-100*(N(1,i)-N(end,i))/N(1,i);
end
z



load("Italy1",'par0','g','h','S0','H0','R0','X0','C','Inc','N'); 
par0a=par0; ga=g; ha=h; S0a=S0; H0a=H0; R0a=R0; X0a=X0; Ca=C; Inca=Inc;

load("Fit1",'T','YX','Y0','Y1','Y2');
Ta=T; YXa=YX; Y0a=Y0; Y1a=Y1; Y2a=Y2;
yXa=YX(:,3); y0a=Y0(:,3); y1a=Y1(:,3); y2a=Y2(:,3);  

load("Italy3",'par0','g','h','S0','H0','R0','X0','C','Inc','Pop'); 
par0b=par0; gb=g; hb=h; S0b=S0; H0b=H0; R0b=R0; X0b=X0; Cb=C; Incb=Inc;

load("Fit3",'T','YX','Y0','Y1','Y2');
Tb=T; YXb=YX; Y0b=Y0; Y1b=Y1; Y2b=Y2;
yXb=sum(YX(:,7:9),2); y0b=sum(Y0(:,7:9),2); 
y1b=sum(Y1(:,7:9),2); y2b=sum(Y2(:,7:9),2);  


[mXa iXa] =max(yXa); [m0a i0a] =max(y0a); 
i=i0a; while y1a(i+1)<=y1a(i); i=i+1; end; 
[m1a i1a] =max(y1a(i:end)); i1a=i1a+i-1;
i=i0a; while y2a(i+1)<=y2a(i); i=i+1; end; 
[m2a i2a] =max(y2a(i:end)); i2a=i2a+i-1;

[mXb iXb] =max(yXb); [m0b i0b] =max(y0b); 
i=i0b; while y1b(i+1)<=y1b(i); i=i+1; end; 
[m1b i1b] =max(y1b(i:end)); i1b=i1b+i-1;
i=i0b; while y2b(i+1)<=y2b(i); i=i+1; end; 
[m2b i2b] =max(y2b(i:end)); i2b=i2b+i-1;


Ytot=ReadItaly(); tend=max(size(Ytot));
%plot(T,y2a,T,y2b,T,y0a,T,y0b)

TT=1:400;

Y=SIORX3_t1_model(par0b,TT,gb,hb,S0b,H0b,R0b,X0b,Cb,Incb,Pop);
y=sum(Y(:,7:9),2);

t70=T(i0b+find(y(i0b:end)<m0b*0.70,1));
Y70=SIORX3_t2_model([par0b t70 1],TT,gb,hb,S0b,H0b,R0b,X0b,Cb,Incb,Pop);
y70=sum(Y70(:,7:9),2);

t50=T(i0b+find(y(i0b:end)<m0b*0.50,1));
Y50=SIORX3_t2_model([par0b t50 1],TT,gb,hb,S0b,H0b,R0b,X0b,Cb,Incb,Pop);
y50=sum(Y50(:,7:9),2);

%plot(TT,y70,TT,y50,TT,y)

% par0 = [ b i0 t0 teps eps]
b=par0b(1); I0b=par0b(2)*ones(1,3)/3; t0=par0b(3); t1=par0b(4); C1=par0b(5)*Cb;

YY=SIORX3_C1_model(TT,t0,b,gb,hb,S0b,I0b,H0b,R0b,X0b,Cb,Incb,Pop,t1,C1);
yy=sum(YY(:,7:9),2);

YY70=SIORX3_C2_model(TT,t0,b,gb,hb,S0b,I0b,H0b,R0b,X0b,Cb,Incb,Pop,t1,C1,t70,Cb);
yy70=sum(YY70(:,7:9),2);

eps=par0(5);
epsZ=[eps eps eps
     eps  1  eps
     eps eps eps];
CC=epsZ.*Cb;
ZZ70=SIORX3_C2_model(TT,t0,b,gb,hb,S0b,I0b,H0b,R0b,X0b,Cb,Incb,Pop,t1,C1,t70,CC);
zz70=sum(ZZ70(:,7:9),2);

eps=par0(5);
epsW=[ 1  1   eps
      1  1   eps
     eps eps eps];
CC=epsW.*Cb;
WW70=SIORX3_C2_model(TT,t0,b,gb,hb,S0b,I0b,H0b,R0b,X0b,Cb,Incb,Pop,t1,C1,t70,CC);
ww70=sum(WW70(:,7:9),2);

eps=par0(5);
epsX=[eps eps eps
      eps  1   1
      eps  1   1];
CC=epsX.*Cb;
XX70=SIORX3_C2_model(TT,t0,b,gb,hb,S0b,I0b,H0b,R0b,X0b,Cb,Incb,Pop,t1,C1,t70,CC);
xx70=sum(XX70(:,7:9),2);

%plot(TT,zz70,TT,ww70,TT,xx70,TT,yy70,TT,yy)
%plot(TT,zz70,TT,ww70,TT,yy70,TT,yy)
%pause
Scenario3figure(TT,[zz70,ww70,yy70,xx70,yy])

M= [ ZZ70(end,13:15) - ZZ70(t70,13:15) 
     WW70(end,13:15) - WW70(t70,13:15) 
     XX70(end,13:15) - XX70(t70,13:15) 
     YY70(end,13:15) - YY70(t70,13:15) ];
 
%plot(M,'-o')

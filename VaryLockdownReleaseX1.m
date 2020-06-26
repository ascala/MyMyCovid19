%Ytot=ReadItaly(); 

% model parameters
load("Italy1",'par0','g','h','S0','I0','H0','R0','X0','C','Inc','N');
load("Fit1",'T','YX','Y0','Y1','Y2');

N=S0+I0+H0+R0;
tauI=10; g=1/tauI; tauH=10; h=1/tauH; 

% useful functions
Fun1=@(p,x) SIORX1_t1_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);
Fun2=@(p,x) SIORX1_t2_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);

tmax=300; T=1:tmax;
r=0.05; 

par=par0; %[ b  i0  t0  teps  eps ]
Y=Fun1(par,T); y0=r*Y(:,3); [m0 i0]=max(y0); t0=T(i0); 

figure(1); plot(T,y0,'r'); hold on


j=0;
for istart=i0:200
    tstart=T(istart); epstart=1;
    par1=[par tstart epstart];
    Y=Fun2(par1,T); y1=r*Y(:,3);
    j=j+1;
    drop(j)=100*(1-y0(istart)/m0);
    [m1 i1]=max(y1(istart:end)); i1=i1+(istart-1); 
    moverm0(j)=m1/m0;
    moverm(j)=m1/y1(istart);
    tovert(j)=T(i1)/T(i0);
    mm(j)=m1; yy(j)=y1(istart);
%    figure(1)
%    plot(tstart:tmax,y1(istart:end),'b'); hold on
%    figure(2)
%    plot(drop,m1/m0,'ok'); hold on
%    figure(3)
%    plot(drop,T(i1)/T(i0),'ok'); hold on
end

figure(2)
subplot(2,1,1); plot(drop,moverm0);
subplot(2,1,2); plot(drop,smooth(tovert,7));

figure(3)
subplot(2,1,1); plot(drop,mm,drop,yy);
subplot(2,1,2); plot(drop,moverm);

%Ytot=ReadItaly(); 

% model parameters
load("Italy1",'par0','g','h','S0','I0','H0','R0','X0','C','Inc','N');
load("Fit1",'T','YX','Y0','Y1','Y2');

N=S0+I0+H0+R0;
tauI=10; g=1/tauI; tauH=10; h=1/tauH; 

% useful functions
Fun1=@(p,x) SIORX1_t1_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);
Fun2=@(p,x) SIORX1_t2_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);

r=0.035; 
tmax=250; T=1:tmax;

i=0;
par=par0; par(5)=1;  %[ b  i0  t0  teps  eps ]
Y=Fun1(par,T); y0=r*Y(:,3); [m0 i0]=max(y0); t0=T(i0); 

% subplot(4,1,1)
% plot(T,y0,'b'); yy=ylim; ylim([0 2.5e5]); hold on
%semilogy(T,y0,'b'); yy=ylim; ylim([0 2.5e5]); hold on

i=0
for teps= 15:-5:5 %[15 10 5]
     par=par0; par(4)=teps;  %[ b  i0  t0  teps  eps ]
     Y=Fun1(par,T); y=r*Y(:,3); [m im]=max(y); tm=T(im);
     fprintf("%.0f & %.0f  & %.2f \\\\\n",teps,round((tm-t0)/7),(m-m0)/m0);
     t1=tm+find(y(tm:end)<0.7*m,1);
     par1=[par t1 1];
     Y=Fun2(par1,T); y1=r*Y(:,3); 
     i=i+1; tmax(i)=tm; teps1(i)=t1;

     subplot(2,1,1); plot(T,[y(1:tm);y1(tm+1:end)],'b'); xx=xlim; hold on
     
     a=par(5); b=-(1+a)/a;  z=[y(1:tm);y1(tm+1:end)];
     subplot(2,1,2); plot(T(1:5:250)+b*(15-teps),z(1:5:250),'o'); xlim(xx);hold on
end

% for teps=[15 30 45]
%      par=par0; par(4)=teps;  %[ b  i0  t0  teps  eps ]
%      Y=Fun1(par,T); y=r*Y(:,3); [m im]=max(y); tm=T(im);
%      fprintf("%.0f & %.0f  & %.2f \\\\\n",teps,round((tm-t0)/7),(m-m0)/m0);
%      t1=tm+find(y(tm:end)<0.7*m,1);
%      par1=[par t1 1];
%      Y=Fun2(par1,T); y1=r*Y(:,3); 
%      [tm t1]
%      i=5-teps/15;subplot(4,1,i)
%      plot(T(1:tm),y(1:tm),'b',T(tm:end),y1(tm:end),'b'); ylim(yy)
% end

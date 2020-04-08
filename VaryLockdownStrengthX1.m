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
tmax=400; T=1:tmax;

i=0;
par=par0; par(5)=1;  %[ b  i0  t0  teps  eps ]
Y=Fun1(par,T); y0=r*Y(:,3); [m0 i0]=max(y0); t0=T(i0); 

subplot(2,1,1); plot(T,y0,'r'); hold on
subplot(2,1,2); semilogy(T,y0,'r'); hold on

R_0=par0(1)/g; eps_crit=1/R_0;
for i=[0.94 0.983 1]
     eps=eps_crit*i
     par=par0; par(5)=eps;  %[ b  i0  t0  teps  eps ]
     Y=Fun1(par,T); y=r*Y(:,3); [m im]=max(y); tm=T(im);
     fprintf("%.2f & %.0f  & %.2f \\\\\n",eps,round((tm-t0)/7),(m-m0)/m0);
     t1=tm+find(y(tm:end)<0.7*m,1);
     par1=[par t1 1];
     Y=Fun2(par1,T); y1=r*Y(:,3); 
     [tm t1]
     i=i+1;
    subplot(2,1,1); plot(T,[y(1:tm);y1(tm+1:end)],'b'); hold on
    subplot(2,1,2); semilogy(T,[y(1:tm);y1(tm+1:end)],'b'); hold on
end


% i=0; R0=par0(1)/g; eps_crit=1/R0;
% for eps=[0.05:0.01:0.29]
%      par=par0; par(5)=eps;  %[ b  i0  t0  teps  eps ]
%      Y=Fun1(par,T); y=r*Y(:,3); [m im]=max(y); tm=T(im);
%      fprintf("%.2f & %.0f  & %.2f \\\\\n",eps,round((tm-t0)/7),(m-m0)/m0);
%      t1=tm+find(y(tm:end)<0.7*m,1);
%      par1=[par t1 1];
%      Y=Fun2(par1,T); y1=r*Y(:,3); 
%      [tm t1]
%      i=i+1;
%      tmax(i)=tm; [x tmax1(i)]=max(y1(t1:end));
% %      subplot(4,1,i)
% %      semilogy(T,y0,'r',T,[y(1:tm);y1(tm+1:end)],'b'); %ylim(yy)
%     semilogy(T,y0,'r',T,[y(1:tm);y1(tm+1:end)],'b'); hold on
% end



% subplot(4,1,1)
% plot(T,y0,'b'); yy=ylim; ylim([0 2.5e5]);
% for i=2:4
%      eps=0.10*(8-i);
%      par=par0; par(5)=eps;  %[ b  i0  t0  teps  eps ]
%      Y=Fun1(par,T); y=r*Y(:,3); [m im]=max(y); tm=T(im);
%      fprintf("%.2f & %.0f  & %.2f \\\\\n",eps,round((tm-t0)/7),(m-m0)/m0);
%      t1=tm+find(y(tm:end)<0.7*m,1);
%      par1=[par t1 1];
%      Y=Fun2(par1,T); y1=r*Y(:,3); 
%      [tm t1]
%      subplot(4,1,i)
%      plot(T(1:tm),y(1:tm),'b',T(tm:end),y1(tm:end),'b'); ylim(yy)
% end

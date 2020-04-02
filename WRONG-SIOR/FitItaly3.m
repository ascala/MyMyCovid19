% contact matrix, populations, incidence of discovery
load("2ageClasses",'contacts','Pop','Inc','Mort');

C=contacts;
S0=Pop; H0=[0 0]; R0=[0 0]; N=sum(Pop);
tau=10; g=1/10; h=1/10; b=4.2*g; 


Fun1=@(p,x) SIOR_local1_model(p,x,g,h,S0,H0,R0,C,Inc,N);
Fun2=@(p,x) SIOR_local2_model(p,x,g,h,S0,H0,R0,C,Inc,N);
Fun3=@(p,x) SIOR_local3_model(p,x,g,h,S0,H0,R0,C,Inc,N);


i0=1; teps1=15; teps2=22; teps3=130;

tmax=2*teps3; T=1:tmax;

par=[0.5693 1 30 teps1 1 teps2 1 teps3 1]; 
Y0=Fun3(par,T); 

par=[0.5764 1   30   teps1  0.5521  teps2 0.5521 teps3 1];
Y1=Fun3(par,T); 

par=[0.5693 1 30 teps1 0.7136 teps2 0.5053 teps3 1];
Y2=Fun3(par,T); 

par=[0.5693 1 30 teps1 0.5 teps2 0.5 teps3 1];
Y3=Fun3(par,T); 
 

r=0.034; 
y0a=r*Y0(:,5); y1a=r*Y1(:,5); y2a=r*Y2(:,5); y3a=r*Y3(:,5); 
subplot(2,1,1); plot(T,y0a,T,y1a,T,y2a,T,y3a)
y0b=r*Y0(:,6); y1b=r*Y1(:,6); y2b=r*Y2(:,6); y3b=r*Y3(:,6); 
subplot(2,1,2); plot(T,y0b,T,y1b,T,y2b,T,y3b)

par=[0.5693 1 30 teps1-7 0.55 teps2 0.5 teps3 1];
Y3=Fun3(par,T); 
 
r=0.034; y0=r*sum(Y0(:,5:6),2); y1=r*sum(Y1(:,5:6),2); y2=r*sum(Y2(:,5:6),2); y3=r*sum(Y3(:,5:6),2); 

[m0 t0]=max(y0); [m1 t1]=max(y1); [m2 t2]=max(y2); [m3 t3]=max(y3);

res=[ (m0-m1)/m0 (t1-t0)/t0
      (m0-m2)/m0 (t2-t0)/t0%];
      (m0-m3)/m0 (t3-t0)/t0];
round(100*res)
%round(([t0 t1 t2]-33)/7)
round(([t0 t1 t2 t3]-33)/7)

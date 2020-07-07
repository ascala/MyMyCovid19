%function [par0 g h S0 H0 R0 C Inc N]=FitItaly();

    % contact matrix, populations, incidence of discovery
    load("2ageClasses",'contacts','Pop','Inc','Mort');

    Ytot=ReadItaly(); tend=max(size(Ytot)); 
    tend=30; % in the paper: 15+15

    
    C=1; Inc=1; % normalization
    S0=sum(Pop); H0=0; R0=0; X0=0; N=sum(Pop);
    tauI=10; g=1/tauI; tauH=9; h=1/tauH; b=3*g; 


    i0=1; teps=15; I0=i0;
    %t0=26; Inc=Inc*100/100;
    %t0=32; Inc=Inc*60/100;
    t0=30; Inc=Inc*40/100;
    %t0=36; Inc=Inc*20/100;
    %t0=39; Inc=Inc*10/100;

    
    %    [ b     i0   t0   teps   eps]
    parX=[b    i0   t0   teps   0.5];

    fun0=@(p,x) SIORX1_t0([p(1) i0 p(3)],x,g,h,S0,H0,R0,X0,C,Inc,N);
    
    lb=[0 1 5 5 0]; % lower bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun0, parX, 1:teps, Ytot(1:teps)', lb);
    y0=fun0(par0,1:teps); err0=norm(Ytot(1:teps)-y0);
    %semilogy(1:tend,Ytot(1:tend),'ok',1:teps,y0,'r'); hold on
  
    beta=par0(1); beta-g
    
    fun1=@(p,x) SIORX1_t1([beta i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,N);
    
    lb=[0 1 5 5 0]; % lower bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun1, par0, 1:tend, Ytot(1:tend)', lb);
    y0=fun1(par0,1:tend); err0=norm(Ytot(1:tend)-y0);
    semilogy(1:tend,Ytot(1:tend),'ok',1:tend,y0,'k'); hold on

[par0(1)*max(eig(C))/g par0]
%pause

Fun1=@(p,x) SIORX1_t1_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);
Fun2=@(p,x) SIORX1_t2_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);

r=0.035; 
tmax=300; T=1:tmax;

parX=par0; parX(5)=1;
YX=Fun1(parX,T); yX=r*YX(:,3);

Y0=Fun1(par0,T); y0=r*Y0(:,3); [m im]=max(y0); 

i1= (im-1)+find(y0(im:end)<m*0.7,1); teps1=T(i1);
par1=[par0 teps1 1];
Y1=Fun2(par1,T); y1=r*Y1(:,3); 

i2= (im-1)+find(y0(im:end)<m*0.5,1); teps2=T(i2);
par2=[par0 teps2 1];
Y2=Fun2(par2,T); y2=r*Y2(:,3); 

figure(2);
%plot(T,yX,'r',T,y1,'b',T,y2,'g',T,y0,'k')
Scenario1figure( T, [yX y1 y2 y0])

save("Italy1",'par0','g','h','S0','I0','H0','R0','X0','C','Inc','N');
save("Fit1",'T','YX','Y0','Y1','Y2');


%end

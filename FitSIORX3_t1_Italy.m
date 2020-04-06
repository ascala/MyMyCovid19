%function [par0 g h S0 H0 R0 C Inc N]=FitSIORX3_t1_Italy();

    % contact matrix, populations, incidence of discovery
    load("3ageClasses",'contacts','Pop','Inc','Mort');

%%%%% do not use incidence 
Inc=[1;1;1];
    
    Ytot=ReadItaly(); tend=max(size(Ytot)); tend=36;

    
    C=contacts; % normalization
    S0=Pop'; H0=[0 0 0]; R0=[0 0 0]; X0=[0 0 0]; N=sum(Pop); 
    tau=10; g=1/10; h=1/10; b=4.2*g; 


    i0=1; teps=15; 
    %t0=25; Inc=2*Inc;
    t0=28; Inc=2*Inc*40/100;
    %t0=25; Inc=2*Inc/2;
    %t0=30; Inc=2*Inc/4;
    %t0=34; Inc=2*Inc/8;
    
%    %%%%%%%%%%   CHECK - shold get same results of the 1 age class case 
%    C=ones(3,3); t0=30; Inc=[1;1;1]*40/100;

    
    %    [ b     i0   t0   teps   eps]
    parX=[3*g    i0   t0   teps   0.5];

    fun0=@(p,x) SIORX3_t0([p(1) i0 p(3)],x,g,h,S0,H0,R0,X0,C,Inc,Pop);
    lb=[0 1 5 5 0]; % lower bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun0, parX, 1:teps, Ytot(1:teps)', lb);
    y0=fun0(par0,1:teps); err0=norm(Ytot(1:teps)-y0);
    semilogy(1:teps,Ytot(1:teps),'o',1:teps,y0,':'); hold on

    beta=par0(1);
    
    fun1=@(p,x) SIORX3_t1([beta i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,Pop);
    lb=[0 1 5 5 0]; % lower bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun1, par0, 1:tend, Ytot(1:tend)', lb);
    y0=fun1(par0,1:tend); err0=norm(Ytot(1:tend)-y0);
    semilogy(1:tend,Ytot(1:tend),'o',1:tend,y0,'--'); hold on
    
    
[par0(1)*max(eig(C))/g par0]

Fun1=@(p,x) SIORX3_t1_model(p,x,g,h,S0,H0,R0,X0,C,Inc,Pop);
Fun2=@(p,x) SIORX3_t2_model(p,x,g,h,S0,H0,R0,X0,C,Inc,Pop);

r=0.035; 
tmax=300; T=1:tmax; iH=7:9;

parX=par0; parX(5)=1;
YX=Fun1(parX,T); yX=r*sum(YX(:,iH),2);

Y0=Fun1(par0,T); y0=r*sum(Y0(:,iH),2); [m im]=max(y0); 

i1= (im-1)+find(y0(im:end)<m*0.7,1); teps1=T(i1);
par1=[par0 teps1 1];
Y1=Fun2(par1,T); y1=r*sum(Y1(:,iH),2); 

i2= (im-1)+find(y0(im:end)<m*0.5,1); teps2=T(i2);
par2=[par0 teps2 1];
Y2=Fun2(par2,T); y2=r*sum(Y2(:,iH),2); 

%figure(2);
%plot(T,yX,'r',T,y1,'b',T,y2,'g',T,y0,'k')
Scenario1figure( T, [yX y1 y2 y0])

save("Italy3",'par0','g','h','S0','H0','R0','X0','C','Inc','Pop');
save("Fit3",'T','YX','Y0','Y1','Y2');

%end
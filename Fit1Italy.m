%function [par0 g h S0 H0 R0 C Inc N]=FitItaly();

    % contact matrix, populations, incidence of discovery
    load("2ageClasses",'contacts','Pop','Inc','Mort');

    C=contacts;
    S0=Pop; H0=[0 0]; R0=[0 0]; N=sum(Pop);
    tau=10; g=1/10; h=1/10; b=4.2*g; 

    Ytot=ReadItaly(); 

    i0=1; teps=15; t0=30;
    fun1=@(p,x) SIOR_local1([p(1) i0 p(3) teps p(5)],x,g,h,S0,H0,R0,C,Inc,N);
    Fun1=@(p,x) SIOR_local1_model([p(1) i0 p(3) teps p(5)],x,g,h,S0,H0,R0,C,Inc,N);
    %    [   b        i0        t0       teps       eps ]
    parX=[0.6    i0   t0   teps   0.5];
    lb=[0 1 5 5 0]; % lower bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun1, parX, 1:33, Ytot', lb);
    y0=fun1(par0,1:33); err0=norm(Ytot-y0);
    semilogy(1:33,Ytot,'o',1:33,y0,'--'); hold on
%     for t0=10:40
%         par1=par0; par1(3)=t0;
%         [par1,ResNorm] = lsqcurvefit(fun, par1, 1:33, Ytot', lb);
%         y1=fun(par1,1:33); err1=norm(Ytot-y1);
%         if(err1<err0) par0=par1; err1=err0; end
%     end
%     semilogy(1:33,y1); hold off
    [par0(1)/g par0]

    % par = [b g h S0 I0 H0 R0] for SIORage_model(par,t,C,Inc,N)
    % par = [b i0 t0 teps eps] for SIOR_local1(par,t,g,h,S0,H0,R0,C,Inc,N)


%end

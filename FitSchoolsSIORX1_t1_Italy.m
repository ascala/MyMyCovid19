%function [par0 g h S0 H0 R0 C Inc N]=FitItaly();

    % contact matrix, populations, incidence of discovery
    load("2ageClasses",'contacts','Pop','Inc','Mort');

    Ytot=ReadItaly(); tend=max(size(Ytot)); 
    
    
    C=1; Inc=1; % normalization
    S0=sum(Pop); H0=0; R0=0; X0=0; N=sum(Pop);
    tau=10; g=1/10; h=1/10; b=4.2*g; 

    
    t1=15-8; t2=15; tend=33;

    i0=1;  
    t0=25; 
    Inc=Inc*40/100;
    
    lb=[0 1 1 1 0 1 0]; % lower bounds for the parameters

    %    [  b  i0  t0  t1  a1  t2  a2]
    parX=[3*g  i0  t0  t1 0.9  t2 0.9];         
    fun0=@(p,x) SIORX1_t0([p(1) i0 t0],x,g,h,S0,H0,R0,X0,C,Inc,N);
    t=1:t1; [par0,ResNorm] = lsqcurvefit(fun0, parX, t, Ytot(t)', lb);
    b=par0(1); 
    fun1=@(p,x) SIORX1_t1([b i0 t0 t1 p(5)],x,g,h,S0,H0,R0,X0,C,Inc,N);
    t=1:t2; [par0,ResNorm] = lsqcurvefit(fun1, par0, t, Ytot(t)', lb);
    a1=par0(5)
    fun2=@(p,x) SIORX1_t2([b i0 t0 t1 a1 t2 p(7)],x,g,h,S0,H0,R0,X0,C,Inc,N);
    t=1:tend; [par0,ResNorm] = lsqcurvefit(fun2, par0, t, Ytot(t)', lb);
    semilogy(1:tend,Ytot(1:tend),'ok',t,fun2(par0,t),'k'); 
    
    [b*C/g par0]
     
     
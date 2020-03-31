%function [par0 g h S0 H0 R0 C Inc N]=FitItaly();

    % contact matrix, populations, incidence of discovery
    load("2ageClasses",'contacts','Pop','Inc','Mort');

    C=contacts;
    S0=Pop; H0=[0 0]; R0=[0 0]; N=sum(Pop);
    tau=10; g=1/10; h=1/10; b=4.2*g; 

    Ytot=ReadItaly(); 

    i0=1; teps1=15; teps2=21; 
    t0=30; Inc=2*Inc;
    t0=30; Inc=2*Inc/4;
    %t0=35; Inc=2*Inc/8;
    
    fun2=@(p,x)       SIOR_local2([p(1) i0 p(3) teps1 p(5) teps2 p(7)],x,g,h,S0,H0,R0,C,Inc,N);
    Fun2=@(p,x) SIOR_local2_model([p(1) i0 p(3) teps1 p(5) teps2 p(7)],x,g,h,S0,H0,R0,C,Inc,N);
    %    [  b    i0   t0   teps1   eps1  teps2   eps2]
    parX=[0.80   i0   t0   teps1   0.7  teps2   0.45];
      %[b  i0  t0  teps1  eps1  teps2 eps2]
    lb=[0  i0  20  teps1     0  teps2    0]; % lower bounds for the parameters
    ub=[2  i0  30  teps1     1  teps2    1]; % upper bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun2, parX, 1:33, Ytot', lb);
    y0=fun2(par0,1:33); err0=norm(Ytot-y0);
    semilogy(1:33,Ytot,'o',1:33,y0); hold on
if 3==3
    for t0=20:40
         par1=par0; par1(3)=t0;
         [par1,ResNorm] = lsqcurvefit(fun2, par1, 1:33, Ytot', lb);
         y1=fun2(par1,1:33); err1=norm(Ytot-y1);
         if(err1<err0) par0=par1; err1=err0; end
     end
   semilogy(1:33,y1); hold off
end

    [par0(1)/g par0]
    

%end

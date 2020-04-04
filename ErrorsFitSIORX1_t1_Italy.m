%function [par0 g h S0 H0 R0 C Inc N]=FitItaly();

    % contact matrix, populations, incidence of discovery
    load("2ageClasses",'contacts','Pop','Inc','Mort');

    Ytot=ReadItaly(); tend=max(size(Ytot)); tend=29;

    
    C=1; Inc=1; % normalization
    S0=sum(Pop); H0=0; R0=0; X0=0; N=sum(Pop);
    tau=10; g=1/10; h=1/10; b=4.2*g; 

    i0=1; teps=15; 
    %t0=26; Inc=Inc*100/100;
    %t0=32; Inc=Inc*60/100;
    t0=30; Inc=Inc*40/100;
    %t0=36; Inc=Inc*20/100;
    %t0=39; Inc=Inc*10/100;

    
    
    lb=[0 1 5 5 0]; % lower bounds for the parameters

    %    [ b     i0   t0   teps   eps]
    parX=[3*g    i0   t0   teps   0.5];

    ntimes=100; par0=zeros(ntimes,5);
    for i=1:ntimes
        s=[sort(randsample(1:teps-1,teps-5,false)) teps]; 
        fun0=@(p,x) SIORX1_t0([p(1) i0 p(3)],x,g,h,S0,H0,R0,X0,C,Inc,N);
        [par0(i,:),ResNorm] = lsqcurvefit(fun0, parX, s, Ytot(s)', lb);
        beta=par0(i,1); 
        t=1:tend;
        fun1=@(p,x) SIORX1_t1([beta i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,N);
        [par0(i,:),ResNorm] = lsqcurvefit(fun1, par0(i,:), t, Ytot(t)', lb);
        semilogy(1:tend,Ytot(1:tend),'ok',t,fun1(par0(i,:),t),'k'); hold on; % pause
    end;
    hold off
     
%     ntimes=30; par0=zeros(ntimes,5);
%     for t0=27:33
%         parX(3)=t0;
%         fun0=@(p,x) SIORX1_t0([p(1) i0 p(3)],x,g,h,S0,H0,R0,X0,C,Inc,N);
%         s=1:teps; [par0(i,:),ResNorm] = lsqcurvefit(fun0, parX, s, Ytot(s)', lb);
%         beta=par0(i,1); 
%         fun1=@(p,x) SIORX1_t1([beta i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,N);
%         t=1:tend; [par0(i,:),ResNorm] = lsqcurvefit(fun1, par0(i,:), t, Ytot(t)', lb);
%         semilogy(1:tend,Ytot(1:tend),'ok',t,fun1(par0(i,:),t),'k'); hold on; % pause
%     end
     
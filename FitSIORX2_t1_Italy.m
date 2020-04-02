%function [par0 g h S0 H0 R0 C Inc N]=FitItaly();

    % contact matrix, populations, incidence of discovery
    load("2ageClasses",'contacts','Pop','Inc','Mort');

    Ytot=ReadItaly();tend=max(size(Ytot)); tend=22;

    
    C=contacts; % normalization
    S0=Pop'; H0=[0 0]; R0=[0 0]; X0=[0 0]; N=sum(Pop); 
    tau=10; g=1/10; h=1/10; b=4.2*g; 


    i0=1; teps=15; 
    %t0=25; Inc=2*Inc;
    t0=30; Inc=2*Inc*40/100;
    %t0=25; Inc=2*Inc/2;
    %t0=30; Inc=2*Inc/4;
    %t0=34; Inc=2*Inc/8;
    fun1=@(p,x) SIORX2_t1([p(1) i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,Pop);
    Fun1=@(p,x) SIORX2_t1_model([p(1) i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,Pop);
    %    [ b     i0   t0   teps   eps]
    parX=[3*g    i0   t0   teps   0.5];
    lb=[0 1 5 5 0]; % lower bounds for the parameters
    [par0,ResNorm] = lsqcurvefit(fun1, parX, 1:tend, Ytot(1:tend)', lb);
    y0=fun1(par0,1:tend); err0=norm(Ytot(1:tend)-y0);
    semilogy(1:tend,Ytot(1:tend),'o',1:tend,y0,'--'); hold on
if 3==1
    for t0=20:40         
        par1=par0; par1(3)=t0;
        [par1,ResNorm] = lsqcurvefit(fun1, par1, 1:tend, Ytot(1:tend)', lb);
        y1=fun1(par1,1:tend); err1=norm(Ytot-y1);
        if(err1<err0) par0=par1; err1=err0; end
    end
    semilogy(1:tend,y1); hold off
end

[par0(1)*max(eig(C))/g par0]

Fun2=@(p,x) SIORX2_t2_model(p,x,g,h,S0,H0,R0,X0,C,Inc,Pop);

r=0.035; 
tmax=300; T=1:tmax;

parX=par0; parX(5)=1;
YX=Fun1(parX,T); yX=r*(YX(:,5)+YX(:,6));

Y0=Fun1(par0,T); y0=r*(Y0(:,5)+Y0(:,6)); [m im]=max(y0); 

i1= (im-1)+find(y0(im:end)<m*0.7,1); teps1=T(i1);
par1=[par0 teps1 1];
Y1=Fun2(par1,T); y1=r*(Y1(:,5)+Y1(:,6)); 

i2= (im-1)+find(y0(im:end)<m*0.5,1); teps2=T(i2);
par2=[par0 teps2 1];
Y2=Fun2(par2,T); y2=r*(Y2(:,5)+Y2(:,6)); 

figure(2);
plot(T,yX,'r',T,y1,'b',T,y2,'g',T,y0,'k')

save("Italy2",'par0');

%end

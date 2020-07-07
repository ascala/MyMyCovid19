
Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "P.A. Bolzano" "P.A. Trento" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
Population=1e6*[1.315 0.5671 1.957 5.827 4.453 1.216 5.897 1.557 10.04 1.532 0.3085 0.5209 0.5382 4.376 4.048 1.648 5.027 3.737 0.886 0.1262 4.905];
nR=max(size(Region));

load("Delays",'dt','Dt'); 
load("Italy1",'par0');
i0=par0(2); t0=par0(3); teps=15;

tau=10; g=1/10; h=1/10; b=4.2*g; C=1; Inc=1; 

%%%%%%%%%%%%%%%%%%
             b=3.5*g;
%%%%%%%%%%%%%%%%%%

r=0.035; 
tmax=500; T=1:tmax;
yX=zeros(tmax,nR); y0=yX; y1=yX; y2=yX;
zX=zeros(tmax,nR); z0=zX; z1=zX; z2=zX;
wX=zeros(tmax,nR); w0=wX; w1=wX; w2=wX;
qX=zeros(tmax,nR); q0=qX; q1=qX; q2=qX;

% first calculate the "full" Italian case
for iR=1:nR
    Pop=Population(iR); N=sum(Pop);
    par0(2)=i0*Population(iR)/sum(Population);
    S0=Pop; H0=0; R0=0; X0=0;  

    Fun1=@(p,x) SIORX1_t1_model([p(1) i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,N);
    Fun2=@(p,x) SIORX1_t2_model([p(1) i0 p(3) teps p(5:end)],x,g,h,S0,H0,R0,X0,C,Inc,N);
      
    par0(3)=round(t0); % synchronous start
    parX=par0; parX(5)=1;
    YX=Fun1(parX,T); zX(:,iR)=r*YX(:,3);
    Y0=Fun1(par0,T); z0(:,iR)=r*Y0(:,3);
    
    
    par0(3)=round(t0-dt(iR)); % asynchronous start
    parX=par0; parX(5)=1;
    YX=Fun1(parX,T); yX(:,iR)=r*YX(:,3);
    Y0=Fun1(par0,T); y0(:,iR)=r*Y0(:,3);
    
end

% when to stop the lockdown
ratio=70/100;

% find global end points
tot=sum(z0,2); % synchronous start
[m im]=max(tot);
i1= (im-1)+find(tot(im:end)<m*ratio,1); teps1sync=T(i1);

tot=sum(y0,2); %asynchronous start
[m im]=max(tot);
i1= (im-1)+find(tot(im:end)<m*ratio,1); teps1async=T(i1);

[ratio,teps1sync,teps1async];

for iR=1:nR

    Pop=Population(iR); N=sum(Pop);
    par0(2)=i0*Population(iR)/sum(Population);
    S0=Pop; H0=0; R0=0; X0=0;  

    Fun1=@(p,x) SIORX1_t1_model([p(1) i0 p(3) teps p(5)],x,g,h,S0,H0,R0,X0,C,Inc,N);
    Fun2=@(p,x) SIORX1_t2_model([p(1) i0 p(3) teps p(5:end)],x,g,h,S0,H0,R0,X0,C,Inc,N);

    %%%%%%% synchronous start, synchronous end
    par0(3)=round(t0);     
    par1=[par0 teps1sync 1];
    Y1=Fun2(par1,T); z1(:,iR)=r*Y1(:,3); 
    
    %%%%%%% synchronous start, asynchronous end
    par0(3)=round(t0); 
    Y0=Fun1(par0,T); q0(:,iR)=r*Y0(:,3); [m im]=max(q0(:,iR)); 
    i1=(im-1)+find(q0(im:end,iR)<m*ratio,1); teps1=T(i1);
    par1=[par0 teps1 1];
    Y1=Fun2(par1,T); q1(:,iR)=r*Y1(:,3); 
    
    %%%%%%% asynchronous start, synchronous end
    par0(3)=round(t0-dt(iR));
    w0(:,iR)=y0(:,iR);
    par1=[par0 teps1async 1];
    Y1=Fun2(par1,T); w1(:,iR)=r*Y1(:,3); 
    
    %%%%%%% asynchronous start, asynchronous end
    par0(3)=round(t0-dt(iR)); 
    %Y0=Fun1(par0,T); y0(:,iR)=r*Y0(:,3); 
    [m im]=max(y0(:,iR)); 
    i1= (im-1)+find(y0(im:end,iR)<m*ratio,1); teps1=T(i1);
    par1=[par0 teps1 1];
    Y1=Fun2(par1,T); y1(:,iR)=r*Y1(:,3); 
    
    
    %plot(T,sum(y1(:,1:iR),2),'b',T,sum(y0(:,1:iR),2),'k');% hold on
    %plot(T,y1(:,1:iR),'b');% hold on
    %pause
end

%plot(T,sum(y1,2),'g',T,sum(w1,2),'b',T,sum(z0,2),'r',T,sum(y0,2),'k'); 
%hold off

i1=find(Region=="Lombardia"); i2=find(Region=="Lazio");
figure(1) % ASYNC start is the realistic one !!!
subplot(2,1,1); plot(T,y1(:,i1),'r',T,y1(:,i2),'k'); hold on; 
subplot(2,1,2); plot(T,w1(:,i1),'r',T,w1(:,i2),'k'); hold on;

[vy1 ty1] = max2(y0(:,i1),y1(:,i1),ratio,T);
[vy2 ty2] = max2(y0(:,i2),y1(:,i2),ratio,T);
[vw1 tw1] = max2(w0(:,i1),w1(:,i1),ratio,T);
[vw2 tw2] = max2(w0(:,i2),w1(:,i2),ratio,T);

[vy1 vy2 vw1 vw2]
[ty1 ty2 tw1 tw2]

% fid = fopen('v.txt', 'a+');
% fprintf(fid, '%d %g %g %g %g\n', ratio*100, vy1, vy2, vw1, vw2);
% fclose(fid);
% 
% fid = fopen('t.txt', 'a+');
% fprintf(fid, '%d %d %d %d %d\n', ratio*100, ty1, ty2, tw1, tw2);
% fclose(fid);


function [v t] = max2(ya,yb,ratio,T)
    [m im]=max(ya);
    i= im+find(ya(im:end)<m*ratio,1)-1;
%    [i ya(i)]
    while not( yb(i)>=yb(i-1) && yb(i)>=yb(i+1) )
        i=i+1
    end
    v=yb(i);
    t=T(i);
end
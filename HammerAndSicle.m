b=0.3437; g=0.1; h=0.1;
N=60345090; C=1; Inc=1; 
S0=N; I0=1; H0=0; R0=0; X0=0; 
t0=7; a0=0.5;

par=[b g h S0 I0 H0 R0 X0];
Y = SIORX1age_model(par,1:t0,C,Inc,N); Y0=Y(end,:);

par=[b g h Y0]; 
tmax=590; t=1:tmax; 
t1=7;
Y = SIORX1age_model(par,1:tmax,C,Inc,N); y=Y(:,3);

t1=7; t2=t1; z=y; Mz=z(t1); mz=Mz*1e-2; Z0=Y(t1,:);
a0=0.1; a1=1;
while t1+t2<tmax
    Y(1:tmax,:)  = SIORX1age_model([b g h Z0],1:tmax,a0*C,Inc,N);  y=Y(:,3);
    t2=find(y<mz,1);
    z(t1:t1+t2-1)=y(1:t2); Z0=Y(t2,:);
    a=a0; a0=a1; a1=a;
    t1=t1+t2
    Y(1:tmax,:)  = SIORX1age_model([b g h Z0],1:tmax,a0*C,Inc,N);  y=Y(:,3);
    t2=find(y>0.9*Mz,1);
    z(t1:t1+t2-1)=y(1:t2); Z0=Y(t2,:);
    a=a0; a0=a1; a1=a;
    t1=t1+t2
    plot(z)
end
pause
semilogy( 1:max(size(z)),z);


% model parameters
load("Italy1",'par0');

%Ytot=ReadItaly(); 

% contact matrix, populations, incidence of discovery
load("2ageClasses",'contacts','Pop','Inc','Mort');

C=contacts; % normalization
S0=Pop; H0=[0 0]; R0=[0 0]; X0=[0 0]; N=sum(Pop);
tau=10; g=1/10; h=1/10; b=4.2*g; 

% useful functions
Fun1=@(p,x) SIORX_local1_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);
Fun2=@(p,x) SIORX_local2_model(p,x,g,h,S0,H0,R0,X0,C,Inc,N);



r=0.035; 
tmax=500; T=1:tmax;

parX=par0; parX(5)=1;
YX=Fun1(parX,T); yX=r*(YX(:,5)+YX(:,6)); [mX iX]=max(yX); tX=T(iX); 

ftm=zeros(99,3); 
for i=99:-1:30
    parq=par0; parq(5)=i/100;  %[ b  i0  t0  teps  eps ]
    Yq=Fun1(parq,T); yq=r*(Yq(:,5)+Yq(:,6)); [mq iq]=max(yq); tq=T(iq); 
    tq=max(tq,tX);
    ftm(i,:)=[(100-i)/100 tq mq]; 
    plot(T,yX,T,yq); pause(0.001);
end
plot(ftm(40:end,2)/tX,ftm(40:end,3)/mX,'o');

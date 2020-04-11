n=5; eps=10^-3;
C=eye(n) + eps*(diag(-log(rand(n-1,1)),-1)+diag(-log(rand(n-1,1)),1));

N=1e5*(0.1*ones(1,n)+0.9*rand(1,n));
R0=zeros(1,n); I0=R0; I0(1)=1; S0=N-I0-R0;


b=0.2; g=0.1; tmax=40; t=1:200;

Y = SIR_matrix_model(b,g,S0,I0,R0,t,C,N);
%plot(Y(:,n+1:2*n)./N)
%plot(Y(:,1:n)./N)
%plot(Y(:,2*n+1:3*n)./N)

for i=1:n 
    t0=find(Y(:,2*n+i)>1e1,1);
    plot(Y(t0:end,2*n+i)); hold on
    z = SIR_model(b,g,Y(t0,i),Y(t0,n+i),Y(t0,2*n+i),t(t0:end),N(i));
    plot(z(:,3),'o'); hold off
    pause
    hold off
end
    
    
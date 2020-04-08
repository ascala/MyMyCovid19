Tpre=readtable("Mobility_Adj_pre_LockDown.csv");
Tpost=readtable("Mobility_Adj_post_LockDown.csv");

C=( table2array(Tpre(:,2:21)) + table2array(Tpost(:,2:21)) )/2;
C=(C+C')/2;
C=C./sum(C); n=max(max(size(C)));

N=1e6*ones(n,1);
I0=zeros(n,1); I0(1)=1;
R0=zeros(n,1);
S0=N-I0-R0;
 
g=1/10; b=3.5*g;

t=1:100;
Y=SIR_ntwk_model(b,g,S0,I0,R0,t,C,N);

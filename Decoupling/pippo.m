Tpre=readtable("Mobility_Adj_pre_LockDown.csv");
Tpost=readtable("Mobility_Adj_post_LockDown.csv");

Cpre=table2array(Tpre(:,2:21));
Cpost=table2array(Tpost(:,2:21));
C=(Cpre+Cpost);
%C=(Cpre./sum(Cpre)+Cpost./sum(Cpost));
%C=(C+C')/2;
C=C./sum(C); n=max(max(size(C)));

Riordina; C=5*C(r2,r2);

Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "Trentino Alto Adige" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
Population=1e6*[1.315 0.5671 1.957 5.827 4.453 1.216 5.897 1.557 10.04 1.532 0.3085 0.5209+0.5382 4.376 4.048 1.648 5.027 3.737 0.886 0.1262 4.905];


I0=zeros(1,n); I0(find(Region=="Lombardia"))=1;
R0=zeros(1,n);
S0=Population-I0-R0;
 
g=1/10; b=3.5*g;

t=1:0.1:500;
Y=SIR_matrix_model(b,g,S0,I0,R0,t,C,Population);
%plot(Y(:,1:n)./Population)
plot(Y(:,n+1:2*n)./Population)
%semilogy(Y(:,2*n+1:3*n)./Population)

for i=1:20
    [mR iR]=max(Y(:,n+i))
    imR(i)=iR;
    tmR(i)=t(iR);
end
[s,sMob]=sort(imR');

load("../Delays",'dt');
dt=[dt(1:11); sum(dt(11:12))/2 ;dt(14:21)];
[s,sDel]=sort(dt);

[Region(sMob)' Region(sDel)']
plot(tmR-min(tmR),dt,'o')

for i=1:20
    fprintf("%s & %s \\\\\n",Region(sMob(i)), Region(sDel(i)))
%    fprintf("%s & %3.2f %s  %3.2f \\\\\n", Region(sMob(i)), (tmR(sMob(i))-min(tmR))/(max(tmR)-min(tmR)), Region(sDel(i)), dt(sDel(i))/max(dt) )            
end



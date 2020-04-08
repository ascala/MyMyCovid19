TC=readtable("ContactsItaly.csv"); 
C=table2array(TC); C=C/max(max(C));

Tpre=readtable("Mobility_Adj_pre_LockDown.csv");
Apre=table2array(Tpre(:,2:21)); Apre=Apre/max(max(Apre));

figure(1)
subplot(1,2,1); imagesc(log(C)); % colorbar
subplot(1,2,2); imagesc(log(Apre)); %colorbar


figure(2)
mobReg=["Friuli" "Emilia" "Marche" "Abruzzo" "Sicilia" "Toscana" "Lazio" "Lombardia" "Campania" "Molise" "Puglia" "Basilicata" "Trentino" "Calabria" "Veneto" "Piemonte" "Val d'Aosta" "Liguria" "Sardegna"	"Umbria"];
%x=sum(Apre-diag(diag(Apre)));
x=sum(Apre);
[t s]=sort(x,'descend'); s=1:20;
imagesc(log(Apre(s,s)))
set(gca,'ytick',1:20,'yticklabel',mobReg(s))
set(gca,'xtick',1:20,'xticklabel',mobReg(s),'xaxisLocation','top'); xtickangle(-90)



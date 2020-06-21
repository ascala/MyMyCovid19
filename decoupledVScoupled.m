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
[t s]=sort(x,'descend'); 
s=1:20;
imagesc(log(Apre(s,s)))
set(gca,'ytick',1:20,'yticklabel',mobReg(s))
set(gca,'xtick',1:20,'xticklabel',mobReg(s),'xaxisLocation','top'); xtickangle(-90)

figure(3)
ageCoh=["00-04","05-09","10-14","15-19","20-24","25-29","30-34","35-39","40-44","45-49","50-54","55-59","60-64","65-69","70+"];
imagesc(log(C)); % colorbar
c=1:15;
set(gca,'ytick',c,'yticklabel',ageCoh(c))
set(gca,'xtick',c,'xticklabel',ageCoh(c),'xaxisLocation','top'); xtickangle(-90)


Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "P.A. Bolzano" "P.A. Trento" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
Population=1e6*[1.315 0.5671 1.957 5.827 4.453 1.216 5.897 1.557 10.04 1.532 0.3085 0.5209 0.5382 4.376 4.048 1.648 5.027 3.737 0.886 0.1262 4.905];
nR=max(size(Region));
DataDir="Italy/";

rho=Population/sum(Population);
load("Delays",'dt','Dt');

% read regional data
iR=1;
nameR=DataDir+Region(iR)+".csv";
TR=readtable(nameR); nDay=max(size(TR.data)); t=1:nDay;
Yin=zeros(nR,nDay); Yin(iR,:)=TR.ricoverati_con_sintomi; 
Yout=zeros(nR,nDay); Yout(iR,:)=TR.dimessi_guariti; 
Ydead=zeros(nR,nDay); Ydead(iR,:)=TR.deceduti; 
Ytot=zeros(nR,nDay); Ytot(iR,:)=TR.totale_casi;
Yhos=zeros(nR,nDay); Yhos(iR,:)=TR.totale_ospedalizzati;
            y=Yin(iR,:)-Yout(iR,:)-Ydead(iR,:); 
%            subplot(1,2,1); semilogy(t,y,'-',[1 nDay],[0 0]); hold on
%            subplot(1,2,2); semilogy(t-dt(iR),y/rho(iR),'o',[1 nDay],[0 0]); 
            plot(t,y); 
            title(Region(iR)); %hold on;
for iR=2:nR
    nameR=DataDir+Region(iR)+".csv"; nameR
    TR=readtable(nameR); Y(iR,:)=TR.totale_casi;
    Yin(iR,:)=TR.ricoverati_con_sintomi; 
    Yout(iR,:)=TR.dimessi_guariti;
    Ydead(iR,:)=TR.deceduti; 
    Ytot(iR,:)=TR.totale_casi;
    Yhos(iR,:)=TR.totale_ospedalizzati;

            y=Yin(iR,:)-Yout(iR,:)-Ydead(iR,:);
            plot(t,y); 
%            subplot(1,2,1); semilogy(t,y,'-',[1 nDay],[0 0]); hold on
%            subplot(1,2,2); semilogy(t-dt(iR),y/rho(iR),'o',[1 nDay],[0 0]); 
            title(Region(iR)); %hold on;
            pause
end
hold off
YIn=sum(Yin); YOut=sum(Yout); YDead=sum(Ydead);
%plot(t,YIn-YOut-YDead,'o')
YTot=sum(Ytot); YHos=sum(Yhos);
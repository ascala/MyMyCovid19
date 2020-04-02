function [Ytot Y] = ReadItaly()
Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "P.A. Bolzano" "P.A. Trento" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
Population=1e6*[1.315 0.5671 1.957 5.827 4.453 1.216 5.897 1.557 10.04 1.532 0.3085 0.5209 0.5382 4.376 4.048 1.648 5.027 3.737 0.886 0.1262 4.905];
nR=max(size(Region));
DataDir="Italy/";

    % read regional data
    iR=1;
    nameR=DataDir+Region(iR)+".csv";
    TR=readtable(nameR); nDay=max(size(TR.stato));
    Y=zeros(nR,nDay); t=1:nDay; Y(iR,:)=TR.totale_casi; 
    %fprintf("%s\n",Region(iR)); 
    idx=find(Y(iR,:)>0); y=Y(iR,idx); T=t(idx);
    for iR=2:nR
        nameR=DataDir+Region(iR)+".csv";
        TR=readtable(nameR);Y(iR,:)=TR.totale_casi; 
        idx=find(Y(iR,:)>0); y=Y(iR,idx); T=t(idx);
    end
    Ytot=sum(Y);

end

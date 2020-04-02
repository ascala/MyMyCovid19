function [Ytot Pop]= ReadRegion(iR)
Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "P.A. Bolzano" "P.A. Trento" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
nR=max(size(Region));
DataDir="Italy/";

    % read regional data
    nameR=DataDir+Region(iR)+".csv";
    TR=readtable(nameR);
    Ytot=TR.totale_casi; 
    %fprintf("%s\n",Region(iR)); 
    
    TP=readtable("Population.csv"); 

    %Region(iR)
    %TP(1,iR+1) % first column are fasce, so iR+1
    PopR=table2array(TP(:,iR+1));
    Pop=[sum(PopR(1:7)) sum(PopR(8:10))];


end

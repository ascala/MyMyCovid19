Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "P.A. Bolzano" "P.A. Trento" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
Population=1e6*[1.315 0.5671 1.957 5.827 4.453 1.216 5.897 1.557 10.04 1.532 0.3085 0.5209 0.5382 4.376 4.048 1.648 5.027 3.737 0.886 0.1262 4.905];
nR=max(size(Region));
DataDir="Italy/";

% read regional data
iR=1;
nameR=DataDir+Region(iR)+".csv";
TR=readtable(nameR); nDay=max(size(TR.stato));
Y=zeros(nR,nDay); t=1:nDay; Y(iR,:)=TR.totale_casi; 
for iR=2:nR
    nameR=DataDir+Region(iR)+".csv";
    TR=readtable(nameR);Y(iR,:)=TR.totale_casi; 
end

i1=find(Region=="Lombardia"); Y1=Y(i1,:); y1=Y1/Population(i1);
Dt=zeros(nR,1); dt=Dt; N=100;
for iR=1:nR 
    Y2=Y(iR,:); y2=Y2/Population(iR);
    
    subplot(1,3,1);
    semilogy(t,Y2); 
%    plot(t,y2); 
    title(Region(iR)); hold on
    
    [vq t1q t2q] = MySample(Y1,t,Y2,t,N);
    Dt(iR)=mean(t2q-t1q);
    subplot(1,3,2);
    semilogy(t-Dt(iR),y2,'o'); 
    title("Delayed"); hold on
    
    [vq t1q t2q] = MySample(y1,t,y2,t,N);
    dt(iR)=mean(t2q-t1q);
    subplot(1,3,3);
    semilogy(t-dt(iR),y2,'o'); 
    title("Normalized"); hold on
    
    %pause
end
subplot(1,3,1); title("All");
hold off

save("Delays",'dt','Dt');

% [s idx]=sort(Dt);
% fprintf("%20s , %s\n","REGION","DELAY")
% for i = 1:nR
%     iR=idx(i);
%     if isnan(dt(iR))
%         fprintf("%22s , NAN\n",Region(iR))
%     else
%         fprintf("%22s , %i\n",Region(iR),int8(Dt(iR)))
%     end
% end
% fprintf("\n\n")
% 
% 
% 
% [s idx]=sort(dmax);
% fprintf("%20s , %s\n","REGION","DELAY")
% for i = 1:nR
%     iR=idx(i);
%     if isnan(dmax(iR))
%         fprintf("%22s , NAN\n",Region(iR))
%     else
%         fprintf("%22s , %i\n",Region(iR),int8(dmax(iR)))
%     end
% end
% fprintf("\n\n")

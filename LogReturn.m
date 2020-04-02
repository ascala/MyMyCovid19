
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

    k=1;
    b=zeros(nR,nDay);b1=zeros(nR,k*nDay);
    for iR=1:nR
        %fprintf("%s\n",Region(iR)); 
        idx=find(Y(iR,:)>0); y=Y(iR,idx); T=t(idx); nT=max(size(T));
        z=diff(y)./y(1:(nT-1));
        %semilogy( 3:(k*nDay-1), w, T(1:nT-1), z, 'o' ); 
        %title(Region(iR)); 
        %pause; 
        b(iR,T(1:nT-1))=z;
    end

    bmean=zeros(nDay,1); bmed=bmean;
    for d=1:nDay
        idx=find(b(:,d)>0);
        if ~isempty(idx)
            bmed(d)=median(b(idx,d));
            bmean(d)=mean(b(idx,d));
        end
    end
    b1mean=zeros(k*nDay,1); b1med=b1mean;
    for d=1:k*nDay
        b1med(d)=median(b1(:,d));
        b1mean(d)=mean(b1(:,d));
    end
    Ytot=sum(Y); Z=diff(Ytot)./Ytot(1:nDay-1); 

    Amed =  0.7373;  % (  0.6077,  0.8669)
    Bmed = -0.06186; % (-0.07893, -0.0448)
    ymed=Amed*exp(Bmed*(1:nDay)');

    Amean =  1.606;  %( 1.037,   2.174)
    Bmean = -0.1003; %(-0.1492, -0.05138)
    ymean=Amean*exp(Bmean*(1:nDay)');

    [cmean,tmean]=min(abs(ymean-b1mean));
    i=find(bmean>0); bmean=bmean(i); i1=find(b1mean>0); b1mean=b1mean(i1);
    semilogy(i,bmean,'o',1:nDay,ymean,'--',i1,b1mean,tmean,b1mean(tmean),'xk')
    hold on
    [cmed,tmed]=min(abs(ymed-b1med));
    j=find(bmed>0); bmed=bmed(i); j1=find(b1med>0); b1med=b1med(i1);
    semilogy(j,bmed,'o',1:nDay,ymed,'--',j1,b1med,tmed,b1med(tmed),'xk')
    hold off
    


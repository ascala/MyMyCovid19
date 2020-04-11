RegionMobility=["Friuli Venezia Giulia" "Emilia Romagna" "Marche" "Abruzzo" "Sicilia" "Toscana" "Lazio" "Lombardia" "Campania" "Molise" "Puglia" "Basilicata" "Trentino Alto Adige"	"Calabria" "Veneto" "Piemonte" "Valle d'Aosta" "Liguria" "Sardegna"	"Umbria"];

Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "Trentino Alto Adige" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];

for i=1:20
    r1(i)=find(Region==RegionMobility(i));
    r2(i)=find(RegionMobility==Region(i));
end

echo Fasce > Fasce.csv
tail -11 Abruzzo.txt | awk '{print $1}' >> Fasce.csv

for region in Abruzzo Basilicata Calabria Campania Emilia\ Romagna Friuli\ Venezia\ Giulia Lazio Liguria Lombardia Marche Molise P.A.\ Bolzano P.A.\ Trento Piemonte Puglia Sardegna Sicilia Toscana Umbria Valle\ d\'Aosta Veneto; do

	sed -i 's/Non noto/Ignoto/g' "$region.txt"
 	
	echo \"$region\" > "$region.csv" 
	tail -11 "$region.txt" | awk '{print $2}' >> "$region.csv" 

done


paste Fasce.csv Abruzzo.csv Basilicata.csv Calabria.csv Campania.csv Emilia\ Romagna.csv Friuli\ Venezia\ Giulia.csv Lazio.csv Liguria.csv Lombardia.csv Marche.csv Molise.csv P.A.\ Bolzano.csv P.A.\ Trento.csv Piemonte.csv Puglia.csv Sardegna.csv Sicilia.csv Toscana.csv Umbria.csv Valle\ d\'Aosta.csv Veneto.csv > IncidenzaRegioni.csv

mv Fasce.csv Abruzzo.csv Basilicata.csv Calabria.csv Campania.csv Emilia\ Romagna.csv Friuli\ Venezia\ Giulia.csv Lazio.csv Liguria.csv Lombardia.csv Marche.csv Molise.csv P.A.\ Bolzano.csv P.A.\ Trento.csv Piemonte.csv Puglia.csv Sardegna.csv Sicilia.csv Toscana.csv Umbria.csv Valle\ d\'Aosta.csv Veneto.csv SAFE/

mv Abruzzo.txt Basilicata.txt Calabria.txt Campania.txt Emilia\ Romagna.txt Friuli\ Venezia\ Giulia.txt Lazio.txt Liguria.txt Lombardia.txt Marche.txt Molise.txt P.A.\ Bolzano.txt P.A.\ Trento.txt Piemonte.txt Puglia.txt Sardegna.txt Sicilia.txt Toscana.txt Umbria.txt Valle\ d\'Aosta.txt Veneto.txt SAFE/

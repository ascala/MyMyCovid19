% Fasce contatti:    ["00-04" "05-09" "10-14" "15-19" "20-24" "25-29" "30-34" "35-39" "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70+"];
% Fasce popolazione: ["0-9" "10-19" "20-29" "30-39" "40-49" "50-59" "60-69" "70-79" "80-89" "90+"]
% Fasce ISS:         ["0-9" "10-19" "20-29" "30-39" "40-49" "50-59" "60-69" "70-79" "80-89" "90+" "ignota"]
TC=readtable("Contacts.csv");
TI=readtable("Incidenza26mar.csv");
TIR=readtable("IncidenzaRegioni26mar.csv");
TP=readtable("Population.csv"); 

% trasforma fasce ISS in incidenza di casi "gravi" per fasce di età
Casi=TI.Casi(1:10); % casi osservati levando quelli ignoti
Pop=TP.Italia; % popolazione per stesse fasce di età
inc=Casi./Pop; % assuming uniform number of infects in all fasce
inc=inc/sum(inc); % normalizzazione
% put in Fasce '00-69' '70+'
inc=[sum(inc(1:7)); sum(inc(8:10))];

C=table2array(TC); % contacts: are aggregated by 5 years fasce up to 70+
% rows/columns   1:14  15
% correspond to 00-69  70+
D=diag(diag(C)); Cgood=C-D/2; % avoid counting twice self contacts 
Cgood=(Cgood+Cgood')/2; % simmetrize !!!
contacts=[  sum(sum(Cgood(1:14,1:14))) sum(sum(Cgood(1:14,15))) 
            sum(sum(Cgood(15,1:14))) sum(sum(Cgood(15,15)))];
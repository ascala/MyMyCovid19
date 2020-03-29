% Fasce contatti:    ["00-04" "05-09" "10-14" "15-19" "20-24" "25-29" "30-34" "35-39" "40-44" "45-49" "50-54" "55-59" "60-64" "65-69" "70+"];
% Fasce popolazione: ["0-9" "10-19" "20-29" "30-39" "40-49" "50-59" "60-69" "70-79" "80-89" "90+"]
% Fasce ISS:         ["0-9" "10-19" "20-29" "30-39" "40-49" "50-59" "60-69" "70-79" "80-89" "90+" "ignota"]
TC=readtable("ContactsItaly.csv");
%TC=readtable("ContactsGermany.csv");
TI=readtable("Incidenza26mar.csv");
TIR=readtable("IncidenzaRegioni26mar.csv");
TP=readtable("Population.csv"); 

% trasforma fasce ISS in incidenza di casi "gravi" per fasce di età
Casi=TI.Casi(1:10); % casi osservati levando quelli ignoti
Pop=TP.Italia; % popolazione per stesse fasce di età
inc=Casi./Pop; % assuming uniform number of infects in all fasce
inc=inc/sum(inc); % normalizzazione
% put in Fasce '0-69' '70+'
inc=[sum(inc(1:7)); sum(inc(8:10))];

C=table2array(TC); % contacts: are aggregated by 5 years fasce up to 70+
% rows/columns   1:2    3:4    5:6    7:8    9:10  11:12  13:14  15
% correspond to 00-09  10-19  20-29  30-39  40-49  50-59  60-69  70+
%                 1      2      3      4      5      6      7     8
Cc=zeros(15,8);
for i=1:15
    for j=1:7
        Cc(i,j)=(C(i,2*j-1)+C(i,2*j))/2;
    end
    Cc(i,8)=C(i,15);
end
c=zeros(8,8);
for i=1:7
    for j=1:8
        c(i,j)=(Cc(2*i-1,j)+Cc(2*i,j))/2; 
    end
end
i=8;
for j=1:8
        c(8,j)=Cc(15,j); 
end
% c are the contacts in 8 classes: 00-09  10-19  20-29  30-39  40-49  50-59 60-69  70+
% Now want to project c in two classes: 00-69 and 70+
Pop1=sum(Pop(1:7)); pop1=Pop(1:7)/Pop1;% up to 70
Pop2=sum(Pop(8:10)); pop2=1; % 70 and more
contacts=zeros(2,2);
contacts(1,1)=pop1'*c(1:7,1:7)*pop1;
contacts(1,2)=pop1'*c(1:7,8)*pop2;
contacts(2,1)=pop2'*c(8,1:7)*pop1;
contacts(2,2)=pop2'*c(8,8)*pop2;

C=contacts;
I0 = [Pop1/1e7;0]; S0=[Pop1;Pop2]-I0; R0 = [0;0];  N=Pop1+Pop2;
eps12=1e-1; eps22=1e-1; damp=[1 eps12; eps12 eps22]; C1=damp.*C; 
tau=10; g=1/10; h=1/10; b=12*g; t=0:0.1:10*tau;
Y=SIRage_model([b g S0' I0' R0'],t,C1,N);
plot(t,Y(:,3)/Pop1,'b',t,Y(:,4)/Pop2,'r'); hold on
plot(t,(Y(:,3:4)'.*(inc./[Pop1; Pop2]))'); hold off
[m i1]=max(Y(:,3)); [m i2]=max(Y(:,4));
[t(i1) t(i2)]




Region=["Abruzzo" "Basilicata" "Calabria" "Campania" "Emilia Romagna" "Friuli Venezia Giulia" "Lazio" "Liguria" "Lombardia" "Marche" "Molise" "P.A. Bolzano" "P.A. Trento" "Piemonte" "Puglia" "Sardegna" "Sicilia" "Toscana" "Umbria" "Valle d'Aosta" "Veneto"];
Population=1e6*[1.315 0.5671 1.957 5.827 4.453 1.216 5.897 1.557 10.04 1.532 0.3085 0.5209 0.5382 4.376 4.048 1.648 5.027 3.737 0.886 0.1262 4.905];
nR=max(size(Region));

load("Delays",'dt','Dt'); 
load("Italy1",'par0');
i0=par0(2); t0=par0(3); teps=15;

tau=10; g=1/10; h=1/10; b=4.2*g; C=1; Inc=1; 

r=0.035; 
tmax=300; T=1:tmax;
Iregion=zeros(tmax,nR); Sregion=Iregion; Rregion=Iregion;
teps=15;
alpha_lock=0.5;
for iR=1:nR

    Pop=Population(iR); N=sum(Pop);
    par0(2)=i0*Population(iR)/sum(Population);
    S0=Pop; H0=0; R0=0; X0=0;  

    par0(3)=round(t0-dt(iR)); % asynchronous start
    Y0=SIORX1age_model([b g h S0 i0 H0 R0 X0],1:round(t0+dt(iR)), C, Inc, Pop);
    Y0=SIORX1age_model([b g h Y0(end,:)],T, alpha_lock*C, Inc, Pop);
    Sregion(:,iR)=Y0(:,1)/N;
    Iregion(:,iR)=Y0(:,2)/N;
    Rregion(:,iR)=Y0(:,4)/N;
end

dI=diff(Iregion)./Iregion(1:end-1,:);
dR=diff(Rregion)./Rregion(1:end-1,:);
dS=-diff(Sregion)./Rregion(1:end-1,:);
%dR=diff(Rregion);
plot(Iregion(2:end,:),dS,'--', 'Color', 0.7*[1 1 1]); hold on

x=mean(Iregion(31,:)); y=mean(dS(31,:));
xM=max(Iregion(31,:)); yM=max(dS(31,:));
plot([0 1.1*xM],[y y],'b',[x x],[0 1.1*yM],'b'); hold on

bad=find(b*Sregion(31,:)-g>0); good=find(b*Sregion(31,:)-g<=0);
p=plot(Iregion(31,bad),dS(31,bad),'^r',...
    Iregion(31,good),dS(31,good),'vg'); 
hold on
legend([p(1) p(2)],'Bad','Good')
axis([0 1.1*max(Iregion(31,:)) 0 1.1*max(dS(31,:))])

%legend([Region "Bad" "Good" ""]);

% pause
% %hold on
% for i=1:30:tmax-1
%     semilogy(Iregion(i+1,:),dR(i,:),'o'); hold on
%     x=mean(Iregion(i+1,:)); y=mean(dR(i,:));
%     plot(x,y,'x'); hold off
%     pause
% end
% 


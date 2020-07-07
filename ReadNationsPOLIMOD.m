Nation=["Belgium" "Germany" "Italy" "Poland" "Finland"  "GreatBritain" "Luxenbourg"];
nN=7;
Ndir="Contacts/";


for iN=1:nN
    TN=readtable(Ndir+Nation(iN)+".csv");
    C=table2array(TN);
    fprintf("%s %4.2g\n",Nation(iN),max(eig(C)));
end
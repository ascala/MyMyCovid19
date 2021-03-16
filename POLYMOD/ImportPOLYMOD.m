%%%%%%%%%%%
% Element (i,j) of a contact matrix are proportional to the probability 
% that an individual of class i infects an individual of class j.
% The relative error for matrix elements is around 7% (see variable Drel)

% 15 age classes
AgeClasses=["00-04"; "05-09"; "10-14"; "15-19"; "20-24"; "25-29"; "30-34"; "35-39"; "45-49"; "50-54"; "55-59"; "60-64"; "65-69"; "70+"];

% read some of the 15x15 contact matrices
DE=csvread('Germany.csv');
GB=csvread('GreatBritain.csv');
IT=csvread('Italy.csv');


%% EVALUATE AN UPPER BOUND TO THE ERROR ON THE MATRICES

CountriesData=csvread('Countries.csv');

RC=CountriesData(3:end,4); % Relative Contacts (exclude BE that is the reference)
RClb=CountriesData(3:end,5); % lower bounds
RCub=CountriesData(3:end,6); % and upper bounds of the 95% confidence interval

% this is the relative error for the elements of the contact matrices
Drel=0.5*mean((RC-RClb)./RC)+0.5*mean((RCub-RC)./RC);


% 7 contact classes 
CClasses=["Home";"Multiple";"Work";"School";"Leisure";"Transport";"Other"];
% 8 countries + "ALL"
Country=["BE";"DE";"FI";"GB";"IT";"LU";"NL";"PL";"ALL"];
% read the contact classes distribution 
HistoCClasses=csvread('ContactClasses.csv');

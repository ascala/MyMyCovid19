#SIR model without demography – practical 1
#function for system of ODEs - see lsoda help for details
SIR.mod <- function(t,var,par) {
  #Rename variables and parameters
  S<- var[1]
  I<- var[2]
  R<- var[3]
  N<- S+I+R
  beta<- par[1]
  gamma<-par[2]
  #The model equations
  dS<- - beta*S*I
  dI <- beta*S*I-gamma*I
  dR<- gamma*I
  #return the three derivatives in a list
  list(c(dS,dI,dR))            }
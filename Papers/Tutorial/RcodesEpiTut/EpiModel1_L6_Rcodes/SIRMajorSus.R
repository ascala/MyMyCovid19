#SIR model assuming difference in susceptibility only
SIRmajorSUS.mod <- function(t,var,par) {
  #Rename variables and parameters
  Sr <- var[1]
  Ss <- var[2]
  Ir <- var[3]
  Is <- var[4]
  R  <- var[5]
  beta <- par[1]
  gamma <- par[2]
  epsR <- par[3]
  #The model equations
  dSr <- -epsR*beta*Sr*(Ir+Is);
  dSs <- -beta*Ss*(Ir+Is);
  dIr <- epsR*beta*Sr*(Ir+Is) - gamma*Ir;
  dIs <- beta*Ss*(Ir+Is) - gamma*Is;
  dR  <- gamma*(Ir+Is);
  #return the three derivatives in a list
  list(c(dSr, dSs, dIr, dIs, dR))}
#SIR model assuming difference in susceptibility AND infectivity
SIRmajorSusInf.mod <- function(t,var,par) {
  #Rename variables and parameters
  Sr <- var[1]
  Ss <- var[2]
  Ir <- var[3]
  Is <- var[4]
  R  <- var[5]
  beta0 <- par[1]
  gamma <- par[2]
  epsR <- par[3]
  epsI <- par[4]
  betaSS <- beta0;
  betaSR <- epsI*beta0;
  betaRS <- epsR*beta0;
  betaRR <- epsR*epsI*beta0;
  beta<- matrix(c(betaSS, betaSR, betaRS, betaRR),nr=2,byrow=T)
  #The model equations
  dSr <- -betaRR*Sr*Ir - betaRS*Sr*Is;
  dSs <- -betaSR*Ss*Ir - betaSS*Ss*Is;
  dIr <- betaRR*Sr*Ir + betaRS*Sr*Is - gamma*Ir;
  dIs <- betaSR*Ss*Ir + betaSS*Ss*Is - gamma*Is;
  dR  <- gamma*(Ir+Is);
  #return the three derivatives in a list
  list(c(dSr, dSs, dIr, dIs, dR))}
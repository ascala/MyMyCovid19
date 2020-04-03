#******************************************************************************#
#                             Epidemic Models Practical 1:                     #
#        Deterministic compartmental models in homogeneous populations         #
#        Section 2: SIR model with demography                                  #
#******************************************************************************#
#myfolder<-"M:\\Lectures\\Summer Course Iowa\\Andrea's praticals\\practical 1"
#myfolder<-"M:\\Course material\\MathematicalModellingCourseUNE\\Tutorials\\EpiModel1_Rcodes"
#setwd(myfolder)
library(deSolve)
#------------------------------------------------------------------------------#
#                                      2.2                                     #
#------------------------------------------------------------------------------#
#SIR model with  demography – practical 2
#function for system of ODEs - see lsoda help for details
SIRwithDemo.mod <- function(t,var,par) {
  #Rename variables and parameters
  S<- var[1]
  I<- var[2]
  R<- var[3]
  N<- S+I+R
  beta<- par[1]
  gamma<-par[2]
  mu<-par[3]
  #The model equations
  dS<-mu - beta*S*I  - mu*S
  dI <- beta*S*I-gamma*I - mu*I
  dR<- gamma*I - mu*R
  #return the three derivatives in a list
  list(c(dS,dI,dR))            }


beta <- 1.66
gamma <- 1 / 2
mu <- 10/365 
SIR.par <- c(beta,gamma, mu)
SIR.init <- c(0.5, 0.001, 1-0.5-0.001)
SIR.t <- seq(0,100, by =0.1)



SIRwithDemo.sol <- as.data.frame(lsoda(SIR.init, SIR.t, SIRwithDemo.mod, SIR.par))
names(SIRwithDemo.sol)[2:4]<-c("S","I","R")
SIRwithDemo.sol$N<-apply(SIRwithDemo.sol[,2:4],1,sum)
par(mfrow=c(1,1))
ylabel<-"Proportion of S, I and R" ; xlabel<-"Time (days)"
ttl<-"SIR model with demography"
with(SIRwithDemo.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
  ,ylim=c(0,1))
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })
legend(85,0.9,c("Susceptible (S)","Infected (I)","Recovered (I)"),
               col=c("green","red","black"),lty=1,lwd=2)







#******************************************************************************#
#                             Epidemic Models Practical 1:                     #
#        Deterministic compartmental models in homogeneous populations         #
#        Optional Section : SIRS and SEIR model                                #
#******************************************************************************#
myfolder<-"M:\\Lectures\\Summer Course UNE\\Andrea's praticals\\practical 1"
setwd(myfolder)
library(deSolve)
#------------------------------------------------------------------------------#
#                     3a - the SIRS model                                      #
#------------------------------------------------------------------------------#
#function for system of ODEs - see lsoda help for details
SIRSDemo.mod <- function(t,var,par) {
  #Rename variables and parameters
  S<- var[1]
  I<- var[2]
  R<- var[3]
  N<- S+I+R
  beta<- par[1]
  gamma<-par[2]
  mu<-par[3]
  w<-par[4]
  #The model equations
  dS <- mu +w*R -beta*S*I - mu*S;
  dI <- beta*S*I - gamma*I - mu*I;
  dR <- gamma*I - w*R- mu*R;
  #return the three derivatives in a list
  list(c(dS,dI,dR))            }


beta <- 1.66
gamma <- 1 / 2
mu <- 10/365 
w1<- 1/14
w2<- 1/90
w3<- 1/365
SIRS.par1 <- c(beta,gamma, mu,w1) ; SIRS.par2 <- c(beta,gamma, mu,w2)
SIRS.par3 <- c(beta,gamma, mu,w3)    
SIRS.init <- c(0.5, 0.001, 1-0.5-0.001)
SIRS.t <- seq(0,100, by =0.1)

SIRSDemo1.sol <- as.data.frame(lsoda(SIRS.init, SIRS.t, SIRSDemo.mod , SIRS.par1))
SIRSDemo2.sol <- as.data.frame(lsoda(SIRS.init, SIRS.t, SIRSDemo.mod , SIRS.par2))
SIRSDemo3.sol <- as.data.frame(lsoda(SIRS.init, SIRS.t, SIRSDemo.mod , SIRS.par3))
names(SIRSDemo1.sol)[2:4]<-c("S","I","R") 
names(SIRSDemo2.sol)[2:4]<-c("S","I","R")  
names(SIRSDemo3.sol)[2:4]<-c("S","I","R")  


#SIRS with immunity period 14 days
par(mfrow=c(1,1))
ylabel<-"Proportion of S, I and R" ; xlabel<-"Time (days)"
ttl<-"SIRS models with different immunity periods (1/w) \n 14 days (solid line), 3 months (--), 1 year (..)"
   
with(SIRSDemo1.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
  ,ylim=c(0,0.9))
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })
#SIRS with immunity period 3 months
 
with(SIRSDemo2.sol,
  {lines(time,S,type="l",col="green", lty=2, lwd=2)
   lines(time,I,col="red",lwd=2, lty=2) ; lines(time,R,lwd=2,lty=2)  
  })  
  
#SIRS with immunity period 3 months
with(SIRSDemo3.sol,
  {lines(time,S,type="l",col="green", lty=3, lwd=2)
   lines(time,I,col="red",lwd=2, lty=3) ; lines(time,R,lwd=2,lty=3)  
  })    
  
legend(85,0.85,c("Susceptible (S)","Infected (I)","Recovered (I)"),
               col=c("green","red","black"),lty=1,lwd=2)


#------------------------------------------------------------------------------#
#                     3a - the SEIR model                                      #
#------------------------------------------------------------------------------#
SEIRDemo.mod <- function(t,var,par) {
  #Rename variables and parameters
  S<- var[1]
  E<- var[2]
  I<- var[3]
  beta<- par[1]
  gamma<-par[2]
  mu<-par[3]
  sigma<-par[4]
  #The model equations
  dS = mu - beta*S*I - mu*S;
  dE = beta*S*I - sigma*E - mu*E;
  dI = sigma*E - gamma*I - mu*I;

  #return the three derivatives in a list
  list(c(dS,dE,dI))            }



beta <- 1.66
gamma <- 1 / 2
mu <- 10/365 
sigma = 1/1;
SEIR.par <- c(beta, gamma, mu, sigma)
SEIR.init <- c(0.5, 0.001, 0.001)
SEIR.t <- seq(0,200, by =0.1)

SIR.par <- c(beta,gamma, mu)
SEIRDemo.sol <- as.data.frame(lsoda(SEIR.init, SEIR.t, SEIRDemo.mod , SEIR.par))
names(SEIRDemo.sol)[2:4]<-c("S","E","I") 
SEIRDemo.sol$R <- 1 - apply((SEIRDemo.sol[,2:4]),1,sum)   




SIRwithDemo.sol <- as.data.frame(lsoda(SIR.init, SEIR.t, SIRwithDemo.mod, SIR.par))
names(SIRwithDemo.sol)[2:4]<-c("S","I","R")

par(mfrow=c(1,1))
ylabel<-"Proportion of S, I and R" ; xlabel<-"Time (days)"
ttl<-"SIR model with demography (solid lines) \n SEIR model with demography (dashed lines) \n"
with(SIRwithDemo.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
  ,ylim=c(0,1))
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })


with(SEIRDemo.sol,
  {lines(time,S,type="l",col="green", lty=2, lwd=2)
   lines(time,I,col="red",lwd=2, lty=2) ; lines(time,R,lwd=2,lty=2) 
   ; lines(time,E,lwd=2,lty=2,col="blue")  
  })  
  
  
legend(170,0.9,c("Susceptible (S)","Exposed (I)","Infected (I)","Recovered (I)"),
               col=c("green","blue","red","black"),lty=1,lwd=2)
  





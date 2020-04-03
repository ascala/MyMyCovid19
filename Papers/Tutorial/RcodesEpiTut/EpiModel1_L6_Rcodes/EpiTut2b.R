#******************************************************************************#
#                             Epidemic Models Practical 2:                     #
#        Deterministic compartmental models in homogeneous populations         #
#        Case 2: Difference in susceptibility and susceptibility               #
#******************************************************************************#
#myfolder<-"M:\\Lectures\\Summer Course UNE\\Andrea's praticals\\practical 2"
myfolder<-"M:\\Course material\\CoursesGiven\\Armidale_Feb2018\\Day2-ModellingEpidemics\\EpiModelTutorials\\EpiModel2_L6_Rcodes"
setwd(myfolder)
library(deSolve)
#------------------------------------------------------------------------------#
#                                      2.2                                     #
#------------------------------------------------------------------------------#
# Defining parameters
beta0 <-1.5
gamma <- 1/2
epsS <- 0.5
propR <- 0.2 
N <- 1000

#------------------------------------------------------------------------------#
#                                Step 2                                        #
#------------------------------------------------------------------------------#
source("betaAndR0fc.R")    #Function to calculate WAIFW-matrix and R0s
# see file SIRMajorSusInf.R  to answer question 2.2a!
source("SIR.R")            #basic SIR model 
#SIR model with difference in susceptibility and infectivity:
source("SIRMajorSusInf.R")
# generating WAIFW-matrix and R0s for different epsI values
(betaAndR0EpsI<-betaAndR0fc(epsI=0.2))
(betaAndR0EpsI<-betaAndR0fc(epsI=1))
(betaAndR0EpsI<-betaAndR0fc(epsI=5))
#------------------------------------------------------------------------------#
#                                Step 3                                        #
#------------------------------------------------------------------------------#
SIRmajorSusInf.init <- c((propR*N-1)/N, 1-propR, 1/N, 0, 0)  # initial conditions 
SIRmajorSusInf.t <- seq(0,60, by=0.1)                   # time frame
# impact of epsI for fixed p=0.2
# list to store solutions for all models varying epsI
SIRmajorSusInf.sol<-list() 
epsI<-c(1, 0.2, 5)
#running models
for (i in 1:length(epsI)){
 aux.par<-c(beta0, gamma, epsS, epsI[i])         # parameters
 #solving the differential equations
 SIRmajorSusInf.sol[[i]] <- as.data.frame(lsoda(SIRmajorSusInf.init,
                           SIRmajorSusInf.t, SIRmajorSusInf.mod, aux.par))
 names(SIRmajorSusInf.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")
  SIRmajorSusInf.sol[[i]] $N<-apply( SIRmajorSusInf.sol[[i]][,2:6],1,sum)
                               }
                               
# Homogenous SIR with average transmission rate:
avgBeta <-propR*epsS*beta0+(1-propR)*beta0            #average beta
SIR.par <- c(avgBeta ,gamma)          # parameters
SIR.init <- c(0.999, 0.001, 0)        # initial values  

#solving the differential equations for basic SIR model
SIR.sol <- as.data.frame(lsoda(SIR.init, SIRmajorSusInf.t, SIR.mod, SIR.par))
names(SIR.sol)[2:4]<-c("S","I","R")
SIR.sol$N<-apply(SIR.sol[,2:4],1,sum)  
  
  
par(mfrow=c(1,2))
# plotting the infection profiles for each model                               
ylabel<-"Proportion infected" ;xlabel<-"Time (days)"
ttl<-" SIR model with different levels of infectivity \n proportion of Infecteds"
with(SIR.sol,
  {plot(time,I,type="l",col="red",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,.5),lty=1) })  
 
for (i in 1:length(epsI)){
  with(SIRmajorSusInf.sol[[i]], lines(time,Ir+Is,col="red", lty=i+1)) }

legend(25,0.2,c("homogeneous population",
 as.expression(lapply(epsI, function(x) bquote(epsilon==.(x))))),
 lty = 1:4,
col="red",lwd=2)

# plotting the recovery profiles for each model                               

ylabel<-"Proportion of recovereds" ; xlabel<-"Time (days)"
ttl<-" SIR model with different levels of infectivity \n proportion of recovereds"
with(SIR.sol,
  {plot(time,R,type="l", xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,1),lty=1) })  
  
for (i in 1:length(epsI)){
  with(SIRmajorSusInf.sol[[i]], lines(time, R , lty=i+1)) }
  

legend(30,0.6,c("homogeneous population",
 as.expression(lapply(epsI, function(x) bquote(epsilon==.(x))))),
 lty = 1:4,
col="black",lwd=2)

#------------------------------------------------------------------------------#
#                                Step 4                                        #
# here analyse the SIR model with difference in both susceptibility and# infectivity  when varying the proportion of animals with low susceptibility for# three scenarios: 
# susceptibility and infectivity positively correlated ()
#------------------------------------------------------------------------------#

propRvec<-seq(0,1,by=0.25)

# list to store solutions for all SIR models varying propR
hetSIRpropPosCorr.sol<-list()         # when traits are pos correlated
hetSIRpropNoCorr.sol<-list()          # when traits are NOT correlated

#declaring parameters again (in case they were changed for testing)
beta0 <-1.5
gamma <- 1/2
epsS <- 0.5
N <- 1000

#setting parameter vector for models
epsIposCorr<-0.2
epsInoCorr<-1
hetSIRpropPosCorr.par<-c(beta0, gamma, epsS,epsIposCorr)        
hetSIRpropNoCorr.par<-c(beta0, gamma, epsS, epsInoCorr) 

# running models

for (i in 1:length(propRvec)){
 #initial values
 # initial infected has high susceptibility if propR==0
 if (propRvec[i]==0){
  aux.init <- c(propRvec[i], ((1-propRvec[i])*N-1)/N,0 , 1/N, 0)}
   else
   {aux.init <- c((propRvec[i]*N-1)/N, 1-propRvec[i], 1/N, 0, 0)}
 #solving the differential equations
 #susceptibility and infectivity positively correlated:
 hetSIRpropPosCorr.sol[[i]] <- as.data.frame(lsoda(aux.init, SIRmajorSusInf.t,
                           SIRmajorSusInf.mod, hetSIRpropPosCorr.par))
 names(hetSIRpropPosCorr.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")
  hetSIRpropPosCorr.sol[[i]] $N<-apply(hetSIRpropPosCorr.sol[[i]][,2:6],1,sum)
 #susceptibility and infectivity NOT correlated: 
 hetSIRpropNoCorr.sol[[i]] <- as.data.frame(lsoda(aux.init, SIRmajorSusInf.t,
                           SIRmajorSusInf.mod, hetSIRpropNoCorr.par))
 names(hetSIRpropNoCorr.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")
  hetSIRpropNoCorr.sol[[i]] $N<-apply(hetSIRpropNoCorr.sol[[i]][,2:6],1,sum)
                               }

                   

# Plot:
par(mfrow=c(1,2))
ylabel<-"Proportion infected"
# susceptibility and infectivity positively correlated:
ttl<-"Proportion infected \n low susceptibility confers low infectivity"    
with(hetSIRpropPosCorr.sol[[1]],
  plot(time,Ir+Is,type="l",col="red",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,0.4)))
#rest of p
   
#aux.leg<-function(value) expression(paste(epsilon,"=",value))
for (i in 2:length(propRvec)){
with(hetSIRpropPosCorr.sol[[i]], lines(time,Ir+Is,type="l",col="red",lty=i))}
legend(30,0.2, c("0% resistant","25% resistant","50% resistant","75% resistant",
  "100% resistant") ,lty = 1:5,col="red",lwd=2)

# susceptibility and infectivity NOT correlated:

ttl<-"Proportion infected \n no correlation between susceptibility and infectivity"  
with(hetSIRpropNoCorr.sol[[1]],
  plot(time,Ir+Is,type="l",col="red",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,0.4)))
#rest of p
   
#aux.leg<-function(value) expression(paste(epsilon,"=",value))
for (i in 2:length(propRvec)){
with(hetSIRpropNoCorr.sol[[i]], lines(time,Ir+Is,type="l",col="red",lty=i))}
legend(30,0.2, c("0% resistant","25% resistant","50% resistant","75% resistant",
  "100% resistant") ,lty = 1:5,col="red",lwd=2)


#R0s:

#creating data.frame with  R0s for different proportion of resistants
R0propR<-data.frame(propR = propRvec,R0posCorr=NA,R0noCorr=NA)
for (i in 1:5){
  R0propR[i,2:3]<-c(betaAndR0fc(propR=propRvec[i],epsI=epsIposCorr)$R0,
                   betaAndR0fc(propR=propRvec[i],epsI=epsInoCorr)$R0)
 }
R0propR










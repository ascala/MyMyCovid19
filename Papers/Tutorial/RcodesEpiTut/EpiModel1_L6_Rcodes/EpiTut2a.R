#******************************************************************************#
#                             Epidemic Models Practical 2:                     #
#        Deterministic compartmental models in homogeneous populations         #
#        Section 1:	Case 1: Difference in susceptibility only                  #
#******************************************************************************#
myfolder<-"M:\\Course material\\CoursesGiven\\Armidale_Feb2018\\Day2-ModellingEpidemics\\EpiModelTutorials\\EpiModel2_L6_Rcodes"
#myfolder<-"M:\\Course material\\MathematicalModellingCourseArmidale\\Tutorials\\EpiModel2_Rcodes"
setwd(myfolder)
library(deSolve)


#------------------------------------------------------------------------------#
#                                      1.3                                     #
#------------------------------------------------------------------------------#
beta <-0.8
gamma <- 1/4
eps <-0.3
p<-0.2 ;
N <- 1000

#------------------------------------------------------------------------------#
#                                Step 1                                        #
#------------------------------------------------------------------------------#
(R0<-(p*eps*beta+(1-p)*beta)/gamma)    #R0
((beta-gamma)/((1-eps)*beta))          # threshold for p required for   R0<1
#------------------------------------------------------------------------------#
#                                Step 2                                        #
#------------------------------------------------------------------------------#
source("SIRMajorSus.R")
                                      
SIRmajorSUS.par <- c(beta,gamma,eps)                 # parameters
SIRmajorSUS.init <- c((p*N-1)/N, 1-p, 1/N, 0, 0)     # initial values             
SIRmajorSUS.t <- seq(0,60, by=0.1)                   # time frame


#solving the differential equations for SIR with difference in susceptibility
SIRmajorSUS.sol <- as.data.frame(lsoda(SIRmajorSUS.init, SIRmajorSUS.t,
                                  SIRmajorSUS.mod, SIRmajorSUS.par))
names(SIRmajorSUS.sol)[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")
SIRmajorSUS.sol$N<-apply(SIRmajorSUS.sol[,2:6],1,sum)

# epidemic model ignoring heterogeneity (basic SIR model)
source("SIR.R")
avgBeta <-p*eps*beta+(1-p)*beta       # average beta
SIR.par <- c(avgBeta ,gamma)          # parameters
SIR.init <- c(0.999, 0.001, 0)        # initial values  

#solving the differential equations for basic SIR model
SIR.sol <- as.data.frame(lsoda(SIR.init, SIRmajorSUS.t, SIR.mod, SIR.par))
names(SIR.sol)[2:4]<-c("S","I","R")
SIR.sol$N<-apply(SIR.sol[,2:4],1,sum)  
  
  
#plot:
ylabel<-"Proportion of S, I and R" ; xlabel<-"Time (days)"
ttl<-"Homogeneous and heterogeneous SIR models \n difference in susceptibility only"
with(SIR.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,1),lty=2)    
   lines(time,I,col="red",lwd=2,lty=2) ; lines(time,R,lwd=2,lty=2)  
  })  
  
with(SIRmajorSUS.sol ,
  {lines(time,Sr+Ss,col="green",lwd=2) ;
   lines(time,Ir+Is,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })        
legend(40,0.8,c("S Homogeneous","I Homogeneous","R Homogeneous",
                "S Heterogeneous","I Heterogeneous","R Heterogeneous"),
               col=rep(c("green","red","black"),2),
               lty=sort(rep(1:2,3),decreasing=T),lwd=2)


#------------------------------------------------------------------------------#
#                                Step 3                                        #
#------------------------------------------------------------------------------#
# for different parameter combinations, change the parameters in lines 12-15
# above and  rerun code from step 2 to generate plot

#------------------------------------------------------------------------------#
#                                Step 4                                        #
#------------------------------------------------------------------------------#
# setting the parameters to initial values!
beta <-0.8
gamma <- 1/4
eps <-0.3
N <- 1000

# impact of epsilon for fixed p=0.2
p<-0.2 ;
# vector for possible epsilon values:
epsVector <-sort(seq(0,1,0.25), decreasing = T)

hetSIReps.sol<-list()  # list to store solutions for all models varying eps

#running models

for (i in 1:length(epsVector)){
 aux.par<-c(beta,gamma,epsVector[i])                  # parameters
 #solving the differential equations
 hetSIReps.sol[[i]] <- as.data.frame(lsoda(SIRmajorSUS.init, SIRmajorSUS.t,
                                  SIRmajorSUS.mod, aux.par))
 names(hetSIReps.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")
 hetSIReps.sol[[i]] $N<-apply(hetSIReps.sol[[i]][,2:6],1,sum)
                               }

# plotting the infection for each model                               


#epsilon 1
ttl<-expression(paste("Heterogeneous SIR model -  effect of different " , epsilon, "  values on the infection dynamics"))    
with(hetSIReps.sol[[1]],
  plot(time,Ir+Is,type="l",col="red",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,0.35)))
#rest of epsilon values
aux.leg<-function(value) expression(paste(epsilon,"=",value))
for (i in 2:length(epsVector)){
with(hetSIReps.sol[[i]], lines(time,Ir+Is,type="l",col="red",lty=i))}
legend(40,0.2,
as.expression(lapply(epsVector, function(x) bquote(epsilon==.(x)))), lty = 1:5,
col="red",lwd=2)



#------------------------------------------------------------------------------#
#                                Step 5                                        #
#------------------------------------------------------------------------------#
# impact of p for fixed eps=0.5
eps<-0.3 ;
# vector for possible epsilon values:
pVector <-seq(0,1,0.25)


hetSIRp.sol<-list()         # list to store solutions for all models varying p

#running models
aux.par<-c(beta,gamma,eps) 
aux.t <- seq(0,100, by=0.1) 
for (i in 1:length(pVector)){
                 # parameters
 aux.init <- c((pVector[i]*N-1)/N, 1-pVector[i], 1/N, 0, 0)     # initial values 
 #solving the differential equations
 hetSIRp.sol[[i]] <- as.data.frame(lsoda(aux.init, aux.t,
                                  SIRmajorSUS.mod, aux.par))
 names(hetSIRp.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")
 hetSIRp.sol[[i]] $N<-apply(hetSIRp.sol[[i]][,2:6],1,sum)
                               }

# plotting the infection for each model                               


#p=0 
ttl<-"Heterogeneous SIR model:  effect of different proportion \n of resistant animals on the infection dynamics"    
with(hetSIRp.sol[[1]],
  plot(time,Ir+Is,type="l",col="red",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,0.35)))
#rest of p
   
#aux.leg<-function(value) expression(paste(epsilon,"=",value))
for (i in 2:length(pVector )){
with(hetSIRp.sol[[i]], lines(time,Ir+Is,type="l",col="red",lty=i))}


legend(60,0.2, c("0% resistant","25% resistant","50% resistant","75% resistant",
  "100% resistant") ,lty = 1:5,col="red",lwd=2)



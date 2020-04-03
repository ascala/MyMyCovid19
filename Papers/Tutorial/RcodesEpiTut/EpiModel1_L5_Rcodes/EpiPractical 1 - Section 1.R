#******************************************************************************#
#                             Epidemic Models Practical 1:                     #
#        Deterministic compartmental models in homogeneous populations         #
#        Section 1: Basic SIR model with no demography                         #
#******************************************************************************#
#myfolder<-"M:\\Lectures\\Summer Course Iowa\\Andrea's praticals\\practical 1"
#myfolder<-"M:\\Course material\\MathematicalModellingCourseUNE\\Tutorials\\EpiModel1_Rcodes"
#setwd(myfolder)
library(deSolve)
#------------------------------------------------------------------------------#
#                                      1.2                                     #
#------------------------------------------------------------------------------#
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
  list(c(dS,dI,dR))        
    }


beta <-0.83
gamma <- 1.0/8.2
SIR.par <- c(beta,gamma)
SIR.init <- c(0.999, 0.001, 0)
SIR.t <- seq(0,60, by=0.1)


SIR.sol <- as.data.frame(lsoda(SIR.init, SIR.t, SIR.mod, SIR.par))
names(SIR.sol)[2:4]<-c("S","I","R")
SIR.sol$N<-apply(SIR.sol[,2:4],1,sum)

ylabel<-"Proportion of S, I and R" ; xlabel<-"Time (days)"
ttl<-"basic SIR model (no demography)"
#pdf("SIR_mod1.pdf")   # uncomment this line to save the plot (See R tutorial) 
par(lwd=1)   # for thicker lines
with(SIR.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl)
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })
legend(40,0.8,c("Susceptible (S)","Infected (I)","Recovered (I)"),
               col=c("green","red","black"),lty=1,lwd=2)
#dev.off()             #uncomment this line  to save the plot   (See R tutorial) 


#------------------------------------------------------------------------------#
#                                 1.3                                          #
#------------------------------------------------------------------------------#
# Obtaining the solutions by looking at model
SIR.sol[SIR.sol$I==max(SIR.sol$I),]   
min(SIR.sol[SIR.sol$time > 12 & SIR.sol$I < 0.05,]$time)
max(SIR.sol$R)



#------------------------------------------------------------------------------#
#                                 1.4                                          #
#------------------------------------------------------------------------------#
#----a----#
SIR.init.a <- c(0.499, 0.001, 0.5)
SIR.sol.a <- as.data.frame(lsoda(SIR.init.a, SIR.t, SIR.mod, SIR.par))
names(SIR.sol.a)[2:4]<-c("S","I","R")

# Plotting the two epidemics side-by-side

par(mfrow=c(2,2))   # command to set the plot window
# 1st epidemic (from 1.2)
ttl<-"basic SIR model (no demography)"
with(SIR.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=2,main=ttl)
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })
legend(35,0.8,c("Susceptible","Infected","Recovered"),
               col=c("green","red","black"),lty=1)
ttl<-"basic SIR model (no demography) \n effect of initial conditions"
# 2nd epidemic (with 50% immune)
with(SIR.sol.a,
  {plot(time,S,type="l", col="green", xlab=xlabel, ylab=ylabel,
        lwd=2,main=ttl,ylim=c(0,1))
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })
  
max(SIR.sol.a$R)  
SIR.sol.a[SIR.sol.a$I==max(SIR.sol.a$I),]   
min(SIR.sol.a[SIR.sol.a$time > 12 & SIR.sol.a$I < 0.05,]$time)



#----b----#


beta.b <-0.83*2
gamma<-1.0/8.2
SIR.par.b <- c(beta.b,gamma)
SIR.sol.b <- as.data.frame(lsoda(SIR.init, SIR.t, SIR.mod, SIR.par.b))
names(SIR.sol.b)[2:4]<-c("S","I","R")
SIR.sol.b[SIR.sol.b$I==max(SIR.sol.b$I),]   

#plot:

ttl<-"basic SIR model (no demography) \n  more virulent strain"
with(SIR.sol.b,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,main=ttl,lwd=2)
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })


#----c----#



gamma.c <- 1/2 
SIR.par.c <- c(beta.b,gamma.c)
SIR.sol.c <- as.data.frame(lsoda(SIR.init, SIR.t, SIR.mod, SIR.par.c))
names(SIR.sol.c)[2:4]<-c("S","I","R")
SIR.sol.c[SIR.sol.c$I==max(SIR.sol.c$I),]   
max(SIR.sol.c$R)
beta.b/gamma.c
 
#plot:


ttl<-"basic SIR model (no demography) \n  more virulent strain and better treatment"
with(SIR.sol.c,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,main=ttl,lwd=2)
   lines(time,I,col="red",lwd=2) ; lines(time,R,lwd=2)  
  })




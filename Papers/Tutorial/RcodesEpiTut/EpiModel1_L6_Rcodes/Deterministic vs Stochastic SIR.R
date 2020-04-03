## R code for comparing stochastic with deterministic SIR models for closed populations

# Set working directory
setwd("M:\\Course material\\MathematicalModellingCourseIowa\\Tutorials\\Epi3")
source("stochastic SIR model.R")

#Deterministic model first:
library(deSolve)
source("SIR.R")
beta <-0.83
gamma <- 1.0/8.2
SIR.par <- c(beta,gamma)
SIR.init <- c(0.999, 0.001, 0)
SIR.t <- seq(0,60, by=0.1)
par(mfrow=c(1,2))
SIR.sol <- as.data.frame(lsoda(SIR.init, SIR.t, SIR.mod, SIR.par))
names(SIR.sol)[2:4]<-c("S","I","R")
SIR.sol$N<-apply(SIR.sol[,2:4],1,sum)


#Generate plot for the deterministic SIR model
par(mfrow=c(1,1))                     
ylabel<-"Proportion of S, I and R" ; xlabel<-"Time (days)"
ttl<-"stochastic vs deterministic SIR"
#pdf("SIR_mod1.pdf")   # uncomment this line to save the plot (See R tutorial) 
par(lwd=1)   # for thicker lines
with(SIR.sol,
  {plot(time,S,type="l",col="green",xlab=xlabel,ylab=ylabel,lwd=3,main=ttl)
   lines(time,I,col="red",lwd=3) ; lines(time,R,lwd=3)  
  })
legend(40,0.8,c("Susceptible (S) - Deterministic SIR","Infected (I) Deterministic SIR",
                "Recovered (I) - Deterministic SIR", "Susceptible (S) - Stochastic SIR",
                 "Infected (I) - Stochastic SIR",
                 "Recovered (I) - Stochastic SIR"),
               col=c("green","red","black"),lty=sort(rep(c(1,2),3)))


#Code the stochastic SIR model               
N<-10 #set population size to 100
reps<-10  #the number of realizations for the stochastic model
testData1<-SIRdataGen(nReps=10,TRbeta=0.83, RRgamma=1/8.2, genArc="noVar",
                 N=N, ngroups=1)
#save(testData1,file="testData1.Rdata")


for (i in 1:reps){
with(testData1[[i]]$SIRts,
  {lines(time,S/N,col="green",lty=2)
   lines(time,I/N,col="red",lty=2) ; lines(time,R/N,lty=2)  
  })
}

#Track events over time
head(testData1[[1]]$SIRts,20)
tail(testData1[[1]]$SIRts,20)






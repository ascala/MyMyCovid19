# Defining parameters
beta0 <-1.5
gamma <- 1/2
epsS <- 0.5
propR <- 0.2 
N <- 1000

#list to store initial conditions for each case:
inicases<-list()
inicases[[1]] <- c((propR*N-100)/N, 1-propR, 100/N, 0, 0)        # case 1
inicases[[2]] <- c(propR, ((1-propR)*N-100)/N, 0, 100/N, 0)      # case 2
inicases[[3]] <- c((propR*N-50), ((1-propR)*N-50), 50, 50, 0)/N    # case 3


# List to save the model solutions
iniHetSIRposCorr.sol<-list()    #Positive correlation (eps=0.2)
iniHetSIRnegCorr.sol<-list()     #Negative correlation (eps=5)

posCorr.par<-c(beta0, gamma, epsS, 0.2)         # parameters
negCorr.par<-c(beta0, gamma, epsS, 5)         # parameters

# fitting the models for 

for (i in 1:3){
 #solving the differential equations
 iniHetSIRposCorr.sol[[i]] <- as.data.frame(lsoda(inicases[[i]] ,
                           SIRmajorSusInf.t, SIRmajorSusInf.mod, posCorr.par))
 names(iniHetSIRposCorr.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R")

 iniHetSIRnegCorr.sol[[i]] <- as.data.frame(lsoda(inicases[[i]] ,
                           SIRmajorSusInf.t, SIRmajorSusInf.mod, negCorr.par))
 names(iniHetSIRnegCorr.sol[[i]])[2:6]<-c("Sr", "Ss", "Ir", "Is", "R") 
                               }

                               
#plots
par(mfrow=c(1,2))
ylabel<-"Proportion infected"
ttl<-expression(paste("Effect of initial conditions: positive correlation (" , epsilon[I], "=0.2)"))
with(iniHetSIRposCorr.sol[[1]],
  {plot(time,Ir+Is,type="l",col=1,xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,0.6),xlim=c(0,30))    
  })  
for (i in 2:3) with(iniHetSIRposCorr.sol[[i]],lines(time,Ir+Is,col=i,lwd=2))
legend(20,0.3,c("Case 1","Case 2","Case 3"),col=1:3,lwd=2)




ylabel<-"Proportion infected"
ttl<-expression(paste("Effect of initial conditions: negative correlation (" , epsilon[I], "=5)"))
with(iniHetSIRnegCorr.sol[[1]],
  {plot(time,Ir+Is,type="l",col=1,xlab=xlabel,ylab=ylabel,lwd=2,main=ttl,
   ylim=c(0,0.6),xlim=c(0,30))    
  })  
for (i in 2:3) with(iniHetSIRnegCorr.sol[[i]],lines(time,Ir+Is,col=i,lwd=2))
legend(20,0.3,c("Case 1","Case 2","Case 3"),col=1:3,lwd=2)


                               
                               
  




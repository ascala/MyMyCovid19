#------------------------------------------------------------------------------#
#     Generating data from an stochastc SIR model                              #
# Frequency dependent force of infection (for practicals)                      #
# g = susceptibility phenotype (log scale)                                     #
# f = infectivity phenotype     (log scale)                                    #
# genetic architecture defined by var genArc:                                  #
# "noVar": no genetic variation                                                #
# "polyGen": polygenic control in g and f (with 1 offspring/mating)            #
# "majGen":  major gene for g and f (to do. Also need to combine three cases)  #
# OUTPUT: list with SIR data frame as time series (SIRts) and on a population  #
#         level (pop) for each replicate                                       #
#------------------------------------------------------------------------------#

SIRdataGen<-function(nReps, TRbeta, RRgamma, genArc="noVar",
                     rhoG, rhoE=-0.8, SigG.g, SigG.f, SigE.g, SigE.f,
                     sires, dpsire, N=sires*dpsire, gr.size=N/ngroups, 
                     ngroups=N/gr.size
                     ){

 SIRdata<-list()
 print(paste("R0=",TRbeta/RRgamma))
 for (kk in 1:nReps) {
 print(kk)   
   SIRts<-list() 
  if (genArc=="noVar"){        #  no variation in f and g     
    pop <- data.frame(ID=(1:N), f=0,g=0)}
    else
    {                       #  polygenic variation in f and g  
     pop <- data.frame(ID=(1:N), sire=sort(rep(1:sires,dpsire)), Ag=rep(NA,N),
                     Af=rep(NA,N))
    #-------------generating  BVs------------------#
      #parents
      covG <- rhoG*sqrt(SigG.g)*sqrt(SigG.f)
      sigmaG <- matrix(c(SigG.g,covG,covG,SigG.f),nc=2,byrow=T)
      auxBV.s <- mvrnorm(n = sires, mu=c(0,0), Sigma=sigmaG)
      auxBV.d <- mvrnorm(n = N, mu=c(0,0), Sigma=sigmaG)
      BV.s <- data.frame(ID=1:sires,ng.off=NA,Ag=auxBV.s[,1],Af=auxBV.s[,2])
      BV.d <- data.frame(ID=1:N,sire=sort(rep(1:sires,dpsire)),Ag=auxBV.d[,1],
                       Af=auxBV.d[,2])
      for (i in 1:sires){
        auxBVmend <- mvrnorm(n = dpsire, mu=c(0,0), Sigma=0.5*sigmaG)
        pop[pop$sire==i,]$Ag <- 0.5*BV.s$Ag[i]+0.5*BV.d[BV.d$sire==i,]$Ag+auxBVmend[,1]
        pop[pop$sire==i,]$Af <- 0.5*BV.s$Af[i]+0.5*BV.d[BV.d$sire==i,]$Af+auxBVmend[,2]
                        } 
    #-------------phenotypes------------------#      
     covE <- rhoE*sqrt(SigE.g)*sqrt(SigE.f)
     sigmaE <- matrix(c(SigE.g,covE,covE,SigE.f),nc=2,byrow=T)
     Eaux <- mvrnorm(n = N, mu=c(0,0), Sigma=sigmaE)
     pop$eg <- Eaux[,1]; pop$ef<-Eaux[,2]
     pop$g <- mu.g+pop$Ag+pop$eg
     pop$f <- mu.f+pop$Af+pop$ef          
   }
#------------------------------------------------------------------------------#
#                     Assigning index cases and groups                         #
#------------------------------------------------------------------------------#
#------------------------------#
#   Random family assignment   #
#------------------------------#
  #index cases
  pop[,"s"] <- sample(c(rep(0,ngroups),rep(1,N-ngroups)),replace=F)
  #groups:
  pop$group <- NA
  pop[pop$s==0,]$group <- 1:ngroups
  pop[pop$s==1,]$group <- sample(rep(1:ngroups,gr.size-1),replace=F)
  pop[pop$s==0,"Tinf"] <- 0
#------------------------------------------------------------------------------#
#                             Generating epidemics                             #
#------------------------------------------------------------------------------#
 #Infected indicator
  pop$I <- 1-pop$s
  pop[pop$s==1,"Tinf"] <--1
  pop$last.Tinf<-0
 #time to recovery and its indicator  
  pop$R<-0  ; pop$Trec<-NA
 #transmission rate vectors
  #betaMat<-list();for (k in 1:ngroups) betaMat[[k]]<-rep(NA,nr=gr.size)
  eRates<-list();for (k in 1:ngroups) eRates[[k]]<-rep(NA,nr=gr.size)
##------------------------------#
##     Gillespie algorithm      #
##------------------------------#
  for (i in 1:ngroups)
  {
   #dataframe with number of SIR over time
   SIRts[[i]]<-data.frame(time=0,S=gr.size-1,I=1,R=0)
    nextT<-0 ; pop.gr<-pop[pop$group==i,]
    while (sum(pop.gr$I) > 0 & sum(pop.gr$I==0) > 0)
    { # event rates
      for (j in 1:gr.size){
      #(recovered individuals cannot be selected)
      if (pop.gr$R[j]==1) eRates[[i]][j]=0   
       else{
        if (pop.gr$I[j]==0){       
          # rate of infection for each susceptible
          eRates[[i]][j]=exp(pop.gr$g[j])*(TRbeta/N)*
                         sum(exp(pop.gr[pop.gr$I==1,]$f))}
          else {   # constant recovery rate of each infected (no variation)
          eRates[[i]][j]=RRgamma }}  
                           }
        nextT<-nextT+rexp(1, rate = sum(eRates[[i]]))
        IDnextT<-sample(pop.gr$ID,size=1,prob=eRates[[i]]/sum(eRates[[i]]))
        SIRts[[i]]<-rbind(SIRts[[i]],SIRts[[i]][nrow(SIRts[[i]]),])
        jj<-nrow(SIRts[[i]])
        if (pop.gr[pop.gr$ID==IDnextT,]$I==1){
            pop.gr[pop.gr$ID==IDnextT,"I"] <- 0
            pop.gr[pop.gr$ID==IDnextT,"R"] <- 1
            pop.gr[pop.gr$ID==IDnextT,"Trec"] <- nextT
            SIRts[[i]][jj,]$time<-nextT
            SIRts[[i]][jj,]$I<-SIRts[[i]][jj,]$I-1
            SIRts[[i]][jj,]$R<-SIRts[[i]][jj,]$R+1 
            }
          else{   # infection of a susceptible         
            pop.gr[pop.gr$ID==IDnextT,"I"] <- 1
            pop.gr[pop.gr$ID==IDnextT,"Tinf"] <- nextT 
            SIRts[[i]][jj,]$time<-nextT
            SIRts[[i]][jj,]$S<-SIRts[[i]][jj,]$S-1
            SIRts[[i]][jj,]$I<-SIRts[[i]][jj,]$I+1
            }
     }
    row.names(SIRts[[i]])<-1:nrow(SIRts[[i]]) 
    pop.gr[pop.gr$Tinf==max(pop.gr$Tinf),"last.Tinf"]<-1
    pop.gr[pop.gr$Tinf==-1,"Tinf"]<-NA
    pop[pop$group==i,]<-pop.gr
  }
  SIRdata[[kk]]<-list(pop=pop, SIRts=as.data.frame(SIRts))
}
 return(SIRdata)
}
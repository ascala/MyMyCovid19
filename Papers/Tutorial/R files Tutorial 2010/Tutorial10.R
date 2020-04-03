#-----------------------------------------------------------------------------#
#          Tutorial10: Bayesian inference with conjugate priors               #
#-----------------------------------------------------------------------------#
#define your folder with the myfolder variable:
myfolder<-"C:\\Users\\andre\\OneDrive\\Documents\\Course material\\CoursesGiven\\Armidale_Feb2018\\Day4-StatisticalInference\\Lecture 10_ Introduction to Bayesian inference and Conjugate Bayesian Models\\R files"
setwd(myfolder)
source("Tutorial10Functions.R")

#-----------------------------------------------#
# Bayesian Inference: plotting priors (Step 1)  #
#-----------------------------------------------#
par(mfrow=c(1,2))
lplot <- function(...) plot(...,type="l",xlab="p (proportion)",lwd=2,ylab="")
lplot(prop.range,dbeta(prop.range, shape1=1, shape2=1),col="red",
      main="non-informative prior")
    segments(0, 0, 0,1,col="red",lwd=2,lty=2)
    segments(1, 0, 1,1,col="red",lwd=2,lty=2)
lplot(prop.range,dbeta(prop.range, shape1=4, shape2=2),
      main="informative prior",col="red")

#-----------------------------------------------#
#Step 2: Bayesian point and interval estimates: #
#-----------------------------------------------#

 
# parameter estimates using non-informative prior:
Bayes.noninfo<-data.frame(sample.size=c(10,30,100),
                     p.hat=NA,lower.limit=NA,upper.limit=NA)  
Bayes.noninfo[1,2:4]<- Bayes.inf(sample.10,info.prior=F) 
Bayes.noninfo[2,2:4]<- Bayes.inf(sample.30,info.prior=F) 
Bayes.noninfo[3,2:4]<- Bayes.inf(sample.100,info.prior=F) 
  
# parameter estimates using informative prior:
Bayes.info<-data.frame(sample.size=c(10,30,100),
                     p.hat=NA,lower.limit=NA,upper.limit=NA)  
Bayes.info[1,2:4]<- Bayes.inf(sample.10,info.prior=T) 
Bayes.info[2,2:4]<- Bayes.inf(sample.30,info.prior=T) 
Bayes.info[3,2:4]<- Bayes.inf(sample.100,info.prior=T) 

 
# comparing all estimates
freq.inf
Bayes.noninfo
Bayes.info

#-----------------------------------------------#
#Step 3: Posterior distributions                #
#-----------------------------------------------#

par(mfrow=c(1,2))
lplot(prop.range,dbeta(prop.range, shape1=1+sum(sample.100),
                       shape2=1+length(sample.100)),col="blue",
                       main="Posterior based on a non-informative prior")

lines(prop.range,dbeta(prop.range, shape1=1+sum(sample.30),
                  shape2=1+length(sample.30)),lwd=2,col="black")

lines(prop.range,dbeta(prop.range, shape1=1+sum(sample.10),
                  shape2=1+length(sample.10)),lwd=2,,col="red")
abline(v=sum(pop)/length(pop),lwd=2,col="green",lty=2)
legend(0.6,10,col="red","n=10",bty="n",lwd=2)
legend(0.6,9,col="black","n=30",bty="n",lwd=2)
legend(0.6,8,col="blue","n=100",bty="n",lwd=2)
legend(0.6,7,col="green","true  value",bty="n",lwd=1)

lplot(prop.range,dbeta(prop.range, shape1=4+sum(sample.100),
                       shape2=2+length(sample.100)),col="blue",
                       main="Posterior based on a informative prior")

lines(prop.range,dbeta(prop.range, shape1=4+sum(sample.30),
                  shape2=2+length(sample.30)),lwd=2,col="black")

lines(prop.range,dbeta(prop.range, shape1=4+sum(sample.10),
                  shape2=2+length(sample.10)),lwd=2,col="red")
abline(v=sum(pop)/length(pop),lwd=2,col="green",lty=2)
legend(0.6,10,col="red","n=10",bty="n",lwd=2)
legend(0.6,9,col="black","n=30",bty="n",lwd=2)
legend(0.6,8,col="blue","n=100",bty="n",lwd=2)
legend(0.6,7,col="green","true parameter value",bty="n",lwd=1)

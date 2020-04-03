#-----------------------------------------------------------------------------#
#          Tutorial12: Bayesian inference via MCMC                            #
#          Application to a hierarchical non-linear model for PRRS            #
#-----------------------------------------------------------------------------#
#define your folder with the myfolder variable:
myfolder<-"C:\\Users\\andre\\OneDrive\\Documents\\Course material\\CoursesGiven\\Armidale_Feb2018\\Day4-StatisticalInference\\Lecture 12_ Applications of Bayesian Inference Using MCMC\\R"
setwd(myfolder)
library(ggplot2); library(plotrix)
source("cplot.R") 

# Load data for 15 pigs
load("pigs.rdata")
npigs<-15
IDpigs<-as.numeric(names(table(pigs$pig)))



# Step 1: plotting viremia profiles -------------------------------------------
pdf("viremia15.pdf")
ggplot(pigs, aes(x=time, y=viremia, group=pig)) +
geom_line(color="blue")+geom_point(color="blue")+
ggtitle("Viraemia profiles for 15 pigs")
dev.off()          

# pigs 6 and 13:
#pdf("viremia15.pdf")
pdf("viremia2andpost.pdf")
pig1<-6
pig2<-13
WoodsFCp<-function(t,a1,b1,c1){
 ans<-(a1)*(t^b1)*exp(-c1*t)
   return(ans)}
par(mar=c(5.1,4.1,4.1,2.1),mfrow=c(2,3))
for (i in c(6,13)){
  with(pigs[pigs$pig==IDpigs[i],],{
     plot(time,viremia,pch=19,ylim=c(0,8),main=paste("pig",i));
     lines(time,viremia,type="l")})
     }
#dev.off()          
    
      
          

#-------------------------------------------------#
# step 2: posteriors of Woods parameters for two pigs     #
# (Question 5)                                    #    
#-------------------------------------------------#               

# load MCMC samples
load("a1chain.rdata")   
load("b1chain.rdata")
load("c1chain.rdata")

# creating some blank space in the plot enviroment
plot(1, type="n", axes=F, xlab="", ylab="")
    
  
#a1:
plot(density(a1chain[,pig1]),xlim=c(1,7.5),col="deepskyblue1",
     main="a1 posterior",lwd=2,xlab="",cex.main=1.5)
     lines(density(a1chain[,pig2]),col="red",lwd=2)
#b1:
plot(density(b1chain[,pig1]),xlim=c(0.18,0.70),ylim=c(0,100),xlab="",
     col="deepskyblue1",main="b1 posterior",lwd=2,cex.main=1.5)
lines(density(b1chain[,pig2]),col="red",lwd=2)
legend(0.3,80,legend=c(paste("pig ", pig2),paste("pig ", pig1)),lty=1,lwd=2,
       col=c("deepskyblue1","red"),bty="n",cex=1.5)
#c1:
plot(density(c1chain[,pig1]),xlim=c(0.02,0.09),ylim=c(0,500),xlab="",
     col="deepskyblue1",main="c1 posterior",lwd=2,cex.main=1.5)
lines(density(c1chain[,pig2]),col="red",lwd=2)
dev.off() 
   

#--------------------------------------------------#
# step 3: Calculating means and 95% credible intervals     #
#--------------------------------------------------#

credInt<-function(x) quantile(x,c(0.025,0.975))
a1post<-matrix(0,4,npigs)
a1post[1,]<-apply(a1chain,2,mean)
a1post[2:3,]<-apply(a1chain,2,credInt)
a1post[4,]<-1:15
b1post<-matrix(0,4,npigs)
b1post[1,]<-apply(b1chain,2,mean)
b1post[2:3,]<-apply(b1chain,2,credInt)
b1post[4,]<-1:15
c1post<-matrix(0,4,npigs)
c1post[1,]<-apply(c1chain,2,mean)
c1post[2:3,]<-apply(c1chain,2,credInt)
c1post[4,]<-1:15


#plot                                     
pdf("credInt.pdf")
par(mfrow=c(1,3))         
centipedePlot(as.matrix(a1post),right.labels=" ",sort.segs=T,
               mar=c(4,2,3,2), gridcol="darkgrey",main="a1 95% CI", col="blue",
               cex.main=1.5,cex.lab=2.5,cex.axis=1.5,
               ,xlab=" ",bg="black",left.labels=a1post[4,])
centipedePlot(as.matrix(b1post),right.labels=" ",sort.segs=T,
               mar=c(4,2,3,2), gridcol="darkgrey",main="b1 95% CI",col="darkgreen",
               cex.main=1.5,cex.lab=2.5,cex.axis=1.5,,xlab=" ",
               bg="black",left.labels=a1post[4,])
centipedePlot(as.matrix(c1post),right.labels=" ",sort.segs=T,
               mar=c(4,2,3,2), gridcol="darkgrey",main="c1 95% CI",col="red",
               cex.main=1.5,cex.lab=2.5,cex.axis=1.5,,xlab=" ",bg="black",
               ,left.labels=a1post[4,])
dev.off()             
       
       
                    
      
          
#---------------------------------------------------------#
# step 4: Ploting Woods function estimates for allpigs    #
#---------------------------------------------------------#          

pdf("woodsall.pdf")      
par(mar=c(5.1,4.1,4.1,2.1)*0.5,mfrow=c(3,5))
for (i in 1:npigs){

  with(pigs[pigs$pig==IDpigs[i],],{
     plot(time,viremia,pch=19,ylim=c(0,8),main=paste("pig",i),type="n");
     WoodsL<-WoodsFCp(time,a1post[2,i],b1post[2,i],c1post[2,i]);
     WoodsU<-WoodsFCp(time,a1post[3,i],b1post[3,i],c1post[3,i]);
     polygon(c(time,rev(time)),c(WoodsL,rev(WoodsU)),col="lightsteelblue1",border=F);
     lines(time,viremia,pch=19,ylim=c(0,8),main=paste("pig",i),type="p");
     lines(time,WoodsFCp(time,a1post[1,i],b1post[1,i],c1post[1,i]),col="blue",lwd=2);}
     )   }         
dev.off()          
                         
               
               













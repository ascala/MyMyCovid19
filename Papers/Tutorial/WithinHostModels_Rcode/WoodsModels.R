library(ggplot2)
library(stringr)

#####################################################
## Coded functions: Do not change this part!
#####################################################
WoodsFunction <- function(a,b,c,time = 50){
	
	num <- max(c(length(a), length(b), length(c)))
	if(length(a)!=num) a<-rep(a,num)
	if(length(b)!=num) b<-rep(b,num)
	if(length(c)!=num) c<-rep(c,num)
	wa1 <- data.frame(x1=0:time,y1 = a[1]*(0:time)^(b[1])*exp(-(c[1])*(0:time)))
	a1 <-ggplot(wa1, aes(x=x1, y=y1)) +geom_line(aes(colour=paste("Set=",1)), lwd=1)+scale_x_continuous(name="Time [Days Post Infection]") +scale_y_continuous(name="Virus [RT_PCR]")
	print(a1)
	an <- a1
	for(i in 2:length(a)){
		wan <- data.frame(x1=0:time,y1 = a[i]*(0:time)^(b[i])*exp(-(c[i])*(0:time)),leg = paste("Set=",i))
		a1<-an+geom_line(data=wan, aes(x=x1, y=y1, colour=leg),lwd=1)
		print(a1)
		an <- a1
	}
}


# the extended woods function with default values
ExtendedWoodsFunction <- function(a1,b1,c1,t0, a2, b2, c2, time = 100){
	
	num <- max(c(length(a1), length(b1), length(c1),length(a1), length(b1), length(c1), length(t0)))
	if(length(a1)!=num) a1<-rep(a1,num)
	if(length(b1)!=num) b1<-rep(b1,num)
	if(length(c1)!=num) c1<-rep(c1,num)
	if(length(a2)!=num) a2<-rep(a2,num)
	if(length(b2)!=num) b2<-rep(b2,num)
	if(length(c2)!=num) c2<-rep(c2,num)
      if(length(t0)!=num) t0<-rep(t0,num)
  cond<-(0:time>t0[1])  # condition to evaluate second term of woods function
	wa1 <- data.frame(x1=0:time,y1 = a1[1]*(0:time)^(b1[1])*exp(-(c1[1])*(0:time))+
   cond*(a2[1]*(cond*((0:time)-t0[1]))^(b2[1])*exp(-(c2[1])*(cond*((0:time)-t0[1])))))   
	aa1 <-ggplot(wa1, aes(x=x1, y=y1)) +geom_line(aes(colour=paste("Set=",1)), lwd=1)+scale_x_continuous(name="Time [Days Post Infection]") +scale_y_continuous(name="Virus [RT_PCR]")
	print(aa1)
	an <- aa1
	for(i in 2:length(a1)){
	wan <- data.frame(x1=0:time,y1 = a1[i]*(0:time)^(b1[i])*exp(-(c1[i])*(0:time))+
    cond*(a2[i]*(cond*((0:time)-t0[i]) )^(b2[i])*exp(-(c2[i])*cond*((0:time)-t0[i]))),
    leg = paste("Set=",i))
	aa1<-an+geom_line(data=wan, aes(x=x1, y=y1, colour=leg),lwd=1)
	print(aa1)
	an <- aa1
	}
}




################################################################
### Using the functions for analysis: You can change this part!
################################################################

# For practical questions 1.1 and 1.2 call the Woods / extended Woods functions to 
# to test the effect of each parameter on curve characteristics
# To plot the profile corresponding to a particular parameter set, call e.g. 
WoodsFunction(a = 15, b = 0.8, c = 0.1, time = 50)
ExtendedWoodsFunction(a1 = 5, b1 = 0.1, c1 = 0.012, t0 = 60, a2 = 2.5, b2=0.8, c2 = 0.15, time = 100)

#To test the effect of e.g. parameter a, generate plots with different values for a, keeping all other parameters fixed:
WoodsFunction(a = c(1, 5, 10,15), b = 0.8, c = 0.1, time = 50)
ExtendedWoodsFunction(a1 = c(1, 5, 10,15), b1 = 0.8, c1 = 0.1,t0 = 20, a2 = 2, b2=0.8, c2 = 0.02, time = 50)
# To test the effect of parameter b (b1) in the Woods functions, type e.g. 
WoodsFunction(a = 5, b = c(0.8,0.5), c = 0.1, time = 50)
ExtendedWoodsFunction(a1 = 5, b1 = c(0.8,0.5), c1 = 0.1,t0 = 20, a2 = 2, b2=0.8, c2 = 0.02, time = 50)



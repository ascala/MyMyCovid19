# function to obtain mean and interval estimates from the postetior
Bayes.inf<-function(sample,info.prior){
  n<-length(sample)
  p.hat<-sum(sample)/length(sample)
  if (info.prior==T) {a<-4;b<-2} else  {a<-1;b<-1}
  a<-a+sum(sample);b<-b+length(sample)
  post.mean<-a/(a+b)
  lower.limit<-qbeta(0.05, a, b)
  upper.limit<-qbeta(0.95, a, b)
  return(round(c(post.mean,lower.limit,upper.limit),2)) 
}
#### result combine 

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_set1.RData")
IPWE_sum =  IPWE_mean = c()
for(iters in 1:100){
  ipwe_sum =  ipwe_mean = c()
  for(i in 1:10){
    temp = Result[[iters]]$Restable[[i]]
    temp = temp[which(temp$truegroup * temp$estgroup == 4 |  temp$truegroup * temp$estgroup == 1),'changescore']
    ipwe_sum = c(ipwe_sum, sum(temp))
    ipwe_mean = c(ipwe_mean,mean(temp))
  }
  IPWE_sum = rbind(IPWE_sum, ipwe_sum)
  IPWE_mean = rbind(IPWE_mean, ipwe_mean)
}

#head(IPWE_sum) 
#apply(IPWE_sum,1,mean)
mean(apply(IPWE_sum,1,mean)) # -54.251
#head(IPWE_mean) 
#apply(IPWE_mean,1,mean)
mean(apply(IPWE_mean,1,mean)) # -7.44571


load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_set2.RData")
IPWE_sum =  IPWE_mean = c()
for(iters in 1:length(Result)){
  ipwe_sum =  ipwe_mean = c()
  for(i in 1:10){
    temp = Result[[iters]]$Restable[[i]]
    temp = temp[which(temp$truegroup * temp$estgroup == 4 |  temp$truegroup * temp$estgroup == 1),'changescore']
    ipwe_sum = c(ipwe_sum, sum(temp))
    ipwe_mean = c(ipwe_mean,mean(temp))
  }
  IPWE_sum = rbind(IPWE_sum, ipwe_sum)
  IPWE_mean = rbind(IPWE_mean, ipwe_mean)
}

#head(IPWE_sum) 
#apply(IPWE_sum,1,mean)
mean(apply(IPWE_sum,1,mean)) # -52.89103
#head(IPWE_mean) 
#apply(IPWE_mean,1,mean)
mean(apply(IPWE_mean,1,mean)) # -7.273393


load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_outcome_set1.RData")
IPWE_sum =  IPWE_mean = c()
for(iters in 1:length(Result)){
  ipwe_sum =  ipwe_mean = c()
  for(i in 1:10){
    temp = Result[[iters]]$Restable[[i]]
    temp = temp[which(temp$truegroup * temp$estgroup == 4 |  temp$truegroup * temp$estgroup == 1),'changescore']
    ipwe_sum = c(ipwe_sum, sum(temp))
    ipwe_mean = c(ipwe_mean,mean(temp))
  }
  IPWE_sum = rbind(IPWE_sum, ipwe_sum)
  IPWE_mean = rbind(IPWE_mean, ipwe_mean)
}

#head(IPWE_sum) 
#apply(IPWE_sum,1,mean)
mean(apply(IPWE_sum,1,mean)) # -52.697
#head(IPWE_mean) 
#apply(IPWE_mean,1,mean)
mean(apply(IPWE_mean,1,mean)) # -7.412043


load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_outcome_set2.RData")
IPWE_sum =  IPWE_mean = c()
for(iters in 1:length(Result)){
  ipwe_sum =  ipwe_mean = c()
  for(i in 1:10){
    temp = Result[[iters]]$Restable[[i]]
    temp = temp[which(temp$truegroup * temp$estgroup == 4 |  temp$truegroup * temp$estgroup == 1),'changescore']
    ipwe_sum = c(ipwe_sum, sum(temp))
    ipwe_mean = c(ipwe_mean,mean(temp))
  } 
  IPWE_sum = rbind(IPWE_sum, ipwe_sum)
  IPWE_mean = rbind(IPWE_mean, ipwe_mean)
}

#head(IPWE_sum) 
#apply(IPWE_sum,1,mean)
mean(apply(IPWE_sum,1,mean)) # -54.12025
#head(IPWE_mean) 
#apply(IPWE_mean,1,mean)
mean(apply(IPWE_mean,1,mean)) # -7.387569




load("~/Desktop/NYU/Research/FDA/10. embarc changescore/linear method 0404/embarc_cv_linear_set2.RData")
IPWE_sum =  IPWE_mean = c()
for(iters in 1:length(Result)){
  ipwe_sum =  ipwe_mean = c()
  for(i in 1:10){
    temp = Result[[iters]]$Restable[[i]]
    temp = temp[which(temp$truegroup * temp$estgroup == 4 |  temp$truegroup * temp$estgroup == 1),'changescore']
    ipwe_sum = c(ipwe_sum, sum(temp))
    ipwe_mean = c(ipwe_mean,mean(temp))
  } 
  IPWE_sum = rbind(IPWE_sum, ipwe_sum)
  IPWE_mean = rbind(IPWE_mean, ipwe_mean)
}

#head(IPWE_sum) 
#apply(IPWE_sum,1,mean)
mean(apply(IPWE_sum,1,mean)) # -54.12025
#head(IPWE_mean) 
#apply(IPWE_mean,1,mean)
mean(apply(IPWE_mean,1,mean)) # -7.387569

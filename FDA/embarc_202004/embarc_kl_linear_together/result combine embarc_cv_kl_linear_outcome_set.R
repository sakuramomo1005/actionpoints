

#########################################################
# set 2 

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_set2.RData")
res1 = c()
for(j in 1:length(Result)){
  temp = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res1 = rbind(res1, temp)
}

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/linear method 0404/embarc_cv_linear_set2.RData")
res2 = c()
for(j in 1:78){
  temp = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res2 = rbind(res2, temp)
}

mean(apply(res1,1,mean, na.rm =TRUE))
mean(apply(res2,1,mean, na.rm =TRUE))
sd(apply(res1,1,mean, na.rm =TRUE))
sd(apply(res2,1,mean, na.rm =TRUE))


#########################################################
# set 3
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/embarc_cv_kl_linear_outcome_set3.RData")
res1 = c(); res2 = c()
for(j in 1:length(Result)){
  temp1 = c(); temp2 = c()
  for(i in 1:10){
    restable = Result[[j]]$result_kl$Restable[[i]]
    temp1 = c(temp1, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
    restable = Result[[j]]$result_linear$Restable[[i]]
    temp2 = c(temp2, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res1 = rbind(res1, temp1)
  res2 = rbind(res2, temp2)
}

mean(apply(res1,1,mean, na.rm =TRUE))
mean(apply(res2,1,mean, na.rm =TRUE))
sd(apply(res1,1,mean, na.rm =TRUE))
sd(apply(res2,1,mean, na.rm =TRUE))


#########################################################
# set 4 
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/embarc_cv_kl_linear_outcome_set4.RData")
res1 = c(); res2 = c()
for(j in 1:length(Result)){
  temp1 = c(); temp2 = c()
  for(i in 1:10){
    restable = Result[[j]]$result_kl$Restable[[i]]
    temp1 = c(temp1, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
    restable = Result[[j]]$result_linear$Restable[[i]]
    temp2 = c(temp2, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res1 = rbind(res1, temp1)
  res2 = rbind(res2, temp2)
}

mean(apply(res1,1,mean, na.rm =TRUE))
mean(apply(res2,1,mean, na.rm =TRUE))
sd(apply(res1,1,mean, na.rm =TRUE))
sd(apply(res2,1,mean, na.rm =TRUE))

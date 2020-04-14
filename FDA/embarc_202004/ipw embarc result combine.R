
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/linear method 0404/embarc_cv_linear_set1.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_set1.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_outcome_set1.RData")

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/linear method 0404/embarc_cv_linear_set2.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_set2.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_outcome_set2.RData")

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set2.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")


load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set1.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set1.RData")

res = c()
for(j in 1:length(Result)){
  temp = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res = rbind(res, temp)
}
# round(res)
as.vector(round(apply(res,1,mean),2))
mean(as.vector(round(apply(res,1,mean),2)))
sd(as.vector(round(apply(res,1,mean),2)))

a1 = apply(res,1,mean)
a2 = apply(res,1,mean)
p1 <- hist(a1[1:50], breaks = 20)                      # centered at 4
p2 <- hist(a2[1:50], breaks = 20)                     # centered at 6
plot( p2, col=rgb(0,0,1,1/4), xlim=c(-33,-25))  # first histogram
plot( p1, col=rgb(1,0,0,1/4), xlim=c(-33,-25), add=T) 

### 
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/linear method 0404/embarc_cv_linear_set1.RData")
res = c()
for(j in 1:length(Result)){
  temp = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res = rbind(res, temp)
}
# round(res)
as.vector(round(apply(res,1,mean),2))
mean(as.vector(round(apply(res,1,mean),2)))
sd(as.vector(round(apply(res,1,mean),2)))
a1 = apply(res,1,mean)


### 
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal/embarc_cv_kl_set1.RData")
res = c()
for(j in 1:length(Result)){
  temp = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
  }
  res = rbind(res, temp)
}
# round(res)
as.vector(round(apply(res,1,mean),2))
mean(as.vector(round(apply(res,1,mean),2)))
sd(as.vector(round(apply(res,1,mean),2)))

a2 = apply(res,1,mean)
p1 <- hist(a1[1:78], breaks = 20, freq = FALSE)                      # centered at 4
p2 <- hist(a2, breaks = 20, freq = FALSE)                     # centered at 6
plot( p1, col=rgb(0,0,1,1/4), xlim=c(-8,-6))  # first histogram
plot( p2, col=rgb(1,0,0,1/4), xlim=c(-8,-6), add=T) 




Cvdrgscore = Cvpboscore = c()
Csall = c()
Allscore = c()
for(j in 1:length(Result)){
  cvdrgscore = cvpboscore = c()
  allscore = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    # restable$changescore = ifelse(restable$changescore >0, 0, restable$changescore)
    # ntemp = sum(restable$changescore!=0)
    cvdrg = restable[restable$truegroup == 2 & restable$estgroup == 2, ]
    cvpbo = restable[restable$truegroup == 1 & restable$estgroup == 1, ]
    allscore = c(allscore, mean(c(cvdrg$changescore , cvpbo$changescore)))
    if(dim(cvdrg)[1] == 0){
      cvdrgscore = c(cvdrgscore, NA)
    }else{
      cvdrgscore = c(cvdrgscore, sum(cvdrg$changescore))
    }
    if(dim(cvpbo)[1] == 0){
      cvpboscore = c(cvpboscore, NA)
    }else{
      cvpboscore = c(cvpboscore, sum(cvpbo$changescore))
    }
  }
  Allscore = rbind(Allscore, allscore)
  # Csall = rbind(Csall, sum(c(cvdrgscore, cvpboscore), na.rm = TRUE) / ntemp)
  Cvdrgscore = rbind(Cvdrgscore, cvdrgscore)
  Cvpboscore = rbind(Cvpboscore, cvpboscore)
}

mean(Allscore)

respbo = apply(Cvpboscore, 1, mean, na.rm = TRUE)
respbo = ifelse(is.na(respbo),0,respbo)
resdrg = apply(Cvdrgscore, 1, mean, na.rm = TRUE)
resdrg = ifelse(is.na(resdrg),0,resdrg)

mean(respbo + resdrg) 
sd(respbo + resdrg)

mean(Csall)
sd(Csall)

# set1
# kl: -54.876, 3.7
# kl outcome: -60.539, 5
# linear: -58.92814, 3.5

# set2
# kl:  -57.2297, 4
# kl outcome: -62.16814, 6.814199
# linear: -53.44729, 3.45


### the simulation 
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set2.RData")
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")

# i suddently fund the change scores are differenct 
for(j in 1:length(Result)){
  for(i in 1:10){
    load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set2.RData")
    restable = Result[[j]]$Restable[[i]]
    load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")
    Result[[j]]$Restable[[i]]$changescore2 = restable$changescore
    print( sum(restable$subj ==  restable2$subj))
    print( sum(restable$changescore ==  restable2$changescore))
  }
}
 
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set2.RData")   
Cvdrgscore = Cvpboscore = c()
SS = c()
for(j in 1:length(Result)){
  cvdrgscore = cvpboscore = c()
  ss = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    restable$realtrue = ifelse(restable$truedrg < restable$truepbo, 2, 1)
    cvdrg = restable[restable$truegroup == 2 & restable$estgroup == 2, ]
    cvpbo = restable[restable$truegroup == 1 & restable$estgroup == 1, ]
    
    ss = c(ss, sum(restable$estgroup == restable$realtrue)/ dim(restable)[1])
    if(dim(cvdrg)[1] == 0){
      cvdrgscore = c(cvdrgscore, NA)
    }else{
      cvdrgscore = c(cvdrgscore, sum(cvdrg$changescore))
    }
    if(dim(cvpbo)[1] == 0){
      cvpboscore = c(cvpboscore, NA)
    }else{
      cvpboscore = c(cvpboscore, sum(cvpbo$changescore))
    }
    
  }
  SS = rbind(SS,ss)
  Cvdrgscore = rbind(Cvdrgscore, cvdrgscore)
  Cvpboscore = rbind(Cvpboscore, cvpboscore)
}

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")
Cvdrgscore = Cvpboscore = c()
SS = c()
for(j in 1:length(Result)){
  cvdrgscore = cvpboscore = c()
  ss = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    restable$realtrue = ifelse(restable$drg < restable$pbo, 2, 1)
    cvdrg = restable[restable$truegroup == 2 & restable$estgroup == 2, ]
    cvpbo = restable[restable$truegroup == 1 & restable$estgroup == 1, ]
    
    ss = c(ss, sum(restable$estgroup == restable$realtrue)/ dim(restable)[1])
    if(dim(cvdrg)[1] == 0){
      cvdrgscore = c(cvdrgscore, NA)
    }else{
      cvdrgscore = c(cvdrgscore, sum(cvdrg$changescore))
    }
    if(dim(cvpbo)[1] == 0){
      cvpboscore = c(cvpboscore, NA)
    }else{
      cvpboscore = c(cvpboscore, sum(cvpbo$changescore))
    }
    
  }
  SS = rbind(SS,ss)
  Cvdrgscore = rbind(Cvdrgscore, cvdrgscore)
  Cvpboscore = rbind(Cvpboscore, cvpboscore)
}

respbo = apply(Cvpboscore, 1, mean, na.rm = TRUE)
respbo = ifelse(is.na(respbo),0,respbo)
resdrg = apply(Cvdrgscore, 1, mean, na.rm = TRUE)
resdrg = ifelse(is.na(resdrg),0,resdrg)

mean(respbo + resdrg) 
sd(respbo + resdrg)


### therefore  we need to change the parameters 


# generate beta randomly
beta_drg = c(0, 1, -0.2)
beta_pbo = c(0, 2, -0.1)

# generate gamma
theta_angle = pi/3
gamma1 = c(0, 1, 0)
gamma2 = c(0, cos(theta_angle), sin(theta_angle))
gamma_drg = gamma1
gamma_pbo = gamma2

plot(X[,2], X %*% (beta_drg - gamma1 * 3 + mvrnorm(1, c(0,0,0), bi_sigma)))
plot(X[,2], X %*% (beta_pbo - gamma2 * 3 + mvrnorm(1, c(0,0,0), bi_sigma)))

X %*% (beta_drg + gamma1 * 3 + mvrnorm(1, c(0,0,0), bi_sigma))

plot(X[,2], X %*% (beta_drg + gamma1 * 3))





dim(restable )
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set1.RData")
restable = Result[[1]]$Restable[[1]]
temp = restable[c(4,6,12,13,15,39,41,30,38,49),]

# set.seed(123)
# temp = restable[sample(1:50,10),]
# temp = temp[order(temp$truegroup),]
# rownames(temp) = NULL
temp$ttt = ifelse(temp$truedrg < temp$truepbo, 2,1)
exampletable = data.frame(id = temp$subj, truedrg = temp$truedrg, 
                          truepbo = temp$truepbo, changescore = temp$changescore,
                          truegroup = temp$ttt, assigned = temp$truegroup,
                          estgroup = temp$estgroup)
# exampletable[3,2] = 227.92
# exampletable[3,3] = 43.9
# exampletable[3,4] = 43.9
# exampletable[3,5] = 1

exampletable$estgroup = exampletable$truegroup
exampletable$estgroup[3] = 2
exampletable$estgroup[4] = 2
exampletable$outcome = ifelse(exampletable$assigned == exampletable$estgroup, exampletable$changescore, 0)
exampletable$group2 = ifelse(exampletable$truegroup == 1,2,1)
exampletable$outcome2 = ifelse(exampletable$assigned == exampletable$group2, exampletable$changescore, 0)

round(exampletable,2)


load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set2.RData")
rresult = Result
load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")
for(j in 1:length(Result)){
  for(i in 1:10){
    restable = rresult[[j]]$Restable[[i]]
    Result[[j]]$Restable[[i]]$changescore2 = restable$changescore
    Result[[j]]$Restable[[i]]$truedrg = restable$truedrg
    Result[[j]]$Restable[[i]]$truepbo = restable$truepbo
    Result[[j]]$Restable[[i]]$estgroup2 = restable$estgroup
  }
}
save(Result, file = "~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")

temp = Result[[j]]$Restable[[i]]
sum(temp$estgroup == temp$estgroup2)

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_kl_set2.RData")   
Cvdrgscore = Cvpboscore = c()
SS = c()
for(j in 1:length(Result)){
  cvdrgscore = cvpboscore = c()
  ss = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    restable$realtrue = ifelse(restable$truedrg < restable$truepbo, 2, 1)
    cvdrg = restable[restable$truegroup == 2 & restable$estgroup == 2, ]
    cvpbo = restable[restable$truegroup == 1 & restable$estgroup == 1, ]
    
    ss = c(ss, sum(restable$estgroup == restable$realtrue)/ dim(restable)[1])
    if(dim(cvdrg)[1] == 0){
      cvdrgscore = c(cvdrgscore, NA)
    }else{
      cvdrgscore = c(cvdrgscore, sum(cvdrg$changescore))
    }
    if(dim(cvpbo)[1] == 0){
      cvpboscore = c(cvpboscore, NA)
    }else{
      cvpboscore = c(cvpboscore, sum(cvpbo$changescore))
    }
    
  }
  SS = rbind(SS,ss)
  Cvdrgscore = rbind(Cvdrgscore, cvdrgscore)
  Cvpboscore = rbind(Cvpboscore, cvpboscore)
}

load("~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/sim_cv_linear_set2.RData")
Cvdrgscore = Cvpboscore = c()
SS = c()
for(j in 1:length(Result)){
  cvdrgscore = cvpboscore = c()
  ss = c()
  for(i in 1:10){
    restable = Result[[j]]$Restable[[i]]
    restable$realtrue = ifelse(restable$truedrg < restable$truepbo, 2, 1)
    cvdrg = restable[restable$truegroup == 2 & restable$estgroup == 2, ]
    cvpbo = restable[restable$truegroup == 1 & restable$estgroup == 1, ]
    
    ss = c(ss, sum(restable$estgroup == restable$realtrue)/ dim(restable)[1])
    if(dim(cvdrg)[1] == 0){
      cvdrgscore = c(cvdrgscore, NA)
    }else{
      cvdrgscore = c(cvdrgscore, sum(cvdrg$changescore2))
    }
    if(dim(cvpbo)[1] == 0){
      cvpboscore = c(cvpboscore, NA)
    }else{
      cvpboscore = c(cvpboscore, sum(cvpbo$changescore2))
    }
    
  }
  
  SS = rbind(SS,ss)
  Cvdrgscore = rbind(Cvdrgscore, cvdrgscore)
  Cvpboscore = rbind(Cvpboscore, cvpboscore)
}

respbo = apply(Cvpboscore, 1, mean, na.rm = TRUE)
respbo = ifelse(is.na(respbo),0,respbo)
resdrg = apply(Cvdrgscore, 1, mean, na.rm = TRUE)
resdrg = ifelse(is.na(resdrg),0,resdrg)

mean(respbo + resdrg) 
sd(respbo + resdrg)



# i give up, lets make up tables 
temp = data.frame(id = 1:4, cs_drg = c(40, -3, -10, -5),
           cs_pbo = c(45, -2, -17,-7),
           truegroup = c(2,2,1,1),
           assign = c(2,1,2,1),
           changescore = c(40, -2,-10,-7),
           estgroup1 = c(2,2,1,1),
           estgroup2 = c(1,1,2,2))
temp$changescore1 = ifelse(temp$estgroup1 == temp$assign, temp$changescore, 0)
temp$changescore2 = ifelse(temp$estgroup2 == temp$assign, temp$changescore, 0)

dat_temp = dat
dat_pbo_est = dat_temp[dat_temp$trt == 1, ]
dat_drg_est = dat_temp[dat_temp$trt == 2, ]

fit_pbo_est = lmer(y ~ tt + I(tt^2) + 
                     (tt + I(tt^2)|subj),
                   data = dat_pbo_est, REML = FALSE)
fit_drg_est = lmer(y ~ tt + I(tt^2)  + 
                     (tt + I(tt^2)|subj),
                   data = dat_drg_est, REML = FALSE)

ni = 7 # number of time points
tt = seq(0,8,0.5) # as.matrix(0:6) # pt = the order of time points
X = cbind(matrix(1, length(tt), 1), tt, tt^2)

coef(fit_pbo_est)$subj %*% t(X)
temp = coef(fit_pbo_est)$subj
temp = unlist(temp)
temp = matrix(temp, length(temp)/3,3)
temp = temp %*% t(X)

plot(tt, temp[1,], col = 2, type = 'l', ylim= c(0,35),
     xlab = 'Week', ylab = 'HRSD',
     main = 'EMBARC study quadratic trajecories')
for(i in 2:dim(temp)[1]){
  lines(tt, temp[i,], col = 2)
}
temp = coef(fit_drg_est)$subj
temp = unlist(temp)
temp = matrix(temp, length(temp)/3,3)
temp = temp %*% t(X)
for(i in 1:dim(temp)[1]){
  lines(tt, temp[i,], col = 4)
}

plot(tt, matrix(c(1,-2,1),1,3) %*% t(X), type = 'l', col = 2,
     xlab = 'Week', ylab = 'HRSD', main = 'scenario 1')
lines(tt, matrix(c(1,-2,0.5),1,3) %*% t(X), col = 4)
legend('topleft', legend = c('drg','pbo'), col = c(4,2), lty = 1)
plot(tt, matrix(c(1,2,-1),1,3) %*% t(X), type = 'l', col = 4,
     xlab = 'Week', ylab = 'HRSD', main = 'scenario 1')
lines(tt, matrix(c(1,2,-0.5),1,3) %*% t(X), col = 2)
legend('bottomleft', legend = c('drg','pbo'), col = c(4,2), lty = 1)

plot(tt, temp[60,], col = 2, type = 'l', ylim= c(0,35))
plot(tt, temp[61,], col = 2, type = 'l', ylim= c(0,35))
plot(tt, temp[71,], col = 2, type = 'l', ylim= c(0,35))

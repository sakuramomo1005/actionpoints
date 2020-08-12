##### EMBARC 

##### IPWE

##### CS, integral, weighted integral 

library(MASS)
library(lme4)

load("~/Desktop/NYU/Research/FDA/16. embarc_cortical_thickness_data/completeembarc.RData")

for(functionsi in 1){
  
  int_ = function(x,seqs){
    t0 = sort(seqs)[1]; t1 = sort(seqs)[length(seqs)]
    a = x[1]; b = x[2]; c = x[3]; # c intercept
    temp1 = a/3*t0^3 + b/2*t0^2 + c*t0
    temp2 = a/3*t1^3 + b/2*t1^2 + c*t1
    temp = temp2 - temp1
    temp = temp/(t1 - t0)
    return(temp)
  }
  
  wint2 = function(x,seqs){
    t0 = sort(seqs)[1]; t1 = sort(seqs)[length(seqs)]
    a = x[1]; b = x[2]; c = x[3]; h = x[4]; g= x[5]
    # temp = exp(g)*(((2*c + 16*b + 128*a)*h^2 + (-b-16*a)*h + a)*exp(16*h) -2*c*h^2 + b*h -a)
    # temp = temp/(4*h^3)
    # temp = temp * (2*h/(exp(g)*exp(16*h) - 1))
    # return(temp)
    temp1 = (2*a*h^2*t0^2 + (2*b*h^2 - 2*a*h)*t0 + 2*c*h^2 - b*h + a)*exp(2*h*t0 + g)/(4*h^3)* (2*h/(exp(g)*(exp(2*t1*h) - exp(2*t0*h))))
    temp2 = (2*a*h^2*t1^2 + (2*b*h^2 - 2*a*h)*t1 + 2*c*h^2 - b*h + a)*exp(2*h*t1 + g)/(4*h^3)* (2*h/(exp(g)*(exp(2*t1*h) - exp(2*t0*h))))
    temp = temp2 - temp1
    temp = temp/(t1 - t0)
    return(temp)
  }
  
}

head(data)

dat_test = data

dat_pbo = dat_test[dat_test$trt == 1, ]; rownames(dat_pbo) = NULL
dat_drg = dat_test[dat_test$trt == 2, ]; rownames(dat_drg) = NULL
fit_pbo_est = lmer(y ~ tt + I(tt^2) + (tt + I(tt^2) |subj),
                   data = dat_pbo, REML = FALSE)
fit_drg_est = lmer(y ~ tt + I(tt^2) + (tt + I(tt^2) |subj),
                   data = dat_drg, REML = FALSE)

est_pbo_intercept = apply(coef(fit_pbo_est)$subj,2,mean)[1]
est_pbo_slope = apply(coef(fit_pbo_est)$subj,2,mean)[2]
est_pbo_concavity = apply(coef(fit_pbo_est)$subj,2,mean)[3]

fixintercept = 50
id = intest1 = intest2 = intest3 = c()
seqs = c(0:4,6,8)
for(i in unique(dat_test$subj)){
  temp = dat_test[dat_test$subj == i, ]
  if(temp$trt[1] == 1){
    coef_temp = unlist(coef(fit_pbo_est)$subj[which(rownames(coef(fit_pbo_est)$subj) == i),])
    coef_temp1 = c(coef_temp[3], coef_temp[2], fixintercept)
    coef_temp3 = c(coef_temp[3], coef_temp[2], fixintercept, est_pbo_concavity, est_pbo_slope)
    id = c(id, i)
    intest1 = c(intest1, int_(coef_temp1, seqs))
    # intest2 = c(intest2, wint2(coef_temp2, seqs))
    intest3 = c(intest3, wint2(coef_temp3, seqs))
  }
  if(temp$trt[1] == 2){
    coef_temp = unlist(coef(fit_drg_est)$subj[which(rownames(coef(fit_drg_est)$subj) == i),])
    coef_temp1 = c(coef_temp[3], coef_temp[2], fixintercept)
    coef_temp3 = c(coef_temp[3], coef_temp[2], fixintercept, est_pbo_concavity, est_pbo_slope)
    # int_(coef_temp1)
    # wint2(coef_temp2)
    # wint2(coef_temp3)
    id = c(id, i)
    intest1 = c(intest1, int_(coef_temp1, seqs))
    # intest2 = c(intest2, wint2(coef_temp2, seqs))
    intest3 = c(intest3, wint2(coef_temp3, seqs))
  }
}

changescore = c()
for(i in unique(data$subj)){
  temp = data[data$subj == i,]; rownames(temp) = NULL
  changescore = c(changescore, temp[temp$tt == 8,]$y - temp[temp$tt == 0,]$y)
}

ipwes = data.frame(subj = unique(data$subj), int = intest1, wint = intest3)

head(ipwes)

intres = ipwes



#####################
# change score
#####################

load('~/Desktop/NYU/Research/FDA/18. variable selection/forward/pbodrg.RData')

Mdrg = c(); Mpbo = c()

for(i in 1:100){
  mdrg = c(); mpbo = c()
  for(j in 1:10){
    temp = Result[[i]]$result_simml[[j]]
    temp = merge(temp, intres, by = 'subj')
    mdrg = c(mdrg, temp[temp$truegroup == 2, ]$changescore)
    mpbo = c(mpbo, temp[temp$truegroup == 1, ]$changescore)
  }
  Mdrg = rbind(Mdrg, mdrg)
  Mpbo = rbind(Mpbo, mpbo)
}

res = cbind(rep(6:7, each = 100),
            c(apply(Mdrg, 1, mean), apply(Mpbo, 1, mean))
)

res = data.frame(res)
colnames(res) = c('res','m')


nnn = 13
names = paste("~/Desktop/NYU/Research/FDA/18. variable selection/forward4 outcome/variable_cembarc_diff_cv_kl_linear_0521_outcome_backward_",
              nnn, '.RData', sep='')
load(names)

# print(length(Result))
M1 = M2 = M3 = M4 = c()

for(i in 1:length(Result)){
  
  m1 = m2 = m3 = m4 = c()
  
  for(j in 1:10){
    
    temp1 = Result[[i]]$result_kl$Restable[[j]]
    temp2 = Result[[i]]$result_linear$Restable[[j]]
    temp3 = Result[[i]]$result_simml[[j]]
    
    temp1 = merge(temp1, intres, by = 'subj')
    temp2 = merge(temp2, intres, by = 'subj')
    temp3 = merge(temp3, intres, by = 'subj')
    
    m1 = c(m1, mean(temp1[temp1$truegroup == temp1$estgroup, ]$changescore))
    m2 = c(m2, mean(temp2[temp2$truegroup == temp2$estgroup, ]$changescore))
    m3 = c(m3, mean(temp3[temp3$truegroup == temp3$simml.trt.rule1, ]$changescore))
    #  m4 = c(m4, mean(temp3[temp3$truegroup == temp3$simml.trt.rule2, ]$changescore))
    
  }
  M1 = rbind(M1, m1)
  M2 = rbind(M2, m2)
  M3 = rbind(M3, m3)
  M4 = rbind(M4, m4)
}

M5 = M1
M6 = M2
M7 = M3


M1 = M2 = M3 = M4 = c()
Mpbo = Mdrg = c()

for(nnn in 1:10){
  names = paste('~/Desktop/NYU/Research/FDA/24. non single index model 20200626/embarc/likelihood_outcome_backward_n',nnn,'.RData', sep='')
  load(names)
  print(length(Result))
  
  wheres = c()
  for(ii in 1:length(Result)){
    wheres = c(wheres, is.null(Result[[ii]]))
  }
  
  for(i in (which(wheres == 0)[1]):length(Result)){
    
    m1 = m2 = m3 = m4 = c()
    mpbo = mdrg = c()
    for(j in 1:10){
      
      temp1 = Result[[i]]$result_like$Restable[[j]]
      temp3 = Result[[i]]$result_simml[[j]]
      
      temp1 = merge(temp1, intres, by = 'subj')
      temp3 = merge(temp3, intres, by = 'subj')
      
      mdrg = c(mdrg, mean(temp1[temp1$truegroup == 2, ]$changescore))
      mpbo = c(mpbo, mean(temp1[temp1$truegroup == 1, ]$changescore))
      m1 = c(m1, mean(temp1[temp1$truegroup == temp1$estgroup, ]$changescore))
      # m2 = c(m2, mean(temp2[temp2$truegroup == temp2$estgroup, ]$changescore))
      m3 = c(m3, mean(temp3[temp3$truegroup == temp3$simml.trt.rule1, ]$changescore))
      # m4 = c(m4, mean(temp3[temp3$truegroup == temp3$simml.trt.rule2, ]$changescore))
      
    }
    M1 = rbind(M1, m1)
    M2 = rbind(M2, m2)
    M3 = rbind(M3, m3)
    M4 = rbind(M4, m4)
    Mdrg = rbind(Mdrg, mdrg)
    Mpbo = rbind(Mpbo, mpbo)
  }
  
}
apply(M1, 1, mean)
apply(M3, 1, mean)
mean(Mdrg)
mean(Mpbo)

temp_cs = cbind(c(rep(1, each = dim(M1)[1]),rep(2:3, each = dim(M5)[1]),rep(5, each = dim(M7)[1]) ), 
                c(apply(M1, 1, mean),
                  apply(M5, 1, mean),
                  apply(M6, 1, mean),
                  apply(M7, 1, mean))
                #apply(M3, 1, mean))
)
colnames(temp_cs) = c('res','m')
temp_cs = rbind(temp_cs, res)


#####################
# integral
#####################

load('~/Desktop/NYU/Research/FDA/18. variable selection/forward/pbodrg.RData')

Mdrg = c(); Mpbo = c()

for(i in 1:100){
  
  mdrg = c(); mpbo = c()
  for(j in 1:10){
    temp = Result[[i]]$result_simml[[j]]
    temp = merge(temp, intres, by = 'subj')
    mdrg = c(mdrg, temp[temp$truegroup == 2, ]$int)
    mpbo = c(mpbo, temp[temp$truegroup == 1, ]$int)
  }
  Mdrg = rbind(Mdrg, mdrg)
  Mpbo = rbind(Mpbo, mpbo)
}

res = cbind(rep(6:7, each = 100),
            c(apply(Mdrg, 1, mean), apply(Mpbo, 1, mean))
)
res = data.frame(res)
colnames(res) = c('res','m')


nnn = 13
names = paste("~/Desktop/NYU/Research/FDA/18. variable selection/forward4 outcome/variable_cembarc_diff_cv_kl_linear_0521_outcome_backward_",
              nnn, '.RData', sep='')
load(names)

# print(length(Result))
M1 = M2 = M3 = M4 = c()

for(i in 1:length(Result)){
  
  m1 = m2 = m3 = m4 = c()
  
  for(j in 1:10){
    
    temp1 = Result[[i]]$result_kl$Restable[[j]]
    temp2 = Result[[i]]$result_linear$Restable[[j]]
    temp3 = Result[[i]]$result_simml[[j]]
    
    temp1 = merge(temp1, intres, by = 'subj')
    temp2 = merge(temp2, intres, by = 'subj')
    temp3 = merge(temp3, intres, by = 'subj')
    
    m1 = c(m1, mean(temp1[temp1$truegroup == temp1$estgroup, ]$int))
    m2 = c(m2, mean(temp2[temp2$truegroup == temp2$estgroup, ]$int))
    m3 = c(m3, mean(temp3[temp3$truegroup == temp3$simml.trt.rule1, ]$int))
    #  m4 = c(m4, mean(temp3[temp3$truegroup == temp3$simml.trt.rule2, ]$changescore))
    
  }
  M1 = rbind(M1, m1)
  M2 = rbind(M2, m2)
  M3 = rbind(M3, m3)
  M4 = rbind(M4, m4)
}

M5 = M1
M6 = M2
M7 = M3


M1 = M2 = M3 = M4 = c()
Mpbo = Mdrg = c()

for(nnn in 1:10){
  names = paste('~/Desktop/NYU/Research/FDA/24. non single index model 20200626/embarc/likelihood_outcome_backward_n',nnn,'.RData', sep='')
  load(names)
  print(length(Result))
  
  wheres = c()
  for(ii in 1:length(Result)){
    wheres = c(wheres, is.null(Result[[ii]]))
  }
  
  for(i in (which(wheres == 0)[1]):length(Result)){
    
    m1 = m2 = m3 = m4 = c()
    mpbo = mdrg = c()
    for(j in 1:10){
      
      temp1 = Result[[i]]$result_like$Restable[[j]]
      temp3 = Result[[i]]$result_simml[[j]]
      
      temp1 = merge(temp1, intres, by = 'subj')
      temp3 = merge(temp3, intres, by = 'subj')
      
      mdrg = c(mdrg, mean(temp1[temp1$truegroup == 2, ]$int))
      mpbo = c(mpbo, mean(temp1[temp1$truegroup == 1, ]$int))
      m1 = c(m1, mean(temp1[temp1$truegroup == temp1$estgroup, ]$int))
      # m2 = c(m2, mean(temp2[temp2$truegroup == temp2$estgroup, ]$changescore))
      m3 = c(m3, mean(temp3[temp3$truegroup == temp3$simml.trt.rule1, ]$int))
      # m4 = c(m4, mean(temp3[temp3$truegroup == temp3$simml.trt.rule2, ]$changescore))
      
    }
    M1 = rbind(M1, m1)
    M2 = rbind(M2, m2)
    M3 = rbind(M3, m3)
    M4 = rbind(M4, m4)
    Mdrg = rbind(Mdrg, mdrg)
    Mpbo = rbind(Mpbo, mpbo)
  }
  
}
apply(M1, 1, mean)
apply(M3, 1, mean)
mean(Mdrg)
mean(Mpbo)

temp_int = cbind(c(rep(1, each = dim(M1)[1]),rep(2:3, each = dim(M5)[1]),rep(5, each = dim(M7)[1]) ), 
                 c(apply(M1, 1, mean),
                   apply(M5, 1, mean),
                   apply(M6, 1, mean),
                   apply(M7, 1, mean))
                 #apply(M3, 1, mean))
)
colnames(temp_int) = c('res','m')
temp_int = rbind(temp_int, res)



#####################
# weight integral
#####################

load('~/Desktop/NYU/Research/FDA/18. variable selection/forward/pbodrg.RData')

Mdrg = c(); Mpbo = c()

for(i in 1:100){
  
  mdrg = c(); mpbo = c()
  for(j in 1:10){
    temp = Result[[i]]$result_simml[[j]]
    temp = merge(temp, intres, by = 'subj')
    mdrg = c(mdrg, temp[temp$truegroup == 2, ]$wint)
    mpbo = c(mpbo, temp[temp$truegroup == 1, ]$wint)
  }
  Mdrg = rbind(Mdrg, mdrg)
  Mpbo = rbind(Mpbo, mpbo)
}

res = cbind(rep(6:7, each = 100),
            c(apply(Mdrg, 1, mean), apply(Mpbo, 1, mean))
)
res = data.frame(res)
colnames(res) = c('res','m')


nnn = 13
names = paste("~/Desktop/NYU/Research/FDA/18. variable selection/forward4 outcome/variable_cembarc_diff_cv_kl_linear_0521_outcome_backward_",
              nnn, '.RData', sep='')
load(names)

# print(length(Result))
M1 = M2 = M3 = M4 = c()

for(i in 1:length(Result)){
  
  m1 = m2 = m3 = m4 = c()
  
  for(j in 1:10){
    
    temp1 = Result[[i]]$result_kl$Restable[[j]]
    temp2 = Result[[i]]$result_linear$Restable[[j]]
    temp3 = Result[[i]]$result_simml[[j]]
    
    temp1 = merge(temp1, intres, by = 'subj')
    temp2 = merge(temp2, intres, by = 'subj')
    temp3 = merge(temp3, intres, by = 'subj')
    
    m1 = c(m1, mean(temp1[temp1$truegroup == temp1$estgroup, ]$wint))
    m2 = c(m2, mean(temp2[temp2$truegroup == temp2$estgroup, ]$wint))
    m3 = c(m3, mean(temp3[temp3$truegroup == temp3$simml.trt.rule1, ]$wint))
    #  m4 = c(m4, mean(temp3[temp3$truegroup == temp3$simml.trt.rule2, ]$changescore))
    
  }
  M1 = rbind(M1, m1)
  M2 = rbind(M2, m2)
  M3 = rbind(M3, m3)
  M4 = rbind(M4, m4)
}

M5 = M1
M6 = M2
M7 = M3


M1 = M2 = M3 = M4 = c()
Mpbo = Mdrg = c()

for(nnn in 1:10){
  names = paste('~/Desktop/NYU/Research/FDA/24. non single index model 20200626/embarc/likelihood_outcome_backward_n',nnn,'.RData', sep='')
  load(names)
  print(length(Result))
  
  wheres = c()
  for(ii in 1:length(Result)){
    wheres = c(wheres, is.null(Result[[ii]]))
  }
  
  for(i in (which(wheres == 0)[1]):length(Result)){
    
    m1 = m2 = m3 = m4 = c()
    mpbo = mdrg = c()
    for(j in 1:10){
      
      temp1 = Result[[i]]$result_like$Restable[[j]]
      temp3 = Result[[i]]$result_simml[[j]]
      
      temp1 = merge(temp1, intres, by = 'subj')
      temp3 = merge(temp3, intres, by = 'subj')
      
      mdrg = c(mdrg, mean(temp1[temp1$truegroup == 2, ]$wint))
      mpbo = c(mpbo, mean(temp1[temp1$truegroup == 1, ]$wint))
      m1 = c(m1, mean(temp1[temp1$truegroup == temp1$estgroup, ]$wint))
      # m2 = c(m2, mean(temp2[temp2$truegroup == temp2$estgroup, ]$changescore))
      m3 = c(m3, mean(temp3[temp3$truegroup == temp3$simml.trt.rule1, ]$wint))
      # m4 = c(m4, mean(temp3[temp3$truegroup == temp3$simml.trt.rule2, ]$changescore))
      
    }
    M1 = rbind(M1, m1)
    M2 = rbind(M2, m2)
    M3 = rbind(M3, m3)
    M4 = rbind(M4, m4)
    Mdrg = rbind(Mdrg, mdrg)
    Mpbo = rbind(Mpbo, mpbo)
  }
  
}
apply(M1, 1, mean)
apply(M3, 1, mean)
mean(Mdrg)
mean(Mpbo)

temp_wint = cbind(c(rep(1, each = dim(M1)[1]),rep(2:3, each = dim(M5)[1]),rep(5, each = dim(M7)[1]) ), 
                 c(apply(M1, 1, mean),
                   apply(M5, 1, mean),
                   apply(M6, 1, mean),
                   apply(M7, 1, mean))
                 #apply(M3, 1, mean))
)
colnames(temp_wint) = c('res','m')
temp_wint = rbind(temp_wint, res)



c2 = rainbow(12, alpha=0.1)[c(1,3,5,7,9,11)]
boxplot(m ~ res, data = temp_cs, col = c2, main ='EMBARC with 13 covariances, change score', ylab = 'IPWE', xaxt = 'n')
# 
# abline(h = quantile(apply(Mdrg, 1, mean), 0.5), lty = 2, col = 2)
# abline(h = quantile(apply(Mpbo, 1, mean), 0.5), lty = 2, col = 2)
# abline(h = quantile(apply(M7, 1, mean, na.rm =TRUE), 0.5), lty = 2, col = 2)

temp = c(mean(temp_cs[temp_cs$res == 1,]$m,na.rm=TRUE), 
         mean(temp_cs[temp_cs$res == 2,]$m,na.rm=TRUE),
         mean(temp_cs[temp_cs$res == 3,]$m,na.rm=TRUE),
         mean(temp_cs[temp_cs$res == 5,]$m,na.rm=TRUE),
         mean(temp_cs[temp_cs$res == 6,]$m,na.rm=TRUE),
         mean(temp_cs[temp_cs$res == 7,]$m,na.rm=TRUE))

axis(1, 1:6, c('likelihood','purity','changescore', 'SIMML','alldrg','allpbo'), las = 2)
text(1:6, temp, round(temp,2))


boxplot(m ~ res, data = temp_int, col = c2, main ='EMBARC with 13 covariances, integral', ylab = 'IPWE', xaxt = 'n')
# 
# abline(h = quantile(apply(Mdrg, 1, mean), 0.5), lty = 2, col = 2)
# abline(h = quantile(apply(Mpbo, 1, mean), 0.5), lty = 2, col = 2)
# abline(h = quantile(apply(M7, 1, mean, na.rm =TRUE), 0.5), lty = 2, col = 2)

temp = c(mean(temp_int[temp_int$res == 1,]$m,na.rm=TRUE), 
         mean(temp_int[temp_int$res == 2,]$m,na.rm=TRUE),
         mean(temp_int[temp_int$res == 3,]$m,na.rm=TRUE),
         mean(temp_int[temp_int$res == 5,]$m,na.rm=TRUE),
         mean(temp_int[temp_int$res == 6,]$m,na.rm=TRUE),
         mean(temp_int[temp_int$res == 7,]$m,na.rm=TRUE))

axis(1, 1:6, c('likelihood','purity','changescore', 'SIMML','alldrg','allpbo'), las = 2)
text(1:6, temp, round(temp,2))


boxplot(m ~ res, data = temp_wint, col = c2, main ='EMBARC with 13 covariances, weighted integral', ylab = 'IPWE', xaxt = 'n')
# 
# abline(h = quantile(apply(Mdrg, 1, mean), 0.5), lty = 2, col = 2)
# abline(h = quantile(apply(Mpbo, 1, mean), 0.5), lty = 2, col = 2)
# abline(h = quantile(apply(M7, 1, mean, na.rm =TRUE), 0.5), lty = 2, col = 2)

temp = c(mean(temp_wint[temp_wint$res == 1,]$m,na.rm=TRUE), 
         mean(temp_wint[temp_wint$res == 2,]$m,na.rm=TRUE),
         mean(temp_wint[temp_wint$res == 3,]$m,na.rm=TRUE),
         mean(temp_wint[temp_wint$res == 5,]$m,na.rm=TRUE),
         mean(temp_wint[temp_wint$res == 6,]$m,na.rm=TRUE),
         mean(temp_wint[temp_wint$res == 7,]$m,na.rm=TRUE))

axis(1, 1:6, c('likelihood','purity','changescore', 'SIMML','alldrg','allpbo'), las = 2)
text(1:6, temp, round(temp,2))




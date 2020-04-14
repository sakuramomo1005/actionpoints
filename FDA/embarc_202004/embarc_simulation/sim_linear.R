#### IPWE simulation 

library(MASS); library(lme4)

source("function20200328.R")

theta_angle = 60
p = 2
angles = theta_angle; theta_angle = theta_angle / 180 * pi
alpha = rep(1,p); 
sigma_drg = sigma_pbo =1

n = 500
seqs = c(0,1,2,3,4,6,8)
sigma0 = sigma_pbo 

# set parameters 
for(parameters in 1){
  
  # generate x
  sigmax = matrix(0.5, p, p)
  diag(sigmax) = 1
  
  ni = 7 # number of time points
  tt = c(0,1,2,3,4,6,8) # as.matrix(0:6) # pt = the order of time points
  X = cbind(matrix(1, length(tt), 1), tt, tt^2)
  
  # generate beta randomly
  beta_drg = c(18.6, -2.3, 0.17)
  beta_pbo = c(18.6, -1.9, 0.14)
  
  # generate gamma
  gamma1 = c(0, 1, 0)
  gamma2 = c(0, cos(theta_angle), sin(theta_angle))
  gamma_drg = gamma1
  gamma_pbo = gamma2
  
  #angel
  angel = sum(gamma1 * gamma2)/((t(gamma1) %*% gamma1) * (t(gamma2) %*% gamma2))
  angel = round(acos(angel) * 180/3.1415926535)
  print(angel)
  
  bi_sigma = matrix(c(8.869, 2.766, -0.359, 2.766, 
                      1.016, -0.104, -0.359, -0.104, 1.5),3,3)
  
  bi_sigma2 = matrix(c(9.507, 1.012, -0.093, 1.012,
                       1, -0.395, -0.093, -0.395, 1.5),3,3)
  
}

dat = true_generation_test3(alpha, p, n = n, ni, tt, X, 
                                 beta_drg, gamma_drg, bi_sigma,sigma_drg,
                                 beta_pbo, gamma_pbo, bi_sigma2,sigma_pbo, sigmax)

dat$trt = ifelse(dat$subj2 <= round(n/2), 2, 1)
dat$y = ifelse(dat$trt ==2, dat$yi_drg, dat$yi_pbo)
# dat$subj
covar_names = paste('X',1:p, sep ='')
temp = dat[,covar_names]
temp = scale(temp)
dat[,covar_names] = temp

# linear formula 
ncovars = length(covar_names)
lmform = paste("changescore ~",covar_names[1])
for(i in 2:ncovars){
  lmform = paste(lmform, "+", covar_names[i])
}
lmform = formula(lmform)

# calculate true change scores 
changescore = c(); assignment = c(); id = c()
bs = c()
cs_drg = cs_pbo = c()
for(i in unique(dat$subj)){
  temp = dat[dat$subj == i,]; rownames(temp) = NULL
  id = c(id, temp$subj[1])
  assignment = c(assignment, temp$trt[1])
  changescore = c(changescore, temp[temp$tt== max(temp$tt),'y'] - 
                    temp[temp$tt == min(temp$tt),'y'])
  cs_drg = c(cs_drg, temp[temp$tt== max(temp$tt),'yi_drg'] - 
               temp[temp$tt == min(temp$tt),'yi_drg'])
  cs_pbo = c(cs_pbo, temp[temp$tt== max(temp$tt),'yi_pbo'] - 
               temp[temp$tt == min(temp$tt),'yi_pbo'])
  bs = c(bs, temp[temp$tt == min(temp$tt),'y'])
}
dat$subj= dat$subj2
dat_subj = data.frame(subj = id, changescore = changescore, 
                      cs_drg = cs_drg, cs_pbo = cs_pbo, 
                      assignment = assignment)
dat = merge(dat, dat_subj, by = 'subj')

# separate into drg and pbo groups. 
dat_drg = dat[dat$trt == 2, ]
dat_pbo = dat[dat$trt == 1, ]

# 10 fold cv
kfold = 10
id_drg = unique(dat_drg$subj)
id_pbo = unique(dat_pbo$subj)

Result = list()

for(iters in 1:100){
  
  print(iters)
  set.seed(iters)
  
  id_drg_fold = sample(rep(1:kfold, length.out = length(id_drg)))
  id_pbo_fold = sample(rep(1:kfold, length.out = length(id_pbo)))
  
  cvdrgscore = cvpboscore = c()
  Restable = list()

  source('cv_linear_sharecode2.R')
 
  result = list(Restable = Restable, 
                cvpboscore = cvpboscore,
                cvdrgscore = cvdrgscore,
                covar_names = covar_names)
  
  Result[[iters]] = result
  
  save(Result, file = 'sim_cv_linear_set1.RData')
}



# 
# for(k in 1:kfold){
#   
#   dat_drg_train = dat_drg[dat_drg$subj %in% id_drg[which(id_drg_fold != k)], ]
#   dat_drg_test = dat_drg[dat_drg$subj %in% id_drg[which(id_drg_fold == k)], ]
#   dat_pbo_train = dat_pbo[dat_pbo$subj %in% id_pbo[which(id_pbo_fold != k)], ]
#   dat_pbo_test = dat_pbo[dat_pbo$subj %in% id_pbo[which(id_pbo_fold == k)], ]
#   
#   cv_train = rbind(dat_drg_train, dat_pbo_train); rownames(cv_train) = NULL
#   cv_test = rbind(dat_drg_test, dat_pbo_test); rownames(cv_test) = NULL
#   
#   # for train data fit linear 
#   dat_linear = cbind(cv_train$subj, cv_train$changescore, cv_train$trt, cv_train[,covar_names])
#   dat_linear = unique(dat_linear)
#   rownames(dat_linear) = NULL
#   colnames(dat_linear) = c('subj', 'changescore','trt', covar_names)
#   linear_drg = dat_linear[dat_linear$trt == 2, ]; rownames(linear_drg) = NULL
#   linear_pbo = dat_linear[dat_linear$trt == 1, ]; rownames(linear_pbo) = NULL
#   
#   # fit linear model 
#   l_est_drg = lm(lmform, data = linear_drg)
#   l_est_pbo = lm(lmform, data = linear_pbo)
#   # test results 
#   test_drg = predict(l_est_drg, newdata = cv_test[,covar_names])
#   test_pbo = predict(l_est_pbo, newdata = cv_test[,covar_names])
#   
#   test_res = data.frame(subj = cv_test$subj, truegroup = cv_test$trt, changescore = cv_test$changescore, estdrg = test_drg, estpbo = test_pbo,
#                         drg = cv_test$cs_drg, pbo = cv_test$cs_pbo)
#   test_res = unique(test_res); rownames(test_res) = NULL
#   test_res$estgroup = ifelse(test_res$estdrg < test_res$estpbo,2,1)
#   
#   Restable[[k]] = test_res
#   
#   cvdrg = test_res[test_res$truegroup == 2 & test_res$estgroup == 2, ]
#   cvpbo = test_res[test_res$truegroup == 1 & test_res$estgroup == 1, ]
#   if(dim(cvdrg)[1] == 0){
#     cvdrgscore = c(cvdrgscore, NA)
#   }else{
#     cvdrgscore = c(cvdrgscore, sum(cvdrg$changescore))
#   }
#   if(dim(cvpbo)[1] == 0){
#     cvpboscore = c(cvpboscore, NA)
#   }else{
#     cvpboscore = c(cvpboscore, sum(cvpbo$changescore))
#   }
#   
# }

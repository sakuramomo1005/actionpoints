# conduct 10-fold cv, estimate coefficient with linear regression. esitmate the group assignment by using the above estimate method. 

# setwd('/Users/yaolanqiu/Desktop/NYU/Research/FDA/10. embarc changescore/longitudinal')

# OUTCOME 

library(lme4)
library(MASS)

source('function_embarc.R')
#################################################
# code 
load('embarc.RData')

# covariates, set 1 
covar_names = c("w0_4165", "w0_4167", "w0_4163", "w0_4162", "w0_4169", "w0_1844",
                "w0_1916", "w0_1915", "w0_1920")

# covar_names = c("dur_MDE","age_MDE", "Greg_FH","fatigue",
#                 "hypersomnia", "axis2", "anger_attack", "anxious",
#                 "w0_4165", "w0_4167", "w0_4163", "w0_4162", "w0_4169", "w0_1844",
#                 "w0_1916", "w0_1915", "w0_1920")

temp = dat[,covar_names]
temp = scale(temp)
dat[,covar_names] = temp

# scale the covariates 

ncovars = length(covar_names)
lmform = paste("changescore ~",covar_names[1])
for(i in 2:ncovars){
  lmform = paste(lmform, "+", covar_names[i])
}
lmform = formula(lmform)

# calculate true change scores 
changescore = c(); assignment = c(); id = c()
for(i in unique(dat$subj)){
  temp = dat[dat$subj == i,]; rownames(temp) = NULL
  id = c(id, temp$subj[1])
  assignment = c(assignment, temp$trt[1])
  changescore = c(changescore, temp[temp$week == max(temp$tt),'y'] - 
                    temp[temp$week == min(temp$tt),'y'])
}
dat_subj = data.frame(subj = id, changescore = changescore, assignment = assignment)
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
  kllist = list()
  
  source('cv_kl_outcome_sharecode.R')
  
  result = list(kllist = kllist,
                Restable = Restable, 
                cvpboscore = cvpboscore,
                cvdrgscore = cvdrgscore,
                covar_names = covar_names)
  
  Result[[iters]] = result
  save(Result, file = 'embarc_cv_kl_outcome_set1.RData')
}



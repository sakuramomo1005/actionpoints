# Roadmap

#### EMBARC 
#### cross validation 
#### 2020-04-04
#### using change score method 

# conduct 10-fold cv, estimate coefficient with linear regression. esitmate the group assignment by using the above estimate method. 

# code 
# load('embarc.RData')

# share code

for(k in 1:kfold){
  
  dat_drg_train = dat_drg[dat_drg$subj %in% id_drg[which(id_drg_fold != k)], ]
  dat_drg_test = dat_drg[dat_drg$subj %in% id_drg[which(id_drg_fold == k)], ]
  dat_pbo_train = dat_pbo[dat_pbo$subj %in% id_pbo[which(id_pbo_fold != k)], ]
  dat_pbo_test = dat_pbo[dat_pbo$subj %in% id_pbo[which(id_pbo_fold == k)], ]
  
  cv_train = rbind(dat_drg_train, dat_pbo_train); rownames(cv_train) = NULL
  cv_test = rbind(dat_drg_test, dat_pbo_test); rownames(cv_test) = NULL
  
  # for train data fit linear 
  dat_linear = cbind(cv_train$subj, cv_train$changescore, cv_train$trt, cv_train[,covar_names])
  dat_linear = unique(dat_linear)
  rownames(dat_linear) = NULL
  colnames(dat_linear) = c('subj', 'changescore','trt', covar_names)
  linear_drg = dat_linear[dat_linear$trt == 2, ]; rownames(linear_drg) = NULL
  linear_pbo = dat_linear[dat_linear$trt == 1, ]; rownames(linear_pbo) = NULL
  
  # fit linear model 
  l_est_drg = lm(lmform, data = linear_drg)
  l_est_pbo = lm(lmform, data = linear_pbo)
  # test results 
  test_drg = predict(l_est_drg, newdata = cv_test[,covar_names])
  test_pbo = predict(l_est_pbo, newdata = cv_test[,covar_names])
  
  test_res = data.frame(subj = cv_test$subj, truegroup = cv_test$trt, changescore = cv_test$changescore, estdrg = test_drg, estpbo = test_pbo)
  test_res = unique(test_res); rownames(test_res) = NULL
  test_res$estgroup = ifelse(test_res$estdrg < test_res$estpbo,2,1)
  
  Restable[[k]] = test_res
  
  cvdrg = test_res[test_res$truegroup == 2 & test_res$estgroup == 2, ]
  cvpbo = test_res[test_res$truegroup == 1 & test_res$estgroup == 1, ]
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

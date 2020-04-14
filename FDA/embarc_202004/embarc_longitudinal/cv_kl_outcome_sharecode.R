### IPWE

for(k in 1:kfold){
  
  print(paste('kfold',k))
  
  dat_drg_train = dat_drg[dat_drg$subj %in% id_drg[which(id_drg_fold != k)], ]
  dat_drg_test = dat_drg[dat_drg$subj %in% id_drg[which(id_drg_fold == k)], ]
  dat_pbo_train = dat_pbo[dat_pbo$subj %in% id_pbo[which(id_pbo_fold != k)], ]
  dat_pbo_test = dat_pbo[dat_pbo$subj %in% id_pbo[which(id_pbo_fold == k)], ]
  
  cv_train = rbind(dat_drg_train, dat_pbo_train); rownames(cv_train) = NULL
  cv_test = rbind(dat_drg_test, dat_pbo_test); rownames(cv_test) = NULL
  
  dat_temp = cv_train
  p = length(covar_names)
  res_temp = optim(rep(1,p), KL_lm_embarc_outcome)
  
  kllist[[k]] = res_temp
  alpha_est = res_temp$par
  alpha_est = alpha_est/sqrt(sum(alpha_est^2))
  
  for(wcalculation in 1){
    # calculate W = alpha^T x
    covar_list = dat_temp[, covar_names]
    temp_W = unlist(c(covar_list))
    temp_W = matrix(temp_W, dim(dat_temp)[1], p)
    dat_temp$W = c(temp_W %*% alpha_est)
  }
  
  dat_pbo_est = dat_temp[dat_temp$trt == 1, ]
  dat_drg_est = dat_temp[dat_temp$trt == 2, ]
  
  fit_pbo_est = lmer(y ~ tt + I(tt^2) + W + W * tt + W * I(tt^2) + 
                       (tt|subj),
                     data = dat_pbo_est, REML = FALSE)
  fit_drg_est = lmer(y ~ tt + I(tt^2) + W + W * tt + W * I(tt^2) + 
                       (tt|subj),
                     data = dat_drg_est, REML = FALSE)
  
  hatbeta1 = as.matrix(fixef(fit_drg_est))[1:3]
  hatgamma1 = as.matrix(fixef(fit_drg_est))[4:6] 
  hatD1 = as.matrix(VarCorr(fit_drg_est)$subj)[1:2, 1:2] 
  hatbeta2 = as.matrix(fixef(fit_pbo_est))[1:3] 
  hatgamma2 = as.matrix(fixef(fit_pbo_est))[4:6] 
  hatD2 = as.matrix(VarCorr(fit_pbo_est)$subj)[1:2, 1:2] 
  
  for(wcalculation in 1){
    # calculate W = alpha^T x
    covar_list = cv_test[, covar_names]
    temp_W = unlist(c(covar_list))
    temp_W = matrix(temp_W, dim(cv_test)[1], p)
    cv_test$W = c(temp_W %*% alpha_est)
  }
  
  seqs = c(0,1,2,3,4,6,8)
  id = c(); 
  estdrg = c(); estpbo = c();
  estgroup = c()
  changescore = c(); 
  truegroup = c()
  
  for(ii in unique(cv_test$subj)){
    
    id = c(id, ii)
    temp = cv_test[cv_test$subj == ii, ]
    rownames(temp) = NULL
    
    changescore = c(changescore, temp$changescore[1])
    truegroup = c(truegroup, temp$assignment[1])
    
    estcoef1 = hatbeta1 + hatgamma1 * temp$W[1]
    estcoef2 = hatbeta2 + hatgamma2 * temp$W[1]
    esty1 = estcoef1[1] + estcoef1[2] * seqs + estcoef1[3] * seqs^2
    esty2 = estcoef2[1] + estcoef2[2] * seqs + estcoef2[3] * seqs^2
    
    dif_drg = esty1[7] - esty1[1]
    dif_pbo = esty2[7] - esty2[1]
    
    estdrg = c(estdrg, dif_drg); 
    estpbo = c(estpbo, dif_pbo)
    
    if(dif_drg < dif_pbo){
      estgroup = c(estgroup,2)
    }else{
      estgroup = c(estgroup,1)
    }
    
  }
  
  restable = data.frame(subj = id, truegroup = truegroup,
                        estgroup = estgroup, 
                        changescore = changescore, estdrg = estdrg, estpbo = estpbo)
  
  cvdrg = restable[restable$truegroup == 2 & restable$estgroup == 2, ]
  cvpbo = restable[restable$truegroup == 1 & restable$estgroup == 1, ]
  
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
  
  Restable[[k]] =  restable
  
}

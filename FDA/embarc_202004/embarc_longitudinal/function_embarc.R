

KL_lm_embarc = function(alpha){
  for(wcalculation in 1){
    # scale alpha
    p = length(covar_names)
    alpha = matrix(alpha,p,1)
    alpha = alpha/c(sqrt(t(alpha) %*% alpha))
    alpha = round(alpha, 2)
    
    # calculate W = alpha^T x
    covar_list = dat_temp[,covar_names]
    # covar_list = scale(covar_list)
    temp_W = unlist(c(covar_list))
    temp_W = matrix(temp_W, dim(dat_temp)[1], p)
    dat_temp$W = c(temp_W %*% alpha)
  }
  
  dat_pbo_est = dat_temp[dat_temp$trt == 1, ]
  dat_drg_est = dat_temp[dat_temp$trt == 2, ]
  
  fit_pbo_est = myTryCatch(lmer(y ~ tt + I(tt^2) + W + W * tt +
                                  W * I(tt^2) + (tt+I(tt^2)|subj),
                                data = dat_pbo_est, REML = FALSE))
  fit_drg_est = myTryCatch(lmer(y ~ tt + I(tt^2) + W + W * tt +
                                  W * I(tt^2) + (tt+I(tt^2)|subj),
                                data = dat_drg_est, REML = FALSE))
  
  # beta, gamma, and D matrix
  beta1 = as.matrix(fixef(fit_drg_est$value))[1:3]
  gamma1 = as.matrix(fixef(fit_drg_est$value))[4:6] 
  D1 = as.matrix(VarCorr(fit_drg_est$value)$subj)[1:3, 1:3] 
  beta2 = as.matrix(fixef(fit_pbo_est$value))[1:3] 
  gamma2 = as.matrix(fixef(fit_pbo_est$value))[4:6] 
  D2 = as.matrix(VarCorr(fit_pbo_est$value)$subj)[1:3, 1:3] 
  
  temp = covar_list 
  xx = as.numeric(unlist(c(temp)))
  xx = matrix(xx, p, dim(dat_temp)[1], byrow = TRUE)
  
  # this is the function derivated from the KL-divergence
  A_0 = -p + 0.5 *  sum(diag(ginv(D1[2:3, 2:3]) %*% D2[2:3, 2:3])) +  0.5 * sum(diag(ginv(D2[2:3, 2:3]) %*% D1[2:3, 2:3]))
  A_1 = t(beta1[2:3] - beta2[2:3]) %*% (ginv(D1[2:3, 2:3]) + ginv(D2[2:3, 2:3])) %*% (beta1[2:3] - beta2[2:3])
  A_2 = t(gamma1[2:3] - gamma2[2:3]) %*% (ginv(D1[2:3, 2:3]) + ginv(D2[2:3, 2:3])) %*% (beta1[2:3] - beta2[2:3])
  A_3 = t(gamma1[2:3] - gamma2[2:3]) %*% (ginv(D1[2:3, 2:3]) + ginv(D2[2:3, 2:3])) %*% (gamma1[2:3] - gamma2[2:3]) 
  
  mu_x = matrix(apply(t(xx), 2, mean), p, 1)
  sigma_x = cov(t(xx))
  
  #lambda0 = max(eigen(sigma_x)$values)
  #n_max = which(eigen(sigma_x)$values == lambda0)
  #est_alpha = eigen(sigma_x)$vectors[,n_max]
  est_alpha = alpha
  est_alpha = matrix(est_alpha, p, 1)
  
  return_res = A_0 + A_1/2 + 
    c(A_3/2) * t(est_alpha) %*% (sigma_x) %*% est_alpha
  
  return_res =  c(-return_res)
  
  return(return_res)
}

KL_lm_embarc_outcome = function(alpha){
  
  for(wcalculation in 1){
    # scale alpha
    p = length(covar_names)
    alpha = matrix(alpha,p,1)
    alpha = alpha/c(sqrt(t(alpha) %*% alpha))
    alpha = round(alpha, 2)
    
    # calculate W = alpha^T x
    covar_list = dat_temp[,covar_names]
    # covar_list = scale(covar_list)
    temp_W = unlist(c(covar_list))
    temp_W = matrix(temp_W, dim(dat_temp)[1], p)
    dat_temp$W = c(temp_W %*% alpha)
  }
  
  dat_pbo_est = dat_temp[dat_temp$trt == 1, ]
  dat_drg_est = dat_temp[dat_temp$trt == 2, ]
  
  fit_pbo_est = myTryCatch(lmer(y ~ tt + I(tt^2) + W + W * tt +
                                  W * I(tt^2) + (tt|subj),
                                data = dat_pbo_est, REML = FALSE))
  fit_drg_est = myTryCatch(lmer(y ~ tt + I(tt^2) + W + W * tt +
                                  W * I(tt^2) + (tt|subj),
                                data = dat_drg_est, REML = FALSE))
  
  # beta, gamma, and D matrix
  beta1 = as.matrix(fixef(fit_drg_est$value))[1:3]
  gamma1 = as.matrix(fixef(fit_drg_est$value))[4:6] 
  D1 = as.matrix(VarCorr(fit_drg_est$value)$subj)[1:2, 1:2] 
  beta2 = as.matrix(fixef(fit_pbo_est$value))[1:3] 
  gamma2 = as.matrix(fixef(fit_pbo_est$value))[4:6] 
  D2 = as.matrix(VarCorr(fit_pbo_est$value)$subj)[1:2, 1:2] 
  est_sigma1 = summary(fit_drg_est$value)$sigma
  est_sigma2 = summary(fit_pbo_est$value)$sigma
  
  temp = covar_list 
  xx = as.numeric(unlist(c(temp)))
  xx = matrix(xx, p, dim(dat_temp)[1], byrow = TRUE)
  
  seqs = c(0,1,2,3,4,6,8)
  X = cbind(rep(1,7),seqs,seqs^2)
  
  beta1 = X %*% beta1; beta2 = X %*% beta2; 
  gamma1 = X %*% gamma1; gamma2 = X %*% gamma2;
  
  D1 = X[,1:2] %*% D1 %*% t(X[,1:2]) + est_sigma1^2 * diag(1,dim(X)[1])
  D2 = X[,1:2] %*% D2 %*% t(X[,1:2]) + est_sigma2^2 * diag(1,dim(X)[1])
  
  # this is the function derivated from the KL-divergence
  A_0 = -p + 0.5 *  sum(diag(ginv(D1[2:3, 2:3]) %*% D2[2:3, 2:3])) +  0.5 * sum(diag(ginv(D2[2:3, 2:3]) %*% D1[2:3, 2:3]))
  A_1 = t(beta1[2:3] - beta2[2:3]) %*% (ginv(D1[2:3, 2:3]) + ginv(D2[2:3, 2:3])) %*% (beta1[2:3] - beta2[2:3])
  A_2 = t(gamma1[2:3] - gamma2[2:3]) %*% (ginv(D1[2:3, 2:3]) + ginv(D2[2:3, 2:3])) %*% (beta1[2:3] - beta2[2:3])
  A_3 = t(gamma1[2:3] - gamma2[2:3]) %*% (ginv(D1[2:3, 2:3]) + ginv(D2[2:3, 2:3])) %*% (gamma1[2:3] - gamma2[2:3]) 
  
  mu_x = matrix(apply(t(xx), 2, mean), p, 1)
  sigma_x = cov(t(xx))
  
  #lambda0 = max(eigen(sigma_x)$values)
  #n_max = which(eigen(sigma_x)$values == lambda0)
  #est_alpha = eigen(sigma_x)$vectors[,n_max]
  est_alpha = alpha
  est_alpha = matrix(est_alpha, p, 1)
  
  return_res = A_0 + A_1/2 + 
    c(A_3/2) * t(est_alpha) %*% (sigma_x) %*% est_alpha
  
  return_res =  c(-return_res)
  
  return(return_res)
}

myTryCatch <- function(expr) {
  warn <- err <- NULL
  value <- withCallingHandlers(
    tryCatch(expr, error=function(e) {
      err <<- e
      NULL
    }), warning=function(w) {
      warn <<- w
      invokeRestart("muffleWarning")
    })
  list(value=value, warning=warn, error=err)
}

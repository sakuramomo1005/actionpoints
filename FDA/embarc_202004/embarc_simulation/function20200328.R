
for(functions in 1){
  
  # bug, sigma did not square 
  # while maybe that is not a bug
  true_generation = function(alpha, p, n, ni, tt, X, 
                             beta_drg, gamma_drg, bi_sigma, sigma_drg,
                             beta_pbo, gamma_pbo, bi_sigma2,sigma_pbo, sigmax){
    # alpha
    # set.seed(123)
    
    alpha = as.matrix(alpha,p,1)
    dat_drg = c()
    for(i in 1:n){
      drg_temp = NULL
      drg_temp$subj = rep(paste('drg',i,sep=''),ni)
      drg_temp$subj2 = rep(i, ni)
      drg_temp$trt = rep('drg',ni)
      drg_temp = as.data.frame(drg_temp)
      # xbaseline = as.matrix(rnorm(p,0,1),p,1)
      baseline = as.matrix(mvrnorm(1,rep(0,p),sigmax),p,1)
      drg_temp = cbind(matrix(rep(baseline, each = ni),ni,p),drg_temp)
      colnames(drg_temp)[1:p] = paste('X',1:p, sep = '')
      w = rep(t(alpha) %*% baseline,ni)
      drg_temp$w = w
      drg_temp$tt = tt
      bi = mvrnorm(1, c(0,0,0), bi_sigma)
      yi = X%*%(beta_drg+bi+gamma_drg*w[1]) + rnorm(ni,0,sigma_drg)
      drg_temp$y = yi
      dat_drg = rbind(dat_drg, as.data.frame(drg_temp))
    }
    
    dat_pbo = c()
    for(i in 1:n){
      pbo_temp = NULL
      pbo_temp$subj = rep(paste('pbo',i,sep=''),ni)
      pbo_temp$subj2 = rep((n+i), ni)
      pbo_temp$trt = rep('pbo',ni)
      pbo_temp = as.data.frame(pbo_temp)
      #baseline = as.matrix(rnorm(p),p,1)
      baseline = as.matrix(mvrnorm(1,rep(0,p),sigmax),p,1)
      pbo_temp = cbind(matrix(rep(baseline, each = ni),ni,p),pbo_temp)
      colnames(pbo_temp)[1:p] = paste('X',1:p, sep = '')
      w = rep(t(alpha) %*% baseline,ni)
      pbo_temp$w = w
      pbo_temp$tt = tt
      bi = mvrnorm(1, c(0,0,0), (bi_sigma2))
      yi = X%*%(beta_pbo+bi+gamma_pbo*w[1]) + rnorm(ni,0,sigma_pbo)
      pbo_temp$y = yi
      dat_pbo = rbind(dat_pbo, as.data.frame(pbo_temp))
    }
    print('True data generated')
    return(list(dat_drg = dat_drg, dat_pbo = dat_pbo))
  }
  
  KL_lm = function(alpha){
    
    dat_try =  dat_temp
  
    for(wcalculation in 1){
      
      # scale alpha
      alpha = matrix(alpha,p,1)
      alpha = alpha/c(sqrt(t(alpha) %*% alpha))
      alpha = round(alpha, 2)
      
      # calculate W = alpha^T x
      covar_list = dat_try[,paste('X', 1:p, sep='')]
      covar_list = scale(covar_list)
      
      temp_W = unlist(c(covar_list))
      temp_W = matrix(temp_W, dim(dat_try)[1], p)
      dat_try$W = c(temp_W %*% alpha)
      
    }
    
    dat_pbo_est = dat_try[dat_try$trt == 1, ]
    dat_drg_est = dat_try[dat_try$trt == 2, ]
    
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
    xx = matrix(xx, p, dim(dat_try)[1], byrow = TRUE)
    
    # this is the function derivated from the KL-divergence
    A_0 = -2 + 0.5 *  sum(diag(ginv(D1[2:3, 2:3]) %*% D2[2:3, 2:3])) +  0.5 * sum(diag(ginv(D2[2:3, 2:3]) %*% D1[2:3, 2:3]))
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
  
  KL_lm_outcome = function(alpha){
    
    dat_try =  dat_temp
    
    for(wcalculation in 1){
      
      # scale alpha
      alpha = matrix(alpha,p,1)
      alpha = alpha/c(sqrt(t(alpha) %*% alpha))
      alpha = round(alpha, 2)
      
      # calculate W = alpha^T x
      covar_list = dat_try[,paste('X', 1:p, sep='')]
      covar_list = scale(covar_list)
      
      temp_W = unlist(c(covar_list))
      temp_W = matrix(temp_W, dim(dat_try)[1], p)
      dat_try$W = c(temp_W %*% alpha)
      
    }
    
    dat_pbo_est = dat_try[dat_try$trt == 1, ]
    dat_drg_est = dat_try[dat_try$trt == 2, ]
    
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
    
    temp = covar_list 
    xx = as.numeric(unlist(c(temp)))
    xx = matrix(xx, p, dim(dat_try)[1], byrow = TRUE)
    
    beta1 = X %*% beta1; beta2 = X %*% beta2; 
    gamma1 = X %*% gamma1; gamma2 = X %*% gamma2;
    D1 = X[,1:2] %*% D1 %*% t(X[,1:2])
    D2 = X[,1:2] %*% D2 %*% t(X[,1:2])
    
    # this is the function derivated from the KL-divergence
    A_0 = -2 + 0.5 *  sum(diag(ginv(D1) %*% D2)) +  
      0.5 * sum(diag(ginv(D2) %*% D1))
    A_1 = t(beta1 - beta2) %*% (ginv(D1) + ginv(D2)) %*% (beta1 - beta2)
    A_2 = t(gamma1 - gamma2) %*% (ginv(D1) + ginv(D2)) %*% (beta1 - beta2)
    A_3 = t(gamma1 - gamma2) %*% (ginv(D1) + ginv(D2)) %*% (gamma1 - gamma2) 
    
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
  
  KL_lm_outcome2 = function(alpha){
    
    dat_try =  dat_temp
    
    for(wcalculation in 1){
      
      # scale alpha
      alpha = matrix(alpha,p,1)
      alpha = alpha/c(sqrt(t(alpha) %*% alpha))
      alpha = round(alpha, 2)
      
      # calculate W = alpha^T x
      covar_list = dat_try[,paste('X', 1:p, sep='')]
      covar_list = scale(covar_list)
      
      temp_W = unlist(c(covar_list))
      temp_W = matrix(temp_W, dim(dat_try)[1], p)
      dat_try$W = c(temp_W %*% alpha)
      
    }
    
    dat_pbo_est = dat_try[dat_try$trt == 1, ]
    dat_drg_est = dat_try[dat_try$trt == 2, ]
    
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
    
    temp = covar_list 
    xx = as.numeric(unlist(c(temp)))
    xx = matrix(xx, p, dim(dat_try)[1], byrow = TRUE)
    
    beta1 = X %*% beta1; beta2 = X %*% beta2; 
    gamma1 = X %*% gamma1; gamma2 = X %*% gamma2;
    D1 = X[,1:2] %*% D1 %*% t(X[,1:2])
    D2 = X[,1:2] %*% D2 %*% t(X[,1:2])
    
    # this is the function derivated from the KL-divergence
    A_0 = -2 + 0.5 *  sum(diag(ginv(D1) %*% D2)) +  
      0.5 * sum(diag(ginv(D2) %*% D1))
    A_1 = t(beta1 - beta2) %*% (ginv(D1) + ginv(D2)) %*% (beta1 - beta2)
    A_2 = t(gamma1 - gamma2) %*% (ginv(D1) + ginv(D2)) %*% (beta1 - beta2)
    A_3 = t(gamma1 - gamma2) %*% (ginv(D1) + ginv(D2)) %*% (gamma1 - gamma2) 
    
    mu_x = matrix(apply(t(xx), 2, mean), p, 1)
    sigma_x = cov(t(xx))
    
    #lambda0 = max(eigen(sigma_x)$values)
    #n_max = which(eigen(sigma_x)$values == lambda0)
    #est_alpha = eigen(sigma_x)$vectors[,n_max]
    est_alpha = alpha
    est_alpha = matrix(est_alpha, p, 1)
    
    return_res = A_0 + A_1/2 + A_2 %*% t(mu_x) %*% est_alpha + 
      c(A_3/2) * (t(est_alpha) %*% (sigma_x) %*% est_alpha + 
                    t(est_alpha) %*% mu_x %*% t(mu_x) %*% est_alpha)
    
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
  
  true_generation_test = function(alpha, p, n, ni, tt, X, 
                                  beta_drg, gamma_drg, bi_sigma, sigma_drg,
                                  beta_pbo, gamma_pbo, bi_sigma2,sigma_pbo, sigmax){
    # alpha
    # set.seed(123)
    
    alpha = as.matrix(alpha,p,1)
    
    dat_test = c()
    for(i in 1:n){
      temp= NULL
      temp$subj2 = rep(i, ni)
      temp = as.data.frame(temp)
      baseline = as.matrix(mvrnorm(1,rep(0,p),sigmax),p,1)
      temp = cbind(matrix(rep(baseline, each = ni),ni,p),temp)
      colnames(temp)[1:p] = paste('X',1:p, sep = '')
      alpha_temp = alpha/ sqrt(sum(alpha^2))
      w = rep(t(alpha_temp) %*% baseline,ni)
      temp$w = w
      temp$tt = tt
      bi_drg = mvrnorm(1, c(0,0,0), bi_sigma)
      bi_pbo = mvrnorm(1, c(0,0,0), bi_sigma2)
      b_drg = beta_drg+bi_drg+gamma_drg*w[1]
      b_pbo = beta_pbo+bi_pbo+gamma_pbo*w[1]
      e_drg = rnorm(ni,0,1)
      e_pbo = rnorm(ni,0,1)
      yi_drg = X%*%(b_drg) + sigma_drg*e_drg
      yi_pbo = X%*%(b_pbo) + sigma_pbo*e_pbo
      temp$yi_drg = yi_drg
      temp$yi_pbo = yi_pbo
      temp$trt_drg = 2
      temp$trt_pbo = 1
      temp$e_drg = e_drg
      temp$e_pbo = e_pbo
      temp$b_drg1 = b_drg[1]
      temp$b_drg2 = b_drg[2]
      temp$b_drg3 = b_drg[3]
      temp$bi_drg1 = bi_drg[1]
      temp$bi_drg2 = bi_drg[2]
      temp$bi_drg3 = bi_drg[3]
      temp$b_pbo1 = b_pbo[1]
      temp$b_pbo2 = b_pbo[2]
      temp$b_pbo3 = b_pbo[3]
      temp$bi_pbo1 = bi_pbo[1]
      temp$bi_pbo2 = bi_pbo[2]
      temp$bi_pbo3 = bi_pbo[3]
      # dat$trt = ifelse(dat$trt == 'drg', 2, 1)
      dat_test = rbind(dat_test, temp)
    }
    print('Test data generated')
    return(dat_test)
  }
  
  true_generation_test2 = function(alpha, p, n, ni, tt, X, 
                                  beta_drg, gamma_drg, bi_sigma, sigma_drg,
                                  beta_pbo, gamma_pbo, bi_sigma2,sigma_pbo, sigmax){
    # alpha
    # set.seed(123)
    # get the true outcome without random error 
    
    alpha = as.matrix(alpha,p,1)
    
    dat_test = c()
    for(i in 1:n){
      temp= NULL
      temp$subj2 = rep(i, ni)
      temp = as.data.frame(temp)
      baseline = as.matrix(mvrnorm(1,rep(0,p),sigmax),p,1)
      temp = cbind(matrix(rep(baseline, each = ni),ni,p),temp)
      colnames(temp)[1:p] = paste('X',1:p, sep = '')
      alpha_temp = alpha/ sqrt(sum(alpha^2))
      w = rep(t(alpha_temp) %*% baseline,ni)
      temp$w = w
      temp$tt = tt
      bi_drg = mvrnorm(1, c(0,0,0), bi_sigma)
      bi_pbo = mvrnorm(1, c(0,0,0), bi_sigma2)
      b_drg = beta_drg+bi_drg+gamma_drg*w[1]
      b_pbo = beta_pbo+bi_pbo+gamma_pbo*w[1]
      e_drg = rnorm(ni,0,1)
      e_pbo = rnorm(ni,0,1)
      
      yi_drg = X%*%(b_drg) + sigma_drg*e_drg
      yi_pbo = X%*%(b_pbo) + sigma_pbo*e_pbo
      yi_drg_noerror = X%*%(b_drg) 
      yi_pbo_noerror = X%*%(b_pbo) 
      
      temp$yi_drg = yi_drg
      temp$yi_pbo = yi_pbo
      temp$yi_drg_noerror = yi_drg_noerror
      temp$yi_pbo_noerror = yi_pbo_noerror
      
      temp$trt_drg = 2
      temp$trt_pbo = 1
      temp$e_drg = e_drg
      temp$e_pbo = e_pbo
      temp$b_drg1 = b_drg[1]
      temp$b_drg2 = b_drg[2]
      temp$b_drg3 = b_drg[3]
      temp$bi_drg1 = bi_drg[1]
      temp$bi_drg2 = bi_drg[2]
      temp$bi_drg3 = bi_drg[3]
      temp$b_pbo1 = b_pbo[1]
      temp$b_pbo2 = b_pbo[2]
      temp$b_pbo3 = b_pbo[3]
      temp$bi_pbo1 = bi_pbo[1]
      temp$bi_pbo2 = bi_pbo[2]
      temp$bi_pbo3 = bi_pbo[3]
      # dat$trt = ifelse(dat$trt == 'drg', 2, 1)
      dat_test = rbind(dat_test, temp)
    }
    print('Test data generated')
    return(dat_test)
  }
  
  true_generation_test3 = function(alpha, p, n, ni, tt, X, 
                                   beta_drg, gamma_drg, bi_sigma, sigma_drg,
                                   beta_pbo, gamma_pbo, bi_sigma2,sigma_pbo, sigmax){
    # alpha
    # set.seed(123)
    # get the true outcome without random error 
    
    alpha = as.matrix(alpha,p,1)
    
    dat_test = c()
    for(i in 1:n){
      temp= NULL
      temp$subj2 = rep(i, ni)
      temp = as.data.frame(temp)
      baseline = as.matrix(mvrnorm(1,rep(0,p),sigmax),p,1)
      temp = cbind(matrix(rep(baseline, each = ni),ni,p),temp)
      colnames(temp)[1:p] = paste('X',1:p, sep = '')
      alpha_temp = alpha/ sqrt(sum(alpha^2))
      w = rep(t(alpha_temp) %*% baseline,ni)
      temp$w = w
      temp$tt = tt
      bi_drg = mvrnorm(1, c(0,0,0), bi_sigma)
      bi_pbo = mvrnorm(1, c(0,0,0), bi_sigma2)
      
      b_drg0 = X%*%(beta_drg+gamma_drg*w[1])
      b_pbo0 = X%*%(beta_pbo+gamma_pbo*w[1])
      
      b_drg = beta_drg+bi_drg+gamma_drg*w[1]
      b_pbo = beta_pbo+bi_pbo+gamma_pbo*w[1]
      
      e_drg = rnorm(ni,0,sigma_drg)
      e_pbo = rnorm(ni,0,sigma_pbo)
      
      yi_drg = X%*%(b_drg) + e_drg
      yi_pbo = X%*%(b_pbo) + e_pbo
      
      yi_drg_noerror = X%*%(b_drg) 
      yi_pbo_noerror = X%*%(b_pbo) 
      
      temp$yi_drg0 = b_drg0
      temp$yi_pbo0 = b_pbo0
      temp$yi_drg = yi_drg
      temp$yi_pbo = yi_pbo
      temp$yi_drg_noerror = yi_drg_noerror
      temp$yi_pbo_noerror = yi_pbo_noerror
      
      temp$trt_drg = 2
      temp$trt_pbo = 1
      temp$e_drg = e_drg
      temp$e_pbo = e_pbo
      temp$b_drg1 = b_drg[1]
      temp$b_drg2 = b_drg[2]
      temp$b_drg3 = b_drg[3]
      temp$bi_drg1 = bi_drg[1]
      temp$bi_drg2 = bi_drg[2]
      temp$bi_drg3 = bi_drg[3]
      temp$b_pbo1 = b_pbo[1]
      temp$b_pbo2 = b_pbo[2]
      temp$b_pbo3 = b_pbo[3]
      temp$bi_pbo1 = bi_pbo[1]
      temp$bi_pbo2 = bi_pbo[2]
      temp$bi_pbo3 = bi_pbo[3]
      # dat$trt = ifelse(dat$trt == 'drg', 2, 1)
      dat_test = rbind(dat_test, temp)
    }
    print('Test data generated')
    return(dat_test)
  }
  
  
  
  KL_lm_fun = function(alpha){
    
    dat_try =  dat_temp
    
    for(wcalculation in 1){
      # scale alpha
      alpha = matrix(alpha,p,1)
      alpha = alpha/c(sqrt(t(alpha) %*% alpha))
      alpha = round(alpha, 2)
      
      # calculate W = alpha^T x
      covar_list = dat_try[,paste('X', 1:p, sep='')]
      covar_list = scale(covar_list)
      
      temp_W = unlist(c(covar_list))
      temp_W = matrix(temp_W, dim(dat_try)[1], p)
      dat_try$W = c(temp_W %*% alpha)
    }
    
    dat_pbo_est = dat_try[dat_try$trt == 1, ]
    dat_drg_est = dat_try[dat_try$trt == 2, ]
    
    fit_pbo_est = myTryCatch(lmer(y ~ tt + I(tt^2) + W + W * tt +
                                    W * I(tt^2) + (tt|subj),
                                  data = dat_pbo_est, REML = FALSE))
    fit_drg_est = myTryCatch(lmer(y ~ tt + I(tt^2) + W + W * tt +
                                    W * I(tt^2) + (tt|subj),
                                  data = dat_drg_est, REML = FALSE))
    
    # beta, gamma, and D matrix
    beta1 = as.matrix(fixef(fit_drg_est$value))[1:3]
    beta1 = X %*% beta1
    beta2 = as.matrix(fixef(fit_pbo_est$value))[1:3] 
    beta2 = X %*% beta2
    gamma1 = as.matrix(fixef(fit_drg_est$value))[4:6] 
    gamma1 = X %*% gamma1
    gamma2 = as.matrix(fixef(fit_pbo_est$value))[4:6] 
    gamma2 = X %*% gamma2
    D1 = as.matrix(VarCorr(fit_drg_est$value)$subj)[1:2, 1:2] 
    D2 = as.matrix(VarCorr(fit_pbo_est$value)$subj)[1:2, 1:2] 
    D1 = Z %*% D1 %*% t(Z )
    D2 = Z %*% D2 %*% t(Z )
    
    est_sigma1 = summary(fit_drg_est$value)$sigma
    est_sigma2 = summary(fit_pbo_est$value)$sigma
    
    D1 = D1 + est_sigma1^2 * diag(1,dim(D1)[1])
    D2 = D2 + est_sigma2^2 * diag(1,dim(D2)[1])
    
    temp = covar_list 
    xx = as.numeric(unlist(c(temp)))
    xx = matrix(xx, p, dim(dat_try)[1], byrow = TRUE)
    
    # this is the function derivated from the KL-divergence
    A_0 = -2 + 0.5 *  sum(diag(ginv(D1[1:7, 1:7]) %*% D2[1:7, 1:7])) + 
      0.5 * sum(diag(ginv(D2[1:7, 1:7]) %*% D1[1:7, 1:7]))
    A_1 = t(beta1[1:7] - beta2[1:7]) %*% (ginv(D1[1:7, 1:7]) + 
                                            ginv(D2[1:7, 1:7])) %*% (beta1[1:7] - beta2[1:7])
    A_2 = t(gamma1[1:7] - gamma2[1:7]) %*% (ginv(D1[1:7, 1:7]) + 
                                              ginv(D2[1:7, 1:7])) %*% (beta1[1:7] - beta2[1:7])
    A_3 = t(gamma1[1:7] - gamma2[1:7]) %*% (ginv(D1[1:7, 1:7]) + 
                                              ginv(D2[1:7, 1:7])) %*% (gamma1[1:7] - gamma2[1:7]) 
    
    mu_x = matrix(apply(t(xx), 2, mean), p, 1)
    sigma_x = cov(t(xx))
    
    est_alpha = alpha
    est_alpha = matrix(est_alpha, p, 1)
    
    return_res = A_0 + A_1/2 + 
      c(A_3/2) * t(est_alpha) %*% (sigma_x) %*% est_alpha
    
    return_res =  c(-return_res)
    
    return(return_res)
  }
  
}


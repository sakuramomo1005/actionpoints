
## result combination 
## simulation 
## cross valiation
## 2020-04-12


kl_m = kl_s = kl_agree_m = kl_agree_s = c()
l_m = l_s = l_agree_m = l_agree_s = c()
pp = ss = aa = c()

for(p in c(2,4)){
  for(sigma0 in c(1,2,10)){
    for(angles in c(0,60,120,180)){
      
      names = paste('~/Desktop/NYU/Research/FDA/10. embarc changescore/simulated/RDatas/sim_embarc_set_',
                    3,'_s_',sigma0,'_p_', p, '_angles_',angles,'.RData', sep='')
      load(names)
      
      print(names)
      pp = c(pp, p); aa = c(aa, angles); ss = c(ss, sigma0)
      
      ######## 
      res = c()
      agreement = c()
      for(j in 1:length(Result$Result_kl)){
        temp = c(); temp2 = c()
        for(i in 1:10){
          restable = Result$Result_kl[[j]]$Restable[[i]]
          restable$realtrue = ifelse(restable$truedrg < restable$truepbo, 2, 1)
          temp2 = c(temp2, sum(restable$realtrue == restable$estgroup)/ dim(restable)[1])
          temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
        }
        res = rbind(res, temp)
        agreement = rbind(agreement, temp2)
      }
      
      kl_m = c(kl_m, mean(apply(res,1,mean, na.rm =TRUE)))
      kl_s = c(kl_s, sd(apply(res,1,mean, na.rm =TRUE)))
      kl_agree_m = c(kl_agree_m, mean(apply(agreement,1,mean)))
      kl_agree_s = c(kl_agree_s, sd(apply(agreement,1,mean)))
      
      ########  
      res = c(); agreement = c()
      for(j in 1:length(Result$Result_linear)){
        temp = c(); temp2 = c()
        for(i in 1:10){
          restable = Result$Result_linear[[j]]$Restable[[i]]
          restable$realtrue = ifelse(restable$drg < restable$pbo, 2, 1)
          temp2 = c(temp2, sum(restable$realtrue == restable$estgroup)/ dim(restable)[1])
          temp = c(temp, mean(restable[restable$truegroup == restable$estgroup,]$changescore))
        }
        res = rbind(res, temp)
        agreement = rbind(agreement, temp2)
      }
      
      l_m = c(l_m, mean(apply(res,1,mean, na.rm =TRUE)))
      l_s = c(l_s, sd(apply(res,1,mean, na.rm =TRUE)))
      l_agree_m = c(l_agree_m, mean(apply(agreement,1,mean)))
      l_agree_s = c(l_agree_s, sd(apply(agreement,1,mean)))
      
    }
  }
}

t1 = data.frame(p = pp, sigma = ss, angle = aa, m = kl_m, s = kl_s, group = 1)
t2 = data.frame(p = pp, sigma = ss, angle = aa, m = l_m, s = l_s, group = 2)



par(oma=c(0,0,2,0))  
par(mfrow=c(3,4))
par(mar=c(4,4,2,1))
m <- matrix(c(1:12,13,13,13,13),nrow = 4,ncol = 4,byrow = TRUE)
layout(mat=m,heights = c(2,2,2,0.8))
count = 0 
for(sigma0 in c(1,2,10)){
  for(p in c(2,4)){
    
    count = count + 1
    if(count %% 4 == 1){
      yy = paste('sigma =', sigma0)
    }else{
      yy = ' '
    }
    if(count < 5){
      mains = paste('p =', p)
    }else{
      mains = ' '
    }
    
    temp1 = t1[t1$p == p & t1$sigma == sigma0, ]
    temp2 = t2[t2$p == p & t2$sigma == sigma0, ]
    plot(c(0,60,120,180), temp1$m,type = 'l', 
         ylim = range(c(t1$m + 1.96*t1$s, t2$m + 1.96*t2$s, t1$m - 1.96*t1$s, t2$m + 1.96*t2$s)), 
         xlab = 'angle',  xaxt = "n",
         ylab = yy, main = mains)
    axis(1, at=c(0,60,120,180), 
         labels = c(0, expression(pi/3), 
                    expression(2*pi/3),
                    expression(pi)))
    points(c(0,60,120,180), temp1$m, pch = 20)
    arrows(c(0,60,120,180), temp1$m - 1.96*temp1$s, 
           c(0,60,120,180), temp1$m + 1.96*temp1$s, 
           length=0.05, angle=90, code=3)
    lines(c(0,60,120,180), rep(0,4), lty = 2, col = 6, lwd = 2)
    
    # linear 
    lines(c(0,60,120,180) + 5, temp2$m, col = 4)
    points(c(0,60,120,180) + 5, temp2$m, pch = 20, col = 4)
    arrows(c(0,60,120,180)+ 5, temp2$m - 1.96*temp2$s, 
           c(0,60,120,180) + 5, temp2$m + 1.96*temp2$s, 
           length=0.05, angle=90, code=3, col = 4)
    
  }
}

oldmar<-par(mar=c(1,1,1,1))
plot.new()
legend(x = "top",inset = 0,
       legend = c("Fix only", "Fix+Random",'Fix+Random+Error','Change Score'), 
       col=c(1,2,4,'darkgreen'), 
       pch=c(20),lty=c(1),
       horiz = TRUE)
par(oldmar)
title(main='Assignment comparison, coefficient, setting 1',outer=T)



tt = data.frame(p = pp, sigma = ss, angle = aa, m = kl_m, s = kl_s, m = l_m, s = l_s,
                m = kl_agree_m, s = kl_agree_s, m = l_agree_m, s = l_agree_s)
tt = round(tt, 3)

colnames(tt) = c('p','sigma','angle', 'mean','sd','mean','sd', 'mean','sd','mean','sd')
linesep = c('', '', '', '\\addlinespace')

kable(tt, "latex", align="c", booktabs=TRUE, escape = F,   
      linesep=linesep,   row.names=FALSE, longtable = T) %>%
  add_header_above(header = c(" " = 1,
                              " " = 1,
                              " " = 1,
                              "longitudinal kl"=2,
                              "change score"=2,
                              "precision kl"=2,
                              "precision change score"=2)) 

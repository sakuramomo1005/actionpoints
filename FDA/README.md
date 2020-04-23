
## 2020-04-23


* trajectory plots -- embarc
   
* trajectory plots -- hcaf

* simulation: 
   + angle between gamma1 and gamam2
   + the length of gamma1 and gamma2; (moving speed)
  
  
   + why the variance of allpbo alldrg are quite small
   




## 2020-04-16

* check the angles between gamma1 and gamma2 for EMBARC dataset with different parameter settings
* check the code: why the "all pbo", "all drug" have so narrow confidence interval?
* try hcaf dataset
* try weighted change score
* how to add longitudinal information? 

## 2020-04-09

* Read park's paper
* Double check the EMBARC results with simulation
* Get the EMBARC dataset with more subjects 
* Double check the code 
* Wrap up 

## 2020-04-02

* IPWE for both decision method, which one is better. 
* double check the comparisons. make sure we are comparing apple to apple. 


## 2020-03-26

1. Since the simulation result is affect a lot by the covariance of the concavity term. Try to fit the LME withtout the random effect of concavity term 
2. Try to calculate the model with outcome directly instead of using coefficnet 
3. For the longitudinal method, try to compare with the fixed effect + random effct, without random error. change the code in data generation. 
4. inverse probablity weighting (IPW) estimation. everybody's change score is the weight. 

* tables in one file
* figures in one file, with different ylim
* write up 

## 2020-03-19

emergency　


## 2020-03-12 

1. The true group decision rule should be the same in the longitudinal method and change score method
2. need analysis of application, the EMBARC data 
cross validation 



## 2020-02-27

1. name of agreement? percentage of correct decision. concordance 
2. derive the variance of beta
3. test the similar between beta, use chi square 

4. whether lower the sample size, there will be a trend that larger sigma will affect the concordance? 
5. try different parameter settings since the intercept dominate the value. 

## 2020-02-20

to do list

1. we will call the linear regression method as change score method 
2. draw the tables of agreements into grahps
3. as dimension increasing, two vectors tend to be orthogonal



## 2020-02-13

1. measure the agreement
  + the alpha method, considers the longitutinal effect of the data 
  + try linear regresssion
  + to make decision functions: prediction the group assignment


## 2020-02-06

to do list

1. more scenario, change random error value, make it bigger  
2. more scenario, change the gamma values, make it larger 
3. repor the score, the difference, instead of just report the signa 

random error: pbo 14, drg: 11

## 2020-01-30

to do list

1. draw the true points on the trajectory plots 
2. prediction: generate training set. generate testing set, calculate counterfactor outcome. 
3. use the average tangent slope as the measure
4. ask for the paper
5. try different scenario, change the sigma I larger, make the variance of concavnity smaller


## 2020-01-28

to do list

1. draw the bar plots
2. different metrics for performance measure
    
## 2020-01-21

to do list

1. the variance, has something wrong, use ZDZ + R instead of ZDZ, cos not invertable. 
    + change the name of the theta, to sth else, cos may be mixed up with the theta of alpha,
2. prediction:
    + think about the performance measure. 
    + think about the decision rule
3. read the paper. why beta = hat sigma / hat sigma has a smaller varaince than beta = hat sigma / sigma
    
    

## 2020-01-16

to do list

1. the results go worse as the ridge penalty get larger. How about try a very small ridge penalty 
2. calculate the cosine similarity by using true D, or true beta or true gamma, see which one dominate the results
3. try x() + Zb instead of use the coefficiency. see whether they can get the same estimation of alpha 

solutions: 
1. use ridge penalty, seems not very well
2. pull the D1 = D2
3. let the concavity out. 

results pdf names: 
1. plot with penalty on the covariance matrix debug
2. variance dominate



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

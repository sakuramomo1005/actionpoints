
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

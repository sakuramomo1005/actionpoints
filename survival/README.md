

## 2020-02-26

begin with the simpleset scenarios. 

independent does not mean non informative

need to know or derive the expression and then do simulation, 

How to evaluate the method? 

  + AUC, draw roc curve
  + median covariates's kaplan meier 
  + predict the survival probabiltiy 


later: 
  + other glm link may also work.  or time dependent logistic regression
  + may also separate the time and covariates related to early death and late death 
  + find some famous real dataset, about 3-5, check the prediction effect, i.e. the dataset in mstate package. 
  + try independent first. 


## 2020-02-19

Begin from simple cox ph model

1. beta0 is big, but drop beta0. the model is misspecified
2. beta0 is not only one, it is a vector, each of them are small but the summation is big
3. 

#### questions 

1. why under independent censoring, cox model doesn't fit well? 
2. why logistic model doesnt't fit well? 
3. how to evaluate the cox model, precision of estimation 
4. how to pull out the S0t function


## 2020-02-15

we still need to construct example to let cox model mis-specify the model, otherwise, the KM can still work. 

## 2020-02-12

1. previous results, make it more clear
2. for the table, report the confidence interval, show that the true value is not in the confidence interval,
3. true exp(beta x)
4. look for joint model
5. read yuan ming's paper again, how he did the simulation 


## 2020-02-03

1. goodness fit (check whether the model fit correctly), or parametric goodness fit, model sepecified test
2. book, applied logistic regression Hosmer, (goodness fit of logistic regression)
3. model diagnosis 
4. prediction, live longer than 3 years or not 
5. try male female
6. relaxed assumption 
7. find covariates, significant for m function, not significant for cox model
8. lasso, variable selection, glmnet, fit cox model with variable selection, adaptive lasso, glmnet + binary regression

## 2020-01-21

1. the proof of the relationship, has some problem, check the book, counting process, page 26, 27 the formula
2. organize the example 1, simulation. 
3. the alternative form of the rho? what is it? 
4. upload the results on the dropbox


## 2020-01-16

1. the relationship between rho and our new assumption, it is not if and only if. our assumption is looser. 
2. real data analysis and time dependent ROC
    + try real data, separate to training and testing dataset, fit the model and estimate the auc, roc, other metrics


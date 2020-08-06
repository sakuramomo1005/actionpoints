
# Results Summary 

2020-08-06

## Purity calculation 

We define a longitudinal single index approach for treatment decision rule optimization. The approach is aimed to maximizes the purity, which is calculated based on Kullback Leibler divergence.

[purity calculation file](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/puritycalculation202008.pdf)

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/purity%20calculation.png)

### 1. Check the optimization 

We show it by simulation, that whether the alogrithm could find the optimal alpha value. We simulate dataset with p = 2 dimension of predictors. We calculate the purity with alpha = (cos(theta), sin(theta)). The plot of theta v.s. purity is drawn. 

Note: 

* 1. The estimation of purity can be unstable, which depends on the random effects 
* 2. The theta that maximizes the purity maybe not the true theta that used to generate simulation dataset
    + It depends on the sample size. The true theta and estimated theta are more close to each other when n = 2000 than n = 200. 
    
 ![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig3.png) ![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig4.png)

[more details in result file](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/purityvslikelihood0711.pdf) 

### 2. Control for the random effect

#### Penalty in random effect 

#### Change estimation distribution (coefficient/outcome)


## Treatment Decision 

### 1. Comparison

### 2. Change comparison criterion

### 3. 




## EMBARC

## HCAF

## Variable selection 

### 1. stepwise selection 

### 2. LASSO

#### Iteration by hand

#### Optim function in R

## Optimization based on likelihood 

## GEM model hypothesis test 


[df calculation](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/likelihood%20ratio%20test%20setting%2020200721.pdf)

[simulation result scenario 1](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200728.pdf)

[simulation result scenario 2](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200728-2.pdf)



## Result type 

* proportion of correct decision PCD
* IPWE
* Ellipse movement 
* Trajectory 
   + assignment of the trajectories
   + individual trajectory estimation
 

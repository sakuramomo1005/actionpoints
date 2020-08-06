<img align="left" width="600" height="200" src="https://www.python.org/python-.png">

# Results Summary 

2020-08-06

## 1. Purity calculation 

We define a longitudinal single index approach for treatment decision rule optimization. The approach is aimed to maximizes the purity, which is calculated based on Kullback Leibler divergence.

[purity calculation file](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/puritycalculation202008.pdf)

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/purity%20calculation.png)

### 1.1. Check the optimization 

We show it by simulation, that whether the alogrithm could find the optimal alpha value. We simulate dataset with p = 2 dimension of predictors. We calculate the purity with alpha = (cos(theta), sin(theta)). The plot of theta v.s. purity is drawn. 

Note: 

* 1. The estimation of purity can be unstable, which depends on the random effects 
* 2. The theta that maximizes the purity maybe not the true theta that used to generate simulation dataset
    + It depends on the sample size. The true theta and estimated theta are more close to each other when n = 2000 than n = 200. 
    
 ![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig3.png) ![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig4.png)

[more details in result file](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/purityvslikelihood0711.pdf) 

### 1.2. Control for the random effect

Since we observed several huge purity values, which are caused by 

* LME model does not converge within iteration times
* estimated D is singular
* small estimated D matrix and then corresponding big inverse value of D. 

To solve that, we considered

* Add penalty in random effect: D = D + lambdaI or add a value lambda at the D[3,3]
* Use outcome as the distribution, instead of coefficient


#### 1.2.1. Penalty in random effect 

With the penalty, the estimation of purity can be more smooth (the plot of theta v.s. purity becomes more smooth)

The histogram of estimated theta value: 

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig5.png)

Result files

* [theta v.s. purity plot](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/add_identy_matrix.pdf)
* [histogram of theta](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/plot_with_penalty_on_the_covariance_matrix_debug.pdf)

#### 1.2.2. Change estimation distribution (coefficient/outcome)

If we look at the outcome distribution, the results have the similar performace as using the coefficient as the distribution. 

* The alpha that optimize the purity is the same in those two method
* The plots of theta v.s. purity (p = 2) has similar shape, the outcome one is more smooth. 

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig6.png)

Result files 

* [purity calculation with outcome distribution](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/notes_change_distributions.pdf)
* [results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/change_distribution_20200118.pdf)


## 2. Treatment Decision 

### 2.1. Comparison

### 2.2. Change comparison criterion

### 3. 




## 3. Variable selection 

### 3.1. stepwise selection 

### 3.2. LASSO

#### 3.2.1. Iteration by hand

#### 3.2.2. Optim function in R

## 4. Optimization based on likelihood 

## 5. GEM model hypothesis test 


Results: 

* [df calculation](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/likelihood%20ratio%20test%20setting%2020200721.pdf)
* [simulation result scenario 1](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200728.pdf)
* [simulation result scenario 2](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200728-2.pdf)




## EMBARC

## HCAF

## Result type 

* proportion of correct decision PCD
* IPWE
* Ellipse movement 
* Trajectory 
   + assignment of the trajectories
   + individual trajectory estimation
 

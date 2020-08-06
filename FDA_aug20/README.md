
# Results Summary 

2020-08-06

Table of contents
=================

1. [ Purity calculation. ](#d1)
   * 1.1 [Check the optimization.](#d11)
   * 1.2 [Control for the random effect.](#d12)
       + 1.2.1 [Penalty in random effect.](#d121)
       + 1.2.2 [Change estimation distribution (coefficient/outcome).](#d122)
       
2. [ Treatment Decision. ](#d2)
   * 2.1 [Comparison.](#d21)
   * 2.2 [Change comparison criterion.](#d22)
   * 2.3 [comparison with SIMML](#d23)
   
3. [Variable selection.](#d3)
   * 3.1 [Stepwise selection](#d31)
   * 3.2 [LASSO](#d32)
       + 3.2.1 [Variable selection based on linear change score model](#d321)
       + 3.2.2 [Iteration by hand](#d322)
       + 3.2.3 [Optim function in R](#d323)
   
4. [Optimization based on likelihood. ](#d4)

5. [GEM model hypothesis test](#d5)



<a name="d1"></a>
## 1. Purity calculation 

We define a longitudinal single index approach for treatment decision rule optimization. The approach is aimed to maximizes the purity, which is calculated based on Kullback Leibler divergence.

[purity calculation file](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/puritycalculation202008.pdf)

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/purity%20calculation.png)

<a name="d11"></a>
### 1.1. Check the optimization 

We show it by simulation, that whether the alogrithm could find the optimal alpha value. We simulate dataset with p = 2 dimension of predictors. We calculate the purity with alpha = (cos(theta), sin(theta)). The plot of theta v.s. purity is drawn. 

Note: 

* 1. The estimation of purity can be unstable, which depends on the random effects 
* 2. The theta that maximizes the purity maybe not the true theta that used to generate simulation dataset
    + It depends on the sample size. The true theta and estimated theta are more close to each other when n = 2000 than n = 200. 
    
 <img src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig3.png" width="425"/> <img src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig4.png" width="425"/> 


[more details in result file](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/purityvslikelihood0711.pdf) 

<a name="d12"></a>
### 1.2. Control for the random effect

Since we observed several huge purity values, which are caused by 

* LME model does not converge within iteration times
* estimated D is singular
* small estimated D matrix and then corresponding big inverse value of D. 

To solve that, we considered

* Add penalty in random effect: D = D + lambdaI or add a value lambda at the D[3,3]
* Use outcome as the distribution, instead of coefficient


<a name="d121"></a>
#### 1.2.1. Penalty in random effect 

With the penalty, the estimation of purity can be more smooth (the plot of theta v.s. purity becomes more smooth)

The histogram of estimated theta value: 

<p align="center">
  <img width="600" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig5.png">
</p>

Result files

* [theta v.s. purity plot](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/add_identy_matrix.pdf)
* [histogram of theta](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/plot_with_penalty_on_the_covariance_matrix_debug.pdf)

<a name="d122"></a>
#### 1.2.2. Change estimation distribution (coefficient/outcome)

If we look at the outcome distribution, the results have the similar performace as using the coefficient as the distribution. 

* The alpha that optimize the purity is the same in those two method
* The plots of theta v.s. purity (p = 2) has similar shape, the outcome one is more smooth. 


<p align="center">
  <img width="400" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig6.png">
</p>

Result files 

* [purity calculation with outcome distribution](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/notes_change_distributions.pdf)
* [results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/change_distribution_20200118.pdf)

<a name="d2"></a>
## 2. Treatment Decision 

Firstly we compared the performance of longitudinal single index method with linear change score model. 

We also check the estimated coefficients 

[check coefficients](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/test%20model%20fitting%2020200308.pdf)


<a name="d21"></a>
### 2.1. Comparison

We tried several parameter scenarios. 

The longitudinal single index model has slightly better results than linear change score model. 

The random error sigma does not have big effect on the results.

As the dimension get larger, the cosine similarity gets larger. 

 <img src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig8.png" width="500"/> <img src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig9.png" width="500"/> 
 
 * [comparison](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/debug.pdf)
 * [comparison2](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/debug_agreement3.pdf)

<a name="d22"></a>
### 2.2. Change comparison criterion

To get more significant differences between those methods,  we would like to see the effect of those variance. Therefore, to calculate the change score

* Observed change score: outcome Y is calculated with fixed, random effect and random error
* Only fixed effect:  outcome Y is calculated with fixed effect
* Fixed + random effect:  outcome Y is calculated with fixed and random effect. 

The one with only fixed effect has the best results, since the estimated outcome is also calculated with only fixed effect. 

<p align="center">
  <img width="600" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/fig10.png">
</p>

Derivation: 
[Derivation](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/result20200402.pdf)

Results
[Results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/plot20200402.pdf)

<a name="d23"></a>
### 2.3 comparison with SIMML

<p align="center">
  <img width="600" height="550" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/sim2.png">
</p>


<p align="center">
  <img width="600" height="550" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/cgif.gif">
</p>


<a name="d3"></a>
## 3. Variable selection 

<a name="d31"></a>
### 3.1. Stepwise selection 


[forward](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/forwardselection.pdf)

[backward](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/backward.pdf)

[simulation](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20205021.pdf)

<p align="center">
  <img width="600" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/boxplot.png">
</p>

<a name="d32"></a>
### 3.2. LASSO

<a name="d321"></a>
#### 3.2.1 Variable selection based on linear change score model

We use LASSO for the linear change score method, and use the selected vaiable to work on the ..... the IPWE is not very good. 

<p align="center">
  <img width="600" height="100" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/lasso_on_cs1.png">
</p>

<p align="center">
  <img width="600" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/lasso_on_cs2.png">
</p>

[lasso](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/lassoselection.pdf)

<a name="d322"></a>
#### 3.2.2. Iteration by hand

<a name="d323"></a>
#### 3.2.3. Optim function in R

<p align="center">
  <img width="800" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/lasso_sim_optim.png">
</p>

<a name="d4"></a>
## 4. Optimization based on likelihood 

To maximize the purity, we use the Kullback Leibler divergence. We could also use likelihood function as the criterion. We then compare the two criteria, purity and likelihood function. 

From simulation, 

* likelihood method has quite similar performance as purity method
* likelihood method is more stable than the purity method. 
* We expect that: 
   + when the GEM model is not true, i.e. the drug group and placebo group have different alpha value, the purity method should performance better than the likelihood method, since purity method does not depend on the structrue of model. 

<a name="d5"></a>
## 5. GEM model hypothesis test 

<p align="center">
  <img width="800" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/gemtest.png">
</p>



[different alpha](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200528.pdf)

Results: 

* [df calculation](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/likelihood%20ratio%20test%20setting%2020200721.pdf)
* [simulation result scenario 1](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200728.pdf)
* [simulation result scenario 2](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200728-2.pdf)

## EMBARC

## HCAF

We also checked the HCAF dataset, the longitudinal method has better IPWE than linear change score. 

The ellipse movement has similar performance as EBMARC dataset 

[hcaf results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/hcafplots.html)

## Result type 

* proportion of correct decision PCD
* IPWE
* Ellipse movement 
* Trajectory 
   + assignment of the trajectories
   + individual trajectory estimation
 

# Question 

The optim

when the dimension is large, it dependents on the parameter setting. 

not converge. 


```diff
- How well does the model perform when the single index structure is invalid?  
```

# Likelihood method and different criteria

In terms of the misspecified longitudinal single index model, there are two ways of "misspecification"

* The drug group and placebo group have different alpha value 
* They do not have alpha x structrue at all

Besides the optimization that maximizes the purity, we also consider another method with loglikelihood,

* i.e. maximizes the loglikelihood function

#### Two different alpha for drug group and placebo group

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/largegamma.gif)



#### Likelihood method 

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/likelihood.png)

[more derivation is here](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/penalized_loglikelihood_20200622.pdf) 

#### Comparison between purity method and likelihood method 

We simulation p = 2, with alpha = (cos(theta), sin(theta)). The plot with x-axis as the theta and y-axis as the purity or loglikelihood is drawn below: 

<p align="center">
  <img width="600" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/anglevsresplot1.png">
</p>

[plot of angle vs purity, with small covariance matrix](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/purityvslikelihood0709.pdf)

This plot doesn't have a good shape. This may be becasue the covariance matrix is relative small and have huge inverse matrix. If we change a covariance matrix and re-draw the plot, we have: 

<p align="center">
  <img width="600" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/anglevsresplot2.png">
</p>

[plot of angle vs purity, with large covariance matrix](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/purityvslikelihood0709.pdf)


#### Simulation 

We conduct several simulation to compare the performance of purity method and likelihood method. 

* In simulation 1 

<p align="center">
  <img width="600" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/sim1.png">
</p>

Likelihood and purity methods have quite similar IPWE and PCD


* In simulation 2 

<p align="center">
  <img width="600" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/sim2.png">
</p>

In this sceanrios the likelihood method performs better than purity. However, we expect purity to be better than likelihood method. 

[more simulation settings and results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/different_gamma_20200627.pdf)


* Simulation 3: compare GEM and non GEM model. 

GEM model has the same alpha in drug and placebo group. Non-GEM model has different alpha in drug and placebo group data generation. 

<p align="center">
  <img width="600" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/sim3.png">
</p>

[more results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/gem-and-non-gem-model-20200628.pdf)

The likelihood and purity have similar results no matter whether the GEM model is true or not. 

The results are similar in some other simulation settings: 
[more simulation](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/results-ipwe-0630.pdf)


#### Criteria 

Firstly we considered using the mean change score as the criterion. 

Calculating the weighted intergal value, or weighted ATS (average tangent slope) may catch more information for the trajectories. 

Therefore, we set the following criteria for IPWE comparison. 

<p align="left">
  <img width="800" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/criteria.png">
</p>

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/criteria%20ipwe.png)

#### Simulation results

With different IPWEs, the performances are quite similar 

<p align="center">
  <img width="800" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/ipwe-criteria1.png">
</p>

<p align="center">
  <img width="800" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/ipwe-criteria2.png">
</p>

[more results are here](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/IPWE-results-20200712.pdf)


#### Summary

From simulation, 

* likelihood method has quite similar performance as purity method
* likelihood method is more stable than the purity method. 
* We expect that: 
   + when the GEM model is not true, i.e. the drug group and placebo group have different alpha value, the purity method should performance better than the likelihood method, since purity method does not depend on the structrue of model. 

However, the results are usually different from our expectation. 

```diff
+ The question is: when purity criterion can have better performance than likelihood criterion? 
```


<p align="center">
  <img width="800" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/method%20compare.png">
</p>

<a name="d5"></a>



## EMBARC data estimation (compare purity / likelihood, different criteria)

<p align="center">
  <img width="500" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/embarc%20likelihood.png">
</p>


## Simulations 


[setting 1](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/different_gamma_20200627.pdf)

[setting 2](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/gem-and-non-gem-model-20200628.pdf)

[setting 3](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/results-ipwe-0630.pdf)

[setting 4, with more criteria](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/results20200708.pdf)

[setting 5, with weighted ATS](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/IPWE-results-20200712.pdf)








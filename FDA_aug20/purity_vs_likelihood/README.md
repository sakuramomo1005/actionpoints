
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

<p align="center">
  <img width="600" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/anglevsresplot1.png">
</p>

<p align="center">
  <img width="600" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/anglevsresplot2.png">
</p>


[plot of angle vs purity, with small covariance matrix](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/purityvslikelihood0709.pdf)

[plot of angle vs purity, with large covariance matrix](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/purityvslikelihood0709.pdf)


## Criteria 

Firstly we considered using the mean change score as the criterion. 

Calculating the weighted intergal value, or weighted ATS (average tangent slope) may catch more information for the trajectories. 

Therefore, we set the following criteria for IPWE comparison. 

![](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/purity_vs_likelihood/Files/criteria.png)


## EMBARC data estimation (compare purity / likelihood, different criteria)











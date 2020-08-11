

For a given dataset, we would like to check whether it has a single index structrue or not, i.e. GEM model, by conducting a likelihood ratio test. 

##### The hypothesis: 

```diff
H0: The data has a GEM structrue, i.e. drug group and placebo group share the same alpha

H1: The data does not have a GEM struectrue. 
```

* If the data is generated from a non-GEM model, we should have a small p value and reject the H0
* If the data is generated from a GEM model, we should have a big p value and accept the H0.

We also want to check, whether the longitudinal method is flexible or not. If it is flexible enough, even if the GEM model assumption is invalid, we may have a high proportion of correct decision. 


##### The model structrue: 

There may have three kinds of structures: 

* GEM model, i.e. drug and placebo group have the same alpha
* Multi-GEM model, i.e. drug group and placebo group have different alpha vector, within each group, the GEM model is correct
* Unrestrict model, i.e. non-GEM model. There does not have single index structures. 


<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/1.png">
</p>

Calculate the degree of freedome: 

<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/2.png">
</p>

[More derivation is here](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/likelihood%20ratio%20test%20setting%2020200721.pdf)

The test statistic is 

-2(L0 - L1)

* If the H0 is true, the distribution of test statistic should follows a chi-square distribution with related degree of freedom 
* If the H0 is true, the distribution of p-value should follows a uniform distribution uni(0,1)


### Results

* The distribution of test statistic and p value when H0 is true: 


<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/6.png">
</p>

[more results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/LRT-simulation-plots-setting1-0722.pdf)

<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/7.png">
</p>

[more results](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/LRT-simulation-plots-setting2-0722.pdf)

The likelihood method has better shape than the purity method.


* The boxplot of the p values 

(compare between GEM, multi-GEM and unrestrict)
<p align="center">
  <img width="800" height="300" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/gem%20compare.png">
</p>

(compare between GEM and unrestrict)
<p align="center">
  <img width="800" height="400" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Figures/gemtest.png">
</p>

[more p-value plots](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/results20200722.pdf)


* IPWE calculation based on different criteria

<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/3.png">
</p>

<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/4.png">
</p>
<p align="center">
  <img width="700" src="https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/5.png">
</p>


[IPWE under different crietria](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/likelihoodratiotest/Files/IPWE-results-20200716.pdf)



* Some other results 

When multi GEM mode is generated, i.e., different alpha for two groups. 

[different alpha](https://github.com/sakuramomo1005/actionpoints/blob/master/FDA_aug20/Files/results20200528.pdf)






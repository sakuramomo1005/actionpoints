
```diff
- How well does the model perform when the single index structure is invalid?  
```

In terms of the misspecified longitudinal single index model, there are two ways of "misspecification"

* The drug group and placebo group have different alpha value 
* They do not have alpha x structrue at all


latexImg = function(latex){

    link = paste0('http://latex.codecogs.com/gif.latex?',
           gsub('\\=','%3D',URLencode(latex)))

    link = gsub("(%..)","\\U\\1",link,perl=TRUE)
    return(paste0('![](',link,')'))
}

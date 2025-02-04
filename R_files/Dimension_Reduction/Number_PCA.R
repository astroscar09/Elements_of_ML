#### This file is for an illustration of determining the number of principal components in PCA

library(ggplot2)
library(tidyr)
library(dplyr)

#################### Mtcars dataset

#### We only consider the numeric variables in mtcars
new_mtcars <- mtcars[,c(-8,-9)]

#### Determine the number of principal components
my_pca_scale <- prcomp(new_mtcars, scale = TRUE)  
#Scale = True is to standardize each predictor, which to make sure that the scale of variables will not have an effect on the output
summary(my_pca_scale)

### We obtain the proportions of variances
my_pca_var = my_pca_scale$sdev^2

my_pca_proportion = my_pca_var/ sum(my_pca_var)

### We plot the proportions of variances
plot(my_pca_proportion, type = "b", xlab = "Principal components", ylab = "Proportion of variances")

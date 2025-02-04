#### This file is for an illustration of PCA with built-in dataset "mtcars"

library(ggplot2)
library(tidyr)
library(dplyr)

#### We only consider the numeric variables in mtcars
new_mtcars <- mtcars[,c(-8,-9)]

#### We take a look at the mean and variance for each feature in the data
apply(new_mtcars, 2, mean) # Mean

apply(new_mtcars, 2, var) # Variance

############################################################# We perform PCA with mtcars where we scale all the features
my_pca_scale <- prcomp(new_mtcars, scale = TRUE)  
#Scale = True is to standardize each predictor, which to make sure that the scale of variables will not have an effect on the output
summary(my_pca_scale)

#### We take a look at the principal components
my_pca_scale$rotation

#### We take a look at data after the projection 
my_pca_scale$x

#### We plot the first two principal components
biplot(my_pca_scale, scale = 0)

########################################################### We perform PCA with mtcars where we do not scale all the features
my_pca_no_scale <- prcomp(new_mtcars, rank = 9)  
summary(my_pca_no_scale)

#### We take a look at the principal components
my_pca_no_scale$rotation

#### We take a look at data after the projection 
my_pca_no_scale$x

#### We plot the first two principal components
biplot(my_pca_no_scale, scale = 0)



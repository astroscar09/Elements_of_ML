#### This file is for an illustration of t-SNE for breast cancer

library(ggplot2)
library(tidyr)
library(dplyr)
library(Rtsne) # This package is for t-SNE 
library(scatterplot3d) # This package is for 3d plot

################################################################################ We load Breast Cancer dataset
breast_cancer = read.csv("breast_cancer.csv", head = TRUE, check.names=FALSE)

### Remove the NA columns
breast_cancer <- breast_cancer[,-33]

################################################################################ We reduce the dimension of data to 2 dimensions

################################################### Performing t-SNE to reduce the dimension of data to 2
breast_cancer_tsne <- Rtsne(breast_cancer[,-c(1,2)], dims = 2, perplexity=150, max_iter = 500)
## dims =  the dimension that we project the data into
## perplexity = to control the variance and the number of neighbors
## max_iter =  the maximum number of iterations for solving the Kullback-Leibler optimization problem

### Take a look at the projected data points
breast_cancer_tsne$Y

### Plot the projected data points
projected_breast_cancer <- as.data.frame(breast_cancer_tsne$Y)

ggplot(projected_breast_cancer, aes(x = V1, y = V2, col = factor(breast_cancer$diagnosis))) +geom_point()

################################################### Performing PCA to reduce the dimension of data to 2
breast_cancer_pca <- prcomp(breast_cancer[,-c(1,2)], scale = TRUE, rank  = 2)
## We use scale = TRUE here as we have quite large differences of the variances among features

### Plot the projected data points from PCA
projected_breast_cancer_pca <- as.data.frame(breast_cancer_pca$x)

ggplot(projected_breast_cancer_pca, aes(x = PC1, y = PC2, col = factor(breast_cancer$diagnosis))) +geom_point()


################################################################################ We reduce the dimension of data to three dimensions

### We turn "B" to 2 and "M" to 1 to plot data in 3d plots later
for (i in 1:nrow(breast_cancer))
{
  if (breast_cancer$diagnosis[i] == "B")
    breast_cancer$diagnosis[i] = 2
  else if (breast_cancer$diagnosis[i] == "M")
    breast_cancer$diagnosis[i] = 1
}

breast_cancer$diagnosis <- as.numeric(breast_cancer$diagnosis)

################################################### Performing PCA to reduce the dimension of data to 3
threedim_breast_cancer_pca <- prcomp(breast_cancer[,-c(1,2)], scale = TRUE, rank  = 3)
## We use scale = TRUE here as we have quite large differences of the variances among features

### Plot the projected data points from PCA
threedim_breast_cancer_pca <- as.data.frame(threedim_breast_cancer_pca$x)
colors <- c("#56B4E9", "#E69F00")
colors <- colors[breast_cancer$diagnosis]
scatterplot3d(x = threedim_breast_cancer_pca$PC1, y = threedim_breast_cancer_pca$PC2, z = threedim_breast_cancer_pca$PC3, pch = 16, angle = 45, color = colors)

################################################### Performing t-SNE to reduce the dimension of data to 3
threedim_breast_cancer_tsne <- Rtsne(breast_cancer[,-c(1,2)], dims = 3, perplexity=100, max_iter = 500)
## dims =  the dimension that we project the data into
## perplexity = to control the variance and the number of neighbors
## max_iter =  the maximum number of iterations for solving the Kullback-Leibler optimization problem

### Plot the projected data points
threedim_breast_cancer_tsne <- as.data.frame(threedim_breast_cancer_tsne$Y)
scatterplot3d(x = threedim_breast_cancer_tsne$V1, y = threedim_breast_cancer_tsne$V2, z = threedim_breast_cancer_tsne$V3, pch = 16, angle = 45, color = colors)





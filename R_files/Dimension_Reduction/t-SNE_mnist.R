#### This file is for an illustration of t-SNE for MNIST

library(ggplot2)
library(tidyr)
library(dplyr)
library(Rtsne) # This package is for t-SNE
library(scatterplot3d) # This package is for 3d plot

################################################################################ We load MNIST dataset
mnist = read.csv("MNIST.csv", head = TRUE, check.names=FALSE)

################################################################################ We reduce the dimension of data to two dimensions

############################################################ Performing t-SNE to reduce the dimension of data to 2
tsne_mnist <- Rtsne(mnist[,-1], dims = 2, perplexity=30, max_iter = 500)
## dims =  the dimension that we project the data into
## perplexity = to control the variance and the number of neighbors
## max_iter =  the maximum number of iterations for solving the Kullback-Leibler optimization problem

### Take a look at the projected data points
tsne_mnist$Y

### Plot the projected data points
projected_mnist <- as.data.frame(tsne_mnist$Y)

ggplot(projected_mnist, aes(x = V1, y = V2, col = factor(mnist$label))) +geom_point()

################################################################ Performing PCA to reduce the dimension of data to 2
pca_mnist <- prcomp(mnist[,-1], rank  = 2)

### Plot the projected data points from PCA
projected_pca_mnist <- as.data.frame(pca_mnist$x)

ggplot(projected_pca_mnist, aes(x = PC1, y = PC2, col = factor(mnist$label))) +geom_point()


################################################################################ We reduce the dimension of data to three dimensions

############################################# We use t-SNE to reduce to three dimensions
threedim_tsne_mnist <- Rtsne(mnist[,-1], dims = 3, perplexity=30, max_iter = 500)
## dims =  the dimension that we project the data into
## perplexity = to control the variance and the number of neighbors
## max_iter =  the maximum number of iterations for solving the Kullback-Leibler optimization problem

### Plot the projected data points
threedim_tsne_mnist <- as.data.frame(threedim_tsne_mnist$Y)

scatterplot3d(x = threedim_tsne_mnist$V1, y = threedim_tsne_mnist$V2, z = threedim_tsne_mnist$V3, pch = 16, angle = 90, color = factor(mnist$label))

################################################################ Performing PCA to reduce the dimension of data to 2
threedim_pca_mnist <- prcomp(mnist[,-1], rank  = 3)

### Plot the projected data points from PCA
threedim_pca_mnist <- as.data.frame(threedim_pca_mnist$x)

scatterplot3d(x = threedim_pca_mnist$PC1, y = threedim_pca_mnist$PC2, z = threedim_pca_mnist$PC3, pch = 16, angle = 90, color = factor(mnist$label))


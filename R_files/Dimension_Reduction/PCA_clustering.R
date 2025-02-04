#### This file is for an illustration of using PCA to visualize clusters from K-means clustering for high dimensional data

library(ggplot2)
library(tidyr)
library(dplyr)
library(MLmetrics)
library(LICORS) #This package includes K-means++
library(ClusterR) #This package includes Gaussian mixtures
library(mixtools) # This packae is used to draw the ellipses

############################################################ We generate data from 3 clusters with 10 dimensions
set.seed(1000)
N = 18000
X <- matrix(rnorm(N), ncol = 20)
Y <- c(rep(-1,N/60), rep(1,N/60), rep(0,N/60))
X[Y == 1,1] = X[Y == 1,1] + 5
X[Y == - 1,2] = X[Y == -1,2] + 5
experiment_data <- data.frame(X=X)

### We look at the variance in each dimension
apply(experiment_data, 2, var)

######################### WITHOUT SCALING - We reduce the dimension of data via PCA to 2 dimensions
my_pca <- prcomp(experiment_data, rank = 2) # rank specifies the maximal number of principal components in PCA
summary(my_pca)

######################## We plot clusters of the new data in two dimensions based on two principal components found by PCA
new_experiment_data <- as.data.frame(my_pca$x)

## Plot the data
ggplot(data = new_experiment_data, aes(x = PC1, y = PC2)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

##### We perform K-means clustering with K = 3 clusters
my_kmeans = kmeans(new_experiment_data, 3, nstart = 20)
my_kmeans$cluster

ggplot(data = new_experiment_data, aes(x = PC1, y = PC2, color = (my_kmeans$cluster))) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

##### We perform Gaussian mixture models with K = 3 clusters
## my_gmm = GMM(new_experiment_data, gaussian_comps = 3, dist_mode = "eucl_dist", "random_spread")

## Visualize Gaussian mixtures
## plot(new_experiment_data, col = "black")
## ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
## ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")
## ellipse(my_gmm$centroids[3,], diag(my_gmm$covariance_matrices[3,]), npoints = 1000, col="green")

######################### WITH SCALING - We reduce the dimension of data via PCA to 2 dimensions
my_scale_pca <- prcomp(experiment_data, scale = TRUE, rank = 2) # rank specifies the maximal number of principal components in PCA
summary(my_pca)

######################## We plot clusters of the new data in two dimensions based on two principal components found by PCA
new_experiment_scale_data <- as.data.frame(my_scale_pca$x)

## Plot the data
ggplot(data = new_experiment_scale_data, aes(x = PC1, y = PC2)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

##### We perform K-means clustering with K = 3 clusters
my_kmeans = kmeans(new_experiment_scale_data, 3, nstart = 20)
my_kmeans$cluster

ggplot(data = new_experiment_scale_data, aes(x = PC1, y = PC2, color = (my_kmeans$cluster))) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

##### We perform Gaussian mixture models with K = 3 clusters
## my_gmm = GMM(new_experiment_data, gaussian_comps = 3, dist_mode = "eucl_dist", "random_spread")

## Visualize Gaussian mixtures
## plot(new_experiment_data, col = "black")
## ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
## ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")
## ellipse(my_gmm$centroids[3,], diag(my_gmm$covariance_matrices[3,]), npoints = 1000, col="green")

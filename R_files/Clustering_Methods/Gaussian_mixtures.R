#### This file is for an illustration of Gaussian mixture models

library(ggplot2)
library(tidyr)
library(dplyr)
library(MLmetrics)
library(ClusterR) #This package includes Gaussian mixtures
library(mixtools) # This packae is used to draw the ellipses

########################################################## We generate data from 3 clusters with good separation
set.seed(1000)
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 6.5
X[Y == - 1,2] = X[Y == -1,2] + 6.5
experiment_data_strong <- data.frame(X=X)

## Plot the data
plot(experiment_data_strong, col = "black")

############################################ Gaussian mixture models

################# We perform Gaussian mixture models with K = 3 clusters
my_gmm = GMM(experiment_data_strong, gaussian_comps = 3, dist_mode = "eucl_dist")
## gaussian_comps = number of clusters (K)
## dist_mode = the choice of distance among data points
##  "eucl_dist" = Euclidean distance, which is the one we have from Gaussian distribution

## Visualize Gaussian mixtures
plot(experiment_data_strong, col = "black")
ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")
ellipse(my_gmm$centroids[3,], diag(my_gmm$covariance_matrices[3,]), npoints = 1000, col="green")


######################## We perform Gaussian mixture models with K = 4 clusters
my_gmm = GMM(experiment_data_strong, gaussian_comps = 4, dist_mode = "eucl_dist")

## Visualize Gaussian mixtures
plot(experiment_data_strong, col = "black")
ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")
ellipse(my_gmm$centroids[3,], diag(my_gmm$covariance_matrices[3,]), npoints = 1000, col="green")
ellipse(my_gmm$centroids[4,], diag(my_gmm$covariance_matrices[4,]), npoints = 1000, col="cyan")

######################### We perform Gaussian mixture models with K = 5 clusters
my_gmm = GMM(experiment_data_strong, gaussian_comps = 5, dist_mode = "eucl_dist")

## Visualize Gaussian mixtures
plot(experiment_data_strong, col = "black")
ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")
ellipse(my_gmm$centroids[3,], diag(my_gmm$covariance_matrices[3,]), npoints = 1000, col="green")
ellipse(my_gmm$centroids[4,], diag(my_gmm$covariance_matrices[4,]), npoints = 1000, col="cyan")
ellipse(my_gmm$centroids[5,], diag(my_gmm$covariance_matrices[5,]), npoints = 1000, col="purple")


######################################################### We now generate data from 3 clusters with poor separation
set.seed(1000)
N = 12000
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 3
X[Y == - 1,2] = X[Y == -1,2] + 5.5
experiment_data_weak <- data.frame(X=X)

## Plot the data
plot(experiment_data_weak, col = "black")

############################################ Gaussian mixture models

###### We perform Gaussian mixture models with K = 2 clusters
my_gmm = GMM(experiment_data_weak, gaussian_comps = 2, dist_mode = "eucl_dist")

## Visualize Gaussian mixtures
plot(experiment_data_weak, col = "black")
ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")

###### We perform Gaussian mixture models with K = 3 clusters
my_gmm = GMM(experiment_data_weak, gaussian_comps = 3, dist_mode = "eucl_dist")

## Visualize Gaussian mixtures
plot(experiment_data_weak, col = "black")
ellipse(my_gmm$centroids[1,], diag(my_gmm$covariance_matrices[1,]), npoints = 1000, col="red") 
ellipse(my_gmm$centroids[2,], diag(my_gmm$covariance_matrices[2,]), npoints = 1000, col="blue")
ellipse(my_gmm$centroids[3,], diag(my_gmm$covariance_matrices[3,]), npoints = 1000, col="green")

############################################ Determine the number of clusters in Gaussian mixture models

######################## Under strong separation setting
my_numbercluster = Optimal_Clusters_GMM(experiment_data_strong, max_clusters = 10, criterion = "BIC", dist_mode = "eucl_dist", plot_data = T)
### max_clusters = the maximum numer of clusters that we consider for the BIC 
### we would like K to be at most 10
### criterion = "BIC" means that we use BIC for the penalized log-likelihood function
### plot_data = T (T = TRUE) means that we would like to plot the values

######################### Under weak separation settings

######### Setting 1
set.seed(1000)
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 3.5
X[Y == - 1,2] = X[Y == -1,2] + 5.5
experiment_data_weak_first <- data.frame(X=X)
plot(experiment_data_weak_first, col = "black")
my_numbercluster = Optimal_Clusters_GMM(experiment_data_weak_first, max_clusters = 10, criterion = "BIC", dist_mode = "eucl_dist", plot_data = T)

########## Setting 2
set.seed(1000)
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 2.5
X[Y == - 1,2] = X[Y == -1,2] + 5.5
experiment_data_weak_second <- data.frame(X=X)
plot(experiment_data_weak_second, col = "black")
my_numbercluster = Optimal_Clusters_GMM(experiment_data_weak_second, max_clusters = 10, criterion = "BIC", dist_mode = "eucl_dist", plot_data = T)

############## Setting 3
set.seed(1000)
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 1.5
X[Y == - 1,2] = X[Y == -1,2] + 5.5
experiment_data_weak_third <- data.frame(X=X)
plot(experiment_data_weak_third, col = "black")
my_numbercluster = Optimal_Clusters_GMM(experiment_data_weak_third, max_clusters = 10, criterion = "BIC", dist_mode = "eucl_dist", plot_data = T)


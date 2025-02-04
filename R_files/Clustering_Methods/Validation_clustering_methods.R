#### This file is for an illustration of issues of clustering methods

library(ggplot2)
library(tidyr)
library(dplyr)
library(MLmetrics)

################### Validation of obtained clusters

######## First set of data
set.seed(1000)
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 3.5
X[Y == - 1,2] = X[Y == -1,2] + 6.5
experiment_data_first <- data.frame(X=X)

ggplot(data = experiment_data_first, aes(x = X[,2], y = X[,1])) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

#### We use K-means with 3 clusters
my_kmeans_first = kmeans(experiment_data_first, 3, nstart = 20)

my_kmeans_first$cluster

## Plot the clustering results with 3 clusters
ggplot(data = experiment_data_first, aes(x = X[,2], y = X[,1], color = (my_kmeans_first$cluster))) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

############## Second set of data
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 3.5
X[Y == - 1,2] = X[Y == -1,2] + 6.5
experiment_data_second <- data.frame(X=X)

ggplot(data = experiment_data_second, aes(x = X[,2], y = X[,1])) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

#### We use K-means with 3 clusters
my_kmeans_second = kmeans(experiment_data_second, 3, nstart = 20)

## Plot the clustering results with 3 clusters
ggplot(data = experiment_data_second, aes(x = X[,2], y = X[,1], color = (my_kmeans_second$cluster))) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

################################ We now compare the set of clusters from first K-means to that from second K-means 

### We obtain the clusters of second dataset via the K-means centers on the first data set
centers_firstKmeans <- my_kmeans_first$centers
distance_mat <- matrix(0, 600, 3)
for (i in 1: 600)
{
  for (j in 1:3)
  {
    distance_mat[i, j] = (experiment_data_second[i,1] - centers_firstKmeans[j,1])^2 + (experiment_data_second[i,2] - centers_firstKmeans[j,2])^2
  }
}

new_clusters <- matrix(0, 600,1)
for (i in 1: 600)
{
  new_clusters[i,1] = which.min(distance_mat[i,])
}

new_clusters <-  as.vector(new_clusters)

#### We switch the order of clusters to deal with label switching between two K-means clustering
my_kmeans_first$centers
my_kmeans_second$centers
for (i in 1: 600)
{
  if (new_clusters[i] == 1)
  {
    new_clusters[i] = 2
  }
  else if (new_clusters[i] == 2)
  {
    new_clusters[i] = 3
  }
  else if (new_clusters[i] == 3)
  {
    new_clusters[i] = 1
  }
}

### Create table of clusters mismatch
table_labels <- table(label_first = new_clusters, label_second = my_kmeans_second$cluster)
table_labels

## Compute ratio of clustering mismatch
ratio_mismatch <- 1 - sum(diag(table_labels))/ sum(table_labels)

  
  
  
  
  





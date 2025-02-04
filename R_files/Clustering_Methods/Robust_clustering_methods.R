#### This file is for an illustration of robustness of clustering methods

library(ggplot2)
library(tidyr)
library(dplyr)
library(MLmetrics)

########################################################################### Robustness of K-means clustering methods
set.seed(1000)
N = 1200
X <- matrix(rnorm(N), ncol = 2)
Y <- c(rep(-1,N/6), rep(1,N/6), rep(0,N/6))
X[Y == 1,1] = X[Y == 1,1] + 1
X[Y == - 1,2] = X[Y == -1,2] + 6
experiment_data <- data.frame(X=X)

ggplot(data = experiment_data, aes(x = X.2, y = X.1)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

################################################################# We randomly add some small noise to 1/5 of the data
set.seed(1000)
random_index <- sample(seq(1:600), 120)
noisy_experiment_data <- experiment_data
noisy_experiment_data[random_index,1] <-  noisy_experiment_data[random_index,1] + rnorm(120, 0, 1)
noisy_experiment_data[random_index,2] <-  noisy_experiment_data[random_index,2] + rnorm(120, 0, 1)

ggplot(data = noisy_experiment_data, aes(x = X.2, y = X.1)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

########### K-means for noisy data
my_kmeans_full = kmeans(noisy_experiment_data, 3, nstart = 20)

ggplot(data = noisy_experiment_data, aes(x = X.2, y = X.1, color = (my_kmeans_full$cluster))) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

########## We now remove all of the noise and perform K-means on the version without noise

### New data set with the indices of noise data
new_experiment_data <- experiment_data[- random_index,]

ggplot(data = new_experiment_data, aes(x = X.2, y = X.1)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

my_kmeans_truncated = kmeans(new_experiment_data, 3, nstart = 20)

### Matching clusters from full data and truncated data
my_kmeans_full$centers
my_kmeans_truncated$centers 
cluster_full <- my_kmeans_full$cluster
cluster_truncated <- my_kmeans_truncated$cluster
for (i in 1:600)
{
  if (cluster_full[i] == 1)
  {
    cluster_full[i] = 2
  }
  else if (cluster_full[i] == 2)
  {
    cluster_full[i] = 1
  }
}

table_labels <- table(label_noisy = cluster_full[-random_index], label_clean = cluster_truncated)
table_labels    
ratio_mismatch <- 1 - sum(diag(table_labels))/ sum(table_labels)

################################################################# We randomly add some quite large noise to 1/5 of the data
set.seed(1000)
random_index_new <- sample(seq(1:600), 120)
large_noisy_experiment_data <- experiment_data
large_noisy_experiment_data[random_index_new,1] <-  large_noisy_experiment_data[random_index_new,1] + rnorm(120, 0, 2)
large_noisy_experiment_data[random_index_new,2] <-  large_noisy_experiment_data[random_index_new,2] + rnorm(120, 0, 2)

ggplot(data = large_noisy_experiment_data, aes(x = X.2, y = X.1)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

########### K-means for quite noisy data
my_kmeans_full_large = kmeans(large_noisy_experiment_data, 3, nstart = 20)

ggplot(data = large_noisy_experiment_data, aes(x = X.2, y = X.1, color = (my_kmeans_full_large$cluster))) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

########## We now remove all of the noise and perform K-means on the version without noise

### New data set with the indices of noise data
new_large_experiment_data <- experiment_data[- random_index_new,]

ggplot(data = new_large_experiment_data, aes(x = X.2, y = X.1)) + geom_point(size = 2) +  theme(legend.position = "none", axis.title.x=element_blank(), axis.title.y=element_blank()) 

my_kmeans_truncated_large = kmeans(new_large_experiment_data, 3, nstart = 20)

### Matching clusters from full data and truncated data
my_kmeans_full_large$centers
my_kmeans_truncated_large$centers 
cluster_full_large <- my_kmeans_full_large$cluster
cluster_truncated_large <- my_kmeans_truncated_large$cluster

table_labels <- table(label_noisy = cluster_full_large[-random_index_new], label_clean = cluster_truncated_large)
table_labels

ratio_mismatch <- 1 - sum(diag(table_labels))/ sum(table_labels)






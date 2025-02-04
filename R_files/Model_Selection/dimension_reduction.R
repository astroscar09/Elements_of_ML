#### This file is for an illustration of PCA with built-in dataset "mtcars"

library(ggplot2)
library(tidyr)
library(dplyr)
library(MLmetrics)
library(glmnet)

#### Install useful packages to visualize PCA
install.packages("pls")
library(pls)

#### We only consider the numeric variables in mtcars
new_mtcars <- mtcars[,c(-8,-9)]

#### We create training and test sets
set.seed(1000)
sample_size <- floor(0.75 * nrow(new_mtcars))

train_index <- sample(seq_len(nrow(new_mtcars)), size = sample_size)
mtcars_train <- new_mtcars[train_index,]
mtcars_test <- new_mtcars[-train_index,]

#### We perform PCA with mtcars on the training set
my_pca <- pcr(mpg~., data = mtcars_train, scale = TRUE, validation = "CV")  
#Scale = True is to standardize each predictor, which to make sure that the scale of variables will not have an effect on the output
#validation = "CV" means that we perform 10-fold cross-validation for each value of M, the number of principal components
summary(my_pca)

#### Plot the cross-validation errors
validationplot(my_pca, val.type = "MSEP")

#### We compute the root mean square error on the test data for the number of components 
### that give the lowest CV in the training data
mpg_predict <- predict(my_pca, mtcars_test, ncomp = 3)

RMSE(mpg_predict, mtcars_test$mpg)

#################################### Comparing to Linear model
my_lm <- lm(mpg~., data = mtcars_train)
lm_predict <- predict(my_lm, mtcars_test)

RMSE(lm_predict, mtcars_test$mpg)

#################################### Comparing to the Lasso

########### The Lasso
M = 100 # number of values of lambda
lambda_val <- seq(0,10, length = M) # sequence of values of lambda
rmse_out_val <- matrix(0, nrow = M, ncol = 1)

response_train_val <- mtcars_train$mpg
predictors_train_val <- model.matrix(mpg~.,mtcars_train)[,-1]
response_test_val <- mtcars_test$mpg
predictors_test_val <- model.matrix(mpg~.,mtcars_test)[,-1]
  
for (j in 1:M)
{
    my_lasso <- glmnet(predictors_train_val, response_train_val, alpha = 1, lambda = lambda_val[j])
    my_lasso_pred <- predict(my_lasso, s = lambda_val[j], predictors_test_val)
    rmse_out_val[j,1] = RMSE(my_lasso_pred, response_test_val)
}

### Finding the best lambda and Plotting the RMSE for different lambda
lambda_best <- lambda_val[which.min(rmse_out_val)]  #### Finding the best lambda

new_rmse_out_val <- as.data.frame(rmse_out_val)
plot <- ggplot(data = new_rmse_out_val, aes(x = lambda_val))
plot <- plot + geom_line( aes_string( y = new_rmse_out_val[,1]), col = 3)
plot + ylab('rmse_out')

### Compute RMSE at the best lambda
my_best_lasso <- glmnet(predictors_test_val,response_test_val, alpha = 1, lambda = lambda_best)
coef(my_best_lasso)

mpg_lasso_predict <- predict(my_best_lasso, s = lambda_best, predictors_test_val)

RMSE(mpg_lasso_predict, response_test_val)



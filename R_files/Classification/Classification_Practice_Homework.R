#### This file is for an illustration of logistic regression with "Heart_disease.csv" data

### First thing to do is load the libraries
library(ggplot2)
library(tidyr)
library(dplyr)
library(FNN)
library(ISLR2)

### Summarize the Weekly Dataset
head(Weekly)

summary(Weekly)

############################## Part (a) Logistic Regression with Y = Direction, X = Lag1 - Lag5 + Volume
my_glm <- glm(Direction~Lag1 + Lag2 + Lag3 + Lag4 + Lag5 + Volume, data = Weekly, family = "binomial")
summary(my_glm)

############################## Part (b) Compute the classification accuracy from the full data
predicted_glm <- predict(my_glm, Weekly, type = "response")
yhat_predict <- ifelse(predicted_glm > 0.5, 1, 0)

table_direction <- table(y = Weekly$Direction, yhat = yhat_predict)
table_direction

accuracy_direction <- sum(diag(table_direction))/ sum(table_direction)
accuracy_direction

############################## Part (c) Logistic Regression with Y = Direction, X = Lag2

### Create training data from years 1990 to 2008 and test data from years 2009 and 2010
Weekly_train <- Weekly[which(Weekly$Year != 2009 & Weekly$Year != 2010),]
Weekly_test <- Weekly[which(Weekly$Year == 2009 | Weekly$Year == 2010),]

### Logistic Regression with Y = Direction, X = Lag2
my_glm_train <- glm(Direction~Lag2, data = Weekly_train, family = "binomial")
summary(my_glm_train)

### Classification accuracy on training data
predicted_glm_train <- predict(my_glm_train, Weekly_train, type = "response")
yhat_predict_train <- ifelse(predicted_glm_train > 0.5, 1, 0)

table_direction_train <- table(y = Weekly_train$Direction, yhat = yhat_predict_train)
table_direction_train

accuracy_direction_train <- sum(diag(table_direction_train))/ sum(table_direction_train)
accuracy_direction_train

### Classification accuracy on test data
predicted_glm_test <- predict(my_glm_train, Weekly_test, type = "response")
yhat_predict_test <- ifelse(predicted_glm_test > 0.5, 1, 0)

table_direction_test <- table(y = Weekly_test$Direction, yhat = yhat_predict_test)
table_direction_test

accuracy_direction_test <- sum(diag(table_direction_test))/ sum(table_direction_test)
accuracy_direction_test

############################## Part (d) KNN with Y = Direction, X = Lag2

### Create training data from years 1990 to 2008 and test data from years 2009 and 2010
Weekly_train <- Weekly[which(Weekly$Year != 2009 & Weekly$Year != 2010),]
Weekly_test <- Weekly[which(Weekly$Year == 2009 | Weekly$Year == 2010),]

## We create separate training and test sets for predictors and labels
Weekly_Direction_train <- Weekly_train[,9]
Weekly_Direction_test <- Weekly_test[,9]

Weekly_Lag2_train <- Weekly_train[,3]
Weekly_Lag2_test <- Weekly_test[,3]

# We first try with K = 1
my_knn <- knn(data.frame(Weekly_Lag2_train), data.frame(Weekly_Lag2_test), Weekly_Direction_train, k = 1)
table_knn <- table(my_knn, Weekly_Direction_test)

accuracy_Direction_test <- sum(diag(table_knn))/ sum(table_knn)
accuracy_Direction_test

# We now find the best value of K from 1 to 150
M = 150 # the number of possible values of K
K <- seq(1, M)


accuracy_Direction_test <- rep(0,M)

for (i in 1:M)
{
  my_knn <- knn(data.frame(Weekly_Lag2_train), data.frame(Weekly_Lag2_test), Weekly_Direction_train, k = K[i])
  table_knn <- table(my_knn, Weekly_Direction_test)
  
  accuracy_Direction_test[i] <- sum(diag(table_knn))/ sum(table_knn)
}
max(accuracy_Direction_test)

accuracy_Direction_test <- as.data.frame(accuracy_Direction_test)
ggplot(accuracy_Direction_test, aes(x = K, y = accuracy_Direction_test)) + geom_line(col = "red")














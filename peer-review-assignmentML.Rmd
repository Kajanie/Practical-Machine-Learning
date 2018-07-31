---
title: "Practical Machine learning peer review Project"
author: "Jane"
date: "7/31/2018"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Synopsis
There are a host of new wearable electronic devices which can track the quantity of activity in which a person engages. An unresolved problem, however, is how to determine whether such activity is being done properly. In other words, we would like to know about the quality of activity/exercise, not just the quantity.

The goal of this project is to use data from accelerometer measurements of participants engaged in different classes of physical activity (bicep curls in this case) to predict the manner in which they did the exercise. The participants were each instructed to perform the exercise either properly (Class A) or in a way which replicated 4 common weightlifting mistakes (Classes B, C, D, and E).
This report contains the explanation of how the analysis were done right from downloading and cleaning of the data, model development, confusion matrix, expected out of sample error and the final prediction model.


## Data download, cleaning and preparation
```{r}
#loading necessary packages
library(caret)
library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(RGtk2)
library(rattle)
library(randomForest)

UrlTrain <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
UrlTest  <- "http://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

# download the datasets
trainingData <- read.csv(url(UrlTrain))
testingData  <- read.csv(url(UrlTest))

features <- names(testingData[,colSums(is.na(testingData)) == 0])[8:59]

# Only use features used in testing cases.
trainingData <- trainingData[,c(features,"classe")]
testingData <- testingData[,c(features,"problem_id")]

dim(trainingData); dim(testingData);
```

# Data partitioning
The data partitioning was done on the training data so that we are able to create a model and test it within the training data before validating it using an independent dataset which is in this case the testing dataset.

```{r}
set.seed(12345)

inTrain <- createDataPartition(trainingData$classe, p=0.6, list=FALSE)
training <- trainingData[inTrain,]
testing <- trainingData[-inTrain,]

dim(training)
```

## Algorithmn development
For this project 2 differnt model algorithms are developed. An assessment is then done to determine the model that provides the best out-of-sample accuracty. The models tested are:

1. Decision trees with CART (rpart)
2. Random forest decision trees (rf)

```{r}
#decision trees CART
modFitDT <- rpart(classe ~ ., data = training, method="class")
fancyRpartPlot(modFitDT)
```

```{r}
#Randomforest
set.seed(12345)
modFitRF <- randomForest(classe ~ ., data = training, ntree = 1000)
```

## Prediction of the data on the created validation set( 'testing' file)
```{r}
#prediction using the decision trees
set.seed(12345)
prediction <- predict(modFitDT, testing, type = "class")
confusionMatrix(prediction, testing$classe)
```

```{r}
#Prediction using Random forest
prediction <- predict(modFitRF, testing, type = "class")
confusionMatrix(prediction, testing$classe)
```
## Prediction on the independent dataset
```{r}
predictionDT <- predict(modFitDT, testingData, type = "class")
predictionDT

predictionRF <- predict(modFitRF, testingData, type = "class")
predictionRF
```
## Conclusion
Random forest algorithmn performed well with an accuracy of 0.99 (within the training data) in comparison to the decision trees algorithmn as shown the confusionmatrix. Once the random forest algorithmn was used for prediction in the independent dataset the accuracy was 1. We can therefore conclude that Randomforest is the best method for the given dataset.

#Code for running "random forest" machine learning algorithm to solve the Titanic survivor problem
#Began 09/30/2018, based on Will Stanton's tutorial
#Make sure "caret" and "randomForest" libraries are installed first
library(caret)
library(randomForest)

#Create working directory and input both training and test sets
setwd("~/R/Titanic/")
trainSet <- read.table("train.csv", sep = ",", header = TRUE)
testSet <- read.table("test.csv", sep = ",", header = TRUE)

#Run random forest algorithm and save model
trainSet$Survived <- factor(trainSet$Survived)
set.seed(43)
model <- train(Survived ~ Pclass + Sex + Parch + Fare, data = trainSet, method = "rf", trControl  = trainControl(method = "cv", number = 5))
#We use a model based on Class, Gender, Price, and whether the passenger had dependents/was a dependent
#Model had an accuracy of 0.8316615 within training set

#Clean test set, apply model to test set, append results to it, and create submission file
testSet$Fare <- ifelse(is.na(testSet$Fare), mean(testSet$Fare, na.rm = TRUE), testSet$Fare)
testSet$Survived <- predict(model, newdata = testSet)
submission <- testSet[,c("PassengerId", "Survived")]
write.table(submission, file = "submission.csv", col.names = TRUE, row.names = FALSE, sep = ",")

#This submission scored 0.78468
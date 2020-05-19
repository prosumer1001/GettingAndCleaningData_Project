## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

library(purrr)
library(tidyverse)
library(rio)
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/subject_test.txt")
str(subject_test)
unique(subject_test)

x_text <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/x_test.txt")
str(x_text)
unique(x_text)
View(x_text)
head(x_text)
tail(x_text)
names(x_text)
## The features number of observations is 561, which is the number of variables that the x_text file has.  That means that I need to transpose the features observations into variables.

y_text <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/y_test.txt")
str(y_text)
unique(y_text)

features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/features.txt")
str(features)
unique(features)
View(features)
head(features)
tail(features$V1)
names(features)


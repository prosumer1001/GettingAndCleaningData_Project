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
#View(x_text)
head(x_text)
tail(x_text)
names(x_text)
## The features number of observations is 561, which is the number of variables that the x_text file has.  That means that I need to transpose the features observations into variables.

y_text <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/y_test.txt")
str(y_text)
unique(y_text)

features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/features.txt")
features <- features %>%  # change names of variables and select only the strings
        rename(objectid = "V1", featureNames = "V2") %>%
        select(featureNames)
names(features) # check names
## TODO on 5/19/2020 I left of needing TODO line 33.
## In this spot, before converting the vector string to colnames, run tolower, stringer, and gsub to remove all punctuation and upper case letters
var2 <- c(1:561) # create placeholder container 1
var3 <- c(1:561) # create placeholder container 2
features <- cbind(features, var2) # bind container 1 to features
features <- cbind(features, var3) # bind container 2 to features
features <- features %>% pivot_wider(names_from = featureNames, values_from = var2) # use dplyr pivot_wider to change the strings to column names
features <- features %>% select(-var3) # remove the exta empty container that did not pivot wider
features <- features[0,] # remove all rows from data frame (tibble)
View(features) # check data frame
str(features) # check data frame

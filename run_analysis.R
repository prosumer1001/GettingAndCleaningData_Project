## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

library(purrr)
library(tidyverse)
library(rio)
library(stringr)
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/subject_test.txt")
str(subject_test)
unique(subject_test)

x_text <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/x_test.txt")
str(x_text)
str(features)
unique(x_text)
View(x_text)
head(x_text)
tail(x_text)
View(x_text)
## The features number of observations is 561, which is the number of variables that the x_text file has.  That means that I need to transpose the features observations into variables.

## TODO: process the y_text file
y_text <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/y_test.txt")
str(y_text); View(y_text); head(y_text)
unique(y_text)


features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/features.txt") # import features.txt data into working environment
x_text <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/x_test.txt") # import features.txt data into working environment
features$V2 <- str_replace_all(features$V2, "[[:punct:]]", "") # remove all punctuation and ensure there are no spaces
features$V2 <- tolower(features$V2)  # make all alpha characters lowercase
features <- features %>%  # change names of variables and select only the strings
        rename(objectid = "V1", featureNames = "V2") %>%
        select(featureNames)
names(x_text) <- features$featureNames # make the vector featureNames the column names for x_text
completeDF <- x_text # create new processed dataframe called `completeDF` that will ultimately have all the test data included once processed
export(completeDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completeDF.RData") # save processed data to appropriate directory

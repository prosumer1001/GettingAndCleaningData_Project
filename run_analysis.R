## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

library(purrr)
library(tidyverse)
library(rio)
library(stringr)

## TEST DATA
## Code below creates the `partialtestDF` data frame.
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/subject_test.txt") ## load the subject_text.txt data file
y_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/y_test.txt") ## load the y_test.txt data file

## TODO:  this code goest with line 15.  Below this line I just discovered that I need to implement the trainig and testing data together.  I think the easiest way to do that will be to shuffle the similar files into the partialDF and completeDF, which should make the finalDF the same as it is now except much larger.

## TODO:  Need to write the codebook.
y_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/y_train.txt")
activity_labels <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/activity_labels.txt") ## load the activity_labels.txt data file
# unique(activity_labels)
y_test <- tibble::rowid_to_column(y_test, "ID") ## create a unique variable named `ID` in the y_test for left_join(by = "ID")
subject_test <- tibble::rowid_to_column(subject_test, "ID") ## create a unique variable named `ID` in the subject_test for left_join(by = "ID")
partialtestDF <- left_join(y_test, subject_test, by = "ID") ## left_join y_test and subject_test by = "ID" to make the partialtestDF dataframe
partialtestDF <- partialtestDF %>% rename(factor = V1.x) ## rename the V1.x vairable to `factor` for left_join with activity_labels later
partialtestDF <- partialtestDF %>% rename(subject = V1.y)  ## rename V1.y as the subject number for clarity
activity_labels <- activity_labels %>% rename(factor = V1) ## rename the V1 variable from activity_lables to factor for left_join with partialtestDF
activity_labels <- activity_labels %>% rename(activitycategory = V2) ## rename V2 from activity_labels to acticity_category for clear variable description
# str(list(partialtestDF, activity_labels)) 
partialtestDF <- left_join(partialtestDF, activity_labels, by = "factor"); str(partialtestDF)  ## conduct left_join(by = "factor") for the partialtestDF and activity_lables described above; use str() to review the outcome of the join
sample_n(partialtestDF, 25) ## take a sample of the partialtestDF to make sure that the DF is complete and accurate
export(partialtestDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/partialtestDF.RData") # save processed data to appropriate directory

## Code below creates the `completetestDF` data frame.  This is the complete set of test data, but not the frontmatter data.
features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/features.txt") # import features.txt data into working environment
x_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/x_test.txt") # import features.txt data into working environment
features$V2 <- str_replace_all(features$V2, "[[:punct:]]", "") # remove all punctuation and ensure there are no spaces
features$V2 <- tolower(features$V2)  # make all alpha characters lowercase
features <- features %>%  # change names of variables and select only the strings
        rename(objectid = "V1", featureNames = "V2") %>%
        select(featureNames)
names(x_test) <- features$featureNames # make the vector featureNames the column names for x_test
completetestDF <- x_test # create new processed dataframe called `completetestDF` that will ultimately have all the test data included once processed
export(completetestDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completetestDF.RData") # save processed data to appropriate directory

## Code below creates the `finaltestDF` data frame; this is the final data frame with all front matter for the test subjects.
partialDF <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/partialDF.RData") # import partialDF.RData
completeDF <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completeDF.RData") ## import completeDF.RData
finaltestDF <- left_join(partialDF, completeDF, by = "ID") ## left join by the ID variable
finaltestDF <- finaltestDF %>% rename(activityfactor = factor) ## rename the factor variable to be congruent with dataframe naming convention
finaltestDF <- finaltestDF %>% rename(subjectnumber = subject) ## rename the subject variable to be congruent with dataframe naming convention
finaltestDF <- finaltestDF %>% rename(objectid = ID) ## rename the ID variable to be the objectid variable
str(finaltestDF)
finaltestDF$activityfactor <- as.factor(finaltestDF$activityfactor)
finaltestDF$activitycategory <- as.factor(finaltestDF$activitycategory)
finaltestDF <- finaltestDF %>% select(c(objectid, activityfactor, activitycategory, subjectnumber), everything())
export(finaltestDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/finaltestDF.RData") # save processed data to appropriate directory

## TRAIN DATA
## Code below creates the partialtrainDF


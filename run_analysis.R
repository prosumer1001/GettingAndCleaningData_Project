## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

library(purrr)
library(tidyverse)
library(rio)
library(stringr)
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/subject_test.txt")
str(subject_test)
unique(subject_test)
subject_test
View(subject_test)

x_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/x_test.txt")
str(x_test)
str(features)
unique(x_test)
View(x_test)
head(x_test)
tail(x_test)
View(x_test)
## TODO:  Below to the cutline is the code that makes the partialDF.  The next thing to do is combine the partialDF and the completeDF.  Then all of the steps need to be outlined in the CODEBOOK.Rmd
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/subject_test.txt") ## load the subject_text.txt data file
y_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/y_test.txt") ## load the y_test.txt data file
activity_labels <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/activity_labels.txt") ## load the activity_labels.txt data file
# unique(activity_labels)
y_test <- tibble::rowid_to_column(y_test, "ID") ## create a unique variable named `ID` in the y_test for left_join(by = "ID")
subject_test <- tibble::rowid_to_column(subject_test, "ID") ## create a unique variable named `ID` in the subject_test for left_join(by = "ID")
partialDF <- left_join(y_test, subject_test, by = "ID") ## left_join y_test and subject_test by = "ID" to make the partialDF dataframe
partialDF <- partialDF %>% rename(factor = V1.x) ## rename the V1.x vairable to `factor` for left_join with activity_labels later
partialDF <- partialDF %>% rename(subject = V1.y)  ## rename V1.y as the subject number for clarity
activity_labels <- activity_labels %>% rename(factor = V1) ## rename the V1 variable from activity_lables to factor for left_join with partialDF
activity_labels <- activity_labels %>% rename(activitycategory = V2) ## rename V2 from activity_labels to acticity_category for clear variable description
# str(list(partialDF, activity_labels)) 
partialDF <- left_join(partialDF, activity_labels, by = "factor"); str(partialDF)  ## conduct left_join(by = "factor") for the partialDF and activity_lables described above; use str() to review the outcome of the join
sample_n(partialDF, 25) ## take a sample of the partialDF to make sure that the DF is complete and accurate
## CUT LINE ##
y_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/y_test.txt")
str(y_test); View(y_test); head(y_test)
unique(y_test)




features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/features.txt") # import features.txt data into working environment
x_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/UCIHARDataset/test/x_test.txt") # import features.txt data into working environment
features$V2 <- str_replace_all(features$V2, "[[:punct:]]", "") # remove all punctuation and ensure there are no spaces
features$V2 <- tolower(features$V2)  # make all alpha characters lowercase
features <- features %>%  # change names of variables and select only the strings
        rename(objectid = "V1", featureNames = "V2") %>%
        select(featureNames)
names(x_test) <- features$featureNames # make the vector featureNames the column names for x_test
completeDF <- x_test # create new processed dataframe called `completeDF` that will ultimately have all the test data included once processed
export(completeDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completeDF.RData") # save processed data to appropriate directory

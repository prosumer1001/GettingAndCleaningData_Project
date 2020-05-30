## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

library(tidyverse)
library(rio)
library(stringr)
library(janitor)
## Table of Contents (TOC)
## 1. Import Data
##      A. y_test (TEST LABELS)
##      B. y_train (TRAINING LABELS)
##      C. subject_test (PERSON UNDERGOING TESTING)
##      D. subject_train (PERSON UNDERGOING TRAINING)
##      E. activity_labels (CLASS LABLE LINKED TO ACTIVITY NAME)
## 2. Create untidy data frames
##      A. Create Activity Labels Data Frame for Joining to y_test and y_train
##      B. LEFT JOIN 01 - y_test + activity_labels to make activityDF01 - goes with test data
##      C. LEFT JOIN 02 - y_train + activity_labels to make activityDF02 - goes with training data
##      D. FULL JOIN 01 - activityDF01 + activityDF02 = activityDF (version 1.0)
##      E. FULL JOIN 02 - subject_test + subject_train = subjectDF (version 1.0)
##      F. Create a vector from the features.txt data set. 
##      G. Make the features.txt names into the variable names for the x_train and x_test data frames.

## 3. Create 

## TOC For DFs Created
## 1. Import Data
## 2. Create untidy data frames
## 3. 


## CUT LINE ##
## 1. Import Data
        ## 0. Paths
testpath <- "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test"
trainingpath <- "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/training"
testinertials<- "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals"
traininginertials<- "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/training/InertialSignals"
processeddata <- "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/processed"
        ## A. y_test (TEST LABLES)
y_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/y_test.txt") ## load the y_test.txt data file
y_test <- tibble::rowid_to_column(y_test, "ID") ## create a unique variable named `ID` in the y_test for left_join(by = "ID")
        ## B. y_train (TRAINING LABELS)
y_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/y_train.txt")
y_train <- tibble::rowid_to_column(y_train, "ID") ## create a unique variable named `ID` in the y_train for left_join(by = "ID")
str(y_train)
x_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/x_test.txt") # import features.txt data into working environment
x_test <- tibble::rowid_to_column(x_test, "ID"); names(x_test)
ID <- x_test %>% select(ID); names(ID)
names(x_test)
x_test <- x_test %>% select(-ID); names(x_test)
x_test <- cbind(x_test, ID); names(x_test)
t <- x_test %>% filter(ID == 461)
head(t)
u <- x_test %>% filter(ID == 475)
head(u)
v <- x_test %>% filter(ID == 489)
head(v)
tuv <- rbind(t, u, v)
View(tuv)
tuv <- select(V461, V475, V489)
names(tuv)


x_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/x_train.txt") # import features.txt data into working environment
x_train <- tibble::rowid_to_column(x_train, "ID"); names(x_train)
ID <- x_train %>% select(ID); names(ID)
names(x_train)
x_train <- x_train %>% select(-ID); names(x_train)
x_train <- cbind(x_train, ID); names(x_train)

        ## C. subject_test (TEST)
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/subject_test.txt") ## load the subject_test.txt (the person's ID number that was in the test) data file
subject_test <- tibble::rowid_to_column(subject_test, "ID") ## create a unique variable named `ID` in the subject_test for left_join(by = "ID")
        ## D. subject_train
subject_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/subject_train.txt") ## load the subject_train.txt data file)
subject_train <- tibble::rowid_to_column(subject_train, "ID") ## create a unique variable named `ID` in the subject_train for left_join(by = "ID")

        ## E. activity_lables
activity_labels <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/activity_labels.txt") ## load the activity_labels.txt data file
unique(activity_labels)
features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/features.txt") # import features.txt data into working environment
ID <- "ID"
features <- rbind(features, ID); tail(features)

## END SECTION 1 ##

## 2. Create Activity and Subject Data Frames (activityDF v1.0 and subjectDF v1.0)
##      A. Create Activity Labels Data Frame for Joining to y_test and y_train
y_test <- y_test %>% rename(label = V1) ## rename variable for future join
y_train <- y_train %>% rename(label = V1) ## rename variable for future join
activity_labels <- activity_labels %>% rename(label = V1) ## rename variable for future join
activity_labels <- activity_labels %>% rename(category = V2) ## rename variable for future join
sample_n(activity_labels, 5)

##      B. LEFT JOIN 01 - y_test + activity_labels to make activityDF01 - goes with test data
activityDF01 <- left_join(y_test, activity_labels, by = "label"); str(activityDF01)  ## conduct left_join(by = "factor") for the partialDF and activity_lables described above; use str() to review the outcome of the join
sample_n(activityDF01, 10) ## take a sample of the partialDF to make sure that the DF is complete and accurate
activityDF01 <- activityDF01 %>% rename(testlabel = label) ## rename variable for future join
activityDF01 <- activityDF01 %>% rename(testcategory = category) ## rename variable for future join
sample_n(activityDF01, 5)

##      C. LEFT JOIN 02 - y_train + activity_labels to make activityDF02 - goes with training data
activityDF02 <- left_join(y_train, activity_labels, by = "label"); str(activityDF02)  ## conduct left_join(by = "factor") for the partialDF and activity_lables described above; use str() to review the outcome of the join
sample_n(activityDF02, 10) ## take a sample of the partialDF to make sure that the DF is complete and accurate
activityDF02 <- activityDF02 %>% rename(traininglabel = label)
activityDF02 <- activityDF02 %>% rename(trainingcategory = category)

##      D. FULL JOIN 01 - activityDF01 + activityDF02 = activityDF (version 1.0)
activityDF <- full_join(activityDF01, activityDF02, by = "ID")
# sample_n(activityDF, 25) ## take a sample of the partialDF to make sure that the DF is complete and accurate
# tail(activityDF)

##      E. FULL JOIN 02 - subject_test + subject_train = subjectDF (version 1.0)
subject_test <- subject_test %>% rename(testsubjectid = V1)
subject_train <- subject_train %>% rename(trainingsubjectid = V1)
subjectDF <- full_join(subject_test, subject_train, by = "ID"); sample_n(subjectDF, 5) ## left_join subject_test and subject_train by = "ID" to make subjectDF (version 1.0)
# sample_n(subjectDF, 25) ## take a sample of the partialDF to make sure that the DF is complete and accurate
# tail(subjectDF)

##      F. Create a vector from the features.txt data set. 
##         The vector becomes the variable names for the x_train and x_test in 
##         the next step.
features$V2 <- str_replace_all(features$V2, "[[:punct:]]", "") # remove all punctuation and ensure there are no spaces
features$V2 <- tolower(features$V2)  # make all alpha characters lowercase
features <- features %>%  # change names of variables and select only the strings
        rename(objectid = "V1", featureNames = "V2") %>%
        select(featureNames); sample_n(features, 10)

##      G. Make the features.txt names into the variable names for the x_train and x_test data frames.
names(x_test) <- features$featureNames; head(x_test); names(x_test) # make the vector featureNames the column names for x_test
names(x_train) <- features$featureNames; head(x_train); names(x_train) # make the vector featureNames the column names for x_train
tail(x_test)
tail(x_train)

## END SECTION 2 ##

## 3. Create `observationsDF`

## TODO:  the data frame that captures all of the training and test 
##        observations.  There will be many variables since both the training 
##        and the test data have the same variables--each of which has 561 
##        variables.  This should be done in three primary steps.  
##        Step 1. make the x_train and x_test, untidy, data frames.  
##        Step 2. make the x_train and x_test, tidy, data frames.  
##        Step 3. merge the x_train and x_test, tidy, data frames into the 
##                `completeDF` data frame.


## Code below creates the `completetestDF` data frame.  This is the complete set of test data, but not the frontmatter data.

completetestDF <- x_test # create new processed data frame called `completetestDF` that will ultimately have all the test data included once processed
names(completetestDF)
completetestDF <- completetestDF %>% select(id, everything()); names(completetestDF)
export(completetestDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completetestDF.RData") # save processed data to appropriate directory

completetrainDF <- x_train # create new processed data frame called `completeDF` that will ultimately have all the test data included once processed
completetrainDF
export(completetrainDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completetrainDF.RData")



## Code below creates the `finaltestDF` data frame; this is the final data frame with all front matter for the test subjects.
labelsDF <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/labelsDF.RData") # import labelsDF.RData
completeDF <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/completeDF.RData") ## import completeDF.RData
finaltestDF <- left_join(labelsDF, completeDF, by = "ID") ## left join by the ID variable
finaltestDF <- finaltestDF %>% rename(activityfactor = factor) ## rename the factor variable to be congruent with dataframe naming convention
finaltestDF <- finaltestDF %>% rename(subjectnumber = subject) ## rename the subject variable to be congruent with dataframe naming convention
finaltestDF <- finaltestDF %>% rename(objectid = ID) ## rename the ID variable to be the objectid variable
str(finaltestDF)
finaltestDF$activityfactor <- as.factor(finaltestDF$activityfactor)
finaltestDF$activitycategory <- as.factor(finaltestDF$activitycategory)
finaltestDF <- finaltestDF %>% select(c(objectid, activityfactor, activitycategory, subjectnumber), everything())
export(finaltestDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/finaltestDF.RData") # save processed data to appropriate directory

## TRAIN DATA
## TODO:  Need to write the codebook.


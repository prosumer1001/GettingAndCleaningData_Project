## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

library(tidyverse)
library(rio)
library(stringr)
## Table of Contents (TOC)
## 1. Import Data
##      A. y_test (TEST LABELS)
##      B. y_train (TRAINING LABELS)
##      C. subject_test (PERSON UNDERGOING TESTING)
##      D. subject_train (PERSON UNDERGOING TRAINING)
##      E. activity_labels (CLASS LABLE LINKED TO ACTIVITY NAME)
## 2. Create Activity and Subject Data Frames
##      A. Create Activity Labels Data Frame for Joining to y_test and y_train
##      B. LEFT JOIN 01 - y_test + activity_labels to make activityDF01 - goes with test data
##      C. LEFT JOIN 02 - y_train + activity_labels to make activityDF02 - goes with training data
##      D. FULL JOIN 01 - activityDF01 + activityDF02 = activityDF (version 1.0)
##      E. FULL JOIN 02 - subject_test + subject_train = subjectDF (version 1.0)
## 3. Create 

## TOC For DFs Created
## 1. No DFs created
## 2. activityDF created for future join
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
        ## C. subject_test (TEST)
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/subject_test.txt") ## load the subject_test.txt (the person's ID number that was in the test) data file
subject_test <- tibble::rowid_to_column(subject_test, "ID") ## create a unique variable named `ID` in the subject_test for left_join(by = "ID")
        ## D. subject_train
subject_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/subject_train.txt") ## load the subject_train.txt data file)
subject_train <- tibble::rowid_to_column(subject_train, "ID") ## create a unique variable named `ID` in the subject_train for left_join(by = "ID")
        ## E. activity_lables
activity_labels <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/activity_labels.txt") ## load the activity_labels.txt data file
unique(activity_labels)
        ## F. Test Data > Inertial Signals
                ## Create a Single DataFrame - complete, data object: `specdata`
                ## Create a list of the files in the directory
testfilelist <- fs::dir_ls(testinertials, regexp = "\\.txt$")
str(testfilelist)
testfiles <- testfilelist %>%
        map_dfc(read_tsv)
export(testfiles, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/processed/testfiles.RData")
str(testfiles)
View(testfiles)

        ## G. Training Data > Inertial Signals
bodyaccxtest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/body_acc_x_test.txt"); sample_n(bodyaccxtest, 10); str(bodyaccxtest)
bodyaccytest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/body_acc_y_test.txt"); sample_n(bodyaccytest)
bodyaccztest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/body_acc_z_test.txt"); sample_n(bodyaccztest)
bodygyroxtest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/body_gyro_x_test.txt"); sample_n(bodygyroxtest)
bodygyroytest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/body_gyro_y_test.txt"); sample_n(bodygyroytest)
bodygyroztest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/body_gyro_z_test.txt"); sample_n(bodygyroztest)
totalaccxtest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/total_acc_x_test.txt"); sample_n(totalaccxtest)
totalaccytest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/total_acc_y_test.txt"); sample_n(totalaccytest)
totalaccztest <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/InertialSignals/total_acc_z_test.txt"); sample_n(totalaccztest)

## TODO:  Import these data sets.
        ## H. Observations Data
features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/features.txt ") # import features.txt data into working environment
x_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/x_test.txt") # import features.txt data into working environment
x_training <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/x_train.txt") # import features.txt data into working environment


## TODO:  You need to figure out how these Inertial Signals fit into the broader data frame.  Double check to make sure the assignment calls for all of these Inertial Signals data frames to be integrated into the final data frame.

## END SECTION 1 ##

## 2. Create Activity and Subject Data Frames (activityDF v1.0 and subjectDF v1.0)
##      A. Create Activity Labels Data Frame for Joining to y_test and y_train
y_test <- y_test %>% rename(label = V1) ## rename variable for future join
y_train <- y_train %>% rename(label = V1) ## rename variable for future join
activity_labels <- activity_labels %>% rename(label = V1) ## rename variable for future join
activity_labels <- activity_labels %>% rename(category = V2) ## rename variable for future join

##      B. LEFT JOIN 01 - y_test + activity_labels to make activityDF01 - goes with test data
activityDF01 <- left_join(y_test, activity_labels, by = "label"); str(activityDF01)  ## conduct left_join(by = "factor") for the partialDF and activity_lables described above; use str() to review the outcome of the join
sample_n(activityDF01, 10) ## take a sample of the partialDF to make sure that the DF is complete and accurate
activityDF01 <- activityDF01 %>% rename(testlabel = label) ## rename variable for future join
activityDF01 <- activityDF01 %>% rename(testcategory = category) ## rename variable for future join

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
subjectDF <- full_join(subject_test, subject_train, by = "ID") ## left_join subject_test and subject_train by = "ID" to make subjectDF (version 1.0)
# sample_n(subjectDF, 25) ## take a sample of the partialDF to make sure that the DF is complete and accurate
# tail(subjectDF)

## END SECTION 2 ##

## 3. Create `observationsDF`

## TODO:  the data frame that captures all of the training and test observations.  There will be many variables since both the training and the test data have the same variables--each of which has 561 variables.  This work will make the data frame extremely wide.  When it is done, the data needs to be made tidy by creating a `training` variable and a `test` variable.  I do not yet know how this data frame will marry up with the INERTIAL SIGNALS data.
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


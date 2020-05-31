## Coursera Getting and Cleaning Data
## script name:  run_analysis.R
## Prepared by Nick Thompson
## 17 MAY 2020 - 01 JUN 2020
## See accompanying files:  README.md; CODEBOOK.md

if(T){ # Preamble
ipak <- function(pkg){
        new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
        if (length(new.pkg)) 
                install.packages(new.pkg, dependencies = TRUE)
        sapply(pkg, require, character.only = TRUE)
}
# Install and Load Packages
packages <- c("arsenal",
              "janitor",
              "rio", 
              "stringr",
              "tidyverse")
ipak(packages)
} # Preamble

## Table of Contents (TOC)
##      1. Import Data
##              A. y_test (TEST LABELS)
##              B. y_train (TRAINING LABELS)
##              C. x_test (TEST DATA)
##              D. x_train (TRAINING DATA)
##              E. subject_test (TEST SUBJECTS)
##              F. subject_train (TRAINING SUBJECTS)
##              G. activity_lables (ACTIVITY FACTOR LABELS)
##              H. features (VARIABLE NAMES AS A FEATURES VECTOR)

##      !!!--- SECTION 2 NOT USED ---!!!
##      2. Create FRONT MATTER (Activity and Subject Data Frames) (activityDF v1.0 and subjectDF v1.0)
##              A. Create Activity Labels Data Frame for Joining to y_test and y_train
##              B. LEFT JOIN 01 - y_test + activity_labels to make activityDF01 (TEST DATA)
##              C. LEFT JOIN 02 - y_train + activity_labels to make activityDF02 (TNG DATA)
##              D. FULL JOIN 01 - activityDF01 + activityDF02 = activityDF (version 1.0)
##              E. FULL JOIN 02 - subject_test + subject_train = subjectDF (version 1.0)

##      3. Create the datasets data frames
##              A. Create the rows data frame
##              B. Create the xtestResults and xtrainResults data frames. 

##      4. Add front matter to xtrainResults and xtestResults DFs.
##              A. Build the xtest results DF with front matter
##              B. Build the xtrain results DF with front matter

##      5. Add experimentType column to each DF, "train" for training and
##              A. Add column for experimentType for testing.
##              B. Add column for experimentType for training

##      6. Merge xtrainResults and xtestResults into `completeDF`, a single 
##              A. Rename subjectID variables to be identical for both data frames
##              B. dplyr bind_rows()


## TOC For DFs Created
## 1. Import Data
## 2. Create untidy data frames
## 3. 


## CUT LINE ##
if(T){ ## BEGIN SECTION 1 ##
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
y_test <- y_test %>% rename(factor = "V1"); str(y_test)

        ## B. y_train (TRAINING LABELS)
y_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/y_train.txt")
y_train <- tibble::rowid_to_column(y_train, "ID") ## create a unique variable named `ID` in the y_train for left_join(by = "ID")
str(y_train)
y_train <- y_train %>% rename(factor = "V1"); str(y_train)

        ## C. x_test (TEST DATA)
x_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/x_test.txt") # import features.txt data into working environment
x_test <- tibble::rowid_to_column(x_test, "ID"); names(x_test)
# ID <- x_test %>% select(ID); names(ID)
names(x_test)
# x_test <- x_test %>% select(-ID); names(x_test)
# x_test <- cbind(x_test, ID); names(x_test)

        ## D. x_train (TRAINING DATA)
x_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/x_train.txt") # import features.txt data into working environment
x_train <- tibble::rowid_to_column(x_train, "ID"); names(x_train)
# ID <- x_train %>% select(ID); names(ID)
names(x_train)
# x_train <- x_train %>% select(-ID); names(x_train)
# x_train <- cbind(x_train, ID); names(x_train)

        ## E. subject_test (TEST)
subject_test <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/test/subject_test.txt") ## load the subject_test.txt (the person's ID number that was in the test) data file
subject_test <- tibble::rowid_to_column(subject_test, "ID"); str(subject_test) ## create a unique variable named `ID` in the subject_test for left_join(by = "ID")
subject_test <- subject_test %>% rename(subjecttestID = "V1"); str(subject_test)

        ## F. subject_train
subject_train <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/train/subject_train.txt") ## load the subject_train.txt data file)
subject_train <- tibble::rowid_to_column(subject_train, "ID"); str(subject_train) ## create a unique variable named `ID` in the subject_train for left_join(by = "ID")
subject_train <- subject_train %>% rename(subjecttrainID = "V1"); str(subject_train)

        ## G. activity_lables
activity_labels <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/activity_labels.txt") ## load the activity_labels.txt data file
labelsDF <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/activity_labels.txt") # import labelsDF.RData
labelsDF <- labelsDF %>% rename(ID = "V1")
labelsDF <- labelsDF %>% rename(label = "V2"); str(labelsDF)
labelsDF <- labelsDF %>% mutate(factor = ID); str(labelsDF)
labelsDF <- labelsDF %>% select(ID, factor, label)
export(labelsDF, file = "~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/labels.RData")
labelsDF <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Processed/labels.RData")

        ## H. features
features <- import("~/Documents/gitrepos/DataAnalysis/GettingAndCleaningData_Project/Project/Data/Raw/features.txt"); head(features) # import features.txt data into working environment
ID <- "ID"
features <- rbind(features, ID); names(features); head(features); tail(features); sample_n(features, 10)

} ## END SECTION 1 ##

if(F){ ## BEGIN SECTION 2 ## NOT USED
## 2. Create FRONT MATTER (Activity and Subject Data Frames) (activityDF v1.0 and subjectDF v1.0)
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

} ## END SECTION 2 ## NOT USED

if(T){ ## BEGIN SECTION 3 ##
##      A. Create the rows data frame that will select the correct variables
##         from the x_test and x_train data frames in Section 3.  This step
##         was necessary because when using regex and grep there were duplicate
##         names in the features.txt data frame.  Thus, removing all except
##         the columns specified in the instructions became a necessary
##         pre-condition to successfully creating the test and training
##         data frames.

rows01 <- features %>% filter(grepl("mean",V2)); str(rows01) # create a new df of only the `mean` values (instructions, requirement #2)
# rows01$V1 <- as.numeric(rows01$V1); str(rows01) # make V1 numeric value
rows01 <- rows01 %>% arrange(V1); rows01; str(rows01) # arrange from smallest to largest
rows02 <- features %>% filter(grepl("std", V2)); rows02; str(rows02) # create a new df of only the `sd` values (instructions, requirement #2)
# rows02$V1 <- as.numeric(rows02$V1); str(rows02) # make V1 numeric value
rows02 <- rows02 %>% arrange(V1); str(rows02) # arrange from smallest to largest
rows01 <- rows01 %>% rename(ID = "V1"); rows01; str(rows01) # rename the V1 to ID
rows02 <- rows02 %>% rename(ID = "V1"); rows02; str(rows02) # rename the V1 to ID
rows <- full_join(rows01, rows02, by = "ID"); names(rows); sample_n(rows, 25) # join rows01 & rows02
rows <- as_tibble(rows) # make rows a tibble
rows <- unite(rows, FEATURE, V2.x:V2.y, na.rm = TRUE, remove = TRUE) # unite the columns into a single column
rows <- rows %>% arrange(ID); rows # arrange from smallest to largest
rows <- rows %>% mutate(ID2 = ID); names(rows); rows
rows <- rows %>% select(ID, ID2, FEATURE)
rows$ID <- as.character(rows$ID) # convert each observation to character
str(rows)
rows$ID <- paste("V", rows$ID) # add a `V` to each observation
rows$ID <- gsub(" ", "", rows$ID) # remove all the white spaces
rows$FEATURE <- str_replace_all(rows$FEATURE, "[[:punct:]]", "") # remove all special characters

##      B. Create the xtestResults and xtrainResults data frames with ID column
xtestResults <- select(x_test, .dots = rows$ID); # create df that only includes the mean and std variables for the test results 
names(xtestResults) <- rows$FEATURE; # Make the vector FEATURE the column names for xtestResults
xtestResults <- tibble::rowid_to_column(xtestResults, "ID"); names(xtestResults)

xtrainResults <- select(x_train, .dots = rows$ID); # create df that only includes the mean and std variables for the train results 
names(xtrainResults) <- rows$FEATURE; # Make the vector FEATURE the column names for xtrainResults
xtrainResults <- tibble::rowid_to_column(xtrainResults, "ID"); names(xtrainResults)

} ## END SECTION 3 ##

if(T){## BEGIN SECTION 4 ##
## 4. Add front matter to xtrainResults and xtestResults DFs.
##      Code below creates two data frames: xtestResults & xtrainResults WITH front matter.
##      A. Build the xtest results DF with front matter
frontMatterTest <- left_join(y_test, subject_test, by = "ID"); str(frontMatterTest); names(frontMatterTest)
frontMatterTest <- left_join(frontMatterTest, labelsDF, by = "factor"); str(xtestResults);  names(frontMatterTest)
frontMatterTest <- frontMatterTest %>% rename(ID = ID.x)
frontMatterTest <- frontMatterTest %>% select(-ID.y)
xtestResults <- left_join(frontMatterTest, xtestResults, by = "ID"); str(xtestResults) ## left join by the ID variable

##      B. Build the xtrain results DF with front matter
frontMatterTrain <- left_join(y_train, subject_train, by = "ID"); str(frontMatterTrain); names(frontMatterTrain)
frontMatterTrain <- left_join(frontMatterTrain, labelsDF, by = "factor"); str(xtrainResults);  names(frontMatterTrain)
frontMatterTrain <- frontMatterTrain %>% rename(ID = ID.x)
frontMatterTrain <- frontMatterTrain %>% select(-ID.y)
xtrainResults <- left_join(frontMatterTrain, xtrainResults, by = "ID"); str(xtrainResults) ## left join by the ID variable

# View(xtrainResults)
# View(xtestResults)


} ## END SECTION 4 ##

if(T){ ## BEGIN SECTION 5 ##
##      5. Add experimentType column to each DF, "train" for training and
##              "test" for testing
##      A. Add column for experimentType for testing.
experimentType <- data.frame(experimentType = "test", stringsAsFactors = FALSE)
experimentType <- experimentType %>% slice(rep(1:n(), each=2947)); str(experimentType)
experimentType <- tibble::rowid_to_column(experimentType, "ID"); str(experimentType)
xtestResults <- left_join(xtestResults, experimentType); names(xtestResults)
xtestResults <- xtestResults %>% select(ID, factor, subjecttestID, label, experimentType, everything()); names(xtestResults)

##      B. Add column for experimentType for training
experimentType <- data.frame(experimentType = "train", stringsAsFactors = FALSE)
experimentType <- experimentType %>% slice(rep(1:n(), each=7352)); str(experimentType)
experimentType <- tibble::rowid_to_column(experimentType, "ID"); str(experimentType)
xtrainResults <- left_join(xtrainResults, experimentType); names(xtrainResults)
xtrainResults <- xtrainResults %>% select(ID, factor, subjecttrainID, label, experimentType, everything()); names(xtrainResults)

        } ## END SECTION 5 ##

if(T){ ## BEGIN SECION 6 ##
##      6. Merge xtrainResults and xtestResults into `completeDF`, a single 
##              tidy dataset.

##      A. Rename subjectID variables to be identical for both data frames
##              and verify.
xtestResults <- xtestResults %>% rename(subjectID = "subjecttestID") # rename subjecttestID
xtrainResults <- xtrainResults %>% rename(subjectID = "subjecttrainID") # rename subjectrainID
all_equal(xtestResults, xtrainResults, ignore_col_order = FALSE, ignore_row_order = TRUE) # verify the columns are identical
##      output:  > [1] "Different number of rows" >> Indicates the columns are identical

##      B. dplyr bind_rows()

completeDF <- bind_rows(xtestResults, xtrainResults)
str(completeDF)

} ## END SECTION 6 ##

## TODO:  the data frame that captures the correct training and test 
##        observations (see .  There will be many variables since both the 
##        training and the test data have the same variables--each of which 
##        has 561 variables.  This should be done in three primary steps.  

##        Step 1. make the x_train (-> xtrainResults) and 
##                x_test (-> xtestResults), untidy, data frames - COMPLETE 
##        STEP 2. add front matter to the xtrainResults & xtestResults 
##                DFs - COMPLETE
##        Step 3. make the xtestResults and xtrainResults, tidy, 
##                data frames - COMPLETE  
##        Step 4. merge the xtrainResults and xtestResults, tidy, data 
##                frames into the `completeDF` data frame. - COMPLETE
##        Step 5. write the README.Rmd
##        Step 6. write the CODEBOOK.Rmd






## TRAIN DATA



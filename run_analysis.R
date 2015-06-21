## This script is used to prepare a tidy dataset to be used for later analysis. 
## The steps involved are collection, cleaning & transformation.
## There are two datasets - training & test datasets, which are merged and measurements 
## like mean and standard deviation are extracted from the merged dataset. 

## Prepare a working directory to download the dataset.
if (!file.exists("Course Project")) {dir.create("Course Project")}
if (!file.exists("./Course Project/samsungdata.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./Course Project/samsungdata.zip")
    unzip("./Course Project/samsungdata.zip")
}

## Load the training & test datasets into R tables.

## Load measurements data.
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE, sep="")
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE, sep="")

## Load activity data.
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", header=FALSE, sep="", col.names="activity")
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, sep="", col.names="activity")

## Load subjects data.
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep="", col.names="subject_id")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep="", col.names="subject_id")

## Combine the subject, activity and measurements data into one dataframe.
train_combine <- cbind(train_subject, train_activity, train)
test_combine <- cbind(test_subject, test_activity, test)

## Combine the training & test datasets to form an "all_participants_data" dataset.
all_participants_data <- rbind(train_combine, test_combine)

## --------------------------------------------------------------------------------------
## End of step 1 of the course project. 
## The all_participants_data is the merged dataset.
## --------------------------------------------------------------------------------------

## The next few lines of code are written for extracting the mean and standard deviation
## data of each of the measurements.

## Load the feature files to get the column names for the measurements.
feature_table <- read.table("./UCI HAR Dataset/features.txt", header=FALSE, sep="", col.names=c("feature_id", "feature_name"), as.is=TRUE)

## Load the dplyr library for data manipulation.
library(dplyr)

## Select rows of data from feature table which contain the words "mean()" or "std()".
## Assign this to ft1.
ft1 <- feature_table[grepl("mean()|std()", feature_table$feature_name), ]

## ft1 contains names with words "meanFreq()" which are not required and can be deleted.
## Assign this to ft2.
ft2 <- ft1[!grepl("meanFreq()", ft1$feature_name), ]

## ft2 now has the column numbers and names of all mean and standard deviation measurements.
## This can be used to extract the measurements data from all_participants_data.
## The all_participants data has the subject_id and activity as the first two columns.
## So, in order to select the columns containing the relevant measurement data, 2 need to
## be added to the column numbers.
## The following line extracts the column numbers and adds 2 to each number.
reqdcols <- ft2[ ,1]+2

## Extract only the mean and standard deviation data for all subjects and all activities
## from the merged dataset.
all_participants_mean_std <- select(all_participants_data, subject_id, activity, reqdcols)

## --------------------------------------------------------------------------------------
## End of step 2 of the course project. 
## The all_participants_mean_std is the merged dataset with only the mean and standard
## deviation data of all measurements.
## --------------------------------------------------------------------------------------

## The next set of code is for assigning descriptive activity names to the data in 
## activity_id column of the merged & extracted data.
activity_table <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE, sep="", col.names=c("activity_id", "activity_name"), as.is=TRUE)

## Replace the activity codes (1,2,3,4,5,6) with the activity descriptions in the activity
## column of the merged, extracted dataset by using activity_name column of the
## activity_table.
for (i in 1:nrow(activity_table)) {
    all_participants_mean_std[all_participants_mean_std$activity == i, "activity"] <- activity_table$activity_name[[i]]
}

## --------------------------------------------------------------------------------------
## End of step 3 of the course project. 
## Now, the all_participants_mean_std is the merged & extracted dataset with the activity
## labels replaced with activity descriptions. 
## --------------------------------------------------------------------------------------

## The next lines of code is for renaming the measurement columns of the dataset in 
## previous step.

## Introduce a 3rd column, feature_newname in the extracted feature_table, ft2 to give
## descriptive names to the features. Replace "-" in the feature names with "." while
## creating the feature_newname variable.
## feature_table has all features but ft2 has only the mean and std measurements, 
## hence using ft2
ft2 <- mutate(ft2, feature_newname = gsub("-",".", feature_name))

## Replace abbrreviated texts with descriptive texts with "." in between words.
## Replace function names mean() and std() with mean and std (strip off the parantheses)
ft2[3] <- lapply(ft2[3], function(x) gsub("BodyAcc", "Body.Acceleration", x))
ft2[3] <- lapply(ft2[3], function(x) gsub("GravityAcc", "Gravity.Acceleration", x))
ft2[3] <- lapply(ft2[3], function(x) gsub("BodyGyro", "Body.Angular.Velocity", x))
ft2[3] <- lapply(ft2[3], function(x) gsub("Jerk", ".Jerk", x))
ft2[3] <- lapply(ft2[3], function(x) gsub("Mag", ".Magnitude", x))
ft2[3] <- lapply(ft2[3], function(x) gsub("BodyBody", "Body", x))
ft2[3] <- lapply(ft2[3], function(x) gsub("\\(\\)", "", x))

## Rename the variables V1, V2, V3 etc. in the dataset with the new names of the
## features.
for (j in 1:nrow(ft2)) {
    names(all_participants_mean_std)[j+2] <- ft2$feature_newname[[j]]
}

## --------------------------------------------------------------------------------------
## End of step 4 of the course project. 
## Now, the all_participants_mean_std is the merged & extracted dataset with the activity
## labels replaced with activity descriptions; and variable names renamed with 
## descriptive feature names. 
## --------------------------------------------------------------------------------------

## The next step is to find the average of each extracted measurements for every
## subject & activity combination. For 30 subjects, doing 6 activities each, and
## 66 measurements, the final dataset is expected to contain 180 rows and 68 columns
## (1 for subject_id, 1 for activity and 66 for measurements). This is the wide form
## of tidy dataset. Each row in the final dataset contains values for 1 subject doing
## 1 activity. Every column in the dataset represents a different variable (or attribute) 
## of the data.

final_dataset <- all_participants_mean_std %>% group_by(subject_id, activity) %>% summarise_each(funs(mean))

## --------------------------------------------------------------------------------------
## End of step 5 of the course project. 
## The final_dataset is the tidy dataset in the wide form. 
## --------------------------------------------------------------------------------------

## Create a text file with the tidy dataset.
write.table(final_dataset, file="./UCI HAR Dataset/tidydataset.txt", row.names=FALSE)


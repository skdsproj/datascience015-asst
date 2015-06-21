# datascience015-asst
This repository has been created as part of the datascience-015 course project.
The repository contains an R script run_analysis.R which creates a tidy dataset and a codebook codebook.MD that describes each variable in the tidy dataset.

### Raw data
Raw data available in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The raw data provided represent data collected from the accelerometers from the Samsung Galaxy S smartphone. There are two datasets - train and test. Both together contain data from 30 subjects, each performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). The data captured from the phone has been pre-processed, sampled and filtered, before presenting as a feature vector of 516 variables for every instance. 

The following input files are used for the creation of the tidy dataset

* **X_train.txt** : contains the data for subjects in the training category
* **X_test.txt** : coontains the data or subjects in the test category 

### Project requirements
The course project requirement is to create a tidy dataset that contains the average of only the mean and standard deviation measurements (and not all 516) from the given raw data. The R script run_analysis.R does this and has comments for each of the 5 steps.   

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The final tidy dataset is in the wide form. Each row in the final dataset contains values for 1 subject doing 1 activity. Every column in the dataset represents a different variable (or attribute) of the data.

The text file can be read into a R dataframe with tidydata <- read.table(filepath, header=TRUE) and then viewed with View(tidydata).

If trying to run the script and do not want to download the data, comment out the pieces of code before the line "Load the training & test datasets into R tables."
 
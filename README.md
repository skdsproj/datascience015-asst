# datascience015-asst
This repository has been created as part of the datascience-015 course project.
The repository contains an R script run_analysis.R which creates a tidy dataset and a codebook codebook.MD that describes each variable in the tidy dataset.

### Raw data
Raw data available in https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

The raw data provided represent data collected from the accelerometers from the Samsung Galaxy S smartphone. There are two datasets - train and test. Both together contain data from 30 subjects, each performing six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). The data captured from the phone has been pre-processed, sampled and filtered, before presenting as a feature vector of 516 variables for every instance. 

The following input files are used for the creation of the tidy dataset

* **X_train.txt** : contains the data for subjects in the training category
* **X_test.txt** : contains the data for subjects in the test category 
* **y_train.txt** : contains the activity ids for corresponding data vector in X_train.txt
* **y_test.txt** : contains the activity ids for corresponding data vector in X_test.txt
* **subject_train.txt** : contains the subject ids for corresponding data vector in X_train.txt
* **subject_test.txt** : contains the subject ids for corresponding data vector in X_test.txt
* **features.txt** : contains the feature names (columns) of the data in X_train.txt and X_test.txt
* **activity_labels.txt** : contains the lookup for activity id to activity names

### Project requirements
The course project requirement is to create a tidy dataset that contains the average of only the mean and standard deviation measurements (and not all 516) from the given raw data. The R script run_analysis.R does this and has comments for each of the 5 steps.   

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The first step has been achieved by combining (column binding) data from subject_train, y_train and x_train to get a training dataset; and by combining (column binding) data from subject_test, y_test and x_test to get a test dataset. Then these two datasets are combined (row binding) to get an all participants dataset. 

The second step involves figuring out which features from features.txt are required, since only mean and standard deviation measurements are required. After narrowing down the columns, only the required columns are selected from the all participants data set. 

The third step involves looking up the activity_labels.txt file to get the activity names and replacing the activity ids in the extracted all participants dataset with activity names.

The merged and extracted dataset created from the above steps does not have proper column names as the input data does not have header. So, in the fourth step, the column names V1, V2 etc. are replaced by the corresponding feature name from the features.txt file. While doing so, the column names have been expanded from their abbreviated version to make it more intuitive.

The fifth step calculates the average of all measurements on a per subject per activity basis. With 30 subjects and each performing 6 activities, the fifth step returns 180 rows. The final tidy dataset is in the wide form since the 66 measurements for 1 subject doing 1 activity are in one row. Every column in the dataset represents a different variable (or attribute) of the data.

The text file can be read into a R dataframe with tidydata <- read.table(filepath, header=TRUE) and then viewed with View(tidydata).

If trying to run the script and do not want to download the data, comment out the pieces of code before the line "Load the training & test datasets into R tables."
 
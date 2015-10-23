Getting and Cleaning Data - Course Project

This project involves using data collected from the accelerometers from the Samsung Galaxy S smartphone that are stored in a zip file.

Using data collected from the accelerometers from the Samsung Galaxy S smartphone and stored in a zip file.
An abstract of the data collection can be found at the following link:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The Zip file containing the data collected can be found at the following link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The R script, run_analysis.R, created to review the data, does the following:
It downloads and unzips the zip file of observations (checking to see if it was already done).
It reads in a file containing the activities:
(1 - WALKING, 2 - WALKING_UPSTAIRS, 3 - WALKING_DOWNSTAIRS, 4 - SITTING, 5 - STANDING, 6 - LAYING)

It reads in a file containing 561 features that are measured.  It then extracts only those features which contain 'mean' and 'std' which is a subset of 79 
the original features.  After it alters the feature names so that they are more human readible: -mean becomes Mean, -std becomes StdDev, and the '-()' characters are removed.
It reads in a file, X_train.txt, which contains training measurements.  It uses featuresExtract to subset.
It reads in a file, Y_train.txt, which contains training activities.
It then reads in a file, subject_train.txt, which contains a list of the subjects measured.
The number of rows in the above 3 datasets is then checked to match before they are combined into the trainingDataset.
    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement. 
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names. 
It reads in a file, X_test.txt, which contains test measurements.  It uses featuresExtract to subset.
It reads in a file, Y_test.txt, which contains test activities.
It then reads in a file, subject_test.txt, which contains a list of the test subjects measured.
The number of rows in the above 3 datasets is then checked to match before they are combined into the testDataset.
    Merges the training and the test sets to create one data set.
    Extracts only the measurements on the mean and standard deviation for each measurement. 
    Uses descriptive activity names to name the activities in the data set
    Appropriately labels the data set with descriptive variable names. 

The trainingDataset and testDataset are then merged, with subjectID, activityID, and featureNames becoming the column names for the observations.	
The subjectID and activityID's are converted into factos and the numeric activityID is then replaced with the more readable activity labels.
The merged dataset is then melted so that the average (mean) value of each featureName for each subject and activity pair can be calculated.
Then a tidy dataset is written out. 
The end result is shown in the file tidy.txt
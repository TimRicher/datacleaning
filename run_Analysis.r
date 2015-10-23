library(reshape2)

setwd("C:/Users/TimRicher/Desktop/R/cleaning/myproject")

## Download the dataset, if it hasn't already happened.:
if (!file.exists("getdata_dataset.zip")){
  datasetFileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(datasetFileURL, "getdata_dataset.zip")
}  
## Unzip the dataset, if it hasn't already happened.:
if (!file.exists("UCI HAR Dataset")) { 
  unzip("getdata_dataset.zip") 
}

# Get Activity Labels
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
# Change Labels from Factors to Characters
activityLabels[,2] <- as.character(activityLabels[,2])
# Get Dataset Features
datasetFeatures <- read.table("UCI HAR Dataset/features.txt")
# Change Features from Factors to Characters
datasetFeatures[,2] <- as.character(datasetFeatures[,2])

# Extract only row numbers of the mean and standard deviation measurements from the dataset Features, 
# which are abbreviated with 'mean' and 'std' in the dataset Feature names.
featuresExtract <- grep(".*mean.*|.*std.*", datasetFeatures[,2])

# Extract the corresponding dataset featuresExtract names
featuresExtract.featureNames <- datasetFeatures[featuresExtract,2]

# Alter the datasetFeature names so they are more understandable.
featuresExtract.featureNames = gsub('-mean', 'Mean', featuresExtract.featureNames)
featuresExtract.featureNames = gsub('-std', 'StdDev', featuresExtract.featureNames)
# Remove unnecessary '-()' from datasetFeature names.
featuresExtract.featureNames <- gsub('[-()]', '', featuresExtract.featureNames)

# Load the training dataset, using featuresExtract to subset.
trainingDatasetX <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresExtract]
# Load the training activities dataset.
trainingActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
# Load the training subjects dataset.
trainingSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

# If the number of observations match then column bind the 3 datasets together
if ((nrow(trainingSubjects)==nrow(trainingDatasetX)) & (nrow(trainingDatasetX)==nrow(trainingActivities))) {
   trainingDataset <- cbind(trainingSubjects, trainingActivities, trainingDatasetX)
}

# Load the test dataset, using featuresExtract to subset.
testDatasetX <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresExtract]
# Load the test activities dataset.
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
# Load the test subjects dataset.
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# If the number of observations match then column bind the 3 datasets together
if ((nrow(testSubjects)==nrow(testDatasetX)) & (nrow(testDatasetX)==nrow(testActivities))) {
   testDataset <- cbind(testSubjects, testActivities, testDatasetX)
}

# merge the training and test datasets
trainingAndTestMergeDatasets <- rbind(trainingDataset, testDataset)
# Add labels for the Subject, the Activity, and the extracted feature names
colnames(trainingAndTestMergeDatasets) <- c("subjectID", "activityID", featuresExtract.featureNames)

# Make the subjectID a factor of the dataset
trainingAndTestMergeDatasets$subjectID <- as.factor(trainingAndTestMergeDatasets$subjectID)
# Make the activityID a factor of the dataset, and update with labels to make more readable
trainingAndTestMergeDatasets$activityID <- factor(trainingAndTestMergeDatasets$activityID, levels = activityLabels[,1], labels = activityLabels[,2])

# Melt the data to create a unique id-variable combination.
trainingAndTestMergeDatasets.wide <- melt(trainingAndTestMergeDatasets, id.vars = c("subjectID", "activityID"))
# Take the mean of the variable for the subject and activity ID combination.
trainingAndTestMergeDatasets.mean <- dcast(trainingAndTestMergeDatasets.wide, subjectID + activityID ~ variable, mean)

# Write a tidy dataset that is comma separated.
write.table(trainingAndTestMergeDatasets.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

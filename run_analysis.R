if (!require('dplyr')) install.packages('dplyr'); library('dplyr')
if (!require('tidyr')) install.packages('tidyr'); library('tidyr')

### Getting Data from the url
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

### Loading Data
subjectTrain <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
dataTrain <- read.table(unz(temp,"UCI HAR Dataset/train/X_train.txt"))
activityTrain <- read.table(unz(temp,"UCI HAR Dataset/train/y_train.txt"))
subjectTest <- read.table(unz(temp,"UCI HAR Dataset/test/subject_test.txt"))
dataTest <- read.table(unz(temp,"UCI HAR Dataset/test/X_test.txt"))
activityTest <- read.table(unz(temp,"UCI HAR Dataset/test/y_test.txt"))
featureName <- read.table(unz(temp,"UCI HAR Dataset/features.txt"))
activityLabels <- read.table(unz(temp,"UCI HAR Dataset/activity_labels.txt"))

unlink(temp)

### STEP 1
### Merging the train dataset and test dataset

### Add activity and subject column to the Train set
dataTrainComplete <- cbind(activityTrain,subjectTrain,dataTrain)

### Add activity and subject column to the Train set
dataTestComplete <- cbind(activityTest,subjectTest,dataTest)

### Merge the two set
mergedData <- rbind(dataTrainComplete,dataTestComplete)

### STEP 2
### Extracting only the measurements on the mean and standard deviation for each measurement.

onlyMeanAndStd <- subset(featureName, grepl("mean\\(\\)|std\\(\\)", V2))

FeatureToExtract <- onlyMeanAndStd$V1
FeatureNameToExtract <- onlyMeanAndStd$V2

### Shift indexes to add the feature after the activity and subject variables
FeatureToExtract <- FeatureToExtract + 2

finalData <- mergedData[,c(1,2,FeatureToExtract)]

### STEP 3
### Using descriptive activity names to name the activities in the data set

### Change the activity id to it's corresponding label
for(i in 1:nrow(finalData)){
  finalData[i,"V1"] <- activityLabels[activityLabels$V1 == finalData[i,"V1"],"V2"]
}

### STEP 4 
### Appropriately labels the data set with descriptive variable names. 

### Renaming columns
names(finalData)[1] <- "activity"
names(finalData)[2] <- "subject"

for(i in 3:ncol(finalData)){
  names(finalData)[i] <- FeatureNameToExtract[i-2]
}

### STEP 5
### From the data set in step 4, creates a second, independent tidy data set with 
### the average of each variable for each activity and each subject.

### Group the data by Activity,Subject and calculate the mean 
### Gather the feature variable as one column
TidyDataset <- finalData %>%
  group_by(activity, subject) %>%
  summarise_all(list(~mean(.))) %>%
  gather(feature, average, 3:ncol(finalData))

### Split the feature variable in 3 variable
### The feature, the operation on this feature(mean, std) and the axe used.
vectorOperation <- vector()
vectorAxis <- vector()

for(i in 1:nrow(TidyDataset)){
  x <- strsplit(TidyDataset$feature[i],"-")
  TidyDataset$feature[i] <- x[[1]][1]
  if(grepl("std",x[[1]][2])){
    x[[1]][2] <- "standart deviation" 
  }
  else{
    x[[1]][2] <- "mean"
  }
  vectorOperation <- c(vectorOperation,x[[1]][2])
  vectorAxis <- c(vectorAxis,x[[1]][3])
}

### Bind the new columns
TidyDataset <- cbind(TidyDataset,vectorOperation,vectorAxe)

### Rename headers
TidyDataset <- rename(TidyDataset,featureOperation = ...5, featureAxis = ...6) 

### Rearrange column order
TidyDataset <- TidyDataset[, c(1,2,3,5,6,4)]

### Export the tidyDataset as csv file
write.csv(TidyDataset, file = "TidyDataset.csv")




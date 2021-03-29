# Codebook

	The raw Data used for creating this tidy dataset 
	is available here :https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Tidy dataset information
	Measuring the average value of the signals recorded for the same activity and subject 
	when the mean or standart deviation are performed on the feature.

## Tidy dataset description

### 1: Activity
	The activity performed by the subject when the signal was recorded.
	Categorical data
		- LAYING
		- STANDING
		- SITTING
		- WALKING_DOWNSTAIRS
		- WALKING_UPSTAIRS
		- WALKING

### 2: Subject
	An identifier for the subject performing the activity.
	Continuous data
	
### 3: feature
	The name of the feature from the accelerometer and gyroscope 3-axial.
	Nominal data

### 4: featureOperation
	The operation performed on the feature.
	Categorical data
		- mean
		- standart deviation
		
### 5: featureAxis
	The axis related to the feature (if the feature was related to the gyroscope).
	Categorical data
		- X
		- Y
		- Z
		- NA
		
### 6: average
	The average value for all the signals recorded for the same activity and subject
	Continuous data

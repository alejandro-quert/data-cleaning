# Data Cleaning Course GRade Project

The original data for this project is located here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

An explanation of why, when and where this data was collected can be found here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Introduction:

As a brief introduction to the situation:

- A group of 30 persons were observed while doing six activities wearing an smartphone on the waist. Using the embedded accelerometer and gyroscope, xial linear acceleration and 3-axial angular velocity was captured.
- Subjects was divided into two groups: test and train.
- For every group, this files were generated: X data (variable measures), Y data (activities), Subjects (subjects ids)
- Also, were supplied files containing: variables names, activities labels and variables explanation.

# Goal:

Our goal was to create an script that process the original data and generate a tidy dataset, where every row represents an unique combination of: 
- The observed subject. 
- The activity the subject was doing.
- The measured variable for this user and activity.
- The mean of all measures for this specific user, activity and variable.

As an example, the row:

"1"	"LAYING"	"tBodyAcc-mean()-X"	"0.22159824394"

means: For subject number 1, when LAYING, all measures for variable tBodyAcc-mean()-X have a mean value of 0.22159824394.

# Followed steps:

For this case, we will focus in variables that measure mean and standard deviation. We did the following:

- Create a dataset that groups subject ids, activities and variable measures for test data.
- Create a dataset that groups subject ids, activities and variable measures for train data.
- Replace activities ids for activities labels. Is a more user friendly format.
- Joing test and train data into a single dataset.
- Generate a subset with mean and std columns only (keeping subject and activity columns).
- Generate a tidy dataset using the previous subsetted data.
- Generate a result dataset, with the average of each variable for each activity and each subject.
- Export the result dataset.

# How to run the analysis:

- Download the file run_analysis.R to a folder with write permissions.
- Open R console in admin mode (at least for Windows).
- Change the R working directory to the location where run_analysis.R is.
- Run source("run_analysis.R")
- Run course_project()
- If everything went well, you should see a file named tidy_result.txt.
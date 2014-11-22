Getting and Cleaning Data
=========================

## Course Project

This repository contains an R script for data download and analysis
called run_analysis.R and the associated code book CodeBook.md that
gives details about the original data set, the transformations 
operated by the R script and the tidy data set produced as an output.

The R script does the following:

- It downloads a zipped data set to the current working directory 
from the URL:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

- It creates a subdirectory called 'smartphone' and unzip the data set into it.

- It reads the data files of interest for the test and training 
data sets, prepends three columns to the measurement files with subject id, activity id and activity names and combines the two
resulting data frames into a single data frame with variables 
named according to the feature names present in the original dataset.

- It subsets the data frame to keep only the measurements on the
mean and standard deviation (std) of each measured quantity.

- It modifies the variable names so that they are descriptives
and consistently follow the same standard.

- It creates a new, independent tidy data set with the average of each variable for each activity and each subject.

- It writes this new data set into a txt file.


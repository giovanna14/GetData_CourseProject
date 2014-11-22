## Getting and Cleaning Data - Course Project

## Step 0. Download the zipped dataset and unzip it into a 
## subdirectory of the current working directory

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,"SIIdataset.zip",method="curl",mode="wb")
if(!file.exists("./smartphone")){dir.create("./smartphone")}
unzip("SIIdataset.zip",exdir="./smartphone")

# The file unzipped into a dir "UCI HAR Dataset" containing 
# some general files and the subdirectories "test" and "train"
# with the datafiles. Let's read the various text files into
# alphabetically ordered lists

datadir <- "smartphone/UCI HAR Dataset"
datadirtest <- "smartphone/UCI HAR Dataset/test"
datadirtrain <- "smartphone/UCI HAR Dataset/train"
gen_files <- list.files(datadir,pattern="\\.txt",full.names=TRUE)
test_files <- list.files(datadirtest,pattern="\\.txt",full.names=TRUE)
training_files <- list.files(datadirtrain,pattern="\\.txt",full.names=TRUE)

## Step 1. Merge the training and the test sets to crete one dataset.

#Read activity names (as factors) and their IDs (as integers)

activities <- read.table(gen_files[1],col.names=c("activityID","activityname"))

#Read feature names (as factors) and their consecutive number (as integer);
# "feature names" identify the 561 fields contained in X_test.txt and 
# X_train.txt

features <- read.table(gen_files[3], sep= " ")

# Read test datafiles, assign names to columns and combine them
# into a single data frame called 'testdata', including an additional 
# column with activity names (this anticipates Step 3).

X_test <- read.table(test_files[2])
colnames(X_test) <- features[,2]
subj_act_test <- data.frame(read.table(test_files[1],
                                       col.names=c("subject")),
                            read.table(test_files[3],
                                       col.names=c("activityID"))
)
subj_act_test[,"activityName"] <- activities[match(
      subj_act_test[,"activityID"],
      activities[,"activityID"]),
      "activityname"]
testdata <- cbind(subj_act_test,X_test)

# Read training datafiles, assign names to columns and combine them
# into a single data frame called 'traindata'

X_train <- read.table(training_files[2])
colnames(X_train) <- features[,2]
subj_act_train <- data.frame(read.table(training_files[1],
                                        col.names=c("subject")),
                             read.table(training_files[3],
                                        col.names=c("activityID"))
)
subj_act_train[,"activityName"] <- activities[match(
  subj_act_train[,"activityID"],
  activities[,"activityID"]),
  "activityname"]
traindata <- cbind(subj_act_train,X_train)

# merge 'testdata' and 'traindata' into a single data frame 'alldata'

alldata <- rbind(testdata,traindata)

## Step 2. Extract only the measurements on the mean and standard 
##   deviation for each measurement.

# find columns that contain "mean()" or "std()" and create
# a character vector with the names of all columns to be kept

tomatch <- c(".mean\\(\\)",".std\\(\\)")
selcol <- grep(paste(tomatch,collapse="|"),features[,2],value=TRUE)
mycol <- c("subject","activityName",selcol)

# subset the dataset by keeping the desired columns

subdata <- alldata[,mycol]


## Step 3. Use descriptive activity names to name the activities in the data set.
 
   # already done as part of Step1

## Step 4. Appropriately label the dataset with descriptive variable names.

mycolnew <- gsub("\\-mean\\(\\)\\-","Mean",mycol)
mycolnew <- gsub("\\-std\\(\\)\\-","Std",mycolnew)
mycolnew <- gsub("\\-mean\\(\\)","Mean",mycolnew)
mycolnew <- gsub("\\-std\\(\\)","Std",mycolnew)

colnames(subdata) <- mycolnew

## Step 5. From the dataset in step 4, create a second, independent tidy data 
## set with the average of each variable for each activity and each subject.

library(data.table)
subdata2 <- as.data.table(subdata)
newsubdata <- subdata2[,lapply(.SD,mean,na.rm=TRUE), 
                       by=c("subject","activityName")]
# reorder the rows of the tidy dataset to have the 30 subjects 
# one after the other for each of the activities
setorder(newsubdata,activityName,subject,na.last=FALSE)

## Step 6. Save the tidy data set created in Step 5 as a txt file
## for submission
write.table(newsubdata,file="tidydataset.txt",row.names=FALSE)


library(plyr)
library(reshape2)

#download data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "UCI HAR Dataset.zip", method = "curl")
unzip("UCI HAR Dataset.zip")

#read in data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt") #data contains measurements in test
y_test <- read.table("UCI HAR Dataset/test/y_test.txt") #data contains activity identifier of test
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt") #data contains subject identifier of test

x_train <- read.table("UCI HAR Dataset/train/X_train.txt") #data measured in train
y_train <- read.table("UCI HAR Dataset/train/y_train.txt") #activity identifier of train
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt") #subject identifier of train

#descriptive files
features <- read.table("UCI HAR Dataset/features.txt")
activity_label <- read.table("UCI HAR Dataset/activity_labels.txt")

#replace activity label with descriptive activity name
activity_test <- activity_label[y_test[[1]],]$V2
activity_train <- activity_label[y_train[[1]],]$V2

#select measurements required
mean_std_measurements <- grep("-(mean|std)\\(\\)", features[,2]) #select mean() and std() processed measurements
feature_as_name <- features$V2[mean_std_measurements]

#combine identifier with measurements
test <- cbind(subject_test, activity_test, x_test[,c(mean_std_measurements)])
train <- cbind(subject_train, activity_train, x_train[,c(mean_std_measurements)])

#make same descriptive column names for test and train data set to merge them by rbind()
names(test) <- c("Subject_ID", "Activity", feature_as_name)
names(train)<- c("Subject_ID", "Activity", feature_as_name)
merged_test_train <- rbind(test, train) #merged test and train data set with only mean and standard deviation for each measurement
write.table(merged_test_train, file = "merged_test_train.txt", row.names = FALSE)

#step 5: independent tidy data with the average of each variable for each activity and each subject
average <- dcast(merged_test_train, Subject_ID~Activity, mean)
write.table(average, file = "averge_variable_each_subject_activity.txt", row.names = F)

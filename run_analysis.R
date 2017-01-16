# Downloads and unzips files

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "data.zip", mode = "wb")
unzip(zipfile = "data.zip")

# Loads the package needed for data transformation

library(plyr)

# 1. Merges the training and the test sets to create one data set

xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")
subjectTrain <- read.table("train/subject_train.txt")
xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")
xData <- rbind(xTrain, xTest)
yData <- rbind(yTrain, yTest)
subjectData <- rbind(subjectTrain, subjectTest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")
featuresMeanStd <- grep("-(mean|std)\\(\\)", features[, 2])
xData <- xData[, featuresMeanStd]
names(xData) <- features[featuresMeanStd, 2]

# 3. Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table("activity_labels.txt")
yData[, 1] <- activityLabels[yData[, 1], 2]
names(yData) <- "activity"

# 4. Appropriately labels the data set with descriptive variable names

names(subjectData) <- "subject"
combinedData <- cbind(xData, yData, subjectData)

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

dataAvg <- ddply(combinedData, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(dataAvg, "tidyDataSet.txt", row.name=FALSE)
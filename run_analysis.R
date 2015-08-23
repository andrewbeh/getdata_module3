# Set to working directory
# setwd("C:/R_Workspace/module3/project")
# getwd()
# 
# if (!file.exists("dataset")){
#   dir.create("dataset")
# }

#1.Merges the training and the test sets to create one data set.
trainData <- read.table("./dataset/train/X_train.txt")
trainLabel <- read.table("./dataset/train/y_train.txt")
trainSubject <- read.table("./dataset/train/subject_train.txt")

testData <- read.table("./dataset/test/X_test.txt")
testLabel <- read.table("./dataset/test/y_test.txt")
testSubject <- read.table("./dataset/test/subject_test.txt")

combineData <- rbind(trainData, testData)
combineLabel <- rbind(trainLabel, testLabel)
combineSubject <- rbind(trainSubject, testSubject)
str(combineSubject)
# str(combineSubject)
# head(testData)
# tail(testData)

#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./dataset/features.txt")
featureSelected <- features[grep("mean|std",features$V2),]
combineData_feature <- combineData[,featureSelected$V1]
featureSelected <- gsub("\\(\\)","",featureSelected$V2)
featureSelected <- gsub("-","",featureSelected)
featureSelected <- gsub("mean","Mean",featureSelected)
featureSelected <- gsub("std","Std",featureSelected)


#3.Uses descriptive activity names to name the activities in the data set
activity <-read.table("./dataset/activity_labels.txt")
activityLabel <- activity[combineLabel[,1],2] #To get the name of the activity using the key V1
combineLabel[,1] <- activityLabel
#str(activityLabel)

#4.Appropriately labels the data set with descriptive variable names. 
names(combineData_feature) <- featureSelected
names(combineLabel) <- "activity"
names(combineSubject) <- "Subject"

cleanData <- cbind(combineSubject, combineLabel, combineData_feature)
write.table(cleanData,"cleanDataset.txt", row.name=FALSE)


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(data.table)
cleanData<-data.table(cleanData)
tidyDataAverage<-cleanData[, lapply(.SD, mean), by="Subject,activity"]   #.SD = sub data
write.table(tidyDataAverage,"cleanDataSet_colmean.txt", row.name=FALSE)


# using dplyr 
# library(dplyr)
# byFeatureMean<- cleanData %>%
#          group_by(Subject,activity) %>%
#          summarise_each(funs(mean))
# View(byFeatureMean)

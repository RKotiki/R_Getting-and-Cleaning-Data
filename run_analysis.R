# Run_Analysis.R - This script merges the taining & test sets and extracts the required information from other text files to create a single cleaned data table on which analysis can be performed.

# Important - To run this script, packages 'sqldf' and 'data.table' should be   installed.

# Data for project has been extracted from the link https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# Important - Unzip the data in the working directory. Re-name the folder to 'dataset'.  

# Cleaned data texts are saved in the Output folder inside 'dataset' folder.

# RK - 25 October 2014

library(sqldf)
library(data.table)

# 1. Merges the training and the test sets to create one data set.

# Training sets
trainX <- read.table("./dataset/train/X_train.txt")  
#dim(trainX) 7352*561
trainY <- read.table("./dataset/train/Y_train.txt")
#dim(trainY)  7352*1
trainSub <- read.table("./dataset/train/subject_train.txt")
#dim(trainSub)  7352*1

# Test sets
testX <- read.table("./dataset/test/X_test.txt")
#dim(testX) 2947*561
testY <- read.table("./dataset/test/Y_test.txt")
#dim(testY) 2947*1
testSub <- read.table("./dataset/test/subject_test.txt")
#dim(testSub) 2947*1

# combining data
ccX<-rbind(trainX,testX)
#dim(ccX) # 10299*561
ccY<-rbind(trainY,testY)
ccSub<-rbind(trainSub,testSub)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

features <- read.table("./dataset/features.txt")
#dim(features)  561*2
x1<-grep("mean\\(\\)|std\\(\\)",features$V2)
#length(x1) 66
Xsubset<-ccX[,x1]

names(Xsubset)<-features[x1,2]

# Formattimg the headers
names(Xsubset) <- gsub("mean","Mean",names(Xsubset))
names(Xsubset) <- gsub("std","Std",names(Xsubset))
names(Xsubset) <- gsub("\\(\\)","",names(Xsubset))
names(Xsubset) <- gsub("-","",names(Xsubset))

# 3.Uses descriptive activity names to name the activities in the data set
activity <- read.table("./dataset/activity_labels.txt")
#dim(activity) 6*2
activity[, 2] <- tolower(gsub("_", "", activity[, 2]))
activity[,2] <- paste(toupper(substr(activity[, 2],1,1)),substring(activity[,2],2))
#First letter is made uppercase and remaining lower case
activity[,2] <- gsub(" ","",activity[,2])
# Removing blanks/spaces
activity[2,2]<-paste(substring(activity[2,2],1,7),paste(toupper(substr(activity[2, 2],8,8)),substring(activity[2,2],9)))
#Formatted to 'WalkingUpstairs'
activity[3,2]<-paste(substring(activity[3,2],1,7),paste(toupper(substr(activity[3, 2],8,8)),substring(activity[3,2],9)))
# Formatted to 'WalkingDownstairs'
activity[, 2] <- gsub(" ", "", activity[, 2])

activity<- activity[order(activity[,1],activity[,2]),]
len <-length(ccY[,1])
# Replacing activity numbers with activity names
for (i in 1:len)
{
  x<-ccY[i,1]
  y<- grep(x,activity[,1])
  ccY[i,1]<-activity[y,2]
} 

names(ccY)<- "Activity"

# 4.Appropriately labels the data set with descriptive variable names. 
names(ccSub) <- "Person"
TidyData <- cbind(ccSub, ccY, Xsubset)
# Creates a Output folder in the dataset and saves the TidyData text in it
if(!file.exists("./dataset/Output")){ dir.create("./dataset/Output")}
write.table(TidyData, "./dataset/Output/Tidy_data.txt", row.name=FALSE)

# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

for (i in 3:68){
  TempTable<-TidyData[,c(1,2,i)]
  TempNames <-names(TempTable)
  names(TempTable)[3]<-"temp"
  # SQL code to Group and take average
  TempSol <- sqldf("SELECT Person,Activity,AVG(temp) FROM TempTable GROUP BY Person,Activity")
  names(TempSol)<-TempNames
  if (i==3)
  {TidyDataGrouped <- TempSol}
  x<-TidyDataGrouped
  if(i>3){
    TidyDataGrouped<- merge(x,TempSol,all=TRUE)
  }
}

# dim(TidyDataGrouped) 180 * 68

TidyDataGrouped <- data.table(TidyDataGrouped)
write.table(TidyDataGrouped, "./dataset/Output/TidyData_Grouped_Means.txt", row.name=FALSE)

#loading packages dplyr and reshape2
library(dplyr)
library(reshape2)

#Downloading to workspace the file Dataset.zip and unzipping it
if (!file.exists("Dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "Dataset.zip")
  unzip("Dataset.zip")
}

#Loading training files into R
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

#Loading testing files into R
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

#creating a vector with the name of activities
activities_names <- read.table ("UCI HAR Dataset/activity_labels.txt")
activities_names <- as.character(activities_names[,2])
              
#creating name of activities column - train and test
ytest <- mutate(ytest, activities_name = activities_names[V1])
ytrain <- mutate(ytrain, activities_name = activities_names[V1])


#Binding rows from training file and test into one
data <- rbind(xtest, xtrain)


#loading column names from features.txt
colnames <- read.table ("UCI HAR Dataset/features.txt")

#Attributing columns names to the data file
names(data) <- as.character(colnames[,2])

#binding columns data from subject and activity - test and trin
train_SA <- cbind(subject_train, activity = ytrain[,2])
test_SA <- cbind(subject_test, activity = ytest[,2])

#Binding rows from trai_SA and test_SA files into one: file_SA and attributin variables name
file_SA <- rbind(test_SA, train_SA)
names(file_SA) <- c("person", "activity")

#Selecting from dataset file only variables about standard deviation and mean
dataset <- data[grep("*mean()* | *std()*",names(data))]

#binding columns file_SA into dataset
dataset <- cbind(file_SA, dataset)

#creating a tidy data set with the average of each variable for each activity and each subject
#first melting datset putting variables as row
melt_file <- melt(dataset,id=c("person","activity"))

#now creating the cross table, tide_file, with the melt_file, obtaining the mean for each variable
tidy_file <- dcast(melt_file,person+activity~variable,mean)

#creating the file "tidy_datase.txt" into workspace
write.table(tidy_file,file="tidy_dataset.txt",row.names = FALSE)




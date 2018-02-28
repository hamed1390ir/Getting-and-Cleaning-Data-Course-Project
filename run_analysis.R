library("dplyr")

setwd("C:/Users/hyazarloo/Documents/R/Project/Data")

# Import features ---------------------------------------------------------

features.file.name<-"./UCI HAR Dataset/features.txt"

features<- read.table(features.file.name, sep="", header=FALSE, fill=FALSE, comment.char="",stringsAsFactors = FALSE)

colnames(features)<-c("feature_ID","feature")

rm("features.file.name")

# Create Training Set -----------------------------------------------------

X.train.file.name<-"./UCI HAR Dataset/train/X_train.txt"
y.train.file.name<-"./UCI HAR Dataset/train/y_train.txt"
subject.train.file.name<-"./UCI HAR Dataset/train/subject_train.txt"
training.set<- read.table(X.train.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
training.labels<- read.table(y.train.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
training.subjects<- read.table(subject.train.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
rm("X.train.file.name","y.train.file.name","subject.train.file.name")
names(training.set)<-features$feature
colnames(training.labels)<-"label_level"
colnames(training.subjects)<-"subject_ID"
training.set<-cbind(training.set,training.labels,training.subjects)
rm("training.labels","training.subjects")
col_idx1 <- grep("label_level", names(training.set))
col_idx2 <- grep("subject_ID", names(training.set))
training.set <- training.set[, c(col_idx1, (1:ncol(training.set))[-col_idx1])]
training.set <- training.set[, c(col_idx2, (1:ncol(training.set))[-col_idx2])]
rm("col_idx1","col_idx2")
# Create Test Set ---------------------------------------------------------
X.test.file.name<-"./UCI HAR Dataset/test/X_test.txt"
y.test.file.name<-"./UCI HAR Dataset/test/y_test.txt"
subject.test.file.name<-"./UCI HAR Dataset/test/subject_test.txt"
test.set<- read.table(X.test.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
test.labels<- read.table(y.test.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
test.subjects<- read.table(subject.test.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
rm("X.test.file.name","y.test.file.name","subject.test.file.name")
names(test.set)<-features$feature
colnames(test.labels)<-"label_level"
colnames(test.subjects)<-"subject_ID"
test.set<-cbind(test.set,test.labels,test.subjects)
rm("test.labels","test.subjects")
col_idx1 <- grep("label_level", names(test.set))
col_idx2 <- grep("subject_ID", names(test.set))
test.set <- test.set[, c(col_idx1, (1:ncol(test.set))[-col_idx1])]
test.set <- test.set[, c(col_idx2, (1:ncol(test.set))[-col_idx2])]
rm("col_idx1","col_idx2")
# Merges the training and the test sets to create one data set ------------
data <- rbind(training.set, test.set)
rm("test.set","training.set")
# Extracts only the measurements on the mean and standard deviatio --------
data_mean_std<-data[,c("label_level", "subject_ID",names(data)[grep("mean|std",names(data))])]
rm("features", "data")
# Uses descriptive activity names to name the activities in the da --------
activity.label.file.name<-"./UCI HAR Dataset/activity_labels.txt"
activity.labels<- read.table(activity.label.file.name, sep="", header=FALSE, fill=FALSE, comment.char="",stringsAsFactors = FALSE)
colnames(activity.labels)<-c("label_level","label")
data_mean_std_activity<-merge(data_mean_std, activity.labels,by="label_level",all.x = TRUE)
data_mean_std_activity$label_level<-NULL
rm("activity.labels", "activity.label.file.name", "data_mean_std")
# Appropriately labels the data set with descriptive variable names -------
data_colnames<-names(data_mean_std_activity)
data_colnames<-make.names(names(data_mean_std_activity))
rm("data_colnames")
# From the data set in step 4, creates a second, independent tidy  --------
summary<-data_mean_std_activity %>% 
        group_by(label,subject_ID) %>% 
        summarize_all(mean)
write.table(summary,"output.txt", row.name=FALSE)

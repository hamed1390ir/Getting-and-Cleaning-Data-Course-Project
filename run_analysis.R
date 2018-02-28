library("dplyr")
setwd("C:/Users/hyazarloo/Documents/R/Project")

activity.label.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/activity_labels.txt"
activity.labels<- read.table(activity.label.file.name, sep="", header=FALSE, fill=FALSE, comment.char="",stringsAsFactors = FALSE)
colnames(activity.labels)<-c("label_level","label")

features.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/features.txt"
features<- read.table(features.file.name, sep="", header=FALSE, fill=FALSE, comment.char="",stringsAsFactors = FALSE)
colnames(features)<-c("feature_ID","feature")


rm("activity.label.file.name","features.file.name")

#*************************************************************

X.train.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/train/X_train.txt"
y.train.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/train/y_train.txt"
subject.train.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/train/subject_train.txt"
training.set<- read.table(X.train.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
training.labels<- read.table(y.train.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
training.subjects<- read.table(subject.train.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
rm("X.train.file.name","y.train.file.name","subject.train.file.name")

colnames(features)<-c("feature_ID","feature")
names(training.set)[features$feature_ID]<-features$feature
colnames(training.labels)<-"label_level"
colnames(training.subjects)<-"subject_ID"

training.set<-cbind(training.set,training.labels,training.subjects)
rm("training.labels","training.subjects")

col_idx1 <- grep("label_level", names(training.set))
col_idx2 <- grep("subject_ID", names(training.set))
training.set <- training.set[, c(col_idx1, (1:ncol(training.set))[-col_idx1])]
training.set <- training.set[, c(col_idx2, (1:ncol(training.set))[-col_idx2])]


training.set<-merge(training.set,activity.labels,by="label_level",all.x = TRUE)

#*************************************************************

X.test.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/test/X_test.txt"
y.test.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/test/y_test.txt"
subject.test.file.name<-"C:/Users/hyazarloo/Documents/R/Project/Data/UCI HAR Dataset/test/subject_test.txt"
test.set<- read.table(X.test.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
test.labels<- read.table(y.test.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
test.subjects<- read.table(subject.test.file.name, sep="", header=FALSE, fill=FALSE, comment.char="")
rm("X.test.file.name","y.test.file.name","subject.test.file.name")


names(test.set)[features$feature_ID]<-features$feature
colnames(test.labels)<-"label_level"
colnames(test.subjects)<-"subject_ID"


test.set<-cbind(test.set,test.labels,test.subjects)
rm("test.labels","test.subjects")

test.set<-merge(test.set,activity.labels,by="label_level",all.x = TRUE)

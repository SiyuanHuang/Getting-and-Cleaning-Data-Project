library(reshape2)

# Step 1: Merge data sets
train<-read.table("X_train.txt")
test<-read.table("X_test.txt")
features<-read.table("features.txt")

train_label<-read.table("y_train.txt")
test_label<-read.table("y_test.txt")
test_subject<-read.table("subject_test.txt")
train_subject<-read.table("subject_train.txt")

data<-rbind(train,test)

# Step 2: Extracts only the mean and standard deviation for each measurement.
# Step 4: Label the data Set with descriptive variable names
names(data)<-features[,2]
MeanStd<-grepl("mean()",features[,2], fixed = T) | grepl("std()",features[,2],fixed = T)
data<-data[,MeanStd]

# Step 3: Name the activities in data set
data$Subject<-as.factor(c(train_subject[,1],test_subject[,1]))
activity<-factor(c(train_label[,1],test_label[,1]),labels = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
data$Activity <- activity

# Step 5: Creat new data set and txt file
dataMelt<-melt(data,id=c("Activity","Subject"),measure.vars=features[,2][MeanStd])
data2<-dcast(dataMelt,Activity + Subject ~ variable,mean)
write.table(data2,"Analysis.txt",row.name = F)
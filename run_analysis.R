if (!require("data.table")){
        install.packages("data.table")
}

if (!require("reshape2")){
        install.packages("reshape2")
}

require("data.table")
require("reshape2")

#load activity labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

#load data columns
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# extract only the measurements on the mean and standard deviation
extract_features <- grepl("mean|std", features)

#load data from test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

names(X_test) = features

#Extract only measurement on the mean and standard deviation for each measurement
X_test = X_test[,extract_features]

# load activity lables
Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

#Bind data
test_data <- cbind(as.data.table(subject_test), Y_test, X_test)

#load data from train data
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(X_train) = features

#Extract only measurement on the mean and standard deviation for each measurement
X_train = X_train[,extract_features]

# load activity lables
Y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

#bind data
train_data <- cbind(as.data.table(subject_train), Y_train, X_train)

#merge data
data = rbind(test_data, train_data)

id_labels <- c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id=id_labels, measure.vars = data_labels)

#apply mean to the dataset
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

        write.table(tidy_data, file="./tidy_data.txt", row.name=FALSE)

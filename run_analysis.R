# Assignment Week 4

setwd("~/Training/03 - Getting and Cleaning Data/Week 4")
library(plyr)
library(dplyr)

# Read Labels
activity_labels <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", sep = " ")
features <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt", sep = " ", )

# Load Trianing data
subject_train <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")

# Load Testing data
subject_test <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")

#1 Merge training and test sets
total_data<- rbind(x_train, x_test)

# Add column labels
colnames(total_data)<- features[,2]

# extract mean and standard deviation data
total_data <- total_data %>% select(grep("mean|std", names(total_data)))

# Combine row labels
row_labels = rbind(y_train, y_test)

# Name activity lookup table   
names(activity_labels) <- c("activity_number", "activity_name")

# Name row labels
names(row_labels) <- c("activity_number")

# Convert row label into activity name
row_names <- join(row_labels, activity_labels, by="activity_number")

# Join activity label with data
total_data <- cbind(row_names$activity_name, total_data)

# Combine subject labels
subject <- rbind(subject_train, subject_test)
names(subject) <- c("subject_number")
total_data <- cbind(subject, total_data)

# Summary table

df <- total_data
summary_table <- df %>%
  group_by(subject_number, row_names$activity_name) %>%
  summarise_all(list(mean))

# Write output files
write.table(total_data, "./data/UCI HAR Tidy Dataset.txt", row.names = FALSE)
write.table(summary_table, "./data/UCI HAR Summary.txt", row.names = FALSE)

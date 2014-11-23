# Libraries

# Check if gdata package is loaded and load if necessary

if(require("gdata")){
    print("gdata is loaded correctly")
} else {
    print("trying to install gdata")
    install.packages("gdata")
    if(require(gdata)){
        print("gdata installed and loaded")
    } else {
        stop("could not install gdata")
    }
}

# Set Working Directory

wd <-getwd()
setwd(wd)

# Download Zip File

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data/UCI-HAR-Dataset.zip")

# Unzip Files in Data Directory

setwd("./data")
unzip("UCI-HAR-Dataset.zip")
setwd(wd)

# Create Root file path for extracting Training Data

fileURL <- paste(getwd(),"/data/UCI HAR Dataset/train",sep="")

# Import subjectTrain table

filename <- "subject_train.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
subjectTrain <- read.table(filename.path)

# Import XTrain table

filename <- "X_train.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
XTrain <- read.table(filename.path)

# Import yTrain table

filename <- "y_train.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
yTrain <- read.table(filename.path)

# Create Root file path for extracting Test Data

fileURL <- paste(getwd(),"/data/UCI HAR Dataset/test",sep="")

# Import subjectTest table

filename <- "subject_test.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
subjectTest <- read.table(filename.path)

# Import XTest Table

filename <- "X_test.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
XTest <- read.table(filename.path)

# Import yTest Table

filename <- "y_test.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
yTest <- read.table(filename.path)

# Import feature names

fileURL <- paste(getwd(),"/data/UCI HAR Dataset",sep="")
filename <- "features.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
features <- read.table(filename.path, stringsAsFactors = FALSE)

# Import Activity Labels and give columns tidy names

fileURL <- paste(getwd(),"/data/UCI HAR Dataset",sep="")
filename <- "activity_labels.txt"
filename.path <- paste(fileURL,"/",filename, sep = "")
activitylabels <- read.table(filename.path, stringsAsFactors = FALSE)
colnames(activitylabels) <- c("activitynumber", "activityname")

# remove 1st column index from features

features$V1 <- NULL
colnames(features)[1] <- 'names'

# Tidy up feature names

# Make all column names lowercase
features$names <- tolower(features$names)
# Remove Dashes
features$names <- gsub("-","",features$names)
# Remove Left Parenthesis
features$names <- gsub("\\(","",features$names)
# Remove Right Parenthesis
features$names <- gsub("\\)","",features$names)
features$names <- gsub(",","",features$names)
# if 1st character is t replace it with "time"
features$names <- gsub("^t","time",features$names)
# if 1st character is f replace it with "freq"
features$names <- gsub("^f","freq",features$names)
# Remove confusing "bodybody" in features$names
features$names <- gsub("bodybody","body",features$names)


# Add Subject Columns to XTest and XTrain

XTrain <- cbind(XTrain,subjectTrain)
XTest <- cbind(XTest, subjectTest)

# Add yTrain and yTest to XTest and Xtrain

XTrain <- cbind(XTrain, yTrain)
XTest <- cbind(XTest, yTest)

# "Stack" XTrain and XTest and create master dataset

dataset <- rbind(XTrain,XTest)

# Add Column Names

colnames(dataset) <- features$names
colnames(dataset)[562] <- "subject"
colnames(dataset)[563] <- "activitynumber"

# Substitute activityname for activitynumber then remove activity number

dataset <- merge(dataset, activitylabels, by = "activitynumber")

dataset$activitynumber <- NULL

library(gdata)

# Identify all columns that have "mean" in them that are NOT meanfreq and convert to vector
# meanfreq is a weighted average and not a true mean so it is excluded
testmean <- unlist(matchcols(dataset, with = c("mean"), without = c("meanfreq")))

# ID all columns that contain std and convert to vector
teststd <- unlist(matchcols(dataset, with = c("std")))

# Concatenate the vectors - this is the list of columns
colnamesextract <- c(testmean,teststd)


# Create Dataset of just means and std categories
meanstddata <- dataset[,colnamesextract]

# Add subject and activity name fields
meanstddata$subject <- dataset$subject
meanstddata$activityname <- dataset$activityname

# aggregate dataset on subject and activity name, ordering by subject and activity name
avgdata <- aggregate(.~ subject + activityname, data = meanstddata, mean)
avgdata <- avgdata[order(avgdata$subject,avgdata$activityname),]

# rename columns to include averages to be more descriptive
colnames(avgdata)[3:75] <- paste(colnames(avgdata)[3:75],"average", sep="")

write.table(avgdata, file = "avgdata.txt", col.names= TRUE, row.name = FALSE)


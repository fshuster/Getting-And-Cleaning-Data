setwd("C:/Data/GettingAndCleaningData")

# Question 1 

#get Data from Internet

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "acsdata.csv")

# read data into R

file = "acsdata.csv"
acsdata <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)

# How many housing units are worth more than $1,000,000

x <- length(acsdata$VAL[acsdata$VAL == 24 & is.na(acsdata$VAL) == FALSE])
print(x)

# Question 3

#get Data from Internet

fileURL3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
download.file(fileURL3, destfile = "NatGasAquiPrgm.xlsx", mode = "wb")

# Fix to get rJava working properly
# needed to load java JDK and JRE in order to get rJava to work

remove.packages('rJava')
options(java.home="C:\\Program Files\\Java\\jre7\\") 
install.packages('rJava')
library(rJava)

# Calculate answer

library(xlsx)
NGAP <- read.xlsx("NatGasAquiPrgm.xlsx", sheetIndex = 1, rowIndex = 18:23, colIndex = 7:15)
q3x <- sum(NGAP$Zip*NGAP$Ext,na.rm=T)
print(q3x)

# Question 4

library(XML)
fileURL4 <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
q4doc <- xmlTreeParse(fileURL4, useInternal = TRUE)
rootNode <- xmlRoot(q4doc)

q4zip <- xpathSApply(rootNode,"//zipcode", xmlValue)
q4x <- length(q4zip[q4zip == "21231" & is.na(q4zip) == FALSE])
print(q4x)

#Question 5

library(data.table)

# Get Data

setwd("C:/Data/GettingAndCleaningData")
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "acsdataQ5.csv")

# Read Data into R with Data table

DT = fread("acsdataQ5.csv", stringsAsFactors = FALSE)

s1 <- system.time(DT[,mean(pwgtp15),by=SEX]) # 0.0034
s2 <- system.time(mean(DT$pwgtp15,by=DT$SEX)) # 0.0072  incorrect formula
s3 <- system.time(sapply(split(DT$pwgtp15,DT$SEX),mean)) ###### 0.0072 ####### Answer
s4 <- system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15)) # error
s5 <- system.time(rowMeans(DT)[DT$SEX==1]; rowMeans(DT)[DT$SEX==2]) # error
s6 <- system.time(tapply(DT$pwgtp15,DT$SEX,mean)) # 0.01365


# Use this loop for increasing the number of repetitions of a function that is too fast to 
# be captured using system.time()

trial_size <- 200
collected_results <- numeric(trial_size)
for (i in 1:trial_size){
    single_function_time <- system.time(mean(DT[DT$SEX==1,]$pwgtp15); mean(DT[DT$SEX==2,]$pwgtp15))
    collected_results[i] <- single_function_time[1]
}
print(mean(collected_results))

DT[,mean(pwgtp15),by=SEX]

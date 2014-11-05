# Load Data

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "getdata_Fdata_Fss06hid.csv")

file = "getdata_Fdata_Fss06hid.csv"
Quiz3acs <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)

summary(Quiz3acs)
str(Quiz3acs)

# Question 1

Quiz3acs$agriculturalLogical <- ifelse(Quiz3acs$ACR == 3 & Quiz3acs$AGS == 6, TRUE, FALSE) 
table(Quiz3acs$agriculturalLogical)
Q3Q1 <- which(Quiz3acs$agriculturalLogical)[1:3]
Q3Q1


# Question 2
library(jpeg)

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(fileURL, destfile = "getdata_jeff.jpg", mode = "wb")

file = "getdata_jeff.jpg"
Q2data <- readJPEG(file, native = TRUE)

Q3Q2 <- quantile(Q2data, c(0.3,0.8))


# Question 3

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileURL, destfile = "getdata_Fdata_FGDP.csv")

column.names <- c("CountryCode", "GDPRank","X.1","CountryName", "GDP", "X.4", "X5" )

file = "getdata_Fdata_FGDP.csv"
Quiz3FGDP <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)

Quiz3FGDP <- Quiz3FGDP[5:nrow(Quiz3FGDP),]

Quiz3FGDPClean <- data.frame(Quiz3FGDP$X, Quiz3FGDP$Gross.domestic.product.2012, Quiz3FGDP$X.3)
colnames(Quiz3FGDPClean) <- c("CountryCode", "GDPRank", "GDP")

Quiz3FGDPClean <- Quiz3FGDPClean[1:190,]

# Problem is here....

Quiz3FGDPClean$CountryCode <- as.character(Quiz3FGDPClean$CountryCode)
Quiz3FGDPClean$GDPRank <- as.integer(as.character(Quiz3FGDPClean$GDPRank))
Quiz3FGDPClean$GDP <- as.integer(gsub(",","",Quiz3FGDPClean$GDP))

# Get FedStats Data

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileURL, destfile = "getdata_Fdata_FEDSTATS_Country.csv")

file = "getdata_Fdata_FEDSTATS_Country.csv"
Quiz3FEDSTATS <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)


Q3Q3data <- merge(Quiz3FGDPClean, Quiz3FEDSTATS, by = "CountryCode")
Q3Q3data <- Q3Q3data[order(Q3Q3data$GDPRank, decreasing = TRUE),]

nrow(Q3Q3data) # 189
Q3Q3data[13,] # St. Kits and Nevis

# Question 4

tapply(Q3Q3data$GDPRank,Q3Q3data$Income.Group, mean)

# Question 5

library(Hmisc)

Q3Q3data$quantile5 <- cut2(Q3Q3data$GDPRank, g=5)
Q3Q5 <- table(Q3Q3data$quantile5, Q3Q3data$Income.Group)
Q3Q5
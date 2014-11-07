# Question 1 

#get Data from Internet

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileURL, destfile = "./data/acsdata.csv")

# read data into R

file = "./data/acsdata.csv"
acsdata <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)

# Split names on "wgtp"

splitNames <- strsplit(names(acsdata),"wgtp")

splitNames[123]

# Question 2

#get Data from Internet and read into R

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileURL, destfile = "./data/FGDP.csv")
file = "./data/FGDP.csv"
FGDP <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)

# Clean up Data

column.names <- c("CountryCode", "GDPRank","X.1","CountryName", "GDP", "X.4", "X5" )

FGDP <- FGDP[5:nrow(FGDP),]
FGDP <- FGDP[1:190,]

FGDPClean <- data.frame(FGDP$X, FGDP$Gross.domestic.product.2012, FGDP$X.3)
colnames(FGDPClean) <- c("CountryCode", "GDPRank", "GDP")

# Remove Commas from GDP

FGDPClean$GDP <- as.numeric(gsub(",","",FGDPClean$GDP))

# Calculate Average GDP

GDPmean <- mean(FGDPClean$GDP)

# Question 3

grep("^United",FGDP$X.2)

# Answer = 3

# Question 4

if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileURL, destfile = "./data/fedstats.csv")
file = "./data/fedstats.csv"
fedstats <-  read.csv(file, header = TRUE, stringsAsFactors = FALSE)

# Merge data

FGDPClean$CountryCode <- as.character(FGDPClean$CountryCode)
FGDPfeststatsmerge <- merge(FGDPClean, fedstats, by = "CountryCode")

length(grep("[Ff]iscal [Yy]ear [Ee]nd: [Jj]une",FGDPfeststatsmerge$Special.Notes))

# Answer = 13

# Question 5

library(quantmod)
amzn <- getSymbols("AMZN",auto.assign=FALSE)
sampleTimes <- index(amzn) 

sampleTimesNew <- format(sampleTimes,"%A %B %d %Y")

length(grep("2012$",sampleTimesNew))
length(grep("^Monday.*2012$",sampleTimesNew))


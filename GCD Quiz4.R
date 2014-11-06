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



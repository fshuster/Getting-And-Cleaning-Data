setwd("C:/Data/GettingAndCleaningData")

# Question 1

library(httr)
library(httpuv)
library(jsonlite)


myapp <- oauth_app("github", "736c1fa579de9b990f85", secret = "ed6ab135028c0e4154d31b5f0898d2a284716032")

github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

req <- GET("https://api.github.com/users/jtleek/repos", config(token = github_token))

json1 <- content(req)
json2 <-jsonlite::fromJSON(toJSON(json1))

quiz2q1 <- reqjson2$created_at[reqjson2$full_name == "jtleek/datasharing"]
print(quiz2q1)

# Question 2

library(sqldf)

# Get the data

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileURL, destfile = "acsdataQ5.csv")

acs = read.csv("acsdataQ5.csv", stringsAsFactors = FALSE)


quiz2q2 <- sqldf("select pwgtp1 from acs where AGEP < 50")


# Question 3

# Correct Answer is 

sqldf("select distinct AGEP from acs")

# is equal to 

unique(acs$AGEP)

# Question 4 

location <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(location)
close(location)

z = c(10,20,30,100)

for (i in z) {
    x <- nchar(htmlCode[i])
    print(x)
}

# Question 5

# Get the data

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(fileURL, destfile = "ncep.for")

quiz2q5 <- read.fwf("ncep.for", widths = c(14,5,9,4,9,4,9,4,9), stringsAsFactors = FALSE)

# Removes extraneous header rows

quiz2q5 <- quiz2q5[-1:-4,]

#Converts Character to Numeric and sums...

sum(as.numeric(quiz2q5$V4))


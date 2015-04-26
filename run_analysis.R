# Import required libraries
library(dplyr)
library(reshape)
library(reshape2)
library(data.table)

# Set up environment
CURDIR <- getwd()
PROJDIR <- "E:\\Documents\\Projects\\R\\Getting and Cleaning Data\\Project"
ZIPURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
ZIPFILE <- "data.zip"
setwd(PROJDIR)
if (! file.exists(ZIPFILE)) download.file(url = ZIPURL, destfile = ZIPFILE)
unzip(zipfile = ZIPFILE, overwrite = T)
setwd("UCI HAR Dataset")

# Process data
## Process ancillary data
activities <- read.table(file = "activity_labels.txt", 
                         sep = " ", 
                         header = F,
                         col.names = c("id", "name"))
features <- read.table(file = "features.txt", 
                       sep = " ", 
                       header = F, 
                       col.names = c("id", "name"),
                       colClasses = c("NULL", NA))
features <- mutate(features, 
                   colClass = ifelse(grepl("*mean*", name) | grepl("*std*", name), 
                                     NA, 
                                     "NULL"), 
                   width = 16)

## Set up data IO routine
read.data <- function(data.set, data.n = -1) {
  targetdata <- read.fwf(file = paste(data.set, "\\X_", data.set, ".txt", sep = ""), 
                         n = data.n, 
                         widths = features$width, 
                         header = F, 
                         col.names = features$name, 
                         colClasses = features$colClass)
  targetdata$subject <- read.table(file = paste(data.set, "\\subject_", data.set, ".txt", sep = ""), 
                                          nrows = data.n, 
                                          header = F, 
                                          col.names = c("subject"))$subject
  targetdata$activity <- read.table(file = paste(data.set, "\\y_", data.set, ".txt", sep = ""), 
                                    nrows = data.n, 
                                    header = F, 
                                    col.names = c("id"))$id
  targetdata$activity <- activities$name[match(targetdata$activity, activities$id)]
  return(targetdata)
}

## FP reading and merging of the data
data.union.raw <- do.call(rbind, lapply(c("test", "train"), read.data))
## Summarize by subject
data.union.summary <- aggregate(. ~ subject, data.union.raw, mean)
## Write output file
setwd("..")
write.table(data.union.summary, "wearablecomputing.txt", row.names = F)

# Clean up
setwd(CURDIR)

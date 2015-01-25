# Coursera Getting and Cleaning Data Course
# January 2015
# runanalysis.R
#

# SET WORKING DIRECTORY -- For Example
#setwd("J:/coursera/DataScience/GettingData/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")


library(dplyr)

# Change this variable to FALSE if you want to leave all intermediate results
# in memory for further use or examination of the process.
removeAllIntermediateTables = TRUE


print("Starting column name extraction...")
feat <- read.table("features.txt", sep="", stringsAsFactors = F, fill=T)

# Remove Brackets and Dashes that could cause errors with column Name usage
# this could be done with a "for loop" with strings in a collection
zz <- feat[,2]
zz2 <- gsub("-", "_", zz)   # replace dashes (minus sign) with underscores
zz3 <- gsub(",", "_", zz2)  # replace commas with underscores
zz4 <- gsub("\\()", "", zz3)# replace bracket SETS with nothing
zz5 <- gsub("\\)", "", zz4) # replace isolated right brackets with underscores
zz6 <- gsub("\\(", "_", zz5)# replace isolated left brackets with underscores
rm(zz,zz2,zz3,zz4,zz5)      # eliminate temporary vectors

print("Loading Activity File")
activities <- read.table("activity_labels.txt", col.names=c("ActivityID","activity" ),sep="", stringsAsFactors=T)

print("Loading Training Subjects")
trainsubject <- read.table("subject_train.txt", col.names=c("SubjectID" ),sep="", stringsAsFactors=T)
trainactivity <- read.table("y_train.txt", col.names=c("ActivityID" ),sep="", stringsAsFactors=T)

# Add Activities description to the training files -- then remove the extra ID field
tractivities <- inner_join(activities,trainactivity, by = c("ActivityID" = "ActivityID"))
tractivities <- select(tractivities, -ActivityID)

print("Loading Test Subjects")
testsubject <- read.table("subject_test.txt", col.names=c("SubjectID" ),sep="", stringsAsFactors=T)
testactivity <- read.table("y_test.txt", col.names=c("ActivityID" ),sep="", stringsAsFactors=T)

# Add Activities description to the "test" files -- then remove the extra ID field
tstactivities <- inner_join(activities,testactivity, by = c("ActivityID" = "ActivityID"))
tstactivities <- select(tstactivities, -ActivityID)

print("Loading Test Files -- sensor data")
XTST <- read.table("X_test.txt", sep="",col.names=zz6,header=F, stringsAsFactors = F)

print("Loading Training Files -- sensor data")
XTRN <- read.table("X_train.txt", sep="",col.names=zz6,header=F, stringsAsFactors = F)

print("Extracting only columns with Median or Standard Deviation measurements")
XTR1 <- select(XTRN, contains("mean"))
XTR2 <- select(XTRN, contains("std"))

# Add the seq data -- which is implicit in the row number
XTRFSeq <- data.frame(SeqID = 1:nrow(XTR2))

# The order in the tables is meaningful -- since the data was recorded sequentially
# This will provide an EXPLICIT sequence variable for purposes of plotting
# and analyzing the data as a reries.
# Selecting data ordered by  ** SubjectID, activity, SeqId  will maintain the collection order....
# Subsequent sorting or in particular **select** with SQLDF could otherwise disrupt the sequence
# as **select** commands do not guarantee data will be returned in any order.
#
XTRF <- bind_cols(XTRFSeq,XTR1, XTR2)
rm(XTR1, XTR2, XTRFSeq)
#rm(y_train)
# y_train is task vector
# subject_train is subject (person) vector


XTS1 <- select(XTST, contains("mean"))
XTS2 <- select(XTST, contains("std"))

# Add the seq data -- which is implicit in the row number
# Explanation is the same as the above.

XTSFSeq <- data.frame(SeqID = 1:nrow(XTS2))

XTSF <- bind_cols(XTSFSeq,XTS1, XTS2)

# Save column names for later use
anames <- c(names(XTS1), names(XTS2))

rm(XTS1, XTS2, XTSFSeq)

# y_test is task vector
# subject_test is subject (person) vector
# Training and test tables with all requested colums present
XTRF2 <- bind_cols(trainsubject, tractivities, XTRF)
XTSF2 <- bind_cols(testsubject, tstactivities, XTSF)


# The "bind_rows command binds the sets with the rows in their original positions 
# within their respective sets -- creating a single table
#
XALL <- bind_rows(XTRF2, XTSF2)
# Sort combined table -- preserving sequences
XALL_sorted <- arrange(XALL, SubjectID, activity, SeqID)

print ("Final groupings and output of ** SubjectActivityAverages.txt **")
# Set groupings for convenient reporting via dplyr
Final_Grouped <- group_by(XALL_sorted,SubjectID, activity , add=F)


# Summarize the 86 variables -- names stored earlier in "anames" for convenience...
# Grouped by Subject, Activity
SubjectActivityAverages <- summarise_each_(Final_Grouped, funs(mean), anames)

# Tested that write of combined table produced correct rows and variables.
# by loading into LibrCalc
write.table(SubjectActivityAverages,file = "SubjectActivityAverages.txt", row.names=FALSE) 

# Tested output by reloading into R and also loading into LibreCalc (LibreOffice)
# Data loaded cleanly with both packages.

# write.table(Final_Grouped,file = "Final_Grouped.txt", row.names=FALSE) 

if (removeAllIntermediateTables==TRUE) {
    rm(list = ls(pattern = "^XT"))
    rm(list = ls(pattern = "^XA"))
    rm(list = ls(pattern = "^train"))
    rm(list = ls(pattern = "^t"))
    rm(list = ls(pattern = "^z"))
    rm(list = ls(pattern = "^f"))
    rm(list = ls(pattern = "^a"))
}

# Finis -------------------------------

# nmg <- names(Final_Grouped)
# nms <- names(SubjectActivityAverages)

# print(nmg)


# Code for Test Plot
# fg1 <- Final_Grouped[Final_Grouped$SubjectID==3 & Final_Grouped$activity == "WALKING",]
# plot (tGravityAcc_mean_Y ~ SeqID, data=fg1)

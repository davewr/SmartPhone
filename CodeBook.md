---
title: "Smartphone Project CodeBook"
author: "Dave Robinson"
date: "Saturday, January 24, 2015"
output: html_document
---

##General Issues

The naming conventions used for the sensor data -- found in "features.txt" allowed use of brackets and minus signs. This caused some issues with manipulating the columns so the following code was used to "rework" the column names for simpler manipulation. While iterating through a collection of changes would be more "cool" -- this is far more obvious as to the manipulation.

```
print("Starting column name extraction...")

feat <- read.table("features.txt", sep="", stringsAsFactors = F, fill=T)

\# Remove Brackets and Dashes that could cause errors with column Name usage

\# this could be done with a "for loop" with strings in a collection

zz <- feat[,2]

zz2 <- gsub("-", "_", zz)   # replace dashes (minus sign) with underscores

zz3 <- gsub(",", "_", zz2)  # replace commas with underscores

zz4 <- gsub("\\()", "", zz3)# replace bracket SETS with nothing

zz5 <- gsub("\\)", "", zz4) # replace isolated right brackets with underscores

zz6 <- gsub("\\(", "_", zz5)# replace isolated left brackets with underscores

rm(zz,zz2,zz3,zz4,zz5)      # eliminate temporary vectors

```
The activities table is loaded in a straightforward manner. It is used with the training file to directly assign the descriptions to the training files which is the matched to the actual sensor data.


```
print("Loading Activity File")
activities <- read.table("activity_labels.txt", col.names=c("ActivityID","activity" ),sep="", stringsAsFactors=T)
```

###Preparing the Training and Test FIles

The preparation for the "Training" and the "Test" files is essentially identical so only the "Training" files will be explained. The only difference in the Training and the Test data is that some subjects were arbitrarily chosen to be on one group or the other. Not all subjects performed all tests -- or perhaps it was simply that the data was not included in this set.


The "subject\_train.txt" file in the TRAIN directory is a vector that has the same number of rows as the actual sensor data in the "X\_train.txt"" file. When combined with the sensor data you can see what data applies to what subject (person) -- as given by a number 1 through 30. The activity data also matches the length of the sensor data set.

Combining the two additional data sets with the sensor data allows you to easily manipulate the sensor data and extract combinations based on the activity and person performing the activity.

Doing a simple plot of various person and activity data sets allowed me to see that clear patterns were visible if the appropriate sensors were chose -- e.g.

```
# Test Plot

fg1 <- Final_Grouped[Final_Grouped$SubjectID==3 & Final_Grouped$activity == "WALKING",]

plot (tGravityAcc_mean_X ~ SeqID, data=fg1)

```

I will mention that I deliberately chose the "X" gravity sensor as it clearly shows a pattern that I would think of as belonging to the "Z" sensor.  Regardless it seems to show a regular "stepping" patter where the body seems to fall for a short period -- like a body "falling" as a step is made.

The point being that maintaining the data in sequence is likely of benefit for many analysis tasks.


```
print("Loading Training Subjects")

trainsubject <- read.table("subject_train.txt", col.names=c("SubjectID" ),sep="", stringsAsFactors=T)

trainactivity <- read.table("y_train.txt", col.names=c("ActivityID" ),sep="", stringsAsFactors=T)

# Add Activities description to the training files -- then remove the extra ID field

tractivities <- inner_join(activities,trainactivity, by = c("ActivityID" = "ActivityID"))

tractivities <- select(tractivities, -ActivityID)
```

The training data is read to the XTRN data frame, then only the mean and standard deviation columns are extracted.

```
print("Loading Training Files -- sensor data")
XTRN <- read.table("X_train.txt", sep="",col.names=zz6,header=F, stringsAsFactors = F)

print("Extracting only columns with Median or Standard Deviation measurements")
XTR1 <- select(XTRN, contains("mean"))
XTR2 <- select(XTRN, contains("std"))

# Add the seq data -- which is implicit in the row number
XTRFSeq <- data.frame(SeqID = 1:nrow(XTR2))
```

The two data frames are then merged with the sequence number created in a separate data frame, then the temporary tables are discarded.

Finally, the subjects column is bound as the first column.


```

# y_test is task vector
# subject_test is subject (person) vector
# Training and test tables with all requested colums present
XTRF2 <- bind_cols(trainsubject, tractivities, XTRF)

```

Finally the data is bound together into a single table by binding the test rows to the training rows:

```
XALL <- bind_rows(XTRF2, XTSF2)
# Sort combined table -- preserving sequences
XALL_sorted <- arrange(XALL, SubjectID, activity, SeqID)

print"Final groupings and output of ** SubjectActivityAverages.txt **"
# Set groupings for convenient reporting via dplyr
Final_Grouped <- group_by(XALL_sorted,SubjectID, activity , add=F)
```

Data is grouped and ordered for the final calculations of the means of all the data via the summarize command.

The data is written to a text file via the "write.table" command.

```
# from lines 86-87 -- colum names were save
# Save column names for later use
anames <- c(names(XTS1), names(XTS2))

# Summarize the 86 variables -- names stored earlier in "anames" for convenience...
# Grouped by Subject, Activity
SubjectActivityAverages <- summarise_each_(Final_Grouped, funs(mean), anames)

# Tested that write of combined table produced correct rows and variables.
# by loading into LibrCalc
write.table(SubjectActivityAverages,file = "SubjectActivityAverages.txt", row.names=FALSE) 
```




###Final Output

The text file written to storage has each row uniquely identified by the first three columns listed below. 
 
 [1] "SubjectID"
 [2] "activity"                           
 [3] "SeqID"  
 
The SeqID will be able maintain the sequential order of the data by sorting the table by those columns if necessary. Since potentially a user could use SQL commands -- which do not guarantee that any particular order will be maintained it is a safe guard so that the order of data collection can be preserved for plotting purposes and perhaps for analyzing the rate at which a person is walking and so forth.

A plot tGravityAcc\_mean\_Y.png has been saved so that the apparent pattern can be confirmed visually.

###Data Format
The data has been left in a wider format as one could argue that a complete tuple is formed by the data which is collected from all the sensors simultaneously. For further analysis in R or in a spreadsheet the data format at this stage makes little difference.

For manipulation via SQL I would prefer that data be stored as follows (with example values shown):

```
Subject, Activity, SeqID, SensorValueName, SensorValue

1,Walking,1,tGravityAcc_mean_Y. 0.203456
```

This format would duplicate the first three colums times the number of rows times the number of data colums ... which is coinsiderable extra memory for no particular foreseeable value. However if necessary the data could be rotated into the verical format for some particular need.

Complete Information on the field names can be found in features.txt and features-info.txt -- both are included in this repository for completeness.


# Complete Data Fields in the final tables.

SubjectActivityAverages is missing only the SeqID field as it is eliminated when the means or averages are calculated for the grouping of subject and activity.

All sensor readings are numeric values.

The angular velocity vectors measured by the gyroscope unitts are radians/second. 

Accelerometer variables are measured in "gravities".

SubjectID and SeqID are integers, activity is a factor with six levels -- derived from the original activities description file. (LAYING, SITTING, WALKING etc.)

Final_Grouped Table fields (two per line separated by a space):

 [1] "SubjectID"                           "activity"                           
 [3] "SeqID"                               "tBodyAcc_mean_X"                    
 [5] "tBodyAcc_mean_Y"                     "tBodyAcc_mean_Z"                    
 [7] "tGravityAcc_mean_X"                  "tGravityAcc_mean_Y"                 
 [9] "tGravityAcc_mean_Z"                  "tBodyAccJerk_mean_X"                
[11] "tBodyAccJerk_mean_Y"                 "tBodyAccJerk_mean_Z"                
[13] "tBodyGyro_mean_X"                    "tBodyGyro_mean_Y"                   
[15] "tBodyGyro_mean_Z"                    "tBodyGyroJerk_mean_X"               
[17] "tBodyGyroJerk_mean_Y"                "tBodyGyroJerk_mean_Z"               
[19] "tBodyAccMag_mean"                    "tGravityAccMag_mean"                
[21] "tBodyAccJerkMag_mean"                "tBodyGyroMag_mean"                  
[23] "tBodyGyroJerkMag_mean"               "fBodyAcc_mean_X"                    
[25] "fBodyAcc_mean_Y"                     "fBodyAcc_mean_Z"                    
[27] "fBodyAcc_meanFreq_X"                 "fBodyAcc_meanFreq_Y"                
[29] "fBodyAcc_meanFreq_Z"                 "fBodyAccJerk_mean_X"                
[31] "fBodyAccJerk_mean_Y"                 "fBodyAccJerk_mean_Z"                
[33] "fBodyAccJerk_meanFreq_X"             "fBodyAccJerk_meanFreq_Y"            
[35] "fBodyAccJerk_meanFreq_Z"             "fBodyGyro_mean_X"                   
[37] "fBodyGyro_mean_Y"                    "fBodyGyro_mean_Z"                   
[39] "fBodyGyro_meanFreq_X"                "fBodyGyro_meanFreq_Y"               
[41] "fBodyGyro_meanFreq_Z"                "fBodyAccMag_mean"                   
[43] "fBodyAccMag_meanFreq"                "fBodyBodyAccJerkMag_mean"           
[45] "fBodyBodyAccJerkMag_meanFreq"        "fBodyBodyGyroMag_mean"              
[47] "fBodyBodyGyroMag_meanFreq"           "fBodyBodyGyroJerkMag_mean"          
[49] "fBodyBodyGyroJerkMag_meanFreq"       "angle_tBodyAccMean_gravity"         
[51] "angle_tBodyAccJerkMean_gravityMean"  "angle_tBodyGyroMean_gravityMean"    
[53] "angle_tBodyGyroJerkMean_gravityMean" "angle_X_gravityMean"                
[55] "angle_Y_gravityMean"                 "angle_Z_gravityMean"                
[57] "tBodyAcc_std_X"                      "tBodyAcc_std_Y"                     
[59] "tBodyAcc_std_Z"                      "tGravityAcc_std_X"                  
[61] "tGravityAcc_std_Y"                   "tGravityAcc_std_Z"                  
[63] "tBodyAccJerk_std_X"                  "tBodyAccJerk_std_Y"                 
[65] "tBodyAccJerk_std_Z"                  "tBodyGyro_std_X"                    
[67] "tBodyGyro_std_Y"                     "tBodyGyro_std_Z"                    
[69] "tBodyGyroJerk_std_X"                 "tBodyGyroJerk_std_Y"                
[71] "tBodyGyroJerk_std_Z"                 "tBodyAccMag_std"                    
[73] "tGravityAccMag_std"                  "tBodyAccJerkMag_std"                
[75] "tBodyGyroMag_std"                    "tBodyGyroJerkMag_std"               
[77] "fBodyAcc_std_X"                      "fBodyAcc_std_Y"                     
[79] "fBodyAcc_std_Z"                      "fBodyAccJerk_std_X"                 
[81] "fBodyAccJerk_std_Y"                  "fBodyAccJerk_std_Z"                 
[83] "fBodyGyro_std_X"                     "fBodyGyro_std_Y"                    
[85] "fBodyGyro_std_Z"                     "fBodyAccMag_std"                    
[87] "fBodyBodyAccJerkMag_std"             "fBodyBodyGyroMag_std"               
[89] "fBodyBodyGyroJerkMag_std"           




```{r,echo=TRUE}

names(Final_Grouped)
```

You can also embed plots, for example:

```{r, echo=FALSE}
plot(cars)
```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.

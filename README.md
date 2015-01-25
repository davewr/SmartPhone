Smartphone Project
---

Title: "README.md"
author: "Dave Robinson"
date: "Saturday, January 24, 2015"
output: html_document

---

The original README.txt that accompanied the data has been included in this archive as Original_README.txt. Please refer to it for any additional technical description of the original variables.

The instructions for creating the required data set(s) were:

Create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

###Running the Script
Place the script in a directory along with the required data.

Set the R working directory to match that of the script and the data.

In the R console (Using either R or R Studio) type:

source("run_analysis.R")

Messages like the following will be printed:

```

[1] "Starting column name extraction..."

[1] "Loading Activity File"

[1] "Loading Training Subjects"

[1] "Loading Test Subjects"

[1] "Loading Test Files -- sensor data"

[1] "Loading Training Files -- sensor data"

[1] "Extracting only columns with Median or Standard Deviation measurements"

[1] "Final groupings and output of ** SubjectActivityAverages.txt **"
```

###Output
The file "SubjectActivityAverages.txt" is produced with the requested averages for the second tidy data set.

Two tables will be left in the work space for review if necessary:

```
Final_Grouped

SubjectActivityAverages
```

The above tables can be used for plotting data or verifying data.

### Acknowledgement and Explanation of Data

The following is extracted or paraphrased from the original README.txt, the original Variables and Unit Information follows in a note:

The general explanation of the experiment is that: Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. 

The sensor data was collected and processed via various algorithms to give some indication of how each person performed the above listed activities during the day. 

###The dataset includes the following files:

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total\_acc\_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 

### Data Notes: 

- Features are normalized and bounded within [-1,1].
- Each feature vector is a row on the text file.


### Data Sharing Notice

Data is from the following study and available at the linked location:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

###License:

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012


This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.


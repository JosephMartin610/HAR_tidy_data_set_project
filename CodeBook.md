All steps from the source data set to the data sets discussed below were made in the R script named run_analysis.R.

The variables in data_HAR_means_by_activity_and_subject.txt are as follows:

1. GroupedBy: indicates if the means in that row are for an "activity" or "subject" group

2. GroupValue: contains value for one of the following
               activity: Each person performed six activities (?WALKING?, ?WALKING_UPSTAIRS?, 
                         ?WALKING_DOWNSTAIRS?, ?SITTING?, ?STANDING?, ?LAYING?) wearing 
                         a smartphone (Samsung Galaxy S II) on the waist.
               subject : subject's ID number (ranges from 1 to 30) 

3-68. The other variables in this dataset (3:68) come from the accelerometer and gyroscope 3-axial raw signalsA TimeAccXYZ and TimeGyroXYZ. These time domain signals (prefix "Time"") were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (TimeBodyAccXYZ and TimeGravityAccXYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz.

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (TimeBodyAccJerkXYZ and TimeBodyGyroJerkXYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (TimeBodyAccMag, TimeGravityAccMag, TimeBodyAccJerkMag, TimeBodyGyroMag, TimeBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing FreqBodyAccXYZ, FreqBodyAccJerkXYZ, FreqBodyGyroXYZ, FreqBodyAccJerkMag, FreqBodyGyroMag, FreqBodyGyroJerkMag. (Note the "Freq"" to indicate frequency domain signals).

These signals were used to estimate variables of the feature vector for each pattern: 'XYZ' is used to denote 3-axial signals in the X, Y, and Z directions.

Mean and STD (standard deviation) values were estimated from these signals and are designated by "Mean"" or "Std"", respectively, in the variable names.

Note that variables 3:68 ("TimeBodyAccMeanX" to "FreqBodyBodyGyroJerkMagStd") have been normalized and bounded within [-1,1].

An additional mean was taken to produce the means by group (specific activity or subject) appearing in data_HAR_means_by_activity_and_subject.txt. 
This is indicated by the "Mean" at the end of all variable names.
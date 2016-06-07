## bring in libraries needed for this script
library(dplyr)

## set working directory
setwd("/Users/martin/data_science/Getting_and_Cleaning_Data/course_project")
workingDir <- getwd()

## download raw data file
urlHAR <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fnHAR <- "getdata_projectfiles_UCI_HAR_Dataset.zip"
download.file(urlHAR,destfile=fnHAR,method="curl")
## unzip raw data file
## this creates and populates the "UCI HAR Dataset" directory
unzip(fnHAR)
baseDataDir <- paste0(workingDir,"/","UCI HAR Dataset")

## The subjects have been separated into the train (training) and test sets.
## Store these names in a vector
setNames <- c("train","test")

## specify the data file prefixes
dataFilesPrefixes  <-  c("subject_",                  "y_",          "X_")
## specify variable names to match these prefixes
dataNamesMatchFiles <- c("subjectnumber", "activitynumber", "featurevals")

## loop over set names and read in data for each set
for(i in 1:length(setNames))
{
    for (j in 1:length(dataFilesPrefixes))
    {
        fn_i_j <- paste0(baseDataDir,"/",setNames[i],"/",dataFilesPrefixes[j],setNames[i],".txt")
        data_i_j <- read.table(fn_i_j)
        assign(paste0(dataNamesMatchFiles[j],"_",setNames[i]),as.matrix(data_i_j))
    }
}
## remove variables that are not needed and are taking up space
rm("dataFilesPrefixes","i","j","fn_i_j","data_i_j")

## read in activity labels
fnHARactivityLabels <- "activity_labels.txt"
activityLabelsRead <- read.table(paste0(baseDataDir,"/",fnHARactivityLabels))
## because there is no header in the file, the columns are named "V1" and "V2"
## give them descriptive variable names
activityLabels <- rename(activityLabelsRead, activitynumber = V1, activitylabel = V2)

## convert activitynumber vectors read in from y_*.txt files to character vectors containing activity names
activitylabel_train <- character(length(activitynumber_train))
activitylabel_test  <- character(length(activitynumber_test))
for (k in 1:length(activityLabels$activitynumber)) {
    lg_k_train <- (activitynumber_train == activityLabels$activitynumber[k])
    activitylabel_train[lg_k_train] <- as.character(activityLabels$activitylabel[k])
    lg_k_test  <- (activitynumber_test  == activityLabels$activitynumber[k])
    activitylabel_test[lg_k_test]   <- as.character(activityLabels$activitylabel[k])
}
## remove variables that are not needed and are taking up space
rm("fnHARactivityLabels","activityLabelsRead","activityLabels","k","lg_k_train","lg_k_test")

## form a data.frame for each set
## store setname and activity as factors since they are categories
df_train <- data_frame( setname = as.factor(rep("training",length(subjectnumber_train))),
                        subjectnumber = as.vector(subjectnumber_train),
                        activity = as.factor(activitylabel_train) )
df_test  <- data_frame( setname = as.factor(rep("test",length(subjectnumber_test))),
                        subjectnumber = as.vector(subjectnumber_test),
                        activity = as.factor(activitylabel_test) )
## Step 3  completed: Used "descriptive activity names to name the activities in the data set."
## Step 4: partially completed: Appropriately labeled "the data set with descriptive variable names."

## read in feature names
fnHARFeatureNames <- "features.txt"
FeatureNamesRead <- read.table(paste0(baseDataDir,"/",fnHARFeatureNames))
## because there is no header in the file, the columns are named "V1" and "V2"
FeatureNames <- as.character(FeatureNamesRead$V2)
FeatureNames_hold <- FeatureNames

## improve the feature names
## remove dashes and parentheses from names
## replace mean(), std(), etc. with Mean, Std, etc.
## because the variable names have multiple parts, do not want to use all lowercase
## mean(): Mean value
FeatureNames <- sub("-mean\\(\\)-","Mean",FeatureNames)
FeatureNames <- sub("-mean\\(\\)","Mean",FeatureNames)
## std(): Standard deviation
FeatureNames <- sub("-std\\(\\)-","Std",FeatureNames)
FeatureNames <- sub("-std\\(\\)","Std",FeatureNames)
## mad(): Median absolute deviation
FeatureNames <- sub("-mad\\(\\)-","Mad",FeatureNames)
FeatureNames <- sub("-mad\\(\\)","Mad",FeatureNames)
## max(): Largest value in array
FeatureNames <- sub("-max\\(\\)-","Max",FeatureNames)
FeatureNames <- sub("-max\\(\\)","Max",FeatureNames)
## min(): Smallest value in array
FeatureNames <- sub("-min\\(\\)-","Min",FeatureNames)
FeatureNames <- sub("-min\\(\\)","Min",FeatureNames)
## sma(): Signal magnitude area
FeatureNames <- sub("-sma\\(\\)-","Sma",FeatureNames)
FeatureNames <- sub("-sma\\(\\)","Sma",FeatureNames)
## energy(): Energy measure. Sum of the squares divided by the number of values.
FeatureNames <- sub("-energy\\(\\)-","Energy",FeatureNames)
FeatureNames <- sub("-energy\\(\\)","Energy",FeatureNames)
## iqr(): Interquartile range
FeatureNames <- sub("-iqr\\(\\)-","Iqr",FeatureNames)
FeatureNames <- sub("-iqr\\(\\)","Iqr",FeatureNames)
## entropy(): Signal entropy
FeatureNames <- sub("-entropy\\(\\)-","Entropy",FeatureNames)
FeatureNames <- sub("-entropy\\(\\)","Entropy",FeatureNames)
## arCoeff(): Autorregresion coefficients with Burg order equal to 4
FeatureNames <- sub("-arCoeff\\(\\)-X,","ArCoeffX",FeatureNames)
FeatureNames <- sub("-arCoeff\\(\\)-Y,","ArCoeffY",FeatureNames)
FeatureNames <- sub("-arCoeff\\(\\)-Z,","ArCoeffZ",FeatureNames)
FeatureNames <- sub("-arCoeff\\(\\)1","ArCoeff1",FeatureNames)
FeatureNames <- sub("-arCoeff\\(\\)2","ArCoeff2",FeatureNames)
FeatureNames <- sub("-arCoeff\\(\\)3","ArCoeff3",FeatureNames)
FeatureNames <- sub("-arCoeff\\(\\)4","ArCoeff4",FeatureNames)
## correlation(): correlation coefficient between two signals
FeatureNames <- sub("-correlation\\(\\)-X,","CorrelationX",FeatureNames)
FeatureNames <- sub("-correlation\\(\\)-Y,","CorrelationY",FeatureNames)
## maxInds(): index of the frequency component with largest magnitude
FeatureNames <- sub("-maxInds-","MaxInds",FeatureNames)
FeatureNames <- sub("-maxInds","MaxInds",FeatureNames)
## meanFreq(): Weighted average of the frequency components to obtain a mean frequency
FeatureNames <- sub("-meanFreq\\(\\)-","MeanFreq",FeatureNames)
FeatureNames <- sub("-meanFreq\\(\\)","MeanFreq",FeatureNames)
## skewness(): skewness of the frequency domain signal
FeatureNames <- sub("-skewness\\(\\)-","Skewness",FeatureNames)
FeatureNames <- sub("-skewness\\(\\)","Skewness",FeatureNames)
## kurtosis(): kurtosis of the frequency domain signal
FeatureNames <- sub("-kurtosis\\(\\)-","Kurtosis",FeatureNames)
FeatureNames <- sub("-kurtosis\\(\\)","Kurtosis",FeatureNames)
## replace remaining (in bandsEneergy and angle) commas with underscores (this is not ideal, but not many choices left)
FeatureNames <- sub(",","_",FeatureNames)
## bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
FeatureNames <- sub("-bandsEnergy\\(\\)-","BandsEnergy_",FeatureNames)
## angle(): Angle between two vectors.
FeatureNames <- sub("angle\\(","Angle",FeatureNames)
FeatureNames <- gsub("\\)","",FeatureNames) # gsub for multiple instances
## replace leading "t" with "Time" and leading "f" with "Freq"
FeatureNames <- sub("^t","Time",FeatureNames)
FeatureNames <- sub("^f","Freq",FeatureNames)
## for consistency change the "t" in Angle variables too
FeatureNames <- sub("Anglet","AngleTime",FeatureNames)
## Step 4 completed: Appropriately labeled "the data set with descriptive variable names."

## check if full list is unique
#FeatureNames[duplicated(FeatureNames)]
## The only ones duplicated are BandsEnergy ones.

## Extract only the variables that have both a mean and std value
#FeatureNames[grep("Mean",FeatureNames)]
#FeatureNames[grep("Std",FeatureNames)]
## unfortunately, was unable have to do the following using a loop and without having to specify each variable to extract by name

## train

df_train <- mutate(df_train, TimeBodyAccMeanX              = featurevals_train[,(FeatureNames == "TimeBodyAccMeanX")])
df_train <- mutate(df_train, TimeBodyAccStdX               = featurevals_train[,(FeatureNames == "TimeBodyAccStdX")])
df_train <- mutate(df_train, TimeBodyAccMeanY              = featurevals_train[,(FeatureNames == "TimeBodyAccMeanY")])
df_train <- mutate(df_train, TimeBodyAccStdY               = featurevals_train[,(FeatureNames == "TimeBodyAccStdY")])
df_train <- mutate(df_train, TimeBodyAccMeanZ              = featurevals_train[,(FeatureNames == "TimeBodyAccMeanZ")])
df_train <- mutate(df_train, TimeBodyAccStdZ               = featurevals_train[,(FeatureNames == "TimeBodyAccStdZ")])

df_train <- mutate(df_train, TimeGravityAccMeanX           = featurevals_train[,(FeatureNames == "TimeGravityAccMeanX")])
df_train <- mutate(df_train, TimeGravityAccStdX            = featurevals_train[,(FeatureNames == "TimeGravityAccStdX")])
df_train <- mutate(df_train, TimeGravityAccMeanY           = featurevals_train[,(FeatureNames == "TimeGravityAccMeanY")])
df_train <- mutate(df_train, TimeGravityAccStdY            = featurevals_train[,(FeatureNames == "TimeGravityAccStdY")])
df_train <- mutate(df_train, TimeGravityAccMeanZ           = featurevals_train[,(FeatureNames == "TimeGravityAccMeanZ")])
df_train <- mutate(df_train, TimeGravityAccStdZ            = featurevals_train[,(FeatureNames == "TimeGravityAccStdZ")])

df_train <- mutate(df_train, TimeBodyAccJerkMeanX          = featurevals_train[,(FeatureNames == "TimeBodyAccJerkMeanX")])
df_train <- mutate(df_train, TimeBodyAccJerkStdX           = featurevals_train[,(FeatureNames == "TimeBodyAccJerkStdX")])
df_train <- mutate(df_train, TimeBodyAccJerkMeanY          = featurevals_train[,(FeatureNames == "TimeBodyAccJerkMeanY")])
df_train <- mutate(df_train, TimeBodyAccJerkStdY           = featurevals_train[,(FeatureNames == "TimeBodyAccJerkStdY")])
df_train <- mutate(df_train, TimeBodyAccJerkMeanZ          = featurevals_train[,(FeatureNames == "TimeBodyAccJerkMeanZ")])
df_train <- mutate(df_train, TimeBodyAccJerkStdZ           = featurevals_train[,(FeatureNames == "TimeBodyAccJerkStdZ")])

df_train <- mutate(df_train, TimeBodyGyroMeanX             = featurevals_train[,(FeatureNames == "TimeBodyGyroMeanX")])
df_train <- mutate(df_train, TimeBodyGyroStdX              = featurevals_train[,(FeatureNames == "TimeBodyGyroStdX")])
df_train <- mutate(df_train, TimeBodyGyroMeanY             = featurevals_train[,(FeatureNames == "TimeBodyGyroMeanY")])
df_train <- mutate(df_train, TimeBodyGyroStdY              = featurevals_train[,(FeatureNames == "TimeBodyGyroStdY")])
df_train <- mutate(df_train, TimeBodyGyroMeanZ             = featurevals_train[,(FeatureNames == "TimeBodyGyroMeanZ")])
df_train <- mutate(df_train, TimeBodyGyroStdZ              = featurevals_train[,(FeatureNames == "TimeBodyGyroStdZ")])

df_train <- mutate(df_train, TimeBodyGyroJerkMeanX         = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkMeanX")])
df_train <- mutate(df_train, TimeBodyGyroJerkStdX          = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkStdX")])
df_train <- mutate(df_train, TimeBodyGyroJerkMeanY         = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkMeanY")])
df_train <- mutate(df_train, TimeBodyGyroJerkStdY          = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkStdY")])
df_train <- mutate(df_train, TimeBodyGyroJerkMeanZ         = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkMeanZ")])
df_train <- mutate(df_train, TimeBodyGyroJerkStdZ          = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkStdZ")])

df_train <- mutate(df_train, TimeBodyAccMagMean            = featurevals_train[,(FeatureNames == "TimeBodyAccMagMean")])
df_train <- mutate(df_train, TimeBodyAccMagStd             = featurevals_train[,(FeatureNames == "TimeBodyAccMagStd")])
df_train <- mutate(df_train, TimeGravityAccMagMean         = featurevals_train[,(FeatureNames == "TimeGravityAccMagMean")])
df_train <- mutate(df_train, TimeGravityAccMagStd          = featurevals_train[,(FeatureNames == "TimeGravityAccMagStd")])
df_train <- mutate(df_train, TimeBodyAccJerkMagMean        = featurevals_train[,(FeatureNames == "TimeBodyAccJerkMagMean")])
df_train <- mutate(df_train, TimeBodyAccJerkMagStd         = featurevals_train[,(FeatureNames == "TimeBodyAccJerkMagStd")])
df_train <- mutate(df_train, TimeBodyGyroMagMean           = featurevals_train[,(FeatureNames == "TimeBodyGyroMagMean")])
df_train <- mutate(df_train, TimeBodyGyroMagStd            = featurevals_train[,(FeatureNames == "TimeBodyGyroMagStd")])
df_train <- mutate(df_train, TimeBodyGyroJerkMagMean       = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkMagMean")])
df_train <- mutate(df_train, TimeBodyGyroJerkMagStd        = featurevals_train[,(FeatureNames == "TimeBodyGyroJerkMagStd")])

df_train <- mutate(df_train, FreqBodyAccMeanX              = featurevals_train[,(FeatureNames == "FreqBodyAccMeanX")])
df_train <- mutate(df_train, FreqBodyAccStdX               = featurevals_train[,(FeatureNames == "FreqBodyAccStdX")])
df_train <- mutate(df_train, FreqBodyAccMeanY              = featurevals_train[,(FeatureNames == "FreqBodyAccMeanY")])
df_train <- mutate(df_train, FreqBodyAccStdY               = featurevals_train[,(FeatureNames == "FreqBodyAccStdY")])
df_train <- mutate(df_train, FreqBodyAccMeanZ              = featurevals_train[,(FeatureNames == "FreqBodyAccMeanZ")])
df_train <- mutate(df_train, FreqBodyAccStdZ               = featurevals_train[,(FeatureNames == "FreqBodyAccStdZ")])

df_train <- mutate(df_train, FreqBodyAccJerkMeanX          = featurevals_train[,(FeatureNames == "FreqBodyAccJerkMeanX")])
df_train <- mutate(df_train, FreqBodyAccJerkStdX           = featurevals_train[,(FeatureNames == "FreqBodyAccJerkStdX")])
df_train <- mutate(df_train, FreqBodyAccJerkMeanY          = featurevals_train[,(FeatureNames == "FreqBodyAccJerkMeanY")])
df_train <- mutate(df_train, FreqBodyAccJerkStdY           = featurevals_train[,(FeatureNames == "FreqBodyAccJerkStdY")])
df_train <- mutate(df_train, FreqBodyAccJerkMeanZ          = featurevals_train[,(FeatureNames == "FreqBodyAccJerkMeanZ")])
df_train <- mutate(df_train, FreqBodyAccJerkStdZ           = featurevals_train[,(FeatureNames == "FreqBodyAccJerkStdZ")])

df_train <- mutate(df_train, FreqBodyGyroMeanX             = featurevals_train[,(FeatureNames == "FreqBodyGyroMeanX")])
df_train <- mutate(df_train, FreqBodyGyroStdX              = featurevals_train[,(FeatureNames == "FreqBodyGyroStdX")])
df_train <- mutate(df_train, FreqBodyGyroMeanY             = featurevals_train[,(FeatureNames == "FreqBodyGyroMeanY")])
df_train <- mutate(df_train, FreqBodyGyroStdY              = featurevals_train[,(FeatureNames == "FreqBodyGyroStdY")])
df_train <- mutate(df_train, FreqBodyGyroMeanZ             = featurevals_train[,(FeatureNames == "FreqBodyGyroMeanZ")])
df_train <- mutate(df_train, FreqBodyGyroStdZ              = featurevals_train[,(FeatureNames == "FreqBodyGyroStdZ")])

df_train <- mutate(df_train, FreqBodyAccMagMean            = featurevals_train[,(FeatureNames == "FreqBodyAccMagMean")])
df_train <- mutate(df_train, FreqBodyAccMagStd             = featurevals_train[,(FeatureNames == "FreqBodyAccMagStd")])
df_train <- mutate(df_train, FreqBodyBodyAccJerkMagMean    = featurevals_train[,(FeatureNames == "FreqBodyBodyAccJerkMagMean")])
df_train <- mutate(df_train, FreqBodyBodyAccJerkMagStd     = featurevals_train[,(FeatureNames == "FreqBodyBodyAccJerkMagStd")])
df_train <- mutate(df_train, FreqBodyBodyGyroMagMean       = featurevals_train[,(FeatureNames == "FreqBodyBodyGyroMagMean")])
df_train <- mutate(df_train, FreqBodyBodyGyroMagStd        = featurevals_train[,(FeatureNames == "FreqBodyBodyGyroMagStd")])
df_train <- mutate(df_train, FreqBodyBodyGyroJerkMagMean   = featurevals_train[,(FeatureNames == "FreqBodyBodyGyroJerkMagMean")])
df_train <- mutate(df_train, FreqBodyBodyGyroJerkMagStd    = featurevals_train[,(FeatureNames == "FreqBodyBodyGyroJerkMagStd")])

## used this to do spot checks that putting data in df_train went correctly
#str_chk <- "FreqBodyAccStdY"
#inds_chk <- 7001:7020
#FeatureNames[FeatureNames == str_chk]
#featurevals_train[inds_chk,(FeatureNames == str_chk)]
#var_chk <- eval(parse(text=paste0("df_train$",FeatureNames[FeatureNames == str_chk])))
#var_chk[inds_chk]

## used this confirm all data are between -1 and 1
#summary(df_train)

rm("featurevals_train")

## test

df_test <- mutate(df_test, TimeBodyAccMeanX              = featurevals_test[,(FeatureNames == "TimeBodyAccMeanX")])
df_test <- mutate(df_test, TimeBodyAccStdX               = featurevals_test[,(FeatureNames == "TimeBodyAccStdX")])
df_test <- mutate(df_test, TimeBodyAccMeanY              = featurevals_test[,(FeatureNames == "TimeBodyAccMeanY")])
df_test <- mutate(df_test, TimeBodyAccStdY               = featurevals_test[,(FeatureNames == "TimeBodyAccStdY")])
df_test <- mutate(df_test, TimeBodyAccMeanZ              = featurevals_test[,(FeatureNames == "TimeBodyAccMeanZ")])
df_test <- mutate(df_test, TimeBodyAccStdZ               = featurevals_test[,(FeatureNames == "TimeBodyAccStdZ")])

df_test <- mutate(df_test, TimeGravityAccMeanX           = featurevals_test[,(FeatureNames == "TimeGravityAccMeanX")])
df_test <- mutate(df_test, TimeGravityAccStdX            = featurevals_test[,(FeatureNames == "TimeGravityAccStdX")])
df_test <- mutate(df_test, TimeGravityAccMeanY           = featurevals_test[,(FeatureNames == "TimeGravityAccMeanY")])
df_test <- mutate(df_test, TimeGravityAccStdY            = featurevals_test[,(FeatureNames == "TimeGravityAccStdY")])
df_test <- mutate(df_test, TimeGravityAccMeanZ           = featurevals_test[,(FeatureNames == "TimeGravityAccMeanZ")])
df_test <- mutate(df_test, TimeGravityAccStdZ            = featurevals_test[,(FeatureNames == "TimeGravityAccStdZ")])

df_test <- mutate(df_test, TimeBodyAccJerkMeanX          = featurevals_test[,(FeatureNames == "TimeBodyAccJerkMeanX")])
df_test <- mutate(df_test, TimeBodyAccJerkStdX           = featurevals_test[,(FeatureNames == "TimeBodyAccJerkStdX")])
df_test <- mutate(df_test, TimeBodyAccJerkMeanY          = featurevals_test[,(FeatureNames == "TimeBodyAccJerkMeanY")])
df_test <- mutate(df_test, TimeBodyAccJerkStdY           = featurevals_test[,(FeatureNames == "TimeBodyAccJerkStdY")])
df_test <- mutate(df_test, TimeBodyAccJerkMeanZ          = featurevals_test[,(FeatureNames == "TimeBodyAccJerkMeanZ")])
df_test <- mutate(df_test, TimeBodyAccJerkStdZ           = featurevals_test[,(FeatureNames == "TimeBodyAccJerkStdZ")])

df_test <- mutate(df_test, TimeBodyGyroMeanX             = featurevals_test[,(FeatureNames == "TimeBodyGyroMeanX")])
df_test <- mutate(df_test, TimeBodyGyroStdX              = featurevals_test[,(FeatureNames == "TimeBodyGyroStdX")])
df_test <- mutate(df_test, TimeBodyGyroMeanY             = featurevals_test[,(FeatureNames == "TimeBodyGyroMeanY")])
df_test <- mutate(df_test, TimeBodyGyroStdY              = featurevals_test[,(FeatureNames == "TimeBodyGyroStdY")])
df_test <- mutate(df_test, TimeBodyGyroMeanZ             = featurevals_test[,(FeatureNames == "TimeBodyGyroMeanZ")])
df_test <- mutate(df_test, TimeBodyGyroStdZ              = featurevals_test[,(FeatureNames == "TimeBodyGyroStdZ")])

df_test <- mutate(df_test, TimeBodyGyroJerkMeanX         = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkMeanX")])
df_test <- mutate(df_test, TimeBodyGyroJerkStdX          = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkStdX")])
df_test <- mutate(df_test, TimeBodyGyroJerkMeanY         = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkMeanY")])
df_test <- mutate(df_test, TimeBodyGyroJerkStdY          = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkStdY")])
df_test <- mutate(df_test, TimeBodyGyroJerkMeanZ         = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkMeanZ")])
df_test <- mutate(df_test, TimeBodyGyroJerkStdZ          = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkStdZ")])

df_test <- mutate(df_test, TimeBodyAccMagMean            = featurevals_test[,(FeatureNames == "TimeBodyAccMagMean")])
df_test <- mutate(df_test, TimeBodyAccMagStd             = featurevals_test[,(FeatureNames == "TimeBodyAccMagStd")])
df_test <- mutate(df_test, TimeGravityAccMagMean         = featurevals_test[,(FeatureNames == "TimeGravityAccMagMean")])
df_test <- mutate(df_test, TimeGravityAccMagStd          = featurevals_test[,(FeatureNames == "TimeGravityAccMagStd")])
df_test <- mutate(df_test, TimeBodyAccJerkMagMean        = featurevals_test[,(FeatureNames == "TimeBodyAccJerkMagMean")])
df_test <- mutate(df_test, TimeBodyAccJerkMagStd         = featurevals_test[,(FeatureNames == "TimeBodyAccJerkMagStd")])
df_test <- mutate(df_test, TimeBodyGyroMagMean           = featurevals_test[,(FeatureNames == "TimeBodyGyroMagMean")])
df_test <- mutate(df_test, TimeBodyGyroMagStd            = featurevals_test[,(FeatureNames == "TimeBodyGyroMagStd")])
df_test <- mutate(df_test, TimeBodyGyroJerkMagMean       = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkMagMean")])
df_test <- mutate(df_test, TimeBodyGyroJerkMagStd        = featurevals_test[,(FeatureNames == "TimeBodyGyroJerkMagStd")])

df_test <- mutate(df_test, FreqBodyAccMeanX              = featurevals_test[,(FeatureNames == "FreqBodyAccMeanX")])
df_test <- mutate(df_test, FreqBodyAccStdX               = featurevals_test[,(FeatureNames == "FreqBodyAccStdX")])
df_test <- mutate(df_test, FreqBodyAccMeanY              = featurevals_test[,(FeatureNames == "FreqBodyAccMeanY")])
df_test <- mutate(df_test, FreqBodyAccStdY               = featurevals_test[,(FeatureNames == "FreqBodyAccStdY")])
df_test <- mutate(df_test, FreqBodyAccMeanZ              = featurevals_test[,(FeatureNames == "FreqBodyAccMeanZ")])
df_test <- mutate(df_test, FreqBodyAccStdZ               = featurevals_test[,(FeatureNames == "FreqBodyAccStdZ")])

df_test <- mutate(df_test, FreqBodyAccJerkMeanX          = featurevals_test[,(FeatureNames == "FreqBodyAccJerkMeanX")])
df_test <- mutate(df_test, FreqBodyAccJerkStdX           = featurevals_test[,(FeatureNames == "FreqBodyAccJerkStdX")])
df_test <- mutate(df_test, FreqBodyAccJerkMeanY          = featurevals_test[,(FeatureNames == "FreqBodyAccJerkMeanY")])
df_test <- mutate(df_test, FreqBodyAccJerkStdY           = featurevals_test[,(FeatureNames == "FreqBodyAccJerkStdY")])
df_test <- mutate(df_test, FreqBodyAccJerkMeanZ          = featurevals_test[,(FeatureNames == "FreqBodyAccJerkMeanZ")])
df_test <- mutate(df_test, FreqBodyAccJerkStdZ           = featurevals_test[,(FeatureNames == "FreqBodyAccJerkStdZ")])

df_test <- mutate(df_test, FreqBodyGyroMeanX             = featurevals_test[,(FeatureNames == "FreqBodyGyroMeanX")])
df_test <- mutate(df_test, FreqBodyGyroStdX              = featurevals_test[,(FeatureNames == "FreqBodyGyroStdX")])
df_test <- mutate(df_test, FreqBodyGyroMeanY             = featurevals_test[,(FeatureNames == "FreqBodyGyroMeanY")])
df_test <- mutate(df_test, FreqBodyGyroStdY              = featurevals_test[,(FeatureNames == "FreqBodyGyroStdY")])
df_test <- mutate(df_test, FreqBodyGyroMeanZ             = featurevals_test[,(FeatureNames == "FreqBodyGyroMeanZ")])
df_test <- mutate(df_test, FreqBodyGyroStdZ              = featurevals_test[,(FeatureNames == "FreqBodyGyroStdZ")])

df_test <- mutate(df_test, FreqBodyAccMagMean            = featurevals_test[,(FeatureNames == "FreqBodyAccMagMean")])
df_test <- mutate(df_test, FreqBodyAccMagStd             = featurevals_test[,(FeatureNames == "FreqBodyAccMagStd")])
df_test <- mutate(df_test, FreqBodyBodyAccJerkMagMean    = featurevals_test[,(FeatureNames == "FreqBodyBodyAccJerkMagMean")])
df_test <- mutate(df_test, FreqBodyBodyAccJerkMagStd     = featurevals_test[,(FeatureNames == "FreqBodyBodyAccJerkMagStd")])
df_test <- mutate(df_test, FreqBodyBodyGyroMagMean       = featurevals_test[,(FeatureNames == "FreqBodyBodyGyroMagMean")])
df_test <- mutate(df_test, FreqBodyBodyGyroMagStd        = featurevals_test[,(FeatureNames == "FreqBodyBodyGyroMagStd")])
df_test <- mutate(df_test, FreqBodyBodyGyroJerkMagMean   = featurevals_test[,(FeatureNames == "FreqBodyBodyGyroJerkMagMean")])
df_test <- mutate(df_test, FreqBodyBodyGyroJerkMagStd    = featurevals_test[,(FeatureNames == "FreqBodyBodyGyroJerkMagStd")])

## just used this to do spot checks that putting data in df_test went correctly
#str_chk <- "TimeBodyAccJerkMeanX"
#inds_chk <- 2001:2020
#FeatureNames[FeatureNames == str_chk]
#featurevals_test[inds_chk,(FeatureNames == str_chk)]
#var_chk <- eval(parse(text=paste0("df_test$",FeatureNames[FeatureNames == str_chk])))
#var_chk[inds_chk]

## used this confirm all data are between -1 and 1
#summary(df_test)

rm("featurevals_test")

## Step 2 completed: Extracted "only the measurements on the mean and standard deviation for each measurement."

## merge the training and test data frames
## temporarily turn off warning messages:
## In rbind_all(x, .id) : Unequal factor levels: coercing to character
## In rbind_all(x, .id) : Unequal factor levels: coercing to character
warn_orig <- options("warn")
options(warn = -1)
dfHAR <- bind_rows(list(df_train, df_test))
options(warn = warn_orig$warn)
## make setname and subjectnumber factors again
dfHAR <- mutate(dfHAR, setname = as.factor(setname))
dfHAR <- mutate(dfHAR, subjectnumber = as.factor(subjectnumber))
## Step 1 completed: Merged "the training and the test sets to create one data set."

## group the data frame by activity and subject
dfHAR_gb_activity <- group_by(dfHAR, activity)
dfHAR_gb_subject  <- group_by(dfHAR, subjectnumber)

## determine average of each variable grouped by activity

dfHAR_summ_activity <- summarize(dfHAR_gb_activity, TimeBodyAccMeanXMean = mean(TimeBodyAccMeanX, na.rm = TRUE))
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccStdXMean  = mean(TimeBodyAccStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccMeanYMean = mean(TimeBodyAccMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccStdYMean  = mean(TimeBodyAccStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccMeanZMean = mean(TimeBodyAccMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccStdZMean  = mean(TimeBodyAccStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccMeanXMean = mean(TimeGravityAccMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccStdXMean  = mean(TimeGravityAccStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccMeanYMean = mean(TimeGravityAccMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccStdYMean  = mean(TimeGravityAccStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccMeanZMean = mean(TimeGravityAccMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccStdZMean  = mean(TimeGravityAccStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkMeanXMean = mean(TimeBodyAccJerkMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkStdXMean  = mean(TimeBodyAccJerkStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkMeanYMean = mean(TimeBodyAccJerkMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkStdYMean  = mean(TimeBodyAccJerkStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkMeanZMean = mean(TimeBodyAccJerkMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkStdZMean  = mean(TimeBodyAccJerkStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroMeanXMean = mean(TimeBodyGyroMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroStdXMean  = mean(TimeBodyGyroStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroMeanYMean = mean(TimeBodyGyroMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroStdYMean  = mean(TimeBodyGyroStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroMeanZMean = mean(TimeBodyGyroMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroStdZMean  = mean(TimeBodyGyroStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkMeanXMean = mean(TimeBodyGyroJerkMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkStdXMean  = mean(TimeBodyGyroJerkStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkMeanYMean = mean(TimeBodyGyroJerkMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkStdYMean  = mean(TimeBodyGyroJerkStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkMeanZMean = mean(TimeBodyGyroJerkMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkStdZMean  = mean(TimeBodyGyroJerkStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccMagMeanMean = mean(TimeBodyAccMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccMagStdMean = mean(TimeBodyAccMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccMagMeanMean = mean(TimeGravityAccMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeGravityAccMagStdMean = mean(TimeGravityAccMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkMagMeanMean = mean(TimeBodyAccJerkMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyAccJerkMagStdMean = mean(TimeBodyAccJerkMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroMagMeanMean = mean(TimeBodyGyroMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroMagStdMean = mean(TimeBodyGyroMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkMagMeanMean = mean(TimeBodyGyroJerkMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, TimeBodyGyroJerkMagStdMean = mean(TimeBodyGyroJerkMagStd, na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccMeanXMean = mean(FreqBodyAccMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccStdXMean  = mean(FreqBodyAccStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccMeanYMean = mean(FreqBodyAccMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccStdYMean  = mean(FreqBodyAccStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccMeanZMean = mean(FreqBodyAccMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccStdZMean  = mean(FreqBodyAccStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccJerkMeanXMean = mean(FreqBodyAccJerkMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccJerkStdXMean  = mean(FreqBodyAccJerkStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccJerkMeanYMean = mean(FreqBodyAccJerkMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccJerkStdYMean  = mean(FreqBodyAccJerkStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccJerkMeanZMean = mean(FreqBodyAccJerkMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccJerkStdZMean  = mean(FreqBodyAccJerkStdZ , na.rm = TRUE)), by="activity")

dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyGyroMeanXMean = mean(FreqBodyGyroMeanX, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyGyroStdXMean  = mean(FreqBodyGyroStdX , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyGyroMeanYMean = mean(FreqBodyGyroMeanY, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyGyroStdYMean  = mean(FreqBodyGyroStdY , na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyGyroMeanZMean = mean(FreqBodyGyroMeanZ, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyGyroStdZMean  = mean(FreqBodyGyroStdZ , na.rm = TRUE)), by="activity")
  
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccMagMeanMean = mean(FreqBodyAccMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyAccMagStdMean = mean(FreqBodyAccMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyBodyAccJerkMagMeanMean = mean(FreqBodyBodyAccJerkMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyBodyAccJerkMagStdMean = mean(FreqBodyBodyAccJerkMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyBodyGyroMagMeanMean = mean(FreqBodyBodyGyroMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyBodyGyroMagStdMean = mean(FreqBodyBodyGyroMagStd, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyBodyGyroJerkMagMeanMean = mean(FreqBodyBodyGyroJerkMagMean, na.rm = TRUE)), by="activity")
dfHAR_summ_activity <- merge(dfHAR_summ_activity,summarize(dfHAR_gb_activity, FreqBodyBodyGyroJerkMagStdMean = mean(FreqBodyBodyGyroJerkMagStd, na.rm = TRUE)), by="activity")

## determine average of each variable grouped by subject

dfHAR_summ_subject <- summarize(dfHAR_gb_subject, TimeBodyAccMeanXMean = mean(TimeBodyAccMeanX, na.rm = TRUE))
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccStdXMean  = mean(TimeBodyAccStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccMeanYMean = mean(TimeBodyAccMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccStdYMean  = mean(TimeBodyAccStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccMeanZMean = mean(TimeBodyAccMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccStdZMean  = mean(TimeBodyAccStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccMeanXMean = mean(TimeGravityAccMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccStdXMean  = mean(TimeGravityAccStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccMeanYMean = mean(TimeGravityAccMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccStdYMean  = mean(TimeGravityAccStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccMeanZMean = mean(TimeGravityAccMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccStdZMean  = mean(TimeGravityAccStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkMeanXMean = mean(TimeBodyAccJerkMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkStdXMean  = mean(TimeBodyAccJerkStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkMeanYMean = mean(TimeBodyAccJerkMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkStdYMean  = mean(TimeBodyAccJerkStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkMeanZMean = mean(TimeBodyAccJerkMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkStdZMean  = mean(TimeBodyAccJerkStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroMeanXMean = mean(TimeBodyGyroMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroStdXMean  = mean(TimeBodyGyroStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroMeanYMean = mean(TimeBodyGyroMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroStdYMean  = mean(TimeBodyGyroStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroMeanZMean = mean(TimeBodyGyroMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroStdZMean  = mean(TimeBodyGyroStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkMeanXMean = mean(TimeBodyGyroJerkMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkStdXMean  = mean(TimeBodyGyroJerkStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkMeanYMean = mean(TimeBodyGyroJerkMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkStdYMean  = mean(TimeBodyGyroJerkStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkMeanZMean = mean(TimeBodyGyroJerkMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkStdZMean  = mean(TimeBodyGyroJerkStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccMagMeanMean = mean(TimeBodyAccMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccMagStdMean = mean(TimeBodyAccMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccMagMeanMean = mean(TimeGravityAccMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeGravityAccMagStdMean = mean(TimeGravityAccMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkMagMeanMean = mean(TimeBodyAccJerkMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyAccJerkMagStdMean = mean(TimeBodyAccJerkMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroMagMeanMean = mean(TimeBodyGyroMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroMagStdMean = mean(TimeBodyGyroMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkMagMeanMean = mean(TimeBodyGyroJerkMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, TimeBodyGyroJerkMagStdMean = mean(TimeBodyGyroJerkMagStd, na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccMeanXMean = mean(FreqBodyAccMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccStdXMean  = mean(FreqBodyAccStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccMeanYMean = mean(FreqBodyAccMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccStdYMean  = mean(FreqBodyAccStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccMeanZMean = mean(FreqBodyAccMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccStdZMean  = mean(FreqBodyAccStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccJerkMeanXMean = mean(FreqBodyAccJerkMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccJerkStdXMean  = mean(FreqBodyAccJerkStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccJerkMeanYMean = mean(FreqBodyAccJerkMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccJerkStdYMean  = mean(FreqBodyAccJerkStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccJerkMeanZMean = mean(FreqBodyAccJerkMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccJerkStdZMean  = mean(FreqBodyAccJerkStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyGyroMeanXMean = mean(FreqBodyGyroMeanX, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyGyroStdXMean  = mean(FreqBodyGyroStdX , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyGyroMeanYMean = mean(FreqBodyGyroMeanY, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyGyroStdYMean  = mean(FreqBodyGyroStdY , na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyGyroMeanZMean = mean(FreqBodyGyroMeanZ, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyGyroStdZMean  = mean(FreqBodyGyroStdZ , na.rm = TRUE)), by="subjectnumber")

dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccMagMeanMean = mean(FreqBodyAccMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyAccMagStdMean = mean(FreqBodyAccMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyBodyAccJerkMagMeanMean = mean(FreqBodyBodyAccJerkMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyBodyAccJerkMagStdMean = mean(FreqBodyBodyAccJerkMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyBodyGyroMagMeanMean = mean(FreqBodyBodyGyroMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyBodyGyroMagStdMean = mean(FreqBodyBodyGyroMagStd, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyBodyGyroJerkMagMeanMean = mean(FreqBodyBodyGyroJerkMagMean, na.rm = TRUE)), by="subjectnumber")
dfHAR_summ_subject <- merge(dfHAR_summ_subject,summarize(dfHAR_gb_subject, FreqBodyBodyGyroJerkMagStdMean = mean(FreqBodyBodyGyroJerkMagStd, na.rm = TRUE)), by="subjectnumber")

## arrange dfHAR_summ_subject by subjectnumber
dfHAR_summ_subject <- arrange(dfHAR_summ_subject,subjectnumber)

## Step 5 completed: From the data set in step 4, created a second, independent tidy data set 
##                   with the average of each variable for each activity and each subject.

## In the submission instructions it seems like they want dfHAR_summ_activity and dfHAR_summ_subject 
## in the same text file so we need merge them here
dfHAR_summ_activity_for_merge <- mutate( dfHAR_summ_activity, GroupedBy = as.factor( rep("activity", length(dfHAR_summ_activity$activity)) ) )
dfHAR_summ_activity_for_merge <- rename(dfHAR_summ_activity_for_merge, GroupValue = activity)
dfHAR_summ_activity_for_merge <- select(dfHAR_summ_activity_for_merge, GroupedBy, everything())
dfHAR_summ_subject_for_merge <- mutate( dfHAR_summ_subject, GroupedBy = as.factor( rep("subject", length(dfHAR_summ_subject$subject)) ), subjectnumber = as.factor(subjectnumber) )
dfHAR_summ_subject_for_merge <- rename(dfHAR_summ_subject_for_merge, GroupValue = subjectnumber)
dfHAR_summ_subject_for_merge <- select(dfHAR_summ_subject_for_merge, GroupedBy, everything())
warn_orig <- options("warn")
options(warn = -1)
dfHAR_means <- bind_rows(list(dfHAR_summ_activity_for_merge, dfHAR_summ_subject_for_merge))
options(warn = warn_orig$warn)
## make GroupedBy and GroupValue factors again
dfHAR_means <- mutate(dfHAR_means, GroupedBy = as.factor(GroupedBy), GroupValue = as.factor(GroupValue))

## save data sets to files
#write.table(dfHAR, file = "data_HAR.txt", row.name=FALSE)
write.table(dfHAR_means, file = "data_HAR_means_by_activity_and_subject.txt", row.name=FALSE)
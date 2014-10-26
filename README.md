Getting and Cleaning Data - Course Project
==========================================
A short description on the 'Run_analysis.R' script

- This script merges the taining & test sets and extracts the required information from other text files to create a       single cleaned data table on which analysis can be performed

- Important : To run this script, packages 'sqldf' and 'data.table' should be installed.

- Data for the project has been extracted from the link 
  'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'. Unzip the data in the working    directory. Re-name the folder to 'dataset'

- Save the script 'Run_analysis.R' in the working directory and run source("Run_analysis.R") in the command window of      RStudio. If not, the code can be copy pasted in the command window of RStudio. Command source("Run_analysis.R") will     take about a minute to complete.
  
- Script geneartes two cleaned data texts which are saved in the 'Output' folder inside the 'dataset' folder.

  - a) Tidy_data.txt - Cleaned dataset with 10299*68 dimensions.
  - b) TidyData_Grouped_Means.txt - Cleaned dataset with 180*68 dimension. The grouping gives the average of each of the        66 variables/features for each activity (6 in number) and each subject (30 in number)

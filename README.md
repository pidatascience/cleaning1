# Wearable Computing
# General Description
This repo holds all code and documentation related to the project course assignment for Coursera's [[https://class.coursera.org/getdata-013/human_grading/view/courses/973500/assessments/3/submissions][Getting and Cleaning Data]] MOOC.

# General file layout
There are 3 main files in the repository:
* [[https://github.com/pidatascience/wearablecomputing/blob/master/run_analysis.R][run_analysis.R]] holds the R code required to build the output data frame as described in the code book
* [[https://github.com/pidatascience/wearablecomputing/blob/master/CodeBook.md][CodeBook.md]] describes all variables of the output data frame.
* [[https://github.com/pidatascience/wearablecomputing/blob/master/README.md][README.md]] documents the repository and purpose of the R files

# Running
To generate the output files, simply run file run_analysis.R. The following requiremets need to be met before running the file:
  * Libraries:
    * dplyr
    * reshape
    * reshape2
    * data.table
  * Active Internet connection (optional, see below)
If you already have a copy of the data available you can place it in the current R working directory with name "data.zip", this will prevent the script from re-downloading and may be useful in environments with limited Internet connectivity.
The output of the script will be a file called wearablecomputing.txt described in [[https://github.com/pidatascience/wearablecomputing/blob/master/CodeBook.md][CodeBook.md]]

# run_analysis.R
There are 3 main sections to the file:
  * Importing required libraries
  * Process Data
  * Cleanup
Of these, the only one adding any true value is 'Process Data' and is in turn divided into the following subsections:
## Process ancillary data
This section produces two small data frames called activities and features which load data from the appropriate files in the top level directory. These data frames are temporary and only serve to label columns (features) and populate the column activities (activities) row of the final frame.
The features data frame is augmented with the following columns for convenience in data IO in the next section:
  * colclass: Contains NA for all average and standard deviation column names, and "NULL" otherwise. Please refer to the documentation of the colclasses parameter of read.fwf/read.table methods for information on the meaning of these values:
  * width: set at a constant 16 representing the number of characters for each column in fixed witdth format.
## Set up Data IO routine
This is the main section of the script. It leverages the fact that the directory and file structure for test and train data sets is identical with the sole difference of the names "train" and "test" labeling each directory and file.
A function read.data is defined taking as parameters both the name of the set (data.set) and a max number of records to extract from each set (data.n). This last parameter is included only for troubleshooting puposes and will be ignored in descriptions going forward.
This routine reads a single data set from the input data set name (data.set) and proceeds to load the fixed width format file "X_(data.set).txt" leveraging read.fwf's arguments to achieve both labeling and column filtering at the earliest possible time. This takes advantage of the extra columns of the features data set described earlier
The rest of the routine adds subject data from file "subject_(data.set).txt" as an extra column and then activity id data from file "y_(data.set).txt"; this last column is then mutated to translate according to the acitivy data frame computed in the last section
## FP reading and merging of the data
Given the data IO routing in the previous section it's trivial to load the data as a merging of all the returned data frames from applications of routine read.data with a bit of Functional Programming reasoning and the help of the do.call function.
## Summarize by subject
We summarize the data frame in the previous section using a function call to aggregate where we achieve a tapply across all columns aggregating on the subject column using average summarization as requested
## Write output file
Self explanatory


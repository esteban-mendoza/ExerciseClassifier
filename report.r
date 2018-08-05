# Required libraries
library(caret)
library(tidyverse)

# Creating data directory
dir.create(file.path("data"))

# Downloading data
url_training = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
url_testing = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

download.file(url_training, destfile = "data/pml-training.csv")
download.file(url_testing, destfile = "data/pml-testing.csv")

# Loading data
training = read.csv("data/pml-training.csv", na.strings = c("#DIV/0!","NA"))
testing = read_csv("data/pml-testing.csv", na="#DIV/0!")

# Dropping row names variable (X)
training = as_tibble(training)
training = select(training, -X)

# Copy of training
x = training


## Preprocessing

nvars = dim(x)[2]
vars_to_keep = vector(length = nvars)

# If a given variable has less than 90% of NA's, we keep it
for (i in 1:nvars) {
    if (mean(is.na(x[,i])) < 0.9) {
        vars_to_keep[i] = TRUE
    }
}

# Dropping variables
x = x[,vars_to_keep]

# Near zero variance
nzv = nearZeroVar(x, saveMetrics = TRUE)
x = x[,!nzv$nzv]

#



# Required libraries
library(tidyverse)
library(caret)

# Creating data directory
dir.create(file.path("data"))

# Downloading data
url_training = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
url_testing = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

download.file(url_training, destfile = "data/pml-training.csv")
download.file(url_testing, destfile = "data/pml-testing.csv")

# Loading data
training = read.csv("data/pml-training.csv", na.strings = "#DIV/0!")
testing = read_csv("data/pml-testing.csv", na="#DIV/0!")

# Dropping X1 variable
training = as_tibble(training)
training = select(training, -X)

# Copy of training
x = training

# Near zero variance
nzv = nearZeroVar(training, saveMetrics = TRUE)
x = x[,!nzv$nzv]


fit = train(classe ~ ., data = training, method = "rpart")

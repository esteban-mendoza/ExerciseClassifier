# Required libraries
library(caret)
library(randomForest)
library(doParallel)

# Parallel processing
cluster <- makeCluster(detectCores())
registerDoParallel(cluster)

# Creating data directory
if (!dir.exists("data"))
    dir.create(file.path("data"))

# Downloading data
url_training = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
url_testing = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

if (!file.exists("data/pml-training.csv"))
    download.file(url_training, destfile = "data/pml-training.csv")

if (!file.exists("data/pml-testing.csv"))
    download.file(url_testing, destfile = "data/pml-testing.csv")

# Loading data
training = read.csv("data/pml-training.csv", na.strings=c("NA",""))
testing = read.csv("data/pml-testing.csv", na.strings=c("NA",""))

# Number of complete registers
sum(apply(!is.na(training), 1, all))

# Dropping index, time stamps and usernames
training = training[,7:160]
testing = testing[,7:160]

# Dropping mostly NAs varilables
mostly_data = apply(!is.na(training), 2, mean) > 0.95

training = training[,mostly_data]
testing = testing[,mostly_data]

# Creating validation set
inTrain = createDataPartition(training$classe, p = 0.8, list = FALSE)
train0 = training[inTrain,]
validation = training[-inTrain,]

## Training
h = train(classe ~ ., data=train0, method = "rf",
          trControl = trainControl(method = "cv", number = 5, 
                                   allowParallel = TRUE))

## Shutting down parallel
stopCluster(cluster)
registerDoSEQ()

## Out-of-sample accuracy
output = predict(h, validation)
confusionMatrix(output, validation$classe)


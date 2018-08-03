
# Downloading data

url_training = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
url_testing = "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

download.file(url_training, destfile = "data/pml-training.csv")
download.file(url_testing, destfile = "data/pml-testing.csv")

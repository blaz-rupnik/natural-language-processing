#importing the dataset
dataset_structure = read.delim('essays-structure.tsv', quote = '', stringsAsFactors = FALSE)

#importing processed dataset
dataset_structure_processed = read.csv(file = 'essays-structure-processed.csv')


#cleaning the texts
library(tm)
library(SnowballC)
corpus_structure = VCorpus(VectorSource(dataset_structure$essay))
#to lower case
corpus_structure <- tm_map(corpus_structure, content_transformer(tolower))
#remove numbers
corpus_structure <- tm_map(corpus_structure, removeNumbers)
#remove punctuations
corpus_structure <- tm_map(corpus_structure, removePunctuation)
#remove english stopwords
corpus_structure <- tm_map(corpus_structure, removeWords, stopwords("english"))
#eliminate whitespace
corpus_structure <- tm_map(corpus_structure, stripWhitespace)

#stemming
corpus_structure <- tm_map(corpus_structure, stemDocument)

#creating the Bag of Words model
dtm_structure = DocumentTermMatrix(corpus_structure) 
#dtm_vocabular = removeSparseTerms(dtm, 0.999)

dataset_structure2 = as.data.frame(as.matrix(dtm_structure))
dataset_structure2$Liked = dataset_structure$grade

dataset_structure2$Liked = factor(dataset_structure2$Liked, levels = c(1,2,3,4,5,6))

library(caTools)
library(caret)
intrain_structure<-createDataPartition(y=dataset_structure2$Liked,p=0.7,list=FALSE)
split_structure = sample.split(dataset_structure2$Liked, SplitRatio = .75)
training_set_structure = dataset_structure2[intrain_structure,]
test_set_structure = dataset_structure2[-intrain_structure,]

#intrain_structure_processed <- createDataPartition(y=dataset_structure_processed$grade,p=0.8,list=FALSE)


library(randomForest)
classifier_structure = randomForest(x = training_set_structure[-8241], y = training_set_structure$Liked, ntree = 10)
#prediction
y_pred_structure = predict(classifier_structure, newdata = test_set_structure[-8241])
cm_structure = table(test_set_structure[,8241],y_pred_structure)
accuracy_structure = sum(diag(cm_structure))/sum(cm_structure)

dataset_structure_processed$grade = factor(dataset_structure_processed$grade, level = c(1,2,3,4,5,6))
split_structure_processed <- sample.split(dataset_structure_processed$grade, SplitRatio = 0.8)
training_set_processed = dataset_structure_processed[split_structure_processed,]
test_set_processed = dataset_structure_processed[split_structure_processed,]
classifier_processed = randomForest(x = training_set_processed[-8], y = training_set_processed$grade, ntree = 10)
y_pred_processed = predict(classifier_processed, newdata = test_set_processed[-8])
cm_processed = table(test_set_processed[,8],y_pred_processed)
accuracy_processed = sum(diag(cm_processed))/sum(cm_processed)

cross_validation_structure_accuracy  = 0
num_of_iterations = 10
for (i in 1:num_of_iterations){
  set.seed(sample(1:1000, 1))
  split_structure_processed <- sample.split(dataset_structure_processed$grade, SplitRatio = 0.8)
  training_set_processed = dataset_structure_processed[split_structure_processed,]
  test_set_processed = dataset_structure_processed[split_structure_processed,]
  classifier_processed = randomForest(x = training_set_processed[-8], y = training_set_processed$grade, ntree = 10)
  y_pred_processed = predict(classifier_processed, newdata = test_set_processed[-8])
  cm_processed = table(test_set_processed[,8],y_pred_processed)
  accuracy_processed = sum(diag(cm_processed))/sum(cm_processed)
  cross_validation_structure_accuracy = cross_validation_structure_accuracy + accuracy_processed
}
print(cross_validation_structure_accuracy/num_of_iterations)

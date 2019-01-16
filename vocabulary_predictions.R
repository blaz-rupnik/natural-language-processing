#importing the dataset
dataset_vocabulary = read.delim('essays-tsv.tsv', quote = '', stringsAsFactors = FALSE)

#importing processed dataset
dataset_vocabulary_processed = read.csv(file = 'essays-vocabulary-processed.csv')
dataset_vocabulary_processed$grade = factor(dataset_vocabulary_processed$grade, level = c(1,2,3,4,5,6))

#cleaning the texts
library(tm)
library(SnowballC)
corpus_vocabular = VCorpus(VectorSource(dataset_vocabulary$essay))
#to lower case
corpus_vocabular <- tm_map(corpus_vocabular, content_transformer(tolower))
#remove numbers
corpus_vocabular <- tm_map(corpus_vocabular, removeNumbers)
#remove punctuations
corpus_vocabular <- tm_map(corpus_vocabular, removePunctuation)
#remove english stopwords
corpus_vocabular <- tm_map(corpus_vocabular, removeWords, stopwords("english"))
#eliminate whitespace
corpus_vocabular <- tm_map(corpus_vocabular, stripWhitespace)

#stemming
corpus_vocabular <- tm_map(corpus_vocabular, stemDocument)

#creating the Bag of Words model
dtm_vocabular = DocumentTermMatrix(corpus_vocabular) 
#dtm_vocabular = removeSparseTerms(dtm, 0.999)

dataset_2 = as.data.frame(as.matrix(dtm_vocabular))
dataset_2$Liked = dataset_vocabulary$grade

dataset_2$Liked = factor(dataset_2$Liked, levels = c(1,2,3,4,5,6))

library(caTools)
library(caret)
intrain<-createDataPartition(y=dataset_2$Liked,p=0.7,list=FALSE)
split = sample.split(dataset_2$Liked, SplitRatio = .75)
training_set = dataset_2[intrain,]
test_set = dataset_2[-intrain,]
View(training_set$Liked)
library(randomForest)
library(naivebayes)
library(e1071)
classifier = randomForest(x = training_set[-8241], y = training_set$Liked, ntree = 10)
classifier_bayes = naiveBayes(x = training_set[-8241],
                              type = c("class","raw"),
                              y = training_set$Liked)
#prediction
y_pred = predict(classifier, newdata = test_set[-8241])
y_bayespred = predict(classifier_bayes, newdata = test_set[-8241])
cm = table(test_set[,8241],y_pred)
accuracy = sum(diag(cm))/sum(cm)
cm_bayes = table(test_set[,8241],y_bayespred)
accuracy_bayes = sum(diag(cm_bayes))/sum(cm_bayes)


cross_validation_vocabulary_accuracy  = 0
num_of_iterations = 10
for (i in 1:num_of_iterations){
  set.seed(sample(1:1000, 1))
  split_vocabulary_processed <- sample.split(dataset_vocabulary_processed$grade, SplitRatio = 0.8)
  training_set_vac_processed = dataset_vocabulary_processed[split_vocabulary_processed,]
  test_set_vac_processed = dataset_vocabulary_processed[-split_vocabulary_processed,]
  classifier_vac_processed = randomForest(x = training_set_vac_processed[-4], y = training_set_vac_processed$grade, ntree = 10)
  y_pred_vac_processed = predict(classifier_vac_processed, newdata = test_set_vac_processed[-4])
  cm_vac_processed = table(test_set_vac_processed[,4],y_pred_vac_processed)
  accuracy_vac_processed = sum(diag(cm_vac_processed))/sum(cm_vac_processed)
  cross_validation_vocabulary_accuracy = cross_validation_vocabulary_accuracy + accuracy_vac_processed
}
print(cross_validation_vocabulary_accuracy/num_of_iterations)


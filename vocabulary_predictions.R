#importing the dataset
dataset_vocabulary = read.delim('essays-tsv.tsv', quote = '', stringsAsFactors = FALSE)

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


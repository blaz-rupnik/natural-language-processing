# Load
library("tm")
library("SnowballC")
library("wordcloud")
library("RColorBrewer")

full_string <- ""
files <- list.files(path="./essay/", full.names=TRUE, recursive=FALSE)
for (filename in files){
  f <- file(filename,'r')
  text <- readLines(f)
  full_string = paste(full_string,text," ")
  close(f)
} 

docs <- Corpus(VectorSource(full_string))
#to lower case
docs <- tm_map(docs, content_transformer(tolower))
#remove numbers
docs <- tm_map(docs, removeNumbers)
#remove english stopwords
docs <- tm_map(docs, removeWords, stopwords("english"))
#remove punctuations
docs <- tm_map(docs, removePunctuation)
#eliminate whitespace
docs <- tm_map(docs, stripWhitespace)

dtm <- TermDocumentMatrix(docs)
m <- as.matrix(dtm)
v <- sort(rowSums(m), decreasing = TRUE)
d <- data.frame(word = names(v), freq=v)
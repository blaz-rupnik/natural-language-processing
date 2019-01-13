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

set.seed(1234)
#wordcloud(words = d$word, freq = d$freq, min.freq = 1,
#          max.words = 200, random.order = FALSE, rot.per = 0.35,
#          colors = brewer.pal(8, "Dark2"))

#barplot(d[1:10,]$freq, las = 2, names.arg = d[1:10,]$word,
#        col = "green", main = "Most frequent words",
#        ylab = "Word frequencies")
#full_string_2 = ""
#whole_file <- file('essays.txt','r')
#full_string_2 = readLines(whole_file)
#close(whole_file)
#docs2 <- Corpus(VectorSource(full_string_2))
#to lower case
#docs2 <- tm_map(docs2, content_transformer(tolower))
#remove numbers
#docs2 <- tm_map(docs2, removeNumbers)
#remove english stopwords
#docs2 <- tm_map(docs2, removeWords, stopwords("english"))
#remove punctuations
#docs2 <- tm_map(docs2, removePunctuation)
#eliminate whitespace
#docs2 <- tm_map(docs2, stripWhitespace)
docs3 <-Corpus(VectorSource(full_string_2))
library("stringr")
avg_num_of_sentences = 0
sapply(strsplit(docs2[[1]]$content, " "), length)
cat("Average number of sentences: ", avg_num_of_sentences/723)
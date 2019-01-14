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

#findAssocs(dtm2, c("laughter"), corlimit=0.4)

occurences <- list()
for(j in 1:length(docs2)){
  text <- docs2[[j]]$content
  text <- strsplit(text,split=' ')
  text <- text[[1]]
  for(i in 1:length(text)){
    word1 <- text[i]
    word2 <- text[i+1]
    occurences[[word1]] <- c(occurences[[word1]], word2)
  }
}
#sorted_table_test <- sort(table(occurences[["people"]]), decreasing = T)
occurences_after <- list()
for(j in 1:length(docs2)){
  text <- docs2[[j]]$content
  text <- strsplit(text,split = ' ')
  text <- text[[1]]
  for(i in 2:length(text)){
    word1 <- text[i]
    word2 <- text[i-1]
    occurences_after[[word1]] <- c(occurences_after[[word1]],word2)
  }
}

predictMissingWord <- function(sentence){
  splitted <- strsplit(sentence, split = '_')[[1]]
  textBefore = splitted[1]
  textAfter = splitted[2]
  hasWordBefore = FALSE
  hasWordAfter = FALSE
  if(textBefore != ""){
    hasWordBefore = TRUE
  }
  if(!is.na(textAfter) && textAfter != ""){
    hasWordAfter = TRUE
  }
  wordBefore = ""
  wordAfter = ""
  if(hasWordBefore){
    splittedBefore <- strsplit(textBefore, split = ' ')[[1]]
    lengthBefore <- length(splittedBefore)
    wordBefore <- splittedBefore[lengthBefore]
  }
  if(hasWordAfter){
    splittedAfter <- strsplit(textAfter, split = ' ')[[1]]
    wordAfter <- splittedAfter[1]
  }
  missing_word <- "_"
  if(hasWordAfter && hasWordBefore){
    sorted_table_after <- sort(table(occurences[[wordAfter]]), decreasing = T)
    #print(names(sorted_table_after))
    sorted_table_before <- sort(table(occurences_after[[wordBefore]]), decreasing = T)
    common <- intersect(names(sorted_table_after),names(sorted_table_before))
    missing_word <- paste("",common[1],"",sep = " ") 
  }else if(hasWordAfter){
    sorted_table_after <- sort(table(occurences[[wordAfter]]), decreasing = T)
    missing_word <- paste(names(sorted_table_after[1]),"",sep = " ")
  }else{
    sorted_table_before <- sort(table(occurences_after[[wordBefore]]), decreasing = T)
    missing_word <- paste("",names(sorted_table_before[1]),sep = " ")
  }
  sentence <- gsub("_",missing_word,sentence)
  return(sentence)
}


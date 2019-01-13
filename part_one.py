#part two of the assignment

#importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import re
import string

numbers = re.compile(r'(\d+)')
translator = str.maketrans('', '', string.punctuation)

def numericalSort(value):
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts

all_texts_in_a_string = ""
csv_file = open('essays.txt','w')
for filename in sorted(os.listdir('essay/'), key=numericalSort):
    text_file = open('essay/'+filename, "r")
    lines = text_file.readlines()
    lines[0] = re.sub("[A-Z]{2,}",'',lines[0]).replace("  ", " ")
    lines[0] = lines[0].replace("@","")
    csv_file.write(lines[0])
    #lines[0] = ' '.join([word for word in lines[0].split() if word not in (stopwords.words('english'))])
    text_file.close()
    #file_handle = open('essay/'+filename,"w")
    #file_handle.write(lines[0])
    #file_handle.close()
#csv_file.write(all_texts_in_a_string)
csv_file.close()
#print(all_texts_in_a_string)
#wordcloud = WordCloud(width = 1000,height = 500).generate(all_texts_in_a_string)
#plt.figure(figsize=(15,8))
#plt.imshow(wordcloud)
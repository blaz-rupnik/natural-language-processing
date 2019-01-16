#part three of the assignment

#importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os
import re
import string
import nltk
nltk.download('punkt')
nltk.download('averaged_perceptron_tagger')

numbers = re.compile(r'(\d+)')
translator = str.maketrans('', '', string.punctuation)

def numericalSort(value):
    parts = numbers.split(value)
    parts[1::2] = map(int, parts[1::2])
    return parts


with open('structure.txt') as f:
    mylist = f.read().splitlines()
all_texts_in_a_string = ""
csv_file = open('essays-structure-processed.csv','w')
csv_file.write("num_sentences,avg_length_sentences,num_nouns,num_verbs,num_conjunctions,num_adjectives,num_adverbs,grade\n")
indx = 0
for filename in sorted(os.listdir('essay/'), key=numericalSort):
    text_file = open('essay/'+filename, "r")
    lines = text_file.readlines()
    lines[0] = lines[0].rstrip()
    lines[0] = lines[0].replace("@", "")
    lines[0] = re.sub("[A-Z]{2,}", '', lines[0]).replace("  ", " ")
    lines[0] = ' '.join(lines[0].split())
    text_for_tag = nltk.word_tokenize(lines[0])
    result_for_tag = nltk.pos_tag(text_for_tag)
    #number of nouns
    list_nouns = ([s for s in result_for_tag if "NN" in s[1]])
    number_of_nouns = len(list_nouns)
    #number of verbs
    list_verbs = ([s for s in result_for_tag if "VB" in s[1]])
    number_of_verbs = len(list_verbs)
    #number of conjuctions
    list_conjuctions = ([s for s in result_for_tag if s[1] == 'CC'])
    number_of_conjuctions = len(list_conjuctions)
    #number of adjectives
    list_adjectives = ([s for s in result_for_tag if "JJ" in s[1]])
    number_of_adjectives = len(list_adjectives)
    #number of adverbs
    list_adverbs = ([s for s in result_for_tag if "RB" in s[1]])
    number_of_adverbs = len(list_adverbs)
    #number of sentences
    num_of_sentences = len(lines[0].split(sep='.'))
    sentences = lines[0].split(sep='.')
    #average length of sentence
    avg_length_of_sentences = sum(map(len, sentences)) / len(sentences)

    csv_file.write(str(num_of_sentences)+','+str(int(avg_length_of_sentences))+','
                   +str(number_of_nouns)+','+str(number_of_verbs)+','
                   +str(number_of_conjuctions)+','+str(number_of_adjectives)+','
                   +str(number_of_adverbs)+','+str(mylist[indx])+'\n')
    indx += 1
    text_file.close()
#csv_file.write(all_texts_in_a_string)
csv_file.close()
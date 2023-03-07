# Data-332-First-Project



## Overview 

This data is a compilation of complaints about consumer financial products and services that we forwarded to companies for resolution. After the company responds, confirming a commercial relationship with the consumer, or after 15 days, whichever comes first, complaints are published.

## Libraries 

In order to perform sentiment analysis in R I installed and loaded the required libraries: tidytext: to tidy and preprocess the text data, dplyr: to manipulate data
ggplot2: to visualize the results, tidyverse: a collection of R packages that work together to make data analysis easier.

## Import the data 

I loaded the text data into R using the read.csv() function and saved it as RDS. 

df1<- read.csv("Consumer_Complaints.csv")
saveRDS(df1, "Consumer_Complaints.RDS")

## Tidy and preprocess the text data:
I fisrt selected the columns relevant for the Sentimental Analysis. I used the tidytext package to convert the text data into a tidy format. This involves separating the text into individual words (tokenization) and removing stop words, punctuation, and other unnecessary elements.

## Sentiment Lexicon 
 
 Used the bing and nrc to convert the companies responses to consumers to a list of words and their associated sentiment scores. 
 
 
## Calculate the sentiment scores

I used the inner_join() function to join the sentiment lexicon with the tidy text data. Then, used the group_by() and count() functions from the dplyr package to calculate the sentiment scores for each text.


## Visualize the results: 

Use the ggplot2 package to visualize the sentiment scores. I used a histogram to show that the negative sentiment outweights the positive sentiment scores. 


# 





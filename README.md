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
 #1 Visual 
Use the ggplot2 package to visualize the sentiment scores. I used a histogram to show that the negative sentiment outweights the positive sentiment scores. 

<img id="img" width="100%" height="100%" style="display: inline;" src="http://127.0.0.1:31221/graphics/6962eab1-8ede-43b6-a513-c73c119943f6.png">

#2 Visual
Using the dplyr and ggplot2 packages in R, I created a visualization of word counts for each sentiment category in a lexicon called lexicon_2.

df <-lexicon_2 %>%
  group_by(sentiment) %>%
  summarise(word_count = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, word_count)) %>%
  #Use `fill = -word_count` to make the larger bars darker
  ggplot(aes(sentiment, word_count, fill = -word_count)) +
  geom_col() +
  guides(fill = "none") + #Turn off the legend
  labs(x = NULL, y = "Word Count") +
  #  scale_y_continuous(limits = c(0, 500000)) + t
  ggtitle("Consumer NRC Sentiment") +
  coord_flip()
  
<img id="img" width="100%" height="100%" style="display: inline;" src="http://127.0.0.1:31221/graphics/e26bd8ac-478d-4297-8508-d182b5f15403.png">


# WordCloud
 Using the wordcloud package in R, I created a wordcloud of sentiment scores in a dataset called SentimentScore2. The resulting wordcloud display the sentiment categories as words, with the size of each word reflecting its frequency in the dataset.
 
<img id="img" width="100%" height="100%" style="display: inline;" src="http://127.0.0.1:31221/graphics/6962eab1-8ede-43b6-a513-c73c119943f6.png">






library(tidyverse)
library(ggplot2)
library(lubridate)
library(readxl)
library(wordcloud)
library(sentimentr)
library(tidytext)
library(textdata)
library(janeaustenr)
library(dplyr)
library(stringr)
library(reshape2)
library(tm)
library(magrittr)
library(lexicon)
library(metricsgraphics)
library(broom)
library(ggthemes)
library(wordcloud)
library(radarchart)
library(treemap)

rm(list = ls())
setwd("~/DATA 332/data")


#import the data
df1<- read.csv("Consumer_Complaints.csv")
saveRDS(df1, "Consumer_Complaints.RDS")
df2 <- readRDS("Consumer_Complaints.csv")

#Tidy the data 

Complaints_Table <- df1 %>%
  select(State, Company, Issue, Company.response.to.consumer, Product) %>%
 drop_na()

tidy_data <- Complaints_Table %>%
  unnest_tokens(word, Company.response.to.consumer) %>%
  anti_join(stop_words)

#Create a sentiment lexicon

lexicon <- get_sentiments("bing")

# Recalculate sentiment scores
#sentiment_scores <- tidy_data %>% 
  #inner_join(lexicon) %>% 
  #group_by(sentiment) %>% 
  #summarise(sentiment_scores = sum(sentiment))

sentiment_scores <- tidy_data %>% 
  inner_join(lexicon) %>% 
  group_by(word) %>% 
  count(sentiment, sort = TRUE) 
 
 #summarize(sentiment_scores = sum(as.numeric(sentiment), na.rm = FALSE))

ggplot(sentiment_scores, aes(x = n)) + 
  geom_histogram(binwidth = 100000, fill = "blue", color = "red") + 
  labs (x = "Sentiment Score", y = "Frequency", title = "Sentimental Analysis Resutls")


#2

lexicon_2 <- get_sentiments("nrc")

df_2 <- tidy_data %>%
  inner_join(lexicon)%>%
  select(sentiment)

SentimentScore2 <- tidy_data %>% 
  inner_join(lexicon_2) %>% 
  select(sentiment)
 
 
wordcloud(SentimentScore2$sentiment, scale=c(5,0.5), 
          min.freq = 1, max.words = Inf, 
          random.order = FALSE,
          rot.per = 0.35, colors = brewer.pal(8, "Dark2"))







  
 
 
 

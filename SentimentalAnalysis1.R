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
library(magrittr)
library(lexicon)
library(metricsgraphics)
library(broom)
library(ggthemes)
library(wordcloud)
library(radarchart)
library(treemap)
library(shiny)


rm(list = ls())
setwd("~/DATA 332/data")


#import the data
df1<- read.csv("Consumer_Complaints.csv")
saveRDS(df1, "Consumer_Complaints.RDS")
#readRDS("Consumer_Complaints.csv")

#Tidy the data 

Complaints_Table <- df1 %>%
  select(State, Company, Issue, Company.response.to.consumer, Product) %>%
 drop_na()

tidy_data <- Complaints_Table %>%
  unnest_tokens(word, Company.response.to.consumer) %>%
  anti_join(stop_words)

#Create a sentiment lexicon

lexicon <- get_sentiments("bing")

# calculate sentiment scores

sentiment_scores <- tidy_data %>% 
  inner_join(lexicon) %>% 
  group_by(word) %>% 
  count(sentiment, sort = TRUE) 
 
 #Creating a histogram to show the overall response of the company the consumer 

ggplot(lexicon, aes(x = sentiment)) + 
  geom_histogram(binwidth = 50000, fill = "blue", color = "red", stat="count") + 
  labs (x = "Sentiment", y = "Frequency", title = "Sentimental Analysis Resutls")


#2 Creating a wordcloud with ncr lexicon 

lexicon_2 <- get_sentiments("nrc")

df_2 <- tidy_data %>%
  inner_join(lexicon)%>%
  select(sentiment)

SentimentScore2 <- tidy_data %>% 
  inner_join(lexicon_2) %>% 
  select(sentiment)
 
word_freq <- table(SentimentScore2$sentiment)

wordcloud(SentimentScore2$sentiment, scale=c(4,1.5), 
          min.freq = 1, max.words = Inf, 
          random.order = FALSE,
          rot.per = 0.35, colors = brewer.pal(8, "Dark2"))

# visual 
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
plot(df)


column_names<-colnames(tidy_data)
ui<-fluidPage( 
  
  titlePanel(title = "Company repomse to Consumer complaints"),
  
  
  fluidRow(
    column(2,
           selectInput('X', 'choose x',column_names,column_names[4]),
           selectInput('Y', 'Choose Y',column_names,column_names[2]),
           selectInput('Splitby', 'Split By', column_names,column_names[5])
    ),
    column(4,plotOutput('plot_01')),
    column(6,DT::dataTableOutput("table_01", width = "100%"))
  )
)
server<-function(input,output){
  
  output$plot_01 <- renderPlot({
    ggplot(tidy_data,aes_string(x=input$X,y=input$Y))+
      geom_smooth()
    
  })
  
  output$table_01<-DT::renderDataTable(tidy_data[,c(input$X,input$Y,input$Splitby)],options = list(pageLength = 4))
}

shinyApp(ui=ui, server=server)

 
 

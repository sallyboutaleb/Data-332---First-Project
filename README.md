# Sentiment Analysis



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

Complaints_Table <- df1 %>%
  select(State, Company, Issue, Company.response.to.consumer, Product) %>%
 drop_na()

tidy_data <- Complaints_Table %>%
  unnest_tokens(word, Company.response.to.consumer) %>%
  anti_join(stop_words)


## Sentiment Lexicon 
 
 Used the bing and nrc to convert the companies responses to consumers to a list of words and their associated sentiment scores. 
 
 lexicon <- get_sentiments("bing")
  
## Calculate the sentiment scores

I used the inner_join() function to join the sentiment lexicon with the tidy text data. Then, used the group_by() and count() functions from the dplyr package to calculate the sentiment scores for each text.

sentiment_scores <- tidy_data %>% 
  inner_join(lexicon) %>% 
  group_by(word) %>% 
  count(sentiment, sort = TRUE) 
  
## Visualize the results: 
 #1 Visual 
Use the ggplot2 package to visualize the sentiment scores. I used a histogram to show that the negative sentiment outweights the positive sentiment scores. 

ggplot(lexicon, aes(x = sentiment)) + 
  geom_histogram(binwidth = 50000, fill = "blue", color = "red", stat="count") + 
  labs (x = "Sentiment", y = "Frequency", title = "Sentimental Analysis Resutls")
  
![visual1](https://user-images.githubusercontent.com/118493723/223335442-5c70d6c9-c507-4891-8c19-54a0bb172498.png)


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
  ggtitle("Consumer NRC Sentiment") +
  coord_flip()
  
![visual2](https://user-images.githubusercontent.com/118493723/223335209-95899cfd-cd88-4510-b894-15b260a4bbce.png)

# WordCloud
 Using the wordcloud package in R, I created a wordcloud of sentiment scores in a dataset called SentimentScore2. The resulting wordcloud display the sentiment categories as words, with the size of each word reflecting its frequency in the dataset.
 
word_freq <- table(SentimentScore2$sentiment)

wordcloud(SentimentScore2$sentiment, scale=c(4,1.5), 
          min.freq = 1, max.words = Inf, 
          random.order = FALSE,
          rot.per = 0.35, colors = brewer.pal(8, "Dark2")) 
          
![wordcloud](https://user-images.githubusercontent.com/118493723/223335373-188bacb5-d1be-478a-ace0-1dc2bf2df45c.png)


## ShinyApp 
 This app allows users to choose variables for the x-axis, y-axis, and split-by variables, and generates an interactive plot and data table based on those choices.
 
column_names<-colnames(lexicon)
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
    ggplot(lexicon,aes_string(x=input$X,y=input$Y))+
      geom_smooth()
    
  })
  
  output$table_01<-DT::renderDataTable(lexicon[,c(input$X,input$Y,input$Splitby)],options = list(pageLength = 4))
}

shinyApp(ui=ui, server=server)

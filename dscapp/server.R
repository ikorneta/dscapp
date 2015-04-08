# server.R
# author: Iga Korneta
# version: 1.0
# created: April 7th, 2015
# Spring 2015 Coursera Data Science Specialisation Capstone Project

# load the libraries
library(shiny)
library(data.table)
library(tm)
library(wordcloud)
library(ggplot2)

# source helper functions
source('./helper.R')

#load the tables
con1 <- file(('./termfreqs/termfreq_4grams.txt'), open="r")
dt1 <- as.data.table(read.csv(con1))
setkey(dt1, prefix)
close(con1)

con1 <- file(('./termfreqs/termfreq_3grams.txt'), open="r")
dt2 <- as.data.table(read.csv(con1))
setkey(dt2, prefix)
close(con1) 

con1 <- file(('./termfreqs/termfreq_2grams.txt'), open="r")
dt3 <- as.data.table(read.csv(con1))
setkey(dt3, prefix)
close(con1) 


for (i in 1:3){
  con1 <- file(paste0('./termfreqs/termfreq_',5-i,'grams_mini.txt'), open="r")
  dttemp <- as.data.table(read.csv(con1))
  setkey(dttemp, prefix)
  assign(paste0("dt",i, "mini"), dttemp, '.GlobalEnv')
  close(con1)  
}


# main function
shinyServer(
  function(input, output) {
    
  #####prediction part (upper row)
  inputcopy <- eventReactive(input$goButton, {input$inputphrase})
  dttemp <- reactive({as.data.frame(findanswer(inputcopy(), dt1, dt2, dt3))})
  
  outputtop1 <- eventReactive(input$goButton, {
    if (input$inputchoice=="one") {
      paste0(inputcopy()," ", as.character(dttemp()[1,1]))
    }
  })
  output$outputtop1 <- renderText({outputtop1()})
  
  outputtop2 <- eventReactive(input$goButton, {
    if (input$inputchoice=="four"){dttemp()}
  })
  output$outputtop2 <- renderTable({outputtop2()})
  
  
  #####statistics and visualisations (lower row)
  ###plots (first tab)  
  p1 <- eventReactive(input$goButton2, {
    p <- ggplot(dt1, aes(freq)) 
    p <- p + geom_histogram(binwidth=200, fill="orange", colour="black") + theme_bw()
    p <- p + scale_y_log10() + annotation_logticks(sides="l") + xlab("Term frequency") + ylab("Count")
    p})
  
  p2 <- eventReactive(input$goButton2, {
    p <- ggplot(dt2, aes(freq)) 
    p <- p + geom_histogram(binwidth=200, fill="yellow", colour="black") + theme_bw()
    p <- p + scale_y_log10() + annotation_logticks(sides="l") + xlab("Term frequency") + ylab("Count")
    p})
  
  p3 <- eventReactive(input$goButton2, {
    p <- ggplot(dt3, aes(freq)) 
    p <- p + geom_histogram(binwidth=1200, fill="green", colour="black") + theme_bw()
    p <- p + scale_y_log10() + annotation_logticks(sides="l") + xlab("Term frequency") + ylab("Count")
    p})
  
  output$outputbottom11 <- renderPlot({p1()})                    
  output$outputbottom12 <- renderPlot({p2()})                     
  output$outputbottom13 <- renderPlot({p3()})
  
  
  ###summaries (second tab)
  dt1sum <- eventReactive(input$goButton2,{
    dttemp <- data.frame(statistic="Number of n-grams", value=nrow(dt1))
    sum <- as.matrix(summary(dt1$freq))
    sum <- data.table(x=row.names(sum), y=sum[,1])
    setkey(sum,x)
    dttemp <- rbind(dttemp, data.frame(statistic="Maximum term frequency", value=sum["Max.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="3rd quartile term frequency", value=sum["3rd Qu.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="Median term frequency", value=sum["Median",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="1st quartile term frequency", value=sum["1st Qu.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="Minimum term frequency", value=sum["Min.",y]))
    summary <- dt1[,length(answer), by=prefix]
    dttemp <- rbind(dttemp, data.frame(statistic="Median number of finds per prefix", value=median(summary$V1)))
  })
  
  dt2sum <- eventReactive(input$goButton2,{
    dttemp <- data.frame(statistic="Number of n-grams", value=nrow(dt2))
    sum <- as.matrix(summary(dt2$freq))
    sum <- data.table(x=row.names(sum), y=sum[,1])
    setkey(sum,x)
    dttemp <- rbind(dttemp, data.frame(statistic="Maximum term frequency", value=sum["Max.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="3rd quartile term frequency", value=sum["3rd Qu.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="Median term frequency", value=sum["Median",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="1st quartile term frequency", value=sum["1st Qu.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="Minimum term frequency", value=sum["Min.",y]))
    summary <- dt2[,length(answer), by=prefix]
    dttemp <- rbind(dttemp, data.frame(statistic="Median number of finds per prefix", value=median(summary$V1)))
  })
  
  dt3sum <- eventReactive(input$goButton2,{
    dttemp <- data.frame(statistic="Number of n-grams", value=nrow(dt2))
    sum <- as.matrix(summary(dt3$freq))
    sum <- data.table(x=row.names(sum), y=sum[,1])
    setkey(sum,x)
    dttemp <- rbind(dttemp, data.frame(statistic="Maximum term frequency", value=sum["Max.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="3rd quartile term frequency", value=sum["3rd Qu.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="Median term frequency", value=sum["Median",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="1st quartile term frequency", value=sum["1st Qu.",y]))
    dttemp <- rbind(dttemp, data.frame(statistic="Minimum term frequency", value=sum["Min.",y]))
    summary <- dt3[,length(answer), by=prefix]
    dttemp <- rbind(dttemp, data.frame(statistic="Median number of finds per prefix", value=median(summary$V1)))
  })
  
  output$outputbottom41 <- renderTable({dt1sum()})
  output$outputbottom42 <- renderTable({dt2sum()})
  output$outputbottom43 <- renderTable({dt3sum()})
  
  
  ###wordclouds (third)
  wordcloud1 <- eventReactive(input$goButton2, {
    wordcloud(paste0(dt1$prefix, " ", dt1$answer), dt1$freq, max.words=100, scale=c(1.5, .5), colors=brewer.pal(5, "Set1"))})
  wordcloud2 <- eventReactive(input$goButton2, {
    wordcloud(paste0(dt2$prefix, " ", dt2$answer), dt2$freq, max.words=100, scale=c(1.5, .5), colors=brewer.pal(5, "Set1"))})
  wordcloud3 <- eventReactive(input$goButton2, {
    wordcloud(paste0(dt3$prefix, " ", dt3$answer), dt3$freq, max.words=100, scale=c(1.5, .5), colors=brewer.pal(5, "Set1"))})
  
  output$outputbottom21 <- renderPlot({wordcloud1()})
  output$outputbottom22 <- renderPlot({wordcloud2()})
  output$outputbottom23 <- renderPlot({wordcloud3()})
  
  ###most frequent terms (fourth tab)
  head1 <- eventReactive(input$goButton2, {head(dt1mini, 7)})
  head2 <- eventReactive(input$goButton2, {head(dt2mini, 7)})
  head3 <- eventReactive(input$goButton2, {head(dt3mini, 7)})
  
  output$outputbottom31 <- renderTable({head1()})
  output$outputbottom32 <- renderTable({head2()})
  output$outputbottom33 <- renderTable({head3()})
  }
)

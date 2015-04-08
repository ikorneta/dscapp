# ui.R
# author: Iga Korneta
# version: 1.0
# created: April 7th, 2015
# Spring 2015 Coursera Data Science Specialisation Capstone Project

library(shiny)

shinyUI(fluidPage(
  titlePanel("DS-CApp: The Spring 2015 Coursera Data Science Capstone App"),  
  fluidRow(
      column(3,
        wellPanel(
        strong("Predict the next word in the phrase."),
        p(strong("Author: "), "Iga Korneta"),
        p(strong("Date: "), "April 2015"),
        p(strong("Code: "), a(href="http://github.com/ikorneta/dscapp", "Github")),
        p(strong("Slide deck:"), a(href="http://rpubs.com/ikorneta/dscapp", "R Pubs")),
        br(),
        strong("Have fun, live long and prosper."), 
        p("RIP Leonard Nimoy and Terry Pratchett, 1931/1948-2015, already a horrible year.")
      )),
      
      column(3,
        br(),
        strong("Input"),
        textInput("inputphrase", label="Put your phrase here", value=""), 
        radioButtons("inputchoice", "Choose whether to:", c("predict one word (as required for the basic Capstone assignment task)"="one", "give you a selection of four words (additional functionality)" = "four")),
        actionButton("goButton", "Let's do this thing!"),
        br()
      ),
      column(3,
        br(),
        strong("Output"),
        br(),
        textOutput("outputtop1"),
        tableOutput("outputtop2")   
      ),
      column(3,
        br(),
        p(strong("For nerds")),
        actionButton("goButton2", "Look at the statistics!"),
        br(),
        p("^^ this'll take a sec, especially the wordclouds, because it's calculated on the go"),
        p("So... just wait. :-)")
        )
    ),
  fluidRow(
      tabsetPanel(
        tabPanel("Histograms",
                 column(4,
                        strong("4-grams"),
                        plotOutput("outputbottom11")),
                 column(4,
                        strong("3-grams"),
                        plotOutput("outputbottom12")),
                 column(4,
                        strong("2-grams"),
                        plotOutput("outputbottom13"))              
                 ),
        
        tabPanel("Summaries",
                 column(4,
                        strong("4-grams"),
                        tableOutput("outputbottom41")),
                 column(4,
                        strong("3-grams"),
                        tableOutput("outputbottom42")),
                 column(4,
                        strong("2-grams"),
                        tableOutput("outputbottom43"))              
        ),
        
        tabPanel("Wordclouds",
                 column(4,
                        strong("4-grams"),
                        plotOutput("outputbottom21")),
                 column(4,
                        strong("3-grams"),
                        plotOutput("outputbottom22")),
                 column(4,
                        strong("2-grams"),
                        plotOutput("outputbottom23")) 
                 
        ),        
        
        tabPanel("Most frequent terms",
                 column(4,
                        strong("4-grams"),
                        tableOutput("outputbottom31")),
                 column(4,
                        strong("3-grams"),
                        tableOutput("outputbottom32")),
                 column(4,
                        strong("2-grams"),
                        tableOutput("outputbottom33"))
                 )
        
        )
  )
))

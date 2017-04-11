#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

state_list = list("Johor", "Kelantan", "Melaka", 
               "N. Sembilan", "P.Pinang",  "Pahang", "Perak", "Perlis", "Sabah",
               "Sarawak", "Selangor", "Terengganu", "WPKL")

# Define UI for application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Dengue Outbreak in Malaysia 2010-2015"),
  
  # Sidebar with a slider input for input of Year
  sidebarLayout(
    sidebarPanel(
      div(class = "description", 
          a(href="https://github.com/wweiw/DevelopingDataProducts", "SourceCode from Github"),
          p(""),
          HTML("1. Tab Panel <strong>Overview Dengue Table </strong> (20 rows) - Choose Year in the Slider below"),
          p(""),
          HTML("2. Tab Panel <strong>Dengue Cases by Year Barchart </strong>- Choose Year in the Slider below"),
          p(""),
          HTML("3. Tab Panel <strong>Dengue Outbreak by State/Area ScatterPlot </strong>- Choose Year in Slider below and then choose State/Area in Tab Panel"),
          p("")),
          sliderInput("select_Year","Year:", min = 2010, max = 2015, value = 1,sep = "")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Overview Dengue Table (sample)", tableOutput("dataTable")),
        tabPanel("Dengue Cases by Year Barchart", plotOutput("plotBar")),
        tabPanel("Dengue Outbreak by State/Area ScatterPlot",  
                 tabPanel("Panel0", selectInput("select_State", h3("Select State"), 
                                                state_list,selected="Selangor"), uiOutput("choose_area") ),
                 plotOutput("plotScatter")))

    )    
  )
))
#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(lubridate)
library(data.table)

dengue_data <-read.csv("dengue_2010_2015.csv")

shinyServer(function(input, output) {
  
  #first tab
  output$dataTable <- renderTable({
    dt <- as.data.table(dengue_data)
    
    selected_year <- as.character(input$select_Year)
    
    # Shows sample of first 30 rows
    if (selected_year == "2010"){
      dt <- dt[dt$Year == "2010"]
    }
    else if (selected_year == "2011"){
      dt <- dt[dt$Year =="2011"]
    }
    else if (selected_year == "2012"){
      dt <- dt[dt$Year =="2012"]
    }
    else if (selected_year == "2013"){
      dt <- dt[dt$Year =="2013"]
    }
    else if (selected_year == "2014"){
      dt <- dt[dt$Year =="2014"]
    }
    else{
      dt <- dt[dt$Year =="2015"]
    }
    head(dt, 20)
  })  
  
  # second tab
  output$plotBar <- renderPlot({
 
    dengue_data.filter<-dengue_data[dengue_data$Year==input$select_Year,]
    
    titlebar <- paste(input$select_Year, sep = " ", 'Total Dengue Outbreak Cases by States in Malaysia')
    
    ggplot(data=dengue_data.filter, aes(x=dengue_data.filter$State, fill=dengue_data.filter$State)) + 
      geom_bar() + labs(title=titlebar, x="States", y="Total Cases", fill="States")
  })
  
  # third tab - UI
  output$choose_area <- renderUI({
    # If missing input, return to avoid error later in function
    if(is.null(input$select_State))
      return()

    dengue_data.filter.state <- dengue_data[dengue_data$State==input$select_State,]
    

    area_list <- c("All Area",as.list(dengue_data.filter.state$Area))
    selectInput("select_Area", h3("Select Area"), area_list, multiple=FALSE)
    
  })
  
  # third tab
  output$plotScatter <- renderPlot({
    
    # define selected_area
    if(is.null(input$select_Area)) {
      selected_area = "All Area"
    } else {
      selected_area <- as.character(input$select_Area)
    }
    
    #Filter dataset by chosen Year, then by State, then by Area
    dengue_data.filter.year <- dengue_data[dengue_data$Year==input$select_Year,]
    dengue_data.filter.final <- dengue_data.filter.year[dengue_data.filter.year$State==input$select_State,]
    if (selected_area=="All Area") {
        # do nothing 
    } else {
      dengue_data.filter.final <- dengue_data.filter.year[dengue_data.filter.year$Area==input$select_Area,]
    }

    #Customize plot title
    titleplot <- paste(input$select_Year, sep = " ", 'Total Dengue Outbreak Cases in Malaysia' )
    titleplot <- paste(titleplot, sep = " - ", input$select_State )
    titleplot <- paste(titleplot, sep = " - ", selected_area )
    
    if (nrow(dengue_data.filter.final) == 0) {
      titleplot <- paste(titleplot, sep = "\n\n", "NO DATA FOUND!")
    }

    ggplot(data=dengue_data.filter.final, aes(x=dengue_data.filter.final$Week, y=dengue_data.filter.final$Outbreak_Duration_Day)) +
      geom_jitter(color="red") + labs(title=titleplot, x="Week No.",y="Outbreak Duration in Day")

  })  
  
})
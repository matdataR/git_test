library(shiny)
library(shinydashboard)




# Header Function ---------------------------------------------------------


header <- dashboardHeader(
  
)


# SideBoard Function ------------------------------------------------------



sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Mean - Normal",
      tabName = "mean_normal",
      menuSubItem(
        "One Sample", 
        tabName = "one-sample-t"),
      menuSubItem(
        "Two sample",
        tabName = "two-sample-t")
      ),
    menuItem(
      "Mean - Non-Normal",
      tabName = "mean_nonnormal",
      menuSubItem(
        "One Sample", 
        tabName = "one-sample-wilc"),
      menuSubItem(
        "Two sample",
        tabName = "two-sample-wilc")
      
    ),
    menuItem(
      "Proportions",
      tabName = "proportions",
      menuSubItem(
        "Large sample",
        tabName = "prop_large"
      ),
      menuSubItem(
        "Exact (small sample)",
        tabName = "prop_small")
    )
  )
)


# Body Function -----------------------------------------------------------



body <- dashboardBody()


# User Interface Function -------------------------------------------------



ui <- dashboardPage(
  header, 
  sidebar, 
  body)




# Server Function ---------------------------------------------------------



server <- function(input, output){
  
}


shinyApp(ui, server)
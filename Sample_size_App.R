library(shiny)
library(shinydashboard)




# Header Function ---------------------------------------------------------


header <- dashboardHeader(
  
)


# SideBoard Function ------------------------------------------------------



sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Home",
      tabName = "home"
      ),
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

one_sample_input <- box(
  title = "Parameter",
  numericInput(
    "one_sample_t_delta",
    label = "Minimal detektierbare Differenz (Delta)",
    value = 0,
    step = 0.5
    ),
  numericInput(
    "one_sample_t_sd",
    label = "Geschätzte Standardabweichung (SD)",
    value = 0,
    step = 0.5
    ),
  numericInput(
    "one_sample_alpha",
    label = "Fehler erster Art (Alpha)",
    min = 0,
    max = 10,
    value = 5,
    step = 0.5
    ),
  numericInput(
    "one_sample_power",
    label = "Teststärke (Power)",
    min = 50, 
    max = 100,
    value = 80,
    step = 0.5
    ),
  radioButtons(
    "one_sample_sided",
    label = "Art des Tests",
    choices = c("Einseitig", "Zweiseitig"),
    selected = "Zweiseitig" 
  )
  )


body <- dashboardBody(
  tabItems(
    tabItem(
      tabName = "home",
      h1("pfm medical - Fallzahlberechnung")#,
      #tags$img(src = "pfmlogo.png")
      ),
    tabItem(
      tabName = "one-sample-t",
            h1("Test"),
      column(width = 12, one_sample_input)
      ),
    tabItem(tabName = "two-sample-t",
            h1("Test2"))
  )
)


# User Interface Function -------------------------------------------------



ui <- dashboardPage(
  header, 
  sidebar, 
  body)




# Server Function ---------------------------------------------------------



server <- function(input, output){
  
}


shinyApp(ui, server)
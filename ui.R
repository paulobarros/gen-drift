library(shiny)

# Define UI for app that draws a histogram ----
fluidPage(
  
  # App title ----
  titlePanel("Simulador Deriva Genética!"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "N",
                  label = "Tamanho da População:",
                  min = 0,
                  max = 1000,
                  value = 50,
                  step = 10),
      
      sliderInput(inputId = "p",
                  label = "Frequência do alelo p:",
                  min = 0.1,
                  max = .9,
                  value = 0.5,
                  step = 0.1),
      
      sliderInput(inputId = "N.gen",
                  label = "Gerações:",
                  min = 10,
                  max = 200,
                  value = 50,
                  step = 10),
      
      sliderInput(inputId = "N.sim",
                  label = "Número de alelos:",
                  min = 3,
                  max = 10,
                  value = 5,
                  step = 1)
      
      
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Histogram ----
      plotOutput(outputId = "distPlot")
      
    )
  )
)
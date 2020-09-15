####################################
# Paulo Barros                     #
# http://github.com/paulobarros    #
####################################


### PACKAGES ####

library(ggplot2)
library(reshape)
library(shiny)
library(extrafont)
library(RColorBrewer)


# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
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

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  output$distPlot <- reactivePlot(function(){
    
    genetic.drift <- function(N = input$N, p = input$p, N.gen = input$N.gen, N.sim = input$N.sim){
      
      # Set up parameters
      N.chrom = 2*N # number of chromosomes
      q = 1-p
      
      
      # Simulation
      P = array(0, dim=c(N.gen,N.sim))
      P[1,] = rep(N.chrom*p,N.sim) # initialize number of A1 alleles in first generation
      for(j in 1:N.sim){
        for(i in 2:N.gen){
          P[i,j] = rbinom(1,N.chrom,prob=P[i-1,j]/N.chrom)
        }  
      }
      P = data.frame(P/N.chrom)
      
      
      # Reshape data and plot the 5 simulations
      sim_data <- melt(P)
      gd <- ggplot(sim_data, aes(x = rep(c(1:N.gen), N.sim), y = value, group = variable))  +
      geom_line(aes(colour = variable),size=0.9) +
        scale_colour_manual(values = colorRampPalette(brewer.pal(N.sim,("Set2")))(N.sim)) +
        labs(title = "Efeitos da Deriva Genética em frequências alélicas ", subtitle= "Organismos diplóides") + 
        xlab("Gerações") + 
        ylab("Frequência Alélica") + 
        ylim(0,1) + 
        labs(colour = "Alelos") +
        theme(text = element_text(family = "Roboto Medium",color = "grey20", size=14),
              plot.title=element_text(size=18),
              legend.text=element_text(size=14))
      
      print(gd)
      
    }
    
    genetic.drift(input$N, input$p, input$N.gen, input$N.sim)
    
    
  })
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)



























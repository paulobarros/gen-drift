library(ggplot2)
library(reshape)
library(RColorBrewer)

# Define server logic required to draw a histogram ----
shinyServer (function(input, output, session) {
  
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
        theme(text = element_text(color = "grey20", size=14),
              plot.title=element_text(size=18),
              legend.text=element_text(size=14))
      
      print(gd)
      
    }
    
    genetic.drift(input$N, input$p, input$N.gen, input$N.sim)
    
    
  })
  
})
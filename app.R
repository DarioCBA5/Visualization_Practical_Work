if(!require(magrittr)) install.packages("magrittr")
if(!require(rvest)) install.packages("rvest")
if(!require(maps)) install.packages("maps")
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(readxl)) install.packages("readxl")
if(!require(ggiraph)) install.packages("ggiraph")
if(!require(RColorBrewer)) install.packages("RColorBrewer")
if(!require(plotly)) install.packages("plotly")
if(!require(dplyr)) install.packages("dplyr")
if(!require(forcats)) install.packages("forcats")

source("helpers.R")
source("main.R")
source("ui.R")



server <- function(input, output) {
  
  
  data_map <- reactive({
    crimes[!is.na(crimes$ISO3), ]
  })
  
  data_bar1 <- reactive({
    
    plotdf <- crimes
    plotdf$number_attacks <- 1
    
    
    
    plotdf <- plotdf %>%
      select(country_txt, UQ(input$var_variable), region_txt) %>%
      filter(if (input$var_barplot_continent != "Global") region_txt == input$var_barplot_continent else TRUE) %>%
      group_by(country_txt) %>%
      summarise(across(UQ(input$var_variable),sum), .groups = "drop")
  })
  
  data_bar2 <- reactive({
    
    if (input$sortbutton %% 2 == 0) {input_var_sorter <- 1} else {input_var_sorter <- 0}
    
    data <- data_bar1() %>% 
              arrange(if (input_var_sorter == 1) desc(UQ(sym(input$var_variable))) else UQ(sym(input$var_variable)))
    
    data <- data[1:input$var_number_columns,c("country_txt",input$var_variable)]
    if (input_var_sorter == 1) {data <- data[nrow(data):1, ]}
    
    return(data)
  })
  
  
  
  
  output$map <- renderGirafe({
    ggiraph(code = print(worldMaps(data_map(), world_data, input$range[1], input$range[2], input$continent, input$WeaponType)))
  })
  
  output$polar <- renderPlotly({
    ScattPlot(crimes, input$var_scatter_continent, input$var_scatter_radio)
  })
  
  output$barchart <- renderPlot({
    Barcharplot(data_bar2(), input$var_variable)
  })
  
}



# Run app
shinyApp(ui = ui, server = server)



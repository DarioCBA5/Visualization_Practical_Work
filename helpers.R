
my_theme <- function () { 
  theme_bw() + theme(axis.title = element_blank(),
                     axis.text = element_blank(),
                     axis.ticks = element_blank(),
                     panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     panel.background = element_blank(), 
                     legend.position = "bottom",
                     panel.border = element_blank(), 
                     strip.background = element_rect(fill = 'white', colour = 'white'),
                     legend.key.width = unit(1,"cm"))
}


worldMaps <- function(df, world_data, input_range_1, input_range_2, input_continent, input_WeaponType){
  
  
  
  plotdf_grouped <- df %>%
    filter(iyear >= input_range_1 & iyear <= input_range_2) %>%
    filter(if (input_continent != "Global") region_txt == input_continent else TRUE) %>%
    filter(Weapon_Type %in% input_WeaponType) %>%
    count(ISO3, region_txt)
  
  
  world_data['region_txt'] <- plotdf_grouped$region_txt[match(world_data$ISO3, plotdf_grouped$ISO3)]
  world_data['Value'] <- plotdf_grouped$n[match(world_data$ISO3, plotdf_grouped$ISO3)]
  
  
  
  # Specify the plot for the world map
  g <- ggplot() + 
    geom_polygon_interactive(data = subset(world_data, lat >= -60 & lat <= 90), color = 'gray70', size = 0.1,
                             aes(x = long, y = lat, fill = Value, group = group, 
                                 tooltip = sprintf("%s<br/>%s", ISO3, Value))) + 
    scale_fill_gradientn(colours = brewer.pal(6, "Reds"), na.value = 'white') + 
    labs(fill = "Number of attacks", color = "green", title = NULL, x = NULL, y = NULL, caption = element_blank()) + 
    my_theme()
  
  return(g)
}



ScattPlot <- function(df, input_continent, input_radio){
  plotdf <- df
  #plotdf <- plotdf[!is.na(plotdf$ISO3), ]
  
  plotdf_grouped <- plotdf %>%
    filter(imonth %in%  1:12 & iday %in% 1:31) %>%
    filter(if (input_continent != "Global") region_txt == input_continent else TRUE) %>%
    count(if (input_radio == 1) imonth else weekday)
  
  r_plot <- as.numeric(t(as.matrix(plotdf_grouped))[2,])
  
  
  g <- plot_ly(
    type = 'scatterpolar',
    mode = "closest",
    fill = 'toself'
  ) %>%
    add_trace(
      r = r_plot,
      theta = if (input_radio == 1){
                c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
              }else{
                c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
              },
      showlegend = TRUE,
      mode = "markers",
      name = input_continent
    )  %>%
    layout(
      #title = "Attacks",
      polar = list(
        radialaxis = list(
          visible = T,
          range = c(0.9*min(r_plot),1.1*max(r_plot)),
          angle = 90,
          tickangle = 90
        ),
        angularaxis = list(
          tickfont = list(
            size = 12
          ),
          rotation = 90,
          direction = 'clockwise'
        )
      ),
      
      showlegend=TRUE
      
      
    )
  
  return(g)
  
}




Barcharplot <- function(df, input_variable){
  
  data <- df
  
  data$country_txt <- factor(data$country_txt, levels = data$country_txt)
  
  g <- ggplot(data,
               aes(x=country_txt,
                   y=UQ(sym(input_variable)),
                   fill =UQ(sym(input_variable)))) + 
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "#FF9966",high = "#990000") +
    theme(axis.title = element_blank(),
          legend.key.height = unit(1,"cm"),
          legend.key.width = unit(1,"cm"),
          legend.title = element_blank()) +
    coord_flip()
  
  return(g)
  
}
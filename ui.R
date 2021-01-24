ui <- 	navbarPage("World Terrorism",
                  tabPanel("Interactive Map",
                           fluidPage(
                             titlePanel("Global distribution"),
                             
                             sidebarLayout(
                               
                               sidebarPanel(
                                 
                                 #helpText("Date range of data."),
                                 
                                 selectInput("continent", 
                                             label = "Choose a continent.",
                                             choices = c("Global",
                                                         "Central America & Caribbean",
                                                         "North America",
                                                         "Southeast Asia",
                                                         "Western Europe",
                                                         "East Asia",
                                                         "South America",
                                                         "Eastern Europe",
                                                         "Sub-Saharan Africa",
                                                         "Middle East & North Africa",
                                                         "Australasia & Oceania",
                                                         "South Asia",
                                                         "Central Asia"
                                             ),
                                             selected = "Global"
                                 ),
                                 
                                 sliderInput("range",
                                             "Years:",
                                             min = 1970,
                                             max = 2018,
                                             value=c(1970, 2018)
                                 ),
                                 checkboxGroupInput(inputId = "WeaponType",
                                                    label = 'Weapon Type:', choices = c("Explosives" = "Explosives",
                                                                                        "Firearms" = "Firearms",
                                                                                        "Incendiary" = "Incendiary",
                                                                                        "Other" = "Other"), 
                                                    selected = c("Explosives" = "Explosives",
                                                                 "Firearms" = "Firearms",
                                                                 "Incendiary" = "Incendiary",
                                                                 "Other" = "Other"),inline=TRUE)
                               ),
                               
                               mainPanel(
                                 girafeOutput("map")
                               )
                               
                             )
                           )
                  ),
                  tabPanel("Month & Day",
                           fluidPage(
                             titlePanel("Frequency distribution"),
                             
                             sidebarLayout(
                               
                               sidebarPanel(
                                 
                                 #helpText("Date range of data."),
                                 
                                 selectInput("var_scatter_continent", 
                                             label = "Choose a continent.",
                                             choices = c("Global",
                                                         "Central America & Caribbean",
                                                         "North America",
                                                         "Southeast Asia",
                                                         "Western Europe",
                                                         "East Asia",
                                                         "South America",
                                                         "Eastern Europe",
                                                         "Sub-Saharan Africa",
                                                         "Middle East & North Africa",
                                                         "Australasia & Oceania",
                                                         "South Asia",
                                                         "Central Asia"
                                             ),
                                             selected = "Global"
                                             
                                 ),
                                 
                                 radioButtons("var_scatter_radio", h3("Periodicity"),
                                              choices = list("Monthly" = 1, "Daily" = 2),selected = 1)
                               ),
                               
                               mainPanel(
                                 plotlyOutput("polar"),
                                 p("ScatterPlot of attacks per month and weekday")
                                 
                               )
                               
                             )
                           )
                  ),
                  tabPanel("Country ranking",
                           fluidPage(
                             titlePanel("Country distribution"),
                             
                             sidebarLayout(
                               
                               sidebarPanel(
                                 
                                 #helpText("Country rankings"),
                                 
                                 selectInput("var_barplot_continent",
                                             label = "Choose a continent.",
                                             choices = c("Global",
                                                         "Central America & Caribbean",
                                                         "North America",
                                                         "Southeast Asia",
                                                         "Western Europe",
                                                         "East Asia",
                                                         "South America",
                                                         "Eastern Europe",
                                                         "Sub-Saharan Africa",
                                                         "Middle East & North Africa",
                                                         "Australasia & Oceania",
                                                         "South Asia",
                                                         "Central Asia"
                                             ),
                                             selected = "Global"
                                             
                                 ),
                                 
                                 numericInput(
                                   "var_number_columns",
                                   "Choose the number of columns to display",
                                   6,
                                   min = 3,
                                   max = 12
                                 ),
                                 
                                 radioButtons("var_variable", h3("Variable to display"),
                                              choices = list("Number of victims" = "nkill",
                                                             "Number of attacks" = "number_attacks",
                                                             "Successful attacks" = "success"),selected = "nkill"),
                                 
                                 h3("Change sort order"),
                                 actionButton("sortbutton", "", icon = icon("arrows-v"))
                               ),
                               
                               mainPanel(
                                 plotOutput("barchart",height = 500),
                               )
                               
                             )
                           )
                  )
)
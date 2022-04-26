library(readr)
library(dplyr)
library(shiny)
library(superml)
library(shinydashboard)
library(randomForest)
options(warn=-1)

model = readRDS("model.rds")


ui = dashboardPage(
  
        dashboardHeader(
          title = "A Fine Windy Day",
          dropdownMenu(type = "message",
                       messageItem(from = "Siddharth", message = "Hey! Welcome To The Dashboard.", time = "Today"),     
                       messageItem(from = "Siddharth", message = "Check the Windmill Power Predictor!", time = "Today"),
                       icon = icon('comment'))
          ),
        
        skin = "purple",
        
        dashboardSidebar(
            sidebarMenu(
                menuItem("Visuals Dashboard", tabName = "dashboard", icon = icon("bar-chart-o")),
                menuItem("Power Predictor", tabName = "form", icon = icon("table"), badgeLabel = "new", badgeColor = "green"),
                menuItem("About Project", tabName = "about", icon = icon("code-fork"))
            )
        ), 
        
        dashboardBody(
            tabItems(
                tabItem(tabName = "dashboard",
                        
                    fluidRow(style = 'margin: 10px;',
                        box(align = "center", solidHeader = T, status = "primary",
                            column(width = 12, img(src = "gif1.gif", width = '100%'))), 
                        box(align = "center", solidHeader = T, status = "primary",
                            column(width = 12, img(src = "gif2.gif", width = '100%')))
                    ),
                    
                    fluidRow(style = 'margin: 25px;',
                          box(width = '100%', solidHeader = T, status = "warning", style = "padding: 15px", 
                              tags$body(HTML(
                              "
                              <div class='tableauPlaceholder' id='viz1650895231198' style='position: relative'>
                                  <noscript>
                                      <a href='#'>
                                          <img alt='Windmill Analytics Dashboard ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Wi&#47;WindmillPowerPrediction&#47;WindmillAnalyticsDashboard&#47;1_rss.png' style='border: none' />
                                      </a>
                                  </noscript>
                                  <object class='tableauViz'  style='display:none;'>
                                      <param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> 
                                      <param name='embed_code_version' value='3' /> 
                                      <param name='site_root' value='' />
                                      <param name='name' value='WindmillPowerPrediction&#47;WindmillAnalyticsDashboard' />
                                      <param name='tabs' value='no' />
                                      <param name='toolbar' value='yes' />
                                      <param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Wi&#47;WindmillPowerPrediction&#47;WindmillAnalyticsDashboard&#47;1.png' /> 
                                      <param name='animate_transition' value='yes' />
                                      <param name='display_static_image' value='yes' />
                                      <param name='display_spinner' value='yes' />
                                      <param name='display_overlay' value='yes' />
                                      <param name='display_count' value='yes' />
                                      <param name='language' value='en-US' />
                                  </object>
                              </div>                
                              <script type='text/javascript'>                    
                                  var divElement = document.getElementById('viz1650895231198');                    
                                  var vizElement = divElement.getElementsByTagName('object')[0];                    
                                  if (divElement.offsetWidth > 800) { 
                                      vizElement.style.width='100%';
                                      vizElement.style.height=(divElement.offsetWidth*0.75)+'px';
                                  } 
                                  else if (divElement.offsetWidth > 500) { 
                                      vizElement.style.width='100%';
                                      vizElement.style.height=(divElement.offsetWidth*0.75)+'px';
                                  } 
                                  else { 
                                      vizElement.style.width='100%';
                                      vizElement.style.height='1327px';
                                  }                     
                                  var scriptElement = document.createElement('script');                    
                                  scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    
                                  vizElement.parentNode.insertBefore(scriptElement, vizElement);                
                              </script>
                              "
                              ))
                          )
                    ) 
                ), # End of Item Tab 1
                
                tabItem(tabName = "form",
                        fluidRow(style = 'margin: 50px;', align = 'center',
                                 box(width = '100%', 
                                     h2("Windmill Power Predictor", align = 'center', style = "padding: 10px; font-family: Georgia, serif; font-size: 30px; color:black"), 
                                     solidHeader = T, status = "warning") 
                         ),
                        
                        fluidRow(style = 'margin: 50px;', 
                            column(width = 12, align = "center",
                                   box(selectInput(inputId = "month", label = "Month", c(1:12)), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(selectInput(inputId = "day", label = "Day", c(1:31)), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(textInput(inputId = "wind_speed", label = "Wind Speed (m/s) (21.23 to 95.25)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(textInput(inputId = "atmospheric_temperature",label = "Atmospheric Temperature (C) (10.10 to 22.57)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(textInput(inputId = "shaft_temperature", label = "Shaft Temperature (C) (41.85 to 45.67)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),  
                                   box(textInput(inputId = "blades_angle", label = "Blade Angle (Deg) (-146.260 to 165.169)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(textInput(inputId = "gearbox_temperature", label = "Gearbox Temperature (C) (40.56 to 45.87)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(textInput(inputId = "engine_temperature", label = "Engine Temperature (C) (41.912 to 45.169)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(textInput(inputId = "motor_torque", label = "Motor Torque (N-m) (870 to 2460.9)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(textInput(inputId = "atmospheric_pressure", label = "Atmospheric Pressure (Pas) (16891 to 116412)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                  
                                   box(textInput(inputId = "area_temperature", label = "Area Temperature (C) (27.33 to 55)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(textInput(inputId = "windmill_body_temperature", label = "Windmill Body Temperature (C) (20.77 to 44.32)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(textInput(inputId = "wind_direction", label = "Wind Direction (Deg) (247.4137 to 331.624)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(textInput(inputId = "resistance", label = "Resistance (ohm) (1268 to 1828)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(selectInput(inputId = "turbine_status", label = "Turbine Status", c("A", "A2", "AAA", "AB", "ABC", "AC", "B", "B2", "BA", "BB", "BBB", "BCB", "BD", "D")), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(selectInput(inputId = "cloud_level", label = "Cloud Level", c("Extremely Low", "Low", "Medium")), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   
                                   box(textInput(inputId = "blade_length", label = "Blade Length (m) (2.249 to 18.21)"), solidHeader = T, status = "warning", style = "padding: 12px; font-family: Times New Roman;"),
                                   box(textInput(inputId = "blade_breadth", label = "Blade Breadth (m) (0.2007 to 0.5000)"), solidHeader = T, status = "primary", style = "padding: 12px; font-family: Times New Roman;")
                            )
                      ),
                      
                      fluidRow(style = 'margin: 50px;', align = 'center', 
                               box(width = '100%', style = "padding: 20px;", solidHeader = T, status = "primary",
                                   actionButton(inputId = "submit", label = "Submit", icon("paper-plane"), class = "btn btn-warning"))
                      ),
                      
                      fluidRow(style = 'margin: 50px;', align = 'center',
                               box(width = '100%', style = "padding: 5px;", solidHeader = T, status = "warning",
                                  valueBoxOutput(outputId = "power", width = 12)) 
                      )

                ), # End of Tab Item 2
                
                tabItem(tabName = "about",
                        fluidRow(style = 'margin: 25px;',
                                 box(width = '100%', solidHeader = T, status = "warning",  
                                     h2("Project Workflow", align = 'center', style = "font-family: Georgia, serif; font-size: 30px; color:black"),
                                     img(src = "Overview.png", width = '100%'))
                        ), 
                        fluidRow(style = 'margin: 25px;',
                                 box(width = '100%', solidHeader = T, status = "warning",  
                                     img(src = "Certificate.jpg", width = '100%'))
                        ) 
                ) # End of Tab Item 3
                
          ) # End of Tab Items
      ) # End of Dashboard Body
) # End of Dashboard Page


server = function(input, output){
    
    user_prediction = reactive({
      
      df = data.frame(
          month = as.numeric(input$month),
          day = as.numeric(input$day),
          wind_speed = as.numeric(input$wind_speed),
          atmospheric_temperature = as.numeric(input$atmospheric_temperature),
          shaft_temperature = as.numeric(input$shaft_temperature),
          blades_angle = as.numeric(input$blades_angle),
          gearbox_temperature = as.numeric(input$gearbox_temperature),
          engine_temperature = as.numeric(input$engine_temperature),
          motor_torque = as.numeric(input$motor_torque),
          atmospheric_pressure = as.numeric(input$atmospheric_pressure),
          area_temperature = as.numeric(input$area_temperature),
          windmill_body_temperature = as.numeric(input$windmill_body_temperature),
          wind_direction = as.numeric(input$wind_direction),
          resistance = as.numeric(input$resistance),
          turbine_status = as.character(input$turbine_status),
          cloud_level = as.character(input$cloud_level),
          blade_length = as.numeric(input$blade_length),
          blade_breadth = as.numeric(input$blade_breadth))
      
          df$cloud_level = as.numeric(factor(df$cloud_level, levels = c("Extremely Low", "Low", "Medium")))
          label = LabelEncoder$new()
          df$turbine_status = label$fit_transform(df$turbine_status)
          
          op = round(predict(model, df), digits = 3)
          valueBox(op, "Power Generated (kW/h)")
      
      }) # End of Dataset Input Function
    
      output$power = renderValueBox({
        
            validate(need(input$submit!=0, "Enter   Details   And   Press   Submit   !"))
            isolate(user_prediction())
        })
  
} # End of Shiny Server


shinyApp(ui, server)


library(shiny)

shinyUI(fluidPage(
    titlePanel("Customer Churn Prediction"),
    title = "Telecom Customer Churn Prediction",
    p(em("Help:", a("How to use this App", href="index.html"))),
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose a CSV file to import:",
                      accept = c("text/csv", "text/comma-separated-values, text/plain", ".csv")),
            
            tags$hr(),
            h5("Or fill in the following fields:"),
            
            textInput("phoneNu", "Phone Number (10 digits):"),
            numericInput("accLen", "Acct. Length (Days):", 0, min = 0, max = 9999, step = 1),
            selectInput("intlPlan", "International Plan:", c(" no", " yes"), selectize = F),
            selectInput("voiceM", "Voice Mail Plan:", c(" no", " yes"), selectize = F),
            numericInput("vmailN", "Total Vmail messages:", 0, min = 0, max = 999999, step = 1),
            numericInput("tDayMin", "Total Day minutes:", 0, min = 0, max = 1000),
            numericInput("tDayCal", "Total Day calls:", 0, min = 0, max = 999999, step = 1),
            numericInput("tDayCha", "Total Day charge:", 0, min = 0, max = 9999),
            numericInput("tEveMin", "Total Eve Minutes:", 0, min = 0, max = 1000),
            numericInput("tEveCal", "Total Eve calls:", 0, min = 0, max = 999999, step = 1),
            numericInput("tEveCha", "Total Eve charge:", 0, min = 0, max = 9999),
            numericInput("tNigMin", "Total Night Min.:", 0, min = 0, max = 1000),
            numericInput("tNigCal", "Total Night Cal.:", 0, min = 0, max = 999999, step = 1),
            numericInput("tNigCha", "Total Night Chrg.:", 0, min = 0, max = 9999),
            numericInput("tIntlMin", "Total Intl. Min.:", 0, min = 0, max = 1000),
            numericInput("tIntlCal", "Total Intl. Cal.:", 0, min = 0, max = 999999, step = 1),
            numericInput("tIntlCha", "Total Intl. Chrg.:", 0, min = 0, max = 9999), 
            numericInput("tServCal", "Cust. Service Cal.:", 0, min = 0, max = 100),
            
            actionButton("submit", "Submit")
            
            ),
        mainPanel(
            h4("Customers Account Information"),
            dataTableOutput("content"),
            dataTableOutput("content2"),
            tags$hr(),
            wellPanel(
                p(actionButton("pred", "Predict"), downloadButton("dnld", "Download"))
            ),
            h4("Result of Prediction (Potentially churn list):"),
            textOutput("text1"),
            dataTableOutput("result")
            
            )
        )
    ))
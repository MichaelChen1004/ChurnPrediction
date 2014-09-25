library(shiny)
load("churnModel.Rdata")   # load the trained final predictive model.

shinyServer(function(input, output) {
    
    # retrieving the customer information through the uploaded csv file.
    churnDF <- reactive({
        inFile <- input$file1
        if (is.null(inFile)) return(NULL)
        else read.csv(inFile$datapath)
    })
    
    # retrieving the customer information through the manually added data.
    churnDF2 <- reactive({
        input$submit
        isolate({if (input$phoneNu != "") {
                custDf <- data.frame(input$phoneNu, input$accLen, input$intlPlan, input$voiceM,
                                     input$vmailN, input$tDayMin, input$tDayCal, input$tDayCha,
                                     input$tEveMin, input$tEveCal, input$tEveCha, input$tNigMin,
                                     input$tNigCal, input$tNigCha, input$tIntlMin, input$tIntlCal,
                                     input$tIntlCha, input$tServCal)
                # write manually input data into a file for further retrieving.
                write.table(custDf, file = "churnList.csv", append = T, sep = ",", 
                            row.names = F, col.names = F)
                # retrieve the data from the file.
                if (file.exists("churnList.csv")) {
                    custDf <- read.csv("churnList.csv", header = F)  
                    # For manually input data, read from the saved file to render table.
                    names(custDf) <- c("phone.number", "account.length", "international.plan", "voice.mail.plan",
                               "number.vmail.messages", "total.day.minutes", "total.day.calls",
                               "total.day.charge", "total.eve.minutes", "total.eve.calls", "total.eve.charge",
                               "total.night.minutes", "total.night.calls", "total.night.charge",
                               "total.intl.minutes", "total.intl.calls", "total.intl.charge",
                               "number.customer.service.calls")
                    return(custDf)
                } else return(NULL)
            }
        })
    })
    
     # display the data from the csv file.
     output$content <- renderDataTable(churnDF(), options = list(iDisplayLength = 10))
     
    # display the data from manually input.
    output$content2 <- renderDataTable({
        input$submit
        isolate(churnDF2())
        }, options = list(iDisplayLength = 10))
    
    # predicting the churn using the ML model for the displayed customer accounts.
    churnResult <- reactive({
        input$pred
        isolate({
            churnDf <- churnDF()
            churnDf2 <- churnDF2()
            if (!is.null(churnDf)) {
                pred <- predict(rfMod, churnDf[, -1])
                if (sum(pred == 1) == 0) return(NULL)  # check if exists churn customers
                else churnDf[pred == 1, ]
            } else if (!is.null(churnDf2)) {
                pred <- predict(rfMod, churnDf2[, -1])
                if (sum(pred == 1) == 0) return(NULL) # check if exists churn customers
                else churnDf2[pred == 1, ]
            } else return()
        })
    })
    
    # display the predicted accounts which have potential churn probabilities.
    output$result <- renderDataTable(churnResult(), options = list(iDisplayLength = 10))
    
    output$text1 <-renderText({
        if (input$pred == 0) return()
        if (is.null(churnResult())) "No potentially churn customers in this list!"
    })
    
    # download the predicted results
    output$dnld <- downloadHandler(filename = "churnList.csv", 
                                   content = function(file) {
                                       write.csv(churnResult(), file)
                                       })
})
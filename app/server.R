library(shiny)
library(tidyverse)
library(shinydashboard)
library(rvest)
library(DT)
library(plotly)
library(dplyr)
library(ggplot2)
library(DBI)
library(RPostgreSQL)

#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Connect Database from Elephant

library(DBI)
library(RPostgres)

connectDB <- function() {
  driver <- dbDriver('PostgreSQL')
  DB <- dbConnect(
    driver,
    dbname = "abmlblif", 
    host = "rosie.db.elephantsql.com",
    user = "abmlblif",
    password = "eom11qi2S2qRJfGHJgHiuqRr0hOlM114-SbcpSFi"
  )
}

#-----------------------------------------------------------------------------#
# Query 1: Tabel Transaksi

q1 <- print(
  "SELECT * FROM transaction"
)

#-----------------------------------------------------------------------------#
# Query 2: Tabel Customers

q2 <- print(
  "SELECT * FROM customers"
)

#--------------------------Pembentukan Dataframe-------------------------------#
# Ubah dataset yang ditarik dari database menjadi bentuk Dataframe

DB <- connectDB()
table1 <- data.frame(dbGetQuery(DB, q1))
table2 <- data.frame(dbGetQuery(DB, q2))

dbDisconnect(DB) 



# Define server logic required to draw a histogram
function(input, output, session) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')

    })
    
    output$best_selling_products_gender_plot <- renderPlot({
      data %>%
        group_by(Gender, Product_name) %>%
        summarise(Quantity = n()) %>%
        ggplot(aes(y = Product_name, x = Gender)) +
        geom_bar(stat = "identity", fill = "#0072B2") +
        geom_text(aes(label = Quantity), hjust = 1.1, color = "white") + # Changed label to Quantity
        coord_flip() + 
        labs(y = "Nama Produk", x = NULL) +
        tema
    })
    
    #----------------------Tab Statistik-------------------------#
    # Render Tabel Data Leaderboard (Transaksi)
    output$out_tbl1 <- renderTable(table01)
    # Render Tabel Data Leaderboard (Pelanggan)
    output$out_tbl2 <- renderTable(table02)

    
}



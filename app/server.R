#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Connect Database from Elephant

library(DBI)
library(RPostgres)

DB <- dbConnect(
  RPostgres::Postgres(),
  dbname="fxrfzxqh",
  host="topsy.db.elephantsql.com",
  user="fxrfzxqh",
  password="jRE1Mgd_PROKue2DjHJFHWTnubI4PlRD"
)

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
  
  output$tanggal <- renderText({
    tanggal <- Sys.Date()
    format(tanggal, "%A, %d %B %Y")
  })
  
  #----------------------Tab Statistik-------------------------#
  # Render Tabel Data Leaderboard (Transaksi)
  
  output$out_tbl1 <- renderTable({
    # Lakukan query ke database
    q1 <- "SELECT * FROM Transaction"
    data1 <- dbGetQuery(DB, q1)
    data1
  })
  
  # Render Tabel Data Leaderboard (Product)
  
  output$out_tbl2 <- renderTable({
    # Lakukan query ke database
    q2 <- "SELECT * FROM Product"
    data2 <- dbGetQuery(DB, q2)
    data2
  })
  
  # Render Tabel Data Leaderboard (Voucher)
  
  output$out_tbl3 <- renderTable({
    # Lakukan query ke database
    q3 <- "SELECT * FROM Voucher"
    data3 <- dbGetQuery(DB, q3)
    data3
  })
  
}

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

connectDB <- function() {
  DB <- dbConnect(
    RPostgres::Postgres(),
    dbname="abmlblif",
    host="rosie.db.elephantsql.com",
    user="abmlblif",
    password="eom11qi2S2qRJfGHJgHiuqRr0hOlM114"
  )  
}

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
  
  output$out_tbl1 <- renderDataTable({
    # Lakukan query ke database
    q1 <- "SELECT t.transactionid, c.gender, c.locations, p.product_name, pm.method_name, v.voucher_name 
          FROM transaction t
          JOIN voucher v ON t.voucherid = v.voucherid
          JOIN product p ON t.productid = p.productid
          JOIN customer c ON t.customerid = c.customerid
          JOIN pay_method pm ON t.pmid = pm.pmid
          ;
"
    data1 <- dbGetQuery(DB, q1)
    data1
  })
  
  # Render Tabel Data Leaderboard (Product)
  
  output$out_tbl2 <- renderDataTable({
    # Lakukan query ke database
    q2 <- "SELECT * FROM Product"
    data2 <- dbGetQuery(DB, q2)
    data2
  })
  
  # Render Tabel Data Leaderboard (Voucher)
  
  output$out_tbl3 <- renderDataTable({
    # Lakukan query ke database
    q3 <- "SELECT * FROM Voucher"
    data3 <- dbGetQuery(DB, q3)
    data3
  })
  
  # Render Tabel Data for Transaction 
  
  q4 <- "SELECT t.total_price, t.quantity, t.voucher_status, p.product_name
          FROM transaction t
          JOIN product p ON t.productid = p.productid"
  
  q5 <- "SELECT t.total_price, t.quantity, t.voucher_status, v.voucher_name
          FROM transaction t
          JOIN voucher v ON t.voucherid = v.voucherid"
  
  q6 <- "SELECT t.total_price, t.quantity, v.voucher_name, p.product_name
          FROM transaction t
          JOIN voucher v ON t.voucherid = v.voucherid
          JOIN product p ON t.productid = p.productid"
  
  DB <- connectDB()
  table04 <- data.frame(dbGetQuery(DB, q4))
  table05 <- data.frame(dbGetQuery(DB, q5))
  table06 <- data.frame(dbGetQuery(DB, q6))
  
  # Output Setting for UI Transaction Product Menu
  
  output$filter_transaction <- renderUI({
    selectInput(
      inputId = "nama_product_filter",
      label = "Pilih Nama Produk",
      multiple = FALSE,
      choices = table04$product_name
    )
  })
  
  data4 <- reactive({
    table04 %>% filter(product_name %in% input$nama_product_filter)
  })
  
  output$out_tbl4 <- renderDataTable({
    data4()
  })
  
  # Output Setting for UI Transaction Voucher Menu
  
  output$filter_voucher <- renderUI({
    selectInput(
      inputId = "nama_voucher_filter",
      label = "Pilih Nama Voucher",
      multiple = FALSE,
      choices = table05$voucher_name
    )
  })
  
  data5 <- reactive({
    table05 %>% filter(voucher_name %in% input$nama_voucher_filter)
  })
  
  output$out_tbl5 <- renderDataTable({
    data5()
  })
  
  # Output Setting for UI Voucher Apply Menu
  
  output$filter_voucher1 <- renderUI({
    selectInput(
      inputId = "product_voucher_filter",
      label = "Pilih Nama Voucher",
      multiple = FALSE,
      choices = table06$voucher_name
    )
  })
  
  data6 <- reactive({
    table06 %>% filter(voucher_name %in% input$product_voucher_filter)
  })
  
  output$out_tbl6 <- renderDataTable({
    data6()
  })
  
}

#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
library(dplyr)
library(plotly)
library(tidyverse)
library(rvest)
library(readr)
library(bs4Dash)

#=============================== DATA ========================================#

# Read the CSV data from the URL
url <- "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/data/data_online_shop.csv"
data <- read_csv(url)

data$Age_Group <- cut(data$Age, breaks = c(0, 18, 30, 50, 100),
                      labels = c("Under 18", "18-30", "31-50", "Over 50"),
                      include.lowest = TRUE)


#=========================== Interface (Front-End) ============================#

fluidPage(
  dashboardPage(
    header <- dashboardHeader(
      title = div(
        style = "text-align: center;",
        img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/logo7.png", height = 135, style = "margin-bottom: -5px;"),  
        h1("Sigmaria Market", style = "color: #ee6363; font-size: 38px; font-weight: bold; margin-top: -20px;"),
        p(strong("Big choice, Big deals!"), style = "color: #4876FF; font-size: 14px; margin-top: -5px; font-family: 'Poplin', sans-serif;")
      ),
      titleWidth = "350px" 
    ), 
    
    
    #------------SIDEBAR-----------------#
    sidebar = dashboardSidebar(
      collapsed = FALSE,
      sidebarMenu(
        menuItem(
          text = "Home",
          tabName = "home",
          icon = icon("dashboard")
        ),
        menuItem(
          text = "Product",
          tabName = "products",
          icon = icon("product-hunt"),
          menuSubItem(
            text = "Product Recommendation",
            tabName = "product_recommendation"
          ),
          menuSubItem(
            text = "Product Category",
            tabName = "product_category"
          ),
          menuSubItem(
            text = "Gallery Product",
            tabName = "gallery_product"
          )
        ),
        menuItem(
          text = "Transactions",
          tabName = "transactions",
          icon = icon("shopping-cart")
        ),
        menuItem(
          text = "Vouchers",
          tabName = "vouchers",
          icon = icon("ticket")
        ),
        menuItem(
          text = "Customers",
          tabName = "customers",
          icon = icon("users")
        ),
        menuItem(
          text = "Payment Methods",
          tabName = "payment_methods",
          icon = icon("credit-card")
        ), 
        menuItem(
          text = "Contact Us",
          tabName = "contact_us",
          icon = icon("envelope")
        )
      ),
      style = "background-color: #FF6A6A; font-size:15px;font-weight:bold; padding: 8px; border-radius: 4px;"
    ), 
    
    
    #-----------------BODY-----------------#
    
    body = dashboardBody(
      tabItems(
        #-------------------------Tab Home ------------------------#
        tabItem(
          tabName = "home",
          jumbotron(
            title = div(
              img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/banner3.png", style = "width: 100%; max-width: 1150px; margin: auto; display: block;"),
            ),
            lead = span("Win cash prizes worth IDR 250 million by simply spending a minimum of IDR 500,000 starting TODAY!", style = "font-size:20px; font-weight:bold; display: flex; align-items: center; background-color: #4876FF; color: #ffffFF; padding: 15px; border-radius: 5px;"),
            status = "danger",
            style = "background-color: #ffffff;"
          ), 
          
          fluidRow(
            box(title = div("What is Sigmaria?", style = "font-weight: bold; text-align: center;"),
                solidHeader = TRUE,
                status = "primary",
                background = "warning",
                width = 6,
                collapsible = TRUE,
                collapsed = TRUE,
                img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/1.png", width = "100%", style = "margin-bottom: 20px;"),
                tags$p("Sigmaria Market is a platform that provides comprehensive information about sales transactions, available products, payment methods, vouchers, and customer data. This platform enables users to browse and acquire various products available in Sigmaria Market. With a wide range of products and recorded transaction information, Sigmaria Market presents up-to-date information about market activities that can assist users in making desired purchases. Additionally, the platform also offers recommendations for products that are suitable for customers.",
                       style = "font-size:17px; color: white; text-align: justify;"),
                style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(title = div("How to use this Platform?", style = "font-weight: bold; text-align: center;"),
                solidHeader = TRUE,
                status = "primary",
                background = "warning",
                width = 6,
                collapsible = TRUE,
                collapsed = TRUE,
                img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/2.png", width = "100%", style = "margin-bottom: 20px;"),
                tags$p("Navigate through the menu at the top of the page to explore the available products and vouchers. Choose your desired category or use the search feature to find specific items. Sigmaria Market will then display detailed information about the products, including vouchers and available payment methods. Simply add your chosen items to the cart and proceed to checkout. Enjoy the convenience of shopping with Sigmaria!",
                       style = "font-size:17px; color: white; text-align: justify;"),
                style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
          )
        ),
        
        #-------------------------Tab Product ------------------------#
        
        #-------------------------Tab Product- Product Recomendation  ------------------------#
        tabItem(
          tabName = "product_recommendation",
          h2(" Product Recommendation", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"),   # Menambahkan judul tab
          fluidRow(
            box(
              title = "Best-Selling Products by Location",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              radioButtons(
                inputId = "location_filter",
                label = "Location:",
                choices = unique(data$Locations),
                selected = unique(data$Locations)[1],
                inline = TRUE
              ),
              plotOutput("best_selling_products_plot", height = "150px"),
              width = 6,
              status = "primary"
            ),
            box(
              title = "Best-Selling Products by Gender",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              radioButtons(
                inputId = "gender_filter",
                label = "Gender:",
                choices = unique(data$Gender),
                selected = unique(data$Gender)[1],
                inline = TRUE
              ),
              plotOutput("best_selling_products_gender_plot", height = "150px"),
              width = 6,
              status = "primary"
            ),
            box(
              title = "Best-Selling Products by Age Group",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              radioButtons(
                inputId = "age_group_filter",
                label = "Age Group:",
                choices = unique(data$Age_Group),
                selected = unique(data$Age_Group)[1]
              ),
              plotOutput("best_selling_products_age_plot", height = "150px"),
              width = 6,
              status = "primary"
            ),
            box(
              title = "Best-Selling Products by Category",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              radioButtons(
                inputId = "category_filter",
                label = "Product Category:",
                choices = unique(data$Product_Category),
                selected = unique(data$Product_Category)[1],
                inline = TRUE
              ),
              plotOutput("best_selling_products_category_plot", height = "150px"),
              width = 6,
              status = "primary"
            ),
          )
        ),
        #-------------------------Tab Product- Product category  ------------------------#
        tabItem(
          tabName = "product_category",
          h2("Product Category", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            column(12, align = "center",
                   p(HTML("Choose from a variety of product categories to explore our offerings. &#128522;"))
            )
          ),
          fluidRow(
            # Box untuk kategori "Apparel"
            box(
              title = "Apparel",
              solidHeader = TRUE,
              status = "primary",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/KATEGORI1.png", width = "100%", style = "margin-bottom: 20px;"),
              
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            
            # Box untuk kategori "Bottles"
            box(
              title = "Bottles",
              solidHeader = TRUE,
              status = "primary",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/KATEGORI4.png", width = "100%", style = "margin-bottom: 20px;"),
             
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ), 
            
            # Box untuk kategori "Office Supplies"
            box(
              title = "Office Supplies",
              solidHeader = TRUE,
              status = "primary",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/KATEGORI3.png", width = "100%", style = "margin-bottom: 20px;"),
              
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            
            # Box untuk kategori "Home Furniture"
            box(
              title = "Home Furniture",
              solidHeader = TRUE,
              status = "primary",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/KATEGORI2.png", width = "100%", style = "margin-bottom: 20px;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          )
        ),
        
        #-------------------------Tab Product- Product name ------------------------#
        tabItem(
          tabName = "gallery_product",
          h2("Gallery Product", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            # Kotak untuk produk "22 oz YouTube Bottle Infuser"
            lapply(c("22 oz YouTube Bottle Infuser",
                     "8 pc Android Sticker Sheet",
                     "Android Infant Short Sleeve Tee Pewter",
                     "Android Matrix Tee White",
                     "Android Men's Engineer Short Sleeve Tee Charcoal",
                     "Android Men's Short Sleeve Tri-blend Hero Tee Grey",
                     "Android Men's Vintage Henley",
                     "Android Sticker Sheet Ultra Removable",
                     "Android Stretch Fit Hat",
                     "Badge Holder",
                     "Ballpoint LED Light Pen",
                     "Ballpoint Stylus Pen",
                     "Colored Pencil Set",
                     "Four Color Retractable Pen",
                     "Galaxy Screen Cleaning Cloth",
                     "Google Crew Sweater Navy",
                     "Google Doodle Decal",
                     "Google Infant Short Sleeve Tee Red",
                     "Google Infant Zip Hood Royal Blue",
                     "Google Laptop and Cell Phone Stickers",
                     "Google Men's  Zip Hoodie",
                     "Google Men's 100% Cotton Short Sleeve Hero Tee Black",
                     "Google Men's 100% Cotton Short Sleeve Hero Tee Navy",
                     "Google Men's 100% Cotton Short Sleeve Hero Tee White",
                     "Google Men's Bike Short Sleeve Tee Charcoal",
                     "Google Men's Pullover Hoodie Grey",
                     "Google Men's Quilted Insulated Vest Black",
                     "Google Men's Short Sleeve Badge Tee Charcoal",
                     "Google Men's Vintage Badge Tee Black",
                     "Google Men's Watershed Full Zip Hoodie Grey",
                     "Google Metallic Notebook Set",
                     "Google Stylus Pen w/ LED Light",
                     "Google Tee Yellow",
                     "Google Toddler Short Sleeve T-shirt Grey",
                     "Google Tri-blend Hoodie Grey",
                     "Google Twill Cap",
                     "Google Women's Fleece Hoodie",
                     "Google Women's Short Sleeve Badge Tee Navy",
                     "Google Women's Short Sleeve Hero Tee Black",
                     "Google Women's Short Sleeve Hero Tee Grey",
                     "Google Women's Short Sleeve Hero Tee Red Heather",
                     "Google Women's Tee Grey",
                     "Google Women's Vintage Hero Tee Black",
                     "Google Women's Vintage Hero Tee White",
                     "Google Womens 3/4 Sleeve Baseball Raglan Heather/Black",
                     "Keyboard DOT Sticker",
                     "Leatherette Journal",
                     "Maze Pen",
                     "Metal Texture Roller Pen",
                     "Nest Cam Indoor Security Camera - USA",
                     "Nest Cam IQ - USA",
                     "Nest Cam Outdoor Security Camera - USA",
                     "Nest Learning Thermostat 3rd Gen-USA - Copper",
                     "Nest Learning Thermostat 3rd Gen-USA - Stainless Steel",
                     "Nest Learning Thermostat 3rd Gen-USA - White",
                     "Nest Protect Smoke + CO Black Battery Alarm-USA",
                     "Nest Protect Smoke + CO White Battery Alarm-USA",
                     "Nest Protect Smoke + CO White Wired Alarm-USA",
                     "Nest Secure Alarm System Starter Pack - USA",
                     "Nest Thermostat E - USA",
                     "Pen Pencil & Highlighter Set",
                     "Recycled Paper Journal Set",
                     "Satin Black Ballpoint Pen",
                     "Spiral Notebook and Pen Set",
                     "Switch Tone Color Crayon Pen",
                     "Waze Mobile Phone Vent Mount",
                     "Waze Mood Ninja Window Decal",
                     "YouTube Custom Decals",
                     "YouTube Men's Short Sleeve Hero Tee Black",
                     "YouTube Men's Vintage Tank",
                     "YouTube Onesie Heather",
                     "YouTube Twill Cap",
                     "YouTube Women's Short Sleeve Hero Tee Charcoal"), function(product_name) {
                       box(
                         title = product_name,
                         solidHeader = TRUE,
                         status = "primary",
                         background = "warning",
                         width = 6,
                         collapsible = TRUE,
                         collapsed = TRUE,
                         img(src = paste0("https://example.com/", gsub("\\s+", "_", tolower(product_name)), "_image.png"), width = "100%", style = "margin-bottom: 20px;"),
                         tags$p("Description of the product goes here.",
                                style = "font-size:17px; color: white; text-align: justify;"),
                         style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                       )
                     })
          )
        ),
        
        
        #-------------------------Tab Transactions ------------------------#
        tabItem(
          tabName = "transactions",
          h2("Search Transaction", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            # Filter product
            box(
              title = "Filter Transaction based on Product",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              tags$p("Choose the product you want to display"),
              tags$br(),
              uiOutput("filter_transaction"),
              width = 12,
              status = "primary"
            ),
            #filter voucher
            box(
              title = "Filter Transaction based on Voucher",
              background = "danger",
              solidHeader = TRUE,
              tags$p("Choose the voucher you want to display"),
              tags$br(),
              uiOutput("filter_voucher"),
              width = 12,
              status = "primary"
            ),
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "Table Transaction",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              dataTableOutput("out_tbl1"),
              width = 12,
              status = "primary"
            ),
          )
        ),
        
        #-------------------------Tab Customers ------------------------#
        tabItem(
          tabName = "customers",
          h2("Search Customers", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            # Filter product
            box(
              title = "Filter Customers based on Product",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              tags$p("Choose the product you want to display"),
              tags$br(),
              uiOutput("filter_cust1"),
              width = 12,
              status = "primary"
            ),
            #filter voucher
            box(
              title = "Filter Customers based on Category",
              background = "danger",
              solidHeader = TRUE,
              tags$p("Choose the Category you want to display"),
              tags$br(),
              uiOutput("filter_category"),
              width = 12,
              status = "primary"
            ),
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "Table Customers",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              dataTableOutput("out_tbl2"),
              width = 12,
              status = "primary"
            ),
          )
        ),
        
        #--------------------------Tab Payment Method--------------------------#
        tabItem(
          tabName = "payment_methods",
          h2("We Accept Different Payment Methods", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            column(12, align = "center",
                   p(HTML("Choose from a variety of payment options to make your purchase easier. &#128522;"))
            )
          ),
          fluidRow(
            box(
              title = div("Card", style = "font-weight: bold; text-align: center;"),
              solidHeader = TRUE,
              status = "primary",
              background = "warning",
              width = 4,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/pm1.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$p("We accept all major credit and debit cards",
                     style = "font-size:17px; color: white; text-align: justify;"),
              style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              title = div("Digital Wallets", style = "font-weight: bold; text-align: center;"),
              solidHeader = TRUE,
              status = "primary",
              background = "warning",
              width = 4,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/pm2.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$p("Use popular digital wallets like Apple Pay and Google Pay.",
                     style = "font-size:17px; color: white; text-align: justify;"),
              style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              title = div("Paypal", style = "font-weight: bold; text-align: center;"),
              solidHeader = TRUE,
              status = "primary",
              background = "warning",
              width = 4,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://github.com/yudheeeeet/mdskel4/raw/main/Image/pm3.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$p("Securely pay with your PayPal account",
                     style = "font-size:17px; color: white; text-align: justify;"),
              style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          ),
          fluidRow(
            column(12, align = "center",
                   p(HTML("For other payment options, please contact our support team. &#128522; Thank you! &#128591;"))
            )
          )
        )
      )
    ),

    #-------------------------Tab Contuct Us ------------------------#
    
    
    #-----------------FOOTER-----------------#
    
    footer = dashboardFooter(
      right = "© 2024 Kelompok 4 | All Rights Reserved",
      left = "Made with ❤️ by Kelompok 4"
      
    )
  )
)


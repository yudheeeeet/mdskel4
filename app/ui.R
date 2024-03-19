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
library(shinyWidgets)

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
      textOutput("tanggal")
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
          text = "Payment Methods",
          tabName = "payment_methods",
          icon = icon("credit-card")
        ), 
        menuItem(
          text = "Our Team",
          tabName = "our_team",
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
          tags$head(
            tags$style(HTML(".jumbotron .btn {display: none;  /* Menghapus tombol more */}"))
          ),
          
          fluidRow(
            box(title = div("What is Sigmaria?", style = "font-weight: bold; text-align: center;"),
                solidHeader = TRUE,
                status = "primary",
                background = "warning",
                width = 6,
                collapsible = TRUE,
                collapsed = TRUE,
                img(src = "depan1.png", width = "100%", style = "margin-bottom: 20px;"),
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
                img(src = "depan2.png", width = "100%", style = "margin-bottom: 20px;"),
                tags$p("Navigate through the menu at the top of the page to explore the available products and vouchers. Choose your desired category or use the search feature to find specific items. Sigmaria Market will then display detailed information about the products, including vouchers and available payment methods. Simply add your chosen items to the cart and proceed to checkout. Enjoy the convenience of shopping with Sigmaria!",
                       style = "font-size:17px; color: white; text-align: justify;"),
                style = "border-radius: 10px; background-color: #FF6a6a; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          )
        ),
        
        #-------------------------Tab Product ------------------------#
        
        #-------------------------Tab Product- Product Recomendation  ------------------------#
        tabItem(
          tabName = "product_recommendation",
          h2(" Product Recommendation", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"),   # Menambahkan judul tab
          column(12, align = "center",
                 p(HTML("Discover our selection of best-selling products and find your new favorites. &#127775;"))
          ),
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
              width = 12,
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
              width = 12,
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
              width = 12,
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
              width = 12,
              status = "primary"
            )
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
              
              fluidRow(
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "16.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/yageyan-Classic-Sneakers-Fashion-black11/dp/B09W57RPXB/ref=sr_1_1_sspa?crid=179LB9OR74BAC&dib=eyJ2IjoiMSJ9.9TmagZJyF-tV6f8Mc3S2tgSWXYphRZ445k4UbS6Sh6udoc2vostRK1d9KClrVR-Ozz9watuXtRH2lP3sy7PZXEIfrtjebClNb4cwDKFWzeZ_uz5oYJKEgwx0GGFtTXu6qrl2UiFi9UlT-wZBrBcEKJ7eAwpow09HsemMwwBgeIhZDEbkCN2LNULcdiJWIcq-OCO3UBkmgvDs4CKYe-xNhXu8UmxGzsMyplKJd_9AcLw.ctyv1mdxCNZe9L3QRorq50AfLqnCEmqnIw-0FIq4nJs&dib_tag=se&keywords=yageyan+Men+Canvas+Low+top+Shoes+Classic+Casual+Sneakers+Black+and+White+Fashion+Shoes&qid=1710244684&sprefix=yageyan+men+canvas+low+top+shoes+classic+casual+sneakers+black+and+white+fashion+shoes%2Caps%2C709&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "17.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Dokotoo-Men-Sweatshirts-Geometric-Pullover/dp/B0C9ZVSXLY/ref=sr_1_1_sspa?dib=eyJ2IjoiMSJ9.fzSJE6dtbbnrbnFHdxXI0k-qwiG9uMwuYDueXmuO18MQd8w4xjdRPmxwzkRcpew3TGe1sOPTUhmwn--6q-mgJr7pBm-Ek0idYs1YsAlKCfo.g4BdbO8psTNskJBJg48V5s_SrHG19vW7P5IJZFgoU-Y&dib_tag=se&keywords=Men%27s+Crewneck+Sweatshirts+Soild+Color+Geometric+Texture+Long+Sleeve+Casual+Pullover+Shirt&qid=1710244647&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "18.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Trendy-Queen-Oversized-Sweatshirts-Turtleneck/dp/B0C5RFPCWK/ref=sr_1_2?crid=HF4HA55C8V0G&dib=eyJ2IjoiMSJ9.ra5EbfipI6ZsHNWNipsBARsPfCQi5-B-_sG5ciia0xM3Rt9WITWLzam2OIPTn_nPiuaH9a37P-0YAuZ48DvTzI4KRHeoUrfJN4o9v7BwkcW91xkqJUuXrkR32XFKRlA7pDTdtHqiNCj5BG749IrUmDjlfEpYAeNVPniD8RCb9DIAVenKP1TtMg47ZppMPWih5kUHPyanfvRob9zlzZJxbcP-3nqhxyIGD92QwbQg_tc.da8Tl2V6c5e2cPeFy8lJBQ_Rja6QRFUtDasMflfCtRw&dib_tag=se&keywords=Trendy+Queen+Womens+Oversized+Sweatshirts+Turtleneck+Pullover+Long+Sleeve+Hoodies+Tops+Fall+Outfits+2023+Clothes&qid=1710244600&sprefix=dokotoo+tops+for+women+trendy+summer+casual+cap+short+sleeve+basic+textured+solid+color+round+neck+t+shirts+blouse%2Caps%2C448&sr=8-2",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "19.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Trendy-Queen-Oversized-Sweatshirts-Turtleneck/dp/B0C5RFPCWK/ref=sr_1_2?crid=HF4HA55C8V0G&dib=eyJ2IjoiMSJ9.ra5EbfipI6ZsHNWNipsBARsPfCQi5-B-_sG5ciia0xM3Rt9WITWLzam2OIPTn_nPiuaH9a37P-0YAuZ48DvTzI4KRHeoUrfJN4o9v7BwkcW91xkqJUuXrkR32XFKRlA7pDTdtHqiNCj5BG749IrUmDjlfEpYAeNVPniD8RCb9DIAVenKP1TtMg47ZppMPWih5kUHPyanfvRob9zlzZJxbcP-3nqhxyIGD92QwbQg_tc.da8Tl2V6c5e2cPeFy8lJBQ_Rja6QRFUtDasMflfCtRw&dib_tag=se&keywords=Trendy+Queen+Womens+Oversized+Sweatshirts+Turtleneck+Pullover+Long+Sleeve+Hoodies+Tops+Fall+Outfits+2023+Clothes&qid=1710244600&sprefix=dokotoo+tops+for+women+trendy+summer+casual+cap+short+sleeve+basic+textured+solid+color+round+neck+t+shirts+blouse%2Caps%2C448&sr=8-2",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "20.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/ANRABESS-Sleeveless-Matching-Loungewear-546Hulv-S/dp/B0BPMKV4RW/ref=sr_1_2_sspa?crid=2437BF1RVQCQ7&dib=eyJ2IjoiMSJ9.5_fqEJFpA3WkE_y4JPJ7s-TVO0sRSwaQaxHAzFYrzi6rUMTEJaEGRsIZZ9yCJYk1HKpE_t40ch73btizsNw3VCJjys_WzWenZ2pMjOzOP9_nnqlvR7C35hBieKdt5mx_CZTRCdAKjP-t27wJxMLSZFLMc0Z7TdZEVbv1L3YwKfuv177Rvwis2qvNg4OYWhtGEv0UrS8SrWCUE9QmUIgizA.I1CMGhBegT0aK3oFNhY0EqjZ04rpKwACuFDEhg_Axjg&dib_tag=se&keywords=ANRABESS+Women%27s+Summer+2+Piece+Outfits+Sleeveless+Tank+Crop+Button+Back+Top+Capri+Wide+Leg+Pants+Linen+Set+with+Pockets&qid=1710244509&sprefix=anrabess+women%27s+summer+2+piece+outfits+sleeveless+tank+crop+button+back+top+capri+wide+leg+pants+linen+set+with+pockets%2Caps%2C600&sr=8-2-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
              ),
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
              fluidRow(
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "11.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/dp/B091Z36D56/ref=twister_B0B65CDMXF?_encoding=UTF8&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "12.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Ocean-Bottle-Eco-Friendly-Stainless-Dishwasher/dp/B08LMDYSFT/ref=sr_1_2_sspa?crid=2Z1ICKF5UMJI3&dib=eyJ2IjoiMSJ9.Ih4x1_CAXuqklXOWIRuwr2odIiHQr0w-WiOdpWiKgcFUhPGVq-imQUL_CbIPoezTbztu8ZmQ37x5zQ8Ze0oAurdaf2jRRP9zrj6H7Nuk6-Gt0DYEuRjVavqwkwyDWVrMYOOBOVGcchaOv39uimgZZ0CfyqXOJNYaMROzhChZbCrrzbN2inTLPVAVLExx8HLvsM1YbFl8kOl7OxpG6Ho9ndrdykvq2jWqIHIX28OtYJjbmZowVSLyUeuPXMMG0yZYmFvkIaZY5Wi2GBmgNgAOcpvUY2Tq0EIZ95tATZnWZZw.7v0jPgdp8r7aP4-6sMuzCYG_NzJ08WIeA1rVfB_Bsww&dib_tag=se&keywords=bottle&qid=1710244052&sprefix=bo%2Caps%2C1726&sr=8-2-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "13.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Insulated-Stainless-Bottles-Leakproof-Toddler/dp/B0C5RD84XV/ref=sr_1_3?crid=2Z7INDYX7KAY5&dib=eyJ2IjoiMSJ9.EfowUEdUBG31DO6okHg1d50fAiixdhhZYTKroH2_hwMDKQX32Ct6GHpjYFClTHYszvkfn1POqai_l3JVyKb4IXw6jLexhIy1BDZsLCkNgTfs9BZ_oeVQr0vKcPn6raSWcRqJQI_82QJ8WsHhPoWN6XSt2vRRnWzhzpTKwf8Ntez5cMurBfQYJ7ZE9nJVmqfnD_wHI4FT3ixMNsRw9gc5UozRbvncm_8ORI1W9jfaQRxPvpyVBppDz4L09_qh469kOVneYvp3Ey9m1-rJHWwhEdIRsto58q4P_8BAwMQGsDA.aJ_Dc4EWQIEo3tU0wXyg_VbtUBA1SN1eWru1xcGwm0A&dib_tag=se&keywords=kids%2Bwater%2Bbottle%2B14%2Boz%2Bpattern&qid=1710244382&sprefix=kids%2Bwater%2Bbottle%2B14%2Boz%2Bpatter%2Caps%2C732&sr=8-3&th=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "14.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Mdkave-Capacity-%EF%BC%8CMultiple-Pockets-Markings/dp/B0CCXSYMG3/ref=sr_1_1?dib=eyJ2IjoiMSJ9._6zmPlu4GspmszUjnhfpXGNGXnTvCuJG75ztsyX4KN7pLgU-9XFVUSEK3Vs_RSFc_l06ZhtsEmn9U7IpX0jbKXseYf1PP_QcMI0Zk_f_QwwXgjeoyXNH-VsaJInRcc66NDKUeGdD-9SPNPN2ricYy42znBF0dIsK25aEfETPorPr0nFFpxSMP12TazpFvfiO39_c_ujjG-gioUaYfwqfIcwbpRTtHo7u8EkOhpYwsoe-DUvQxqQie0gLkHk6R_vLISkzWsl1SCbIsOk0u4e-toecNNPdPSdLdsQ1jP9SlkY.CzYMb3RRYb9TEZG7hZbBmB2FeFN3ef_Royfpeud_z_g&dib_tag=se&keywords=64+oz+Water+Bottle%2C+1%2F2+Gallon+Water+Bottle%2C+Water+Bottle+Holder+with+Shoulder+Strap%2C+Time+Motivational+Water+Bottle+-+Great+for+Camping%2C+Gym+and+Outdoor+Activities%2C+Gift&qid=1710243781&sr=8-1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "15.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/bubba-Refresh-Insulated-Bottle-TEAL/dp/B0CB216JQY/ref=sr_1_44?dib=eyJ2IjoiMSJ9.14Q8SYoaYv52isn5bz2zp_0F8lv7WAsVFXlfQBg03dEZ9b1VTrqRLtKdN5-GafTXUUoAQOhS0xuWh45JTJBpGO0hYKE2ds6NydcSYqY-6HwEdmmT6tI-AO1w2IMIcJktchw2pxYnMOU9wfYLNTVB8Z4LOsBdiqlJzmE3YRelrQwdooXPDD8JtZzRCb4rTbAC7J09znBU1vZ5rYSHvKuUV340-_-kQOzDt5l56UxvDKb5U18ox0ctylbRx4FMUgOP41nO34qbxih9hOqBiKVoLp-dVjcQP8lTSCbMicsrvHY.JObR27so8-L9ArJJa8DTnzMcRGquSsAcvYRhRVI4TVE&dib_tag=se&keywords=bubba%2Bwater%2Bbottles&qid=1710243700&sr=8-44&th=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
              ),
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
              
              fluidRow(
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "1.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Supplies-Accessories-Stapler-Dispenser-Coworkers/dp/B0CCPNXX4Y/ref=sr_1_1_sspa?crid=3HM4RPLWVMJGU&dib=eyJ2IjoiMSJ9.oKRBmkLNiT5xdouPio_si2xOKacL6PT7O4qab9tjVBlnUZXDQajNp0dnP8qnNc9s9s86LLJIogrXlRseg9529eK3CAouWfQFBZ8CiZg2oEFdTkWxhMLr9ioaZsH1j5iQcigLrIdtOdzrNzwYyIFKUOU7t_j1GqQdiNuOgTFwroT7Mv9LWvhL2fLdZQYQP0paaGjC32dF_j_1sVhxohSVpGvJx-Y3TLY-SK4mzrqaRtV1pr_l8EKFi3jCIw-juVzam1GnXGDKFiFdOjwTAxMGtwqBZZwUl9ISWLp3TmCJRw8.jDzNXKYCb3ZIMzMtiGEg38XQw6vu2ORYab1zyGsb-Bc&dib_tag=se&keywords=Teal+Office+Supplies%2C+Teal+Office+Supplies+and+Accessories%2C+Mint+Green+Stapler+and+Tape+Dispenser+Set+for+Women%2C+Green+Office+Desk+Accessories%2C+Office+Gift+for+Women%2C+Office+Lady%2C+Coworkers&qid=1710244875&sprefix=teal+office+supplies%2C+teal+office+supplies+and+accessories%2C+mint+green+stapler+and+tape+dispenser+set+for+women%2C+green+office+desk+accessories%2C+office+gift+for+women%2C+office+lady%2C+coworkers%2Caps%2C382&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "2.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Amazon-Basics-Stapler-Capacity-Non-Slip/dp/B079ZV4V3C/ref=sr_1_5?dib=eyJ2IjoiMSJ9.uErXibz2Eau072k5SQ4w7IgFzjo79zyAEy1QBW5PaVTP_bwMOF4PMt-gdmsbEc5kLM81HfgT6z06WaDRZ4dAzb9uh5I5NyivWm8cyq55Sd6rNsSlGv6Q3yRzlSO8HQPjWEhZhC6cM87N34X7Z9BTTKSmnG1pY2V8uA58H-JGIig3gG91fItwRHZbWoIdEAnzdKFjxdR0OvzPyLR6Kt7GMl9cMACHsALkTN6bhDuNPqhvuinfSB_INQokqYq6KpIGfnrDu5kOSuI0Wk3ABOORhl6n2NTKFdO-ghaSoROySlI.dG2Jpw5LnovtvVfkNVsNmbaIJcbzBITmWn7l-3Al5b8&dib_tag=se&keywords=Amazon+Basics+Stapler+with+1000+Staples%2C+Office+Stapler%2C+25+Sheet&qid=1710244844&sr=8-5",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "3.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Mr-Folders-Morandi-Colored-Supplies/dp/B0C4PMH7HY/ref=sr_1_1?dib=eyJ2IjoiMSJ9.ObEOgQlTCmxGGZHGL38Bnj3nywpcqEe8vlv6LfcHdcsIbh-yLCzt8wMWTjkJuIjKrQX7Dr-GeaYNuGwNmw13C0zdDpL9dVoLa_qyH7g3t_VJIzejeRlGsnAHt8pjXOeCZq_vcmqxST3hGPBQtiu4NDcex6ARuqbEDtc39_Oo89NgbFxPLhiqMVrSwIIAZqhy6VL_Z1V9Ik3BFCoC3PLG6O7tDR6Xtq18SSqQXLY7AfYRriXzxABW4YLFrrkG7HylCQ2iWkJOWWhaFq1Fo1RpOUK5nenCqzoWG-iratdnbvk.5u4aY1-ugDWFI2g8BaR6GUu59VrTfv73Zuk_c4tH6m8&dib_tag=se&keywords=Mr.%2BPen%2BFile%2BFolders%2C%2B18%2BPack%2C%2BMorandi%2BColors%2C%2B1%2F3-Cut%2BTab%2C%2BLetter%2BSize%2C%2BDurable%2BPaper%2BFolders%2C%2BOffice%2BSupplies&qid=1710244796&sr=8-1&th=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "4.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Drawdart-Retractable-Aesthetic-Journaling-Supplies/dp/B0CGLJCC5Q/ref=sr_1_2?crid=SLNDQNQ233CW&dib=eyJ2IjoiMSJ9.8tUtvYh7UQsCGySnLpVW5nqXFkf8H2XPue0FXGv83iatMZFxpxwKrse3zslEVZgD2DbwaG3iEUWhMmb1bUGZreT3ZtJGlRxgO0IlaBOeFbRN26EWaBNZ_LC-Vq989ywbHdBnEDZ66K53dyT2DgnKTHmyMjHktf0JeafBB_c7mZWmYm8D8ViMcem-ekCvHwbHNO4Jysuq4dkb33laWhrp7Ejp-bDLTHHhFW1olx3ZUH6tTeCBzGenKE0FMXPnzl_l6-dWoCqFywLkGLcVbx28dGCEBXt_Bm2EPLKRWHQR3yA.P1BAR9TejJXutdreY9PUPyHOpxJAyH7LzYEsFb37lNk&dib_tag=se&keywords=Gel+Pens%2C+12+Pcs+Smooth+Writing+Pens+No+Bleed+%26+Smear%2C+Black+Ink+Cute+Pens+Fine+Point+%280.5mm%29%2C+Retractable+Aesthetic+Journaling+Pens+School+Office+Supplies+for+Women+%26+Men&qid=1710244770&sprefix=gel+pens%2C+12+pcs+smooth+writing+pens+no+bleed+%26+smear%2C+black+ink+cute+pens+fine+point+0.5mm+%2C+retractable+aesthetic+journaling+pens+school+office+supplies+for+women+%26+men%2Caps%2C503&sr=8-2",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "6.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Mr-Sticky-Vintage-Colored-Colorful/dp/B0BKVTPT9C/ref=sr_1_5?dib=eyJ2IjoiMSJ9.aux3V_tWmgqJaRnSCtZxexpfO1Dp1tuhW3EbHRE8MsPka1xgq_CiHQzZgHIpGW_adH3Fktuwrwm3lEs-egiTjbK0P87N9P0hu77BlY41Jhq5wPykhKF8WW7TnPdhIzrK_PgwEtISgPHJpCXvXvIKiZDwRFmOkD-3pofALzMPuQ6PbdvAbvQQks9sIrB6-eHw-RXc-61hEmRdW_boAIGLi0KHiTmrA53bIVmAxOEN78TykhLHNJF4vJMtsOKPbYg_nbt950rpwbV8XgAykJh7CjOuY10OPjciGbwq5pwCHpA.NbLXEZsK_tY807KIcpTO4oU63M1U4OaI3PNzaHU7f-Y&dib_tag=se&keywords=Mr.+Pen-+Sticky+Notes%2C+12+Pads%2C+3%E2%80%9Dx3%E2%80%9D%2C+Vintage+Colors%2C+Sticky+Notes+3x3%2C+Sticky+Note%2C+Sticky+Pads%2C+Sticky+Notes+Bulk%2C+Stick+Notes%2C+Colored+Sticky+Notes%2C+Sticky+Note+Pad%2C+Colorful+Sticky+Notes&qid=1710244717&sr=8-5",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
              ),
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
              fluidRow(
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "5.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Moen-YB8099CH-Toilet-Roller-Chrome/dp/B001DEIG44/ref=sr_1_1_sspa?crid=2GBSOIBI4E4F0&dib=eyJ2IjoiMSJ9.PuzCIN2hUkZqmbALpeLujYEzGf-KpBysjleFxZGEwsozG7S6RxEbuybKP58tgnxB7ru4pg0fTvrXF0r85nzbMwOGeehRfsrg2YusBTUJEJ3NYYnTLcsTyV2YcbiSmK-E1dpHtdZGTasfxfOAdM6O9DtbATVp2Nu-vZoR4hBtb3GmHI7RUJEkV4poXn64jApn7vHaS0R_pKW0-Xa_CxAr4HrGS4xXenTSTCLoJ2GevvI.pSnHSlo7CxSsrUcznUppP-DfzWeCllhu154sXSFAyOM&dib_tag=se&keywords=Moen+YB8099CH+Mason+Toilet+Paper+Roller%2C+Chrome&qid=1710245101&sprefix=moen+yb8099ch+mason+toilet+paper+roller%2C+chrome%2Caps%2C347&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "7.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/KOHLER-4636-RL-0-Cachet-ReadyLatch-Elongated/dp/B0B4X11K31/ref=sr_1_5?crid=SM30K1S2CH90&dib=eyJ2IjoiMSJ9.GhUmdn0vEl4KdwPKVixV_gWI4bJ9NG3ab_ePnvM4rXx-VjYOamnYPJByUwGqNXoO846gSyFa8UR0i2yRwlouhJtfLu9fF7hQEcrtpFDZrjNx50ia-QJxa9uU7tvlo0L_G-TJPTRZCJ9S7WkVXO3VRXFdweh2w3ykDZhmQwsH6adyVrzDk7q1UEpj58TbvETalo_Pu8Lso1rjlS_Kk1UtPW7XYwEkixaR2oFR9gIBMh1eCuFwED3dfg274e2xSHxHbGEb-Cc67IvjlUhpglRzwbPclcctuhwEO2TAPJe3Is4.7GkSPXNzlYjwJRi3fiVU1ZKycQEaJwyeoNJNeku2Hg8&dib_tag=se&keywords=KOHLER+4636-RL-0+Cachet+ReadyLatch+Elongated+Toilet+Seat%2C+Quiet-Close+Lid+and+Seat%2C+Countoured+Seat%2C+Grip-Tight+Bumpers+and+Installation+Hardware%2C+White&qid=1710244957&sprefix=kohler+4636-rl-0+cachet+readylatch+elongated+toilet+seat%2C+quiet-close+lid+and+seat%2C+countoured+seat%2C+grip-tight+bumpers+and+installation+hardware%2C+white%2Caps%2C316&sr=8-5",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "8.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Rubbermaid-Commercial-Plastic-Polypropylene-FG631000WHT/dp/B005KDCMBM/ref=sr_1_1?crid=27E1S7PLTU7GU&dib=eyJ2IjoiMSJ9.Y6FNyrdfwCuHsACMQbRtXAYNtWU4D9zoH4WHKFTtLkZxyJE_AP0HJ-bs3wzIrn_12bCsAwODkoRR2wRHLS85MpliQH3cgDtxtoj2rm9v1GUNoVUbEc1qPldXZE2bbXsEXgJuj2WR12xXOWk0DNSdR6pGGKAD1Lg-eTQfQLwMVffEaESgjLA9s1Njuey42YROMIHXwWZy4F9ut6My870qPt2jhg4QZKlLMFvOYWLe-K0LM_GSnqgeHB6_ah-65bmfYOrxsjBYhBP_gL-ll1GNCPItSpeuo9dHwHbMAgbrR2M.bOFhAq8QuidUaAnsrs4akwxucN7ibi0c6WMkiAJiHzo&dib_tag=se&keywords=Rubbermaid+Commercial+15+Inch+toilet+brush&qid=1710245081&sprefix=rubbermaid+commercial+15+inch+toilet+brush%2Caps%2C422&sr=8-1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "9.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Bathroom-Absorbent-Microfiber-Non-Slip-Machine/dp/B08XZ2KQZR/ref=sr_1_1_sspa?dib=eyJ2IjoiMSJ9.3uRf51H6mHv2r6jC2CeKv8jf6HHKDZcEhb3VHsTAiXzzMglakPNczxojXfDCBqQvMauqQSDmxfqVGimNLrIlRX78LkDlbxmbD9jPbvdVcolDQ_ttPgjkIM2Hdw3TO489XV4Ijc-foT7zYmDSTsQTAiNWa22KpOrqGsgRIsVH60nngzy53p4WeAe_-RaDckXVimGDtmMwVNbSeHmXKV9ehT13OnXAzeB9ofznT6t2EITmV_FT7JyxNHl9FTzGrZATUs5r1ALIwZ1jIKOUpZ3aMR4L3ysM3iKuIYnuaMzsiJc.oP6ONYBs4YOmKTs_bGgoaep3M90dYJaK6vd-VCssNbY&dib_tag=se&keywords=OLANLY+Luxury+Bathroom+Rug+Mat+24x16%2C+Extra+Soft+and+Absorbent+Microfiber+Bath+Rugs%2C+Non-Slip+Plush+Shaggy+Bath+Carpet%2C+Machine+Wash+Dry%2C+Bath+Mats+for+Bathroom+Floor%2C+Tub+and+Shower%2C+Grey&qid=1710244901&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
                box(
                  solidHeader = TRUE,
                  status = "danger",
                  background = "white",
                  width = 4,
                  img(src = "10.png", width = "100%", style = "margin: 0; padding: 0;"),
                  tags$a(href = "https://www.amazon.com/Clorox-Toilet-Plunger-White-Gray/dp/B00P7VW2H6/ref=sr_1_1?dib=eyJ2IjoiMSJ9.RlvKmoc94FKPxL2CDx67Gy4oCCmudcq1-Qu9D1MnXN8.eqS0Pkt6dWgVEwzWNkSGi26Ekq7O8Df4Q9Sx4yIuBnY&dib_tag=se&keywords=Clorox+Toilet+Plunger+with+Hideaway+Storage+Caddy%2C+6.5%E2%80%9D+x+6.5%E2%80%9D+x+19.5%E2%80%9D%2C+White%2FGray&qid=1710244931&sr=8-1",
                         class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
                  style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
                ),
              ),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          )
        ),
        
        #-------------------------Tab Product- Product name ------------------------#
        tabItem(
          tabName = "gallery_product",
          h2("Gallery Product", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            column(12, align = "center",
                   p(HTML("Explore our extensive gallery of products and immerse yourself in a world of choices. &#128248;"))
            )
          ),
          fluidRow(
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "1.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Supplies-Accessories-Stapler-Dispenser-Coworkers/dp/B0CCPNXX4Y/ref=sr_1_1_sspa?crid=3HM4RPLWVMJGU&dib=eyJ2IjoiMSJ9.oKRBmkLNiT5xdouPio_si2xOKacL6PT7O4qab9tjVBlnUZXDQajNp0dnP8qnNc9s9s86LLJIogrXlRseg9529eK3CAouWfQFBZ8CiZg2oEFdTkWxhMLr9ioaZsH1j5iQcigLrIdtOdzrNzwYyIFKUOU7t_j1GqQdiNuOgTFwroT7Mv9LWvhL2fLdZQYQP0paaGjC32dF_j_1sVhxohSVpGvJx-Y3TLY-SK4mzrqaRtV1pr_l8EKFi3jCIw-juVzam1GnXGDKFiFdOjwTAxMGtwqBZZwUl9ISWLp3TmCJRw8.jDzNXKYCb3ZIMzMtiGEg38XQw6vu2ORYab1zyGsb-Bc&dib_tag=se&keywords=Teal+Office+Supplies%2C+Teal+Office+Supplies+and+Accessories%2C+Mint+Green+Stapler+and+Tape+Dispenser+Set+for+Women%2C+Green+Office+Desk+Accessories%2C+Office+Gift+for+Women%2C+Office+Lady%2C+Coworkers&qid=1710244875&sprefix=teal+office+supplies%2C+teal+office+supplies+and+accessories%2C+mint+green+stapler+and+tape+dispenser+set+for+women%2C+green+office+desk+accessories%2C+office+gift+for+women%2C+office+lady%2C+coworkers%2Caps%2C382&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "2.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Amazon-Basics-Stapler-Capacity-Non-Slip/dp/B079ZV4V3C/ref=sr_1_5?dib=eyJ2IjoiMSJ9.uErXibz2Eau072k5SQ4w7IgFzjo79zyAEy1QBW5PaVTP_bwMOF4PMt-gdmsbEc5kLM81HfgT6z06WaDRZ4dAzb9uh5I5NyivWm8cyq55Sd6rNsSlGv6Q3yRzlSO8HQPjWEhZhC6cM87N34X7Z9BTTKSmnG1pY2V8uA58H-JGIig3gG91fItwRHZbWoIdEAnzdKFjxdR0OvzPyLR6Kt7GMl9cMACHsALkTN6bhDuNPqhvuinfSB_INQokqYq6KpIGfnrDu5kOSuI0Wk3ABOORhl6n2NTKFdO-ghaSoROySlI.dG2Jpw5LnovtvVfkNVsNmbaIJcbzBITmWn7l-3Al5b8&dib_tag=se&keywords=Amazon+Basics+Stapler+with+1000+Staples%2C+Office+Stapler%2C+25+Sheet&qid=1710244844&sr=8-5",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "3.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Mr-Folders-Morandi-Colored-Supplies/dp/B0C4PMH7HY/ref=sr_1_1?dib=eyJ2IjoiMSJ9.ObEOgQlTCmxGGZHGL38Bnj3nywpcqEe8vlv6LfcHdcsIbh-yLCzt8wMWTjkJuIjKrQX7Dr-GeaYNuGwNmw13C0zdDpL9dVoLa_qyH7g3t_VJIzejeRlGsnAHt8pjXOeCZq_vcmqxST3hGPBQtiu4NDcex6ARuqbEDtc39_Oo89NgbFxPLhiqMVrSwIIAZqhy6VL_Z1V9Ik3BFCoC3PLG6O7tDR6Xtq18SSqQXLY7AfYRriXzxABW4YLFrrkG7HylCQ2iWkJOWWhaFq1Fo1RpOUK5nenCqzoWG-iratdnbvk.5u4aY1-ugDWFI2g8BaR6GUu59VrTfv73Zuk_c4tH6m8&dib_tag=se&keywords=Mr.%2BPen%2BFile%2BFolders%2C%2B18%2BPack%2C%2BMorandi%2BColors%2C%2B1%2F3-Cut%2BTab%2C%2BLetter%2BSize%2C%2BDurable%2BPaper%2BFolders%2C%2BOffice%2BSupplies&qid=1710244796&sr=8-1&th=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "4.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Drawdart-Retractable-Aesthetic-Journaling-Supplies/dp/B0CGLJCC5Q/ref=sr_1_2?crid=SLNDQNQ233CW&dib=eyJ2IjoiMSJ9.8tUtvYh7UQsCGySnLpVW5nqXFkf8H2XPue0FXGv83iatMZFxpxwKrse3zslEVZgD2DbwaG3iEUWhMmb1bUGZreT3ZtJGlRxgO0IlaBOeFbRN26EWaBNZ_LC-Vq989ywbHdBnEDZ66K53dyT2DgnKTHmyMjHktf0JeafBB_c7mZWmYm8D8ViMcem-ekCvHwbHNO4Jysuq4dkb33laWhrp7Ejp-bDLTHHhFW1olx3ZUH6tTeCBzGenKE0FMXPnzl_l6-dWoCqFywLkGLcVbx28dGCEBXt_Bm2EPLKRWHQR3yA.P1BAR9TejJXutdreY9PUPyHOpxJAyH7LzYEsFb37lNk&dib_tag=se&keywords=Gel+Pens%2C+12+Pcs+Smooth+Writing+Pens+No+Bleed+%26+Smear%2C+Black+Ink+Cute+Pens+Fine+Point+%280.5mm%29%2C+Retractable+Aesthetic+Journaling+Pens+School+Office+Supplies+for+Women+%26+Men&qid=1710244770&sprefix=gel+pens%2C+12+pcs+smooth+writing+pens+no+bleed+%26+smear%2C+black+ink+cute+pens+fine+point+0.5mm+%2C+retractable+aesthetic+journaling+pens+school+office+supplies+for+women+%26+men%2Caps%2C503&sr=8-2",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "5.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Moen-YB8099CH-Toilet-Roller-Chrome/dp/B001DEIG44/ref=sr_1_1_sspa?crid=2GBSOIBI4E4F0&dib=eyJ2IjoiMSJ9.PuzCIN2hUkZqmbALpeLujYEzGf-KpBysjleFxZGEwsozG7S6RxEbuybKP58tgnxB7ru4pg0fTvrXF0r85nzbMwOGeehRfsrg2YusBTUJEJ3NYYnTLcsTyV2YcbiSmK-E1dpHtdZGTasfxfOAdM6O9DtbATVp2Nu-vZoR4hBtb3GmHI7RUJEkV4poXn64jApn7vHaS0R_pKW0-Xa_CxAr4HrGS4xXenTSTCLoJ2GevvI.pSnHSlo7CxSsrUcznUppP-DfzWeCllhu154sXSFAyOM&dib_tag=se&keywords=Moen+YB8099CH+Mason+Toilet+Paper+Roller%2C+Chrome&qid=1710245101&sprefix=moen+yb8099ch+mason+toilet+paper+roller%2C+chrome%2Caps%2C347&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "6.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Mr-Sticky-Vintage-Colored-Colorful/dp/B0BKVTPT9C/ref=sr_1_5?dib=eyJ2IjoiMSJ9.aux3V_tWmgqJaRnSCtZxexpfO1Dp1tuhW3EbHRE8MsPka1xgq_CiHQzZgHIpGW_adH3Fktuwrwm3lEs-egiTjbK0P87N9P0hu77BlY41Jhq5wPykhKF8WW7TnPdhIzrK_PgwEtISgPHJpCXvXvIKiZDwRFmOkD-3pofALzMPuQ6PbdvAbvQQks9sIrB6-eHw-RXc-61hEmRdW_boAIGLi0KHiTmrA53bIVmAxOEN78TykhLHNJF4vJMtsOKPbYg_nbt950rpwbV8XgAykJh7CjOuY10OPjciGbwq5pwCHpA.NbLXEZsK_tY807KIcpTO4oU63M1U4OaI3PNzaHU7f-Y&dib_tag=se&keywords=Mr.+Pen-+Sticky+Notes%2C+12+Pads%2C+3%E2%80%9Dx3%E2%80%9D%2C+Vintage+Colors%2C+Sticky+Notes+3x3%2C+Sticky+Note%2C+Sticky+Pads%2C+Sticky+Notes+Bulk%2C+Stick+Notes%2C+Colored+Sticky+Notes%2C+Sticky+Note+Pad%2C+Colorful+Sticky+Notes&qid=1710244717&sr=8-5",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "7.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/KOHLER-4636-RL-0-Cachet-ReadyLatch-Elongated/dp/B0B4X11K31/ref=sr_1_5?crid=SM30K1S2CH90&dib=eyJ2IjoiMSJ9.GhUmdn0vEl4KdwPKVixV_gWI4bJ9NG3ab_ePnvM4rXx-VjYOamnYPJByUwGqNXoO846gSyFa8UR0i2yRwlouhJtfLu9fF7hQEcrtpFDZrjNx50ia-QJxa9uU7tvlo0L_G-TJPTRZCJ9S7WkVXO3VRXFdweh2w3ykDZhmQwsH6adyVrzDk7q1UEpj58TbvETalo_Pu8Lso1rjlS_Kk1UtPW7XYwEkixaR2oFR9gIBMh1eCuFwED3dfg274e2xSHxHbGEb-Cc67IvjlUhpglRzwbPclcctuhwEO2TAPJe3Is4.7GkSPXNzlYjwJRi3fiVU1ZKycQEaJwyeoNJNeku2Hg8&dib_tag=se&keywords=KOHLER+4636-RL-0+Cachet+ReadyLatch+Elongated+Toilet+Seat%2C+Quiet-Close+Lid+and+Seat%2C+Countoured+Seat%2C+Grip-Tight+Bumpers+and+Installation+Hardware%2C+White&qid=1710244957&sprefix=kohler+4636-rl-0+cachet+readylatch+elongated+toilet+seat%2C+quiet-close+lid+and+seat%2C+countoured+seat%2C+grip-tight+bumpers+and+installation+hardware%2C+white%2Caps%2C316&sr=8-5",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "8.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Rubbermaid-Commercial-Plastic-Polypropylene-FG631000WHT/dp/B005KDCMBM/ref=sr_1_1?crid=27E1S7PLTU7GU&dib=eyJ2IjoiMSJ9.Y6FNyrdfwCuHsACMQbRtXAYNtWU4D9zoH4WHKFTtLkZxyJE_AP0HJ-bs3wzIrn_12bCsAwODkoRR2wRHLS85MpliQH3cgDtxtoj2rm9v1GUNoVUbEc1qPldXZE2bbXsEXgJuj2WR12xXOWk0DNSdR6pGGKAD1Lg-eTQfQLwMVffEaESgjLA9s1Njuey42YROMIHXwWZy4F9ut6My870qPt2jhg4QZKlLMFvOYWLe-K0LM_GSnqgeHB6_ah-65bmfYOrxsjBYhBP_gL-ll1GNCPItSpeuo9dHwHbMAgbrR2M.bOFhAq8QuidUaAnsrs4akwxucN7ibi0c6WMkiAJiHzo&dib_tag=se&keywords=Rubbermaid+Commercial+15+Inch+toilet+brush&qid=1710245081&sprefix=rubbermaid+commercial+15+inch+toilet+brush%2Caps%2C422&sr=8-1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "9.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Bathroom-Absorbent-Microfiber-Non-Slip-Machine/dp/B08XZ2KQZR/ref=sr_1_1_sspa?dib=eyJ2IjoiMSJ9.3uRf51H6mHv2r6jC2CeKv8jf6HHKDZcEhb3VHsTAiXzzMglakPNczxojXfDCBqQvMauqQSDmxfqVGimNLrIlRX78LkDlbxmbD9jPbvdVcolDQ_ttPgjkIM2Hdw3TO489XV4Ijc-foT7zYmDSTsQTAiNWa22KpOrqGsgRIsVH60nngzy53p4WeAe_-RaDckXVimGDtmMwVNbSeHmXKV9ehT13OnXAzeB9ofznT6t2EITmV_FT7JyxNHl9FTzGrZATUs5r1ALIwZ1jIKOUpZ3aMR4L3ysM3iKuIYnuaMzsiJc.oP6ONYBs4YOmKTs_bGgoaep3M90dYJaK6vd-VCssNbY&dib_tag=se&keywords=OLANLY+Luxury+Bathroom+Rug+Mat+24x16%2C+Extra+Soft+and+Absorbent+Microfiber+Bath+Rugs%2C+Non-Slip+Plush+Shaggy+Bath+Carpet%2C+Machine+Wash+Dry%2C+Bath+Mats+for+Bathroom+Floor%2C+Tub+and+Shower%2C+Grey&qid=1710244901&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "10.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Clorox-Toilet-Plunger-White-Gray/dp/B00P7VW2H6/ref=sr_1_1?dib=eyJ2IjoiMSJ9.RlvKmoc94FKPxL2CDx67Gy4oCCmudcq1-Qu9D1MnXN8.eqS0Pkt6dWgVEwzWNkSGi26Ekq7O8Df4Q9Sx4yIuBnY&dib_tag=se&keywords=Clorox+Toilet+Plunger+with+Hideaway+Storage+Caddy%2C+6.5%E2%80%9D+x+6.5%E2%80%9D+x+19.5%E2%80%9D%2C+White%2FGray&qid=1710244931&sr=8-1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "11.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/dp/B091Z36D56/ref=twister_B0B65CDMXF?_encoding=UTF8&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "12.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Ocean-Bottle-Eco-Friendly-Stainless-Dishwasher/dp/B08LMDYSFT/ref=sr_1_2_sspa?crid=2Z1ICKF5UMJI3&dib=eyJ2IjoiMSJ9.Ih4x1_CAXuqklXOWIRuwr2odIiHQr0w-WiOdpWiKgcFUhPGVq-imQUL_CbIPoezTbztu8ZmQ37x5zQ8Ze0oAurdaf2jRRP9zrj6H7Nuk6-Gt0DYEuRjVavqwkwyDWVrMYOOBOVGcchaOv39uimgZZ0CfyqXOJNYaMROzhChZbCrrzbN2inTLPVAVLExx8HLvsM1YbFl8kOl7OxpG6Ho9ndrdykvq2jWqIHIX28OtYJjbmZowVSLyUeuPXMMG0yZYmFvkIaZY5Wi2GBmgNgAOcpvUY2Tq0EIZ95tATZnWZZw.7v0jPgdp8r7aP4-6sMuzCYG_NzJ08WIeA1rVfB_Bsww&dib_tag=se&keywords=bottle&qid=1710244052&sprefix=bo%2Caps%2C1726&sr=8-2-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "13.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Insulated-Stainless-Bottles-Leakproof-Toddler/dp/B0C5RD84XV/ref=sr_1_3?crid=2Z7INDYX7KAY5&dib=eyJ2IjoiMSJ9.EfowUEdUBG31DO6okHg1d50fAiixdhhZYTKroH2_hwMDKQX32Ct6GHpjYFClTHYszvkfn1POqai_l3JVyKb4IXw6jLexhIy1BDZsLCkNgTfs9BZ_oeVQr0vKcPn6raSWcRqJQI_82QJ8WsHhPoWN6XSt2vRRnWzhzpTKwf8Ntez5cMurBfQYJ7ZE9nJVmqfnD_wHI4FT3ixMNsRw9gc5UozRbvncm_8ORI1W9jfaQRxPvpyVBppDz4L09_qh469kOVneYvp3Ey9m1-rJHWwhEdIRsto58q4P_8BAwMQGsDA.aJ_Dc4EWQIEo3tU0wXyg_VbtUBA1SN1eWru1xcGwm0A&dib_tag=se&keywords=kids%2Bwater%2Bbottle%2B14%2Boz%2Bpattern&qid=1710244382&sprefix=kids%2Bwater%2Bbottle%2B14%2Boz%2Bpatter%2Caps%2C732&sr=8-3&th=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "14.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Mdkave-Capacity-%EF%BC%8CMultiple-Pockets-Markings/dp/B0CCXSYMG3/ref=sr_1_1?dib=eyJ2IjoiMSJ9._6zmPlu4GspmszUjnhfpXGNGXnTvCuJG75ztsyX4KN7pLgU-9XFVUSEK3Vs_RSFc_l06ZhtsEmn9U7IpX0jbKXseYf1PP_QcMI0Zk_f_QwwXgjeoyXNH-VsaJInRcc66NDKUeGdD-9SPNPN2ricYy42znBF0dIsK25aEfETPorPr0nFFpxSMP12TazpFvfiO39_c_ujjG-gioUaYfwqfIcwbpRTtHo7u8EkOhpYwsoe-DUvQxqQie0gLkHk6R_vLISkzWsl1SCbIsOk0u4e-toecNNPdPSdLdsQ1jP9SlkY.CzYMb3RRYb9TEZG7hZbBmB2FeFN3ef_Royfpeud_z_g&dib_tag=se&keywords=64+oz+Water+Bottle%2C+1%2F2+Gallon+Water+Bottle%2C+Water+Bottle+Holder+with+Shoulder+Strap%2C+Time+Motivational+Water+Bottle+-+Great+for+Camping%2C+Gym+and+Outdoor+Activities%2C+Gift&qid=1710243781&sr=8-1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "15.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/bubba-Refresh-Insulated-Bottle-TEAL/dp/B0CB216JQY/ref=sr_1_44?dib=eyJ2IjoiMSJ9.14Q8SYoaYv52isn5bz2zp_0F8lv7WAsVFXlfQBg03dEZ9b1VTrqRLtKdN5-GafTXUUoAQOhS0xuWh45JTJBpGO0hYKE2ds6NydcSYqY-6HwEdmmT6tI-AO1w2IMIcJktchw2pxYnMOU9wfYLNTVB8Z4LOsBdiqlJzmE3YRelrQwdooXPDD8JtZzRCb4rTbAC7J09znBU1vZ5rYSHvKuUV340-_-kQOzDt5l56UxvDKb5U18ox0ctylbRx4FMUgOP41nO34qbxih9hOqBiKVoLp-dVjcQP8lTSCbMicsrvHY.JObR27so8-L9ArJJa8DTnzMcRGquSsAcvYRhRVI4TVE&dib_tag=se&keywords=bubba%2Bwater%2Bbottles&qid=1710243700&sr=8-44&th=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "16.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/yageyan-Classic-Sneakers-Fashion-black11/dp/B09W57RPXB/ref=sr_1_1_sspa?crid=179LB9OR74BAC&dib=eyJ2IjoiMSJ9.9TmagZJyF-tV6f8Mc3S2tgSWXYphRZ445k4UbS6Sh6udoc2vostRK1d9KClrVR-Ozz9watuXtRH2lP3sy7PZXEIfrtjebClNb4cwDKFWzeZ_uz5oYJKEgwx0GGFtTXu6qrl2UiFi9UlT-wZBrBcEKJ7eAwpow09HsemMwwBgeIhZDEbkCN2LNULcdiJWIcq-OCO3UBkmgvDs4CKYe-xNhXu8UmxGzsMyplKJd_9AcLw.ctyv1mdxCNZe9L3QRorq50AfLqnCEmqnIw-0FIq4nJs&dib_tag=se&keywords=yageyan+Men+Canvas+Low+top+Shoes+Classic+Casual+Sneakers+Black+and+White+Fashion+Shoes&qid=1710244684&sprefix=yageyan+men+canvas+low+top+shoes+classic+casual+sneakers+black+and+white+fashion+shoes%2Caps%2C709&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "17.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Dokotoo-Men-Sweatshirts-Geometric-Pullover/dp/B0C9ZVSXLY/ref=sr_1_1_sspa?dib=eyJ2IjoiMSJ9.fzSJE6dtbbnrbnFHdxXI0k-qwiG9uMwuYDueXmuO18MQd8w4xjdRPmxwzkRcpew3TGe1sOPTUhmwn--6q-mgJr7pBm-Ek0idYs1YsAlKCfo.g4BdbO8psTNskJBJg48V5s_SrHG19vW7P5IJZFgoU-Y&dib_tag=se&keywords=Men%27s+Crewneck+Sweatshirts+Soild+Color+Geometric+Texture+Long+Sleeve+Casual+Pullover+Shirt&qid=1710244647&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "18.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Trendy-Queen-Oversized-Sweatshirts-Turtleneck/dp/B0C5RFPCWK/ref=sr_1_2?crid=HF4HA55C8V0G&dib=eyJ2IjoiMSJ9.ra5EbfipI6ZsHNWNipsBARsPfCQi5-B-_sG5ciia0xM3Rt9WITWLzam2OIPTn_nPiuaH9a37P-0YAuZ48DvTzI4KRHeoUrfJN4o9v7BwkcW91xkqJUuXrkR32XFKRlA7pDTdtHqiNCj5BG749IrUmDjlfEpYAeNVPniD8RCb9DIAVenKP1TtMg47ZppMPWih5kUHPyanfvRob9zlzZJxbcP-3nqhxyIGD92QwbQg_tc.da8Tl2V6c5e2cPeFy8lJBQ_Rja6QRFUtDasMflfCtRw&dib_tag=se&keywords=Trendy+Queen+Womens+Oversized+Sweatshirts+Turtleneck+Pullover+Long+Sleeve+Hoodies+Tops+Fall+Outfits+2023+Clothes&qid=1710244600&sprefix=dokotoo+tops+for+women+trendy+summer+casual+cap+short+sleeve+basic+textured+solid+color+round+neck+t+shirts+blouse%2Caps%2C448&sr=8-2",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "19.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/Trendy-Queen-Oversized-Sweatshirts-Turtleneck/dp/B0C5RFPCWK/ref=sr_1_2?crid=HF4HA55C8V0G&dib=eyJ2IjoiMSJ9.ra5EbfipI6ZsHNWNipsBARsPfCQi5-B-_sG5ciia0xM3Rt9WITWLzam2OIPTn_nPiuaH9a37P-0YAuZ48DvTzI4KRHeoUrfJN4o9v7BwkcW91xkqJUuXrkR32XFKRlA7pDTdtHqiNCj5BG749IrUmDjlfEpYAeNVPniD8RCb9DIAVenKP1TtMg47ZppMPWih5kUHPyanfvRob9zlzZJxbcP-3nqhxyIGD92QwbQg_tc.da8Tl2V6c5e2cPeFy8lJBQ_Rja6QRFUtDasMflfCtRw&dib_tag=se&keywords=Trendy+Queen+Womens+Oversized+Sweatshirts+Turtleneck+Pullover+Long+Sleeve+Hoodies+Tops+Fall+Outfits+2023+Clothes&qid=1710244600&sprefix=dokotoo+tops+for+women+trendy+summer+casual+cap+short+sleeve+basic+textured+solid+color+round+neck+t+shirts+blouse%2Caps%2C448&sr=8-2",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 3,
              img(src = "20.png", width = "100%", style = "margin: 0; padding: 0;"),
              tags$a(href = "https://www.amazon.com/ANRABESS-Sleeveless-Matching-Loungewear-546Hulv-S/dp/B0BPMKV4RW/ref=sr_1_2_sspa?crid=2437BF1RVQCQ7&dib=eyJ2IjoiMSJ9.5_fqEJFpA3WkE_y4JPJ7s-TVO0sRSwaQaxHAzFYrzi6rUMTEJaEGRsIZZ9yCJYk1HKpE_t40ch73btizsNw3VCJjys_WzWenZ2pMjOzOP9_nnqlvR7C35hBieKdt5mx_CZTRCdAKjP-t27wJxMLSZFLMc0Z7TdZEVbv1L3YwKfuv177Rvwis2qvNg4OYWhtGEv0UrS8SrWCUE9QmUIgizA.I1CMGhBegT0aK3oFNhY0EqjZ04rpKwACuFDEhg_Axjg&dib_tag=se&keywords=ANRABESS+Women%27s+Summer+2+Piece+Outfits+Sleeveless+Tank+Crop+Button+Back+Top+Capri+Wide+Leg+Pants+Linen+Set+with+Pockets&qid=1710244509&sprefix=anrabess+women%27s+summer+2+piece+outfits+sleeveless+tank+crop+button+back+top+capri+wide+leg+pants+linen+set+with+pockets%2Caps%2C600&sr=8-2-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&psc=1",
                     class = "btn btn-block", role = "button", "BUY", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "GALLERY PRODUCT",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              tableOutput("out_tbl2"),
              width = 12,
              status = "primary"
            )
          )
        ),
        
        
        #-------------------------Tab Transactions ------------------------#
        tabItem(
          tabName = "transactions",
          h2("Summary Information", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            column(12, align = "center",
                   p(HTML("Choose from a variety of options below to view detailed summaries. &#128075;"))
            )
          ),
          fluidRow(
            valueBox(
              value = length(data$CustomerID),
              subtitle = "Total Customers", 
              icon = icon("users", lib = "font-awesome"), 
              color = "primary", 
              width = 3,
              href = "#customer_details"  # Link to customer details section
            ),
            valueBox(
              value = nrow(data),
              subtitle = "Total Transactions", 
              icon = icon("shopping-cart", lib = "font-awesome"), 
              color = "danger", 
              width = 3,
              href = "#transaction_details"  # Link to transaction details section
            ),
            valueBox(
              value = sum(data$Quantity),
              subtitle = "Total Items Sold", 
              icon = icon("box", lib = "font-awesome"), 
              color = "primary", 
              href = "#items_sold_details" 
            ), 
            valueBox(
              value = sum(data$Total_Price),
              subtitle = "Total Revenue", 
              icon = icon("dollar-sign", lib = "font-awesome"),
              color = "danger", 
              width = 3,
              href = "#revenue_details"   
            )
          ),
          h2("Search Transaction", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            column(12, align = "center",
                   p(HTML("Use the filters below to search for specific transactions. &#11088;"))
            )
          ),
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
            box(title = "filter results", status = "danger",
                  dataTableOutput("out_tbl4"),
                  width = 12
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
            box(title = "filter results", status = "danger",
                dataTableOutput("out_tbl5"),
                width = 12
            ),
          ),
          fluidRow(
            # Display tabel 
            box(
              title = "Transaction",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              tableOutput("out_tbl1"),
              width = 12,
              status = "primary"
            )
          )
        ),
        
        #-------------------------Tab Voucher ------------------------#
        tabItem(
          tabName = "vouchers",
          h2("Search Product Based On Voucher", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            # Filter product
            box(
              title = "Choose Voucher you want to apply",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              tags$p("Choose Voucher you want to apply"),
              tags$br(),
              uiOutput("filter_voucher1"),
              width = 12,
              status = "primary"
            )
          ),
          fluidRow(
            # Display tabel
            box(
              title = "Voucher",
              background = "danger",  # Mengubah warna latar belakang box
              solidHeader = TRUE,
              tableOutput("out_tbl3"),
              width = 12,
              status = "primary"
            )
          )
        ),
        
        #--------------------------Tab Our Team -------------------------
        tabItem(
          tabName = "our_team",
          h2("Our Team!!!", align = "center", style = "color: #FF6A6A; font-size: 36px; font-weight: bold; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);"), # Menambahkan judul tab
          fluidRow(
            column(12, align = "center",
                   p(HTML("If you have any questions, our dedicated team is here to help. &#128515;"))
            )
          ),
          fluidRow(
            box(
              title = p(HTML("Database Manager &#128525;")),
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/TASYA.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$a(href = "https://www.instagram.com/tasya.anisah/",
                     class = "btn btn-block", role = "button", "Instagram", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              tags$a(href = "https://github.com/tasyaanisahrizqi",
                     class = "btn btn-block", role = "button", "GitHub", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          ),
          fluidRow(
            box(
              title = p(HTML("Backend Developer &#129488;")),
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/YUDHIT.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$a(href = "https://www.instagram.com/_ydth_",
                     class = "btn btn-block", role = "button", "Instagram", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              tags$a(href = "https://github.com/yudheeeeet",
                     class = "btn btn-block", role = "button", "GitHub", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          ),
          fluidRow(
            box(
              title = p(HTML("Technical Writer &#128150;")),
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/YUNNA.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$a(href = "https://www.instagram.com/yunnamentari/",
                     class = "btn btn-block", role = "button", "Instagram", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              tags$a(href = "https://github.com/yunnamentari",
                     class = "btn btn-block", role = "button", "GitHub", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
          ),
          fluidRow(
            box(
              title = p(HTML("Frontend Developer &#x1F338;")),
              solidHeader = TRUE,
              status = "danger",
              background = "white",
              width = 12,
              collapsible = TRUE,
              collapsed = TRUE,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/HUS.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$a(href = "https://www.instagram.com/huuuuuuuss/",
                     class = "btn btn-block", role = "button", "Instagram", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              tags$a(href = "https://github.com/hhyuss",
                     class = "btn btn-block", role = "button", "GitHub", style = "font-weight:bold; background-color:#4876FF; color: #FFFFFF;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            )
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
              background = "white",
              width = 4,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/pay1.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$p("We accept all major credit and debit cards",
                     style = "font-size:17px; color: #283593; text-align: justify;"),
              style = "border-radius: 10px; background-color: #FFFFFF; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            
            box(
              title = div("Digital Wallets", style = "font-weight: bold; text-align: center;"),
              solidHeader = TRUE,
              status = "primary",
              background = "warning",
              width = 4,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/pay2.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$p("Use popular digital wallets like Apple Pay, Google Pay, and Samsung Pay.",
                     style = "font-size:17px; color: #283593; text-align: justify;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
            ),
            box(
              title = div("Paypal", style = "font-weight: bold; text-align: center;"),
              solidHeader = TRUE,
              status = "primary",
              background = "warning",
              width = 4,
              img(src = "https://raw.githubusercontent.com/yudheeeeet/mdskel4/main/Image/pay3.png", width = "100%", style = "margin-bottom: 20px;"),
              tags$p("Securely pay with your PayPal account",
                     style = "font-size:17px; color: #283593F; text-align: justify;"),
              style = "border-radius: 10px; background-color: #FFffff; box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);"
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
    
    #-----------------FOOTER-----------------#
    
    footer = dashboardFooter(
      right = "© 2024 Kelompok 4 | All Rights Reserved",
      left = "Made with ❤️ by Kelompok 4"
      
    )
  )
)

library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(RPostgreSQL)
library(DBI)
library(DT)
library(bs4Dash)
library(dplyr)
library(fontawesome)

#=========================== Interface (Front-End) ============================#

fluidPage (
  dashboardPage (
    
    #--------------HEADER-----------------#
    header = dashboardHeader(
      title = span(img(src="https://raw.githubusercontent.com/rahmiandr/kelompok3_MDS/main/image/logobaru.png",
                       height = 35))
    ),
    #------------SIDEBAR-----------------#
    sidebar = dashboardSidebar(
      collapsed = TRUE,
      sidebarMenu(
        menuItem(
          text = "Dashboard",
          tabName = "dashboard",
          icon = icon("dashboard")
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
          text = "Products",
          tabName = "products",
          icon = icon("product-hunt")
        )
      )
    ),
    #-----------------BODY-----------------#
    body = dashboardBody(
      tabItems(
        #-------------------------Tab Beranda-------------------------#
        tabItem(
          tabName = "b=beranda",
          jumbotron(
            title = span("SIGMARIA MARKET1",style = "font-size:46px;font-weight:bold;"),
            lead = "Selamat Datang di Sigmaria Market Database!", 
            span("Sigmaria Market adalah sebuah platform yang menyediakan informasi lengkap tentang transaksi penjualan, produk yang tersedia, metode pembayaran yang digunakan, voucher yang tersedia, dan data pelanggan. Platform ini memungkinkan pengguna untuk menjelajahi dan memperoleh berbagai produk yang tersedia di Sigmaria Market. Dengan berbagai macam produk dan informasi tentang transaksi yang tercatat, Sigmaria Market menyajikan informasi terkini mengenai aktivitas pasar yang dapat membantu pengguna dalam melakukan pembelian yang diinginkan. Selain itu, platform ini juga menyediakan rekomendasi product yang sesuai untuk customer. ",
                 style = "font-size:20px;text-align:justify;"),
            status = "info",
            href = "https://www.sigmariamarker.com/"
          ),
          tags$h2("Panduan"),
          tags$p("Arahkan kursor ke sisi kiri layar atau klik ikon garis tiga pada sisi pojok kanan atas untuk mengakses bilah sisi (side bar). 
                 Empat fitur utama pada Sigmaria Market adalah sebagai berikut,"),
          tags$ol(
            tags$li("Cari Transaksi"),
            tags$p("Gunakan fitur pencarian transaksi untuk menemukan transaksi berdasarkan kriteria tertentu seperti tanggal, jumlah, atau jenis transaksi. Anda dapat menggunakan filter untuk menemukan transaksi yang relevan dengan kebutuhan Anda."),
            tags$br(),
            tags$li("Cari Produk"),
            tags$p("Manfaatkan fitur pencarian produk untuk menelusuri produk yang tersedia di Sigmaria Market. Anda dapat menggunakan filter untuk mencari produk berdasarkan kategori, harga, atau stok yang tersedia."),
            tags$br(),
            tags$li("Cari Metode Pembayaran"),
            tags$p("Telusuri berbagai metode pembayaran yang tersedia di Sigmaria Market. Anda dapat menemukan informasi tentang metode pembayaran yang diterima serta mengakses detail terkait dengan setiap metode pembayaran."),
            tags$br(),
            tags$li("Cari Voucher"),
            tags$p("Temukan berbagai voucher dan penawaran spesial yang tersedia di Sigmaria Market. Gunakan fitur pencarian untuk menelusuri voucher berdasarkan kategori, diskon, atau masa berlaku."),
            tags$br(),
            tags$li("Cari Pelanggan"),
            tags$p("Jelajahi data pelanggan Sigmaria Market untuk mendapatkan wawasan tentang profil pelanggan dan aktivitas mereka. Anda dapat menemukan informasi tentang pelanggan berdasarkan kriteria seperti jenis kelamin, lokasi, atau riwayat transaksi.")
          ), 
          tags$h2("Info Pengembang Situs"),
          tags$p("Situs ini merupakan projek praktikum kelompok mata kuliah Manajemen Data Statistika (STA1582) dari Program Statistika dan Sains Data Pascasarjana IPB University.
                 Tim pengembang situs adalah sebagai berikut,"),
          tags$ul(
            tags$li("Tasya sebagai Database Manager"),
            tags$li("Uswatun Hasanah sebagai Frontend Developer"),
            tags$li("Rahmat YUdit sebagai Backend Developer"),
            tags$li("Yunna Mentari sebagai Technical Writer")
          ),
          tags$p("Info lebih lanjut mengenai projek database ini dapat diakses di github pengembang."),
          tags$a(href="https://github.com/yudheeeeet/mdskel4", "link github")
        ),
        
        #--------------------------Tab Transaksi--------------------------#
        tabItem(
          tabName = "transactions",
          fluidRow(
            tags$h1("Pencarian Transaksi"),
          ),
          fluidRow(
            # Filter tanggal transaksi
            box(
              tags$h3("Filter Tanggal"),
              tags$p("Pilih rentang tanggal transaksi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_date"),
              width = 4
            ),
            # Filter jumlah transaksi
            box(
              tags$h3("Filter Jumlah Transaksi"),
              tags$p("Pilih rentang jumlah transaksi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_quantity"),
              width = 4
            ),
            # Filter jenis transaksi
            box(
              tags$h3("Filter Jenis Transaksi"),
              tags$p("Pilih jenis transaksi yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_type"),
              width = 4
            )
          ),
          fluidRow(
            # Display tabel transaksi
            box(
              tags$h3("Tabel Transaksi"),
              dataTableOutput("transaction_table"),
              width = 12
            )
          )
        ),
        
        #-------------------------Tab Produk-------------------------#
        tabItem(
          tabName = "products",
          fluidRow(
            tags$h1("Pencarian Produk"),
          ),
          fluidRow(
            # Filter kategori produk
            box(
              tags$h3("Filter Kategori"),
              tags$p("Pilih kategori produk yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_category"),
              width = 4
            ),
            # Filter harga produk
            box(
              tags$h3("Filter Harga"),
              tags$p("Pilih rentang harga produk yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_price"),
              width = 4
            ),
            # Filter stok produk
            box(
              tags$h3("Filter Stok"),
              tags$p("Pilih rentang stok produk yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_stock"),
              width = 4
            )
          ),
          fluidRow(
            # Display tabel produk
            box(
              tags$h3("Tabel Produk"),
              dataTableOutput("product_table"),
              width = 12
            )
          )
        ),
        
        #-------------------------Tab Metode Pembayaran-------------------------#
        tabItem(
          tabName = "payment_methods",
          fluidRow(
            tags$h1("Pencarian Metode Pembayaran"),
          ),
          fluidRow(
            # Filter metode pembayaran
            box(
              tags$h3("Filter Metode Pembayaran"),
              tags$p("Pilih metode pembayaran yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_payment_method"),
              width = 6
            ),
            # Filter jumlah transaksi untuk metode pembayaran
            box(
              tags$h3("Filter Jumlah Transaksi"),
              tags$p("Pilih rentang jumlah transaksi untuk metode pembayaran yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_payment_method_quantity"),
              width = 6
            )
          ),
          fluidRow(
            # Display tabel metode pembayaran
            box(
              tags$h3("Tabel Metode Pembayaran"),
              dataTableOutput("payment_method_table"),
              width = 12
            )
          )
        ),
        
        #-------------------------Tab Voucher-------------------------#
        tabItem(
          tabName = "vouchers",
          fluidRow(
            tags$h1("Pencarian Voucher"),
          ),
          fluidRow(
            # Filter diskon voucher
            box(
              tags$h3("Filter Diskon"),
              tags$p("Pilih rentang diskon voucher yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_discount"),
              width = 6
            ),
            # Filter masa berlaku voucher
            box(
              tags$h3("Filter Masa Berlaku"),
              tags$p("Pilih rentang masa berlaku voucher yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_expiry"),
              width = 6
            )
          ),
          fluidRow(
            # Display tabel voucher
            box(
              tags$h3("Tabel Voucher"),
              dataTableOutput("voucher_table"),
              width = 12
            )
          )
        ),
        
        #-------------------------Tab Pelanggan-------------------------#
        tabItem(
          tabName = "customers",
          fluidRow(
            tags$h1("Pencarian Pelanggan"),
          ),
          fluidRow(
            # Filter usia pelanggan
            box(
              tags$h3("Filter Usia"),
              tags$p("Pilih rentang usia pelanggan yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_age"),
              width = 6
            ),
            # Filter gender pelanggan
            box(
              tags$h3("Filter Gender"),
              tags$p("Pilih gender pelanggan yang ingin ditampilkan"),
              tags$br(),
              uiOutput("filter_gender"),
              width = 6
            )
          ),
          fluidRow(
            # Display tabel pelanggan
            box(
              tags$h3("Tabel Pelanggan"),
              dataTableOutput("customer_table"),
              width = 12
            )
          )
        ),
        
        #-----------------FOOTER-----------------#
        footer = dashboardFooter(
          left = "by Kelompok 4",
          right = "Bogor, 2024"
        )
      )
    )
  )
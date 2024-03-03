library(shiny)
library(tidyverse)
library(shinydashboard)
library(rvest)
library(DT)
library(plotly)

ui<-fluidPage( 
  dashboardPage( skin = "yellow",
                 dashboardHeader(title = "Informasi Virus Korona", titleWidth = 650),
                 dashboardSidebar(
                   sidebarMenu(id = 'sidebarmenu',
                               # first menu item
                               menuItem("Apa Itu Virus Korona?", tabName = "penjelasan1", icon = icon("question-circle")),
                               # second menu item with 2 sub menus
                               menuItem('chart',
                                        menuSubItem('Sebaran di Indonesia',
                                                    tabName = 'chart1',
                                                    icon = icon('line-chart')),
                                        menuSubItem('Sebaran di Dunia',
                                                    tabName = 'chart2',
                                                    icon = icon('line-chart'))),
                               menuItem("Database", tabName = "db", icon = icon("database"))
                   )),
                 dashboardBody(
                   tabItems(
                     tabItem("penjelasan1", h4("Coronavirus atau virus corona merupakan keluarga besar virus yang menyebabkan infeksi saluran pernapasan atas ringan hingga sedang, seperti penyakit flu. Banyak orang terinfeksi virus ini, setidaknya satu kali dalam hidupnya.")),
                     tabItem(tabName = "chart1",
                             # First Row
                             fluidRow(box(title = "Perbandingan Kasus positif dan Meninggal", plotlyOutput("plot1", height = 250), width = 12),
                                      box(title = "Perbandingan Kasus Korona Beberapa Negara", plotlyOutput("plot2", height = 250),
                                          width=6, solidHeader = F),
                                      box(title = "Hubungan Kasus Positif dan Meninggal", plotlyOutput("plot3", height = 250)
                                      ))),
                     tabItem(tabName = "chart2",
                             # First Row
                             fluidRow(box(title = "Box with a plot", plotlyOutput("plot4", height = 450)), width = 12)),
                     tabItem(tabName = "db",
                             # First Row
                             fluidRow(tabBox(id="tabchart1",
                                             tabPanel("World",DT::dataTableOutput("Tab1", height = "450px"), width = 9),
                                             tabPanel("Indonesia",DT::dataTableOutput("Tab2", height = "450px"), width = 9), width = 12)))
                   ))))

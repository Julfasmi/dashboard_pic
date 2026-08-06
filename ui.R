# UI ==========
ui <- fluidPage(
  titlePanel("Dashboard Persebaran Mitra by Cluster"),

  tabsetPanel(
    # TAB DASHBOARD =====
    tabPanel(
      "Dashboard",

      br(),

      sidebarLayout(
        sidebarPanel(
          selectInput(
            inputId = "Kanwil",
            label = "Kanwil",
            choices = c("Semua", sort(unique(df_plot$Kanwil))),
            selected = "Semua"
          ),

          uiOutput("Kancab_ui"),

          uiOutput("Cluster_ui"),

          textInput(
            inputId = "mitra",
            label = "Cari Rekanan",
            value = ""
          )
        ),

        mainPanel(
          fluidRow(
            column(
              3,
              wellPanel(
                h4("Jumlah Mitra"),
                textOutput("total_mitra")
              )
            ),

            column(
              3,
              wellPanel(
                h4("Jumlah Kancab"),
                textOutput("total_kancab")
              )
            ),

            column(
              3,
              wellPanel(
                h4("Jumlah Kanwil"),
                textOutput("total_kanwil")
              )
            ),

            column(
              3,
              wellPanel(
                h4("Jumlah Cluster"),
                textOutput("total_cluster")
              )
            )
          ),

          br(),

          plotlyOutput(
            "map",
            height = "650px"
          )
        )
      )
    ),

    # TAB DATA =====
    tabPanel(
      "Data",

      br(),

      fluidRow(
        column(
          width = 3,

          downloadButton(
            outputId = "download_excel",
            label = "Download Excel",
            width = "100%"
          )
        )
      ),

      br(),

      DTOutput("tabel")
    )
  )
)

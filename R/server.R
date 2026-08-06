# PACKAGES ==========
library(shiny)
library(ggplot2)
library(tidygeocoder)
library(plotly)
library(DT)
library(gt)
library(tidyr)
library(purrr)
library(readxl)
library(dplyr)
library(stringr)
library(geosphere)
library(openxlsx)

# data.valid <- read.xlsx(FILE_VALID)

# hasil.cluster <- read.xlsx(FILE_CLUSTER)

# jumlah.pic <- read.xlsx(FILE_SUMMARY)

# SERVER ==========
server <- function(input, output, session) {
  ## FILTER KANCAB =====
  output$Kancab_ui <- renderUI({
    data_tmp <- df_plot

    if (input$Kanwil != "Semua") {
      data_tmp <- data_tmp %>%
        filter(Kanwil == input$Kanwil)
    }

    selectInput(
      inputId = "Kancab",

      label = "Kancab",

      choices = c(
        "Semua",
        sort(unique(data_tmp$Kancab))
      ),

      selected = "Semua"
    )
  })

  ## FILTER CLUSTER =====
  output$Cluster_ui <- renderUI({
    data_tmp <- df_plot

    if (input$Kanwil != "Semua") {
      data_tmp <- data_tmp %>%
        filter(Kanwil == input$Kanwil)
    }

    if (!is.null(input$Kancab)) {
      if (input$Kancab != "Semua") {
        data_tmp <- data_tmp %>%
          filter(Kancab == input$Kancab)
      }
    }

    selectInput(
      inputId = "Cluster",

      label = "Cluster",

      choices = c(
        "Semua",
        sort(unique(data_tmp$Cluster))
      ),

      selected = "Semua"
    )
  })

  ## DATA FILTER =====
  data_filter <- reactive({
    df <- df_plot

    if (input$Kanwil != "Semua") {
      df <- df %>%
        filter(Kanwil == input$Kanwil)
    }

    if (!is.null(input$Kancab)) {
      if (input$Kancab != "Semua") {
        df <- df %>%
          filter(Kancab == input$Kancab)
      }
    }

    if (!is.null(input$Cluster)) {
      if (input$Cluster != "Semua") {
        df <- df %>%
          filter(Cluster == input$Cluster)
      }
    }

    if (input$mitra != "") {
      df <- df %>%
        filter(
          grepl(
            input$mitra,
            Rekanan,
            ignore.case = TRUE
          )
        )
    }

    df
  })

  ## KPI =====
  output$total_mitra <- renderText({
    nrow(data_filter())
  })

  output$total_kancab <- renderText({
    length(unique(data_filter()$Kancab))
  })

  output$total_kanwil <- renderText({
    length(unique(data_filter()$Kanwil))
  })

  output$total_cluster <- renderText({
    length(unique(data_filter()$Cluster))
  })

  ## MAP =====
  output$map <- renderPlotly({
    warna <- reactive({
      if (input$Kanwil == "Semua") {
        "Kanwil"
      } else if (is.null(input$Kancab) || input$Kancab == "Semua") {
        "Kancab"
      } else {
        "Cluster"
      }
    })

    plot_ly(
      data = data_filter(),

      lat = ~Latitude,

      lon = ~Longitude,

      type = "scattermapbox",

      mode = "markers",

      color = ~ .data[[warna()]],

      text = ~ paste(
        "<b>Mitra :</b>",
        Rekanan,

        "<br><b>Kanwil :</b>",
        Kanwil,

        "<br><b>Kancab :</b>",
        Kancab,

        "<br><b>Koordinat :</b>",
        `Koordinat Lokasi`,

        "<br><b>Cluster :</b>",
        Cluster
      ),

      hoverinfo = "text",

      marker = list(
        size = 8
      )
    ) %>%

      layout(
        mapbox = list(
          style = "open-street-map",

          center = list(
            lat = -2,
            lon = 118
          ),

          zoom = 3.5
        ),

        margin = list(
          l = 0,
          r = 0,
          t = 40,
          b = 0
        )
      )
  })

  ## TABEL =====
  output$tabel <- renderDT({
    datatable(
      data_filter(),

      extensions = "Buttons",

      options = list(
        pageLength = 15,
        scrollX = TRUE
      )
    )
  })

  output$download_excel <- downloadHandler(
    filename = function() {
      "Hasil_Filter.xlsx"
    },

    content = function(file) {
      openxlsx::write.xlsx(
        data_filter(),
        file,
        overwrite = TRUE
      )
    }
  )
}

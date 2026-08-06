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


# app.R

source("R/ui.R")
source("R/server.R")

shinyApp(
  ui = ui,
  server = server
)

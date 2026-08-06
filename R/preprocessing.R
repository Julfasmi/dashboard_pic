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


# PREPROCESSING ==========
source("R/config.R")
source("R/helper.R")

data.valid <- read.xlsx(FILE_INPUT)

data.valid <-
  data.valid %>%

  rename_kolom() %>%

  clean_coordinate() %>%

  clean_kanwil() %>%

  convert_capacity() %>%

  add_capacity_category() %>%

  extract_coordinate() %>%

  filter_coordinate()

save_excel(
  data.valid,
  FILE_VALID
)

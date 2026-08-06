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


# CLUSTERING ==========
source("R/config.R")
source("R/helper.R")

hasil.cluster <-
  data.valid %>%

  group_by(
    Kanwil,
    Kancab
  ) %>%

  group_modify(
    ~ cek_cluster(
      .x,
      radius_km = RADIUS_CLUSTER,
      max_mitra = MAX_MITRA
    )
  ) %>%

  ungroup() %>%

  split_cluster(MAX_MITRA) %>%

  rename_cluster() %>%

  arrange(
    Kanwil,
    Kancab,
    Cluster
  )

save_excel(
  hasil.cluster,
  FILE_CLUSTER
)

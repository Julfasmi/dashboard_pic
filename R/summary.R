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


# SUMMARY ==========
jumlah.pic <-
  hasil.cluster %>%
  summarise(
    Jumlah_Cluster = n_distinct(Cluster),
    Jumlah_Mitra = n(),
    .by = c(Kanwil, Kancab)
  )

ringkasan.cluster <-
  hasil.cluster %>%
  summarise(
    Jumlah_Mitra = n(),
    Daftar_Mitra = paste(Rekanan, collapse = ", "),
    .by = c(Kanwil, Kancab, Cluster)
  )


# SAVE ==========
save_excel(
  jumlah.pic,
  FILE_SUMMARY
)

save_excel(
  list(
    "Data Valid" = data.valid,
    "Hasil Cluster" = hasil.cluster,
    "Ringkasan Cluster" = ringkasan.cluster,
    "Jumlah Cluster" = jumlah.pic
  ),
  FILE_REPORT
)

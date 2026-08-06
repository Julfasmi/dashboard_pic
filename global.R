# PACKAGES ==========
library(shiny)
library(dplyr)
library(plotly)
library(DT)
library(openxlsx)
library(readxl)
library(ggplot2)
library(geosphere)
library(stringr)
library(tidyr)
library(purrr)
library(gt)
library(tidygeocoder)


# SOURCE ==========
source("R/config.R")
source("R/helper.R")
source("R/process.R")


# DATA
hasil <- process_data()

data.valid <- hasil$data.valid
hasil.cluster <- hasil$hasil.cluster
jumlah.pic <- hasil$jumlah.pic
ringkasan.cluster <- hasil$ringkasan.cluster

df_plot <- hasil.cluster

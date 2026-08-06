# ==========================================================
# PACKAGES
# ==========================================================

library(shiny)
library(ggplot2)
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
library(tidygeocoder)

# ==========================================================
# SOURCE
# ==========================================================

source("R/config.R")
source("R/helper.R")

# ==========================================================
# MEMBACA HASIL PREPROCESSING
# ==========================================================

# data.valid <- read.xlsx(FILE_VALID)

hasil.cluster <- read.xlsx("output/Hasil Cluster.xlsx")

# jumlah.pic <- read.xlsx(FILE_SUMMARY)

df_plot <- hasil.cluster

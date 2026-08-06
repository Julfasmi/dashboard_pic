# Jalankan preprocessing
source("R/preprocessing.R")

# Jalankan clustering
source("R/clustering.R")

# Jalankan summary
source("R/summary.R")

# Jalankan dashboard
shiny::runApp(
  appDir = ".",
  host = "127.0.0.1",
  port = 3838,
  launch.browser = TRUE
)

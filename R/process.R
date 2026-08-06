# PREPROCESSING ==========
source("R/config.R")
source("R/helper.R")


process_data <- function() {
  data.valid <- read.xlsx(FILE_INPUT) %>%
    rename_kolom() %>%
    clean_coordinate() %>%
    clean_kanwil() %>%
    convert_capacity() %>%
    add_capacity_category() %>%
    extract_coordinate() %>%
    filter_coordinate()

  hasil.cluster <- data.valid %>%
    group_by(Kanwil, Kancab) %>%
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
    arrange(Kanwil, Kancab, Cluster)

  jumlah.pic <- hasil.cluster %>%
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

  return(
    list(
      data.valid = data.valid,
      hasil.cluster = hasil.cluster,
      jumlah.pic = jumlah.pic,
      ringkasan.cluster = ringkasan.cluster
    )
  )
}

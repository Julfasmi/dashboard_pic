# RENAME KOLOM ==========
rename_kolom <- function(df) {
  df %>%

    rename(
      Kanwil = KANWIL,

      Kancab = KANCAB,

      Rekanan = `NAMA.MITRA`,

      `Alamat Mitra` = `ALAMAT.MITRA`,

      `Koordinat Lokasi` = `KOORDINAT.LOKASI`,

      `Kapasitas Pengeringan (ton/hari)` = `Kapasitas.Pengeringan.(ton/hari)`,

      `Kapasitas Penggilingan (ton/hari)` = `Kapasitas.Penggilingan.(ton/hari)`
    )
}


# MEMBERSIHKAN NAMA KANWIL ==========
clean_kanwil <- function(df) {
  df %>%

    mutate(
      Kanwil = Kanwil %>%

        stringr::str_replace_all("[0-9]", "") %>%

        stringr::str_replace_all("\\.", "") %>%

        stringr::str_trim(side = "left")
    )
}


# MEMBERSIHKAN KOORDINAT ==========
clean_coordinate <- function(df) {
  df %>%

    mutate(
      `Koordinat Lokasi` = `Koordinat Lokasi` %>%

        stringr::str_replace_all("\\s+", "") %>%

        stringr::str_replace_all(",", ", ")
    )
}


# KONVERSI KAPASITAS ==========
convert_capacity <- function(df) {
  df %>%

    mutate(
      `Kapasitas Pengeringan (ton/hari)` = suppressWarnings(
        as.numeric(
          `Kapasitas Pengeringan (ton/hari)`
        )
      ),

      `Kapasitas Penggilingan (ton/hari)` = suppressWarnings(
        as.numeric(
          `Kapasitas Penggilingan (ton/hari)`
        )
      )
    )
}


# ADD KATEGORI KAPASITAS ==========
add_capacity_category <- function(df) {
  df %>%
    mutate(
      `Kategori Kapasitas Pengeringan` = case_when(
        `Kapasitas Pengeringan (ton/hari)` >= KAPASITAS_PENGERINGAN ~ "BESAR",
        TRUE ~ "KECIL"
      ),

      `Kategori Kapasitas Penggilingan` = case_when(
        `Kapasitas Penggilingan (ton/hari)` >= KAPASITAS_PENGGILINGAN ~ "BESAR",
        TRUE ~ "KECIL"
      )
    )
}


# MEMBACA KOORDINAT ==========
cek_koordinat <- function(x) {
  if (
    stringr::str_detect(
      x,
      "^[0-9.-]+\\s*,\\s*[0-9.-]+$"
    )
  ) {
    temp <- stringr::str_split(
      x,
      ","
    )[[1]]

    return(
      c(
        as.numeric(temp[1]),

        as.numeric(temp[2])
      )
    )
  }

  c(NA, NA)
}


# MEMBUAT LATITUDE LONGITUDE ==========
extract_coordinate <- function(df) {
  coord <-
    purrr::map(
      df$`Koordinat Lokasi`,

      cek_koordinat
    )

  coord <- do.call(
    rbind,

    coord
  )

  df$Latitude <- coord[, 1]

  df$Longitude <- coord[, 2]

  df
}


# FILTER KOORDINAT VALID ==========
filter_coordinate <- function(df) {
  df %>%

    filter(
      !is.na(Latitude),

      !is.na(Longitude)

      # !(
      # `Kategori Kapasitas Pengeringan` == "KECIL" &
      # `Kategori Kapasitas Penggilingan` == "KECIL"
      # )
    )
}


# SAVE EXCEL ==========
save_excel <- function(df, file) {
  openxlsx::write.xlsx(
    df,

    file,

    overwrite = TRUE
  )
}


# RENAME CLUSTER ==========
rename_cluster <- function(df) {
  df %>%

    group_by(Kancab) %>%

    mutate(
      Cluster = dense_rank(Cluster),

      Cluster = LETTERS[Cluster],

      Cluster = paste0(Kancab, "-", Cluster)
    ) %>%

    ungroup()
}


# CEK CLUSTER ==========
cek_cluster <- function(
  df,
  radius_km = RADIUS_CLUSTER,
  max_mitra = MAX_MITRA
) {
  # Jika hanya ada satu mitra
  if (nrow(df) == 1) {
    df$Cluster <- 1
    return(df)
  }

  # Membuat matriks koordinat
  koordinat <- as.matrix(
    df[, c("Longitude", "Latitude")]
  )

  # Menghitung matriks jarak (meter)
  matriks_jarak <- geosphere::distm(
    koordinat,
    fun = geosphere::distHaversine
  )

  # Hierarchical Clustering
  hc <- hclust(
    as.dist(matriks_jarak),
    method = "complete"
  )

  # Membentuk cluster berdasarkan radius
  df$Cluster <- cutree(
    hc,
    h = radius_km * 1000
  )

  return(df)
}


# SPLIT CLUSTER ==========
split_cluster <- function(df, max_mitra = NULL) {
  if (is.null(max_mitra)) {
    return(df)
  }

  hasil <- list()

  id <- 1

  for (cl in unique(df$Cluster)) {
    tmp <- df %>%
      filter(Cluster == cl)

    # Ubah dulu menjadi character
    tmp$Cluster <- as.character(tmp$Cluster)

    if (nrow(tmp) <= max_mitra) {
      hasil[[id]] <- tmp
    } else {
      grup <- ceiling(seq_len(nrow(tmp)) / max_mitra)

      tmp$Cluster <- paste0(cl, "_", grup)

      hasil[[id]] <- tmp
    }

    id <- id + 1
  }

  bind_rows(hasil)
}

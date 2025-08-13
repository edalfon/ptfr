ingest_cercano_saija <- function() {
  readxl::read_excel(
    "data/listados/Cercano/L_C_Saija.xlsx",
    range = "B3:E269",
    col_types = "text"
  ) |>
    janitor::clean_names()
}

ingest_lejano_saija <- function() {
  readxl::read_excel("data/listados/Lejano/L_L_Saija.xlsx", range = "A1:C54") |>
    janitor::clean_names()
}

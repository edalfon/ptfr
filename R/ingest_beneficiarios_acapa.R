ingest_beneficiarios_acapa <- function(
  filename = "./data/listados/Beneficiarios/L_B_Acapa.xlsx"
) {
  beneficiarios_acapa <- readxl::read_excel(
    filename,
    sheet = "Beneficiarios",
    range = "B4:F166"
  ) |>
    janitor::clean_names()
}

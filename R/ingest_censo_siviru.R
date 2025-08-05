ingest_censo_siviru <- function() {
  siviru <- readxl::read_excel(
    "data/listados/Censo_Siviru.xlsx",
    sheet = "SIVIRÚ",
    range = "A14:J611",
    col_types = "text"
  ) |>
    janitor::clean_names() |>
    mutate(site = "SIVIRU") |>
    mutate(
      fecnac = as.Date(as.numeric(fecha_de_nacimiento_d_m_a), origin = "1900-01-01")
    )

  siviru
}

ingest_censo_dotenedo <- function() {
  dotenedo <- readxl::read_excel(
    "data/listados/Censo_Siviru.xlsx",
    sheet = "DOTENEDÓ",
    range = "A14:J202",
    col_types = "text"
  ) |>
    janitor::clean_names() |>
    mutate(site = "DOTENEDO") |>
    mutate(fecnac = as.Date(fecha_de_nacimiento_d_m_a, format = "%d/%m/%Y"))

  dotenedo
}

ingest_censo_usuraga <- function() {
  usuraga <- readxl::read_excel(
    "data/listados/Censo_Usuraga.xlsx",
    range = "B4:K826",
    col_names = TRUE,
    col_types = "text"
  ) |>
    janitor::clean_names() |>
    mutate(site = "USURAGA") |>
    mutate(beneficiaria = 0) |>
    mutate(
      fecnac = dplyr::coalesce(
        as.Date(fecha_de_nacimiento_d_m_a, format = "%d/%m/%Y"),
        as.Date(as.numeric(fecha_de_nacimiento_d_m_a), origin = "1900-01-01")
      )
    )

  usuraga
}

ingest_beneficiarios_siviru <- function() {
  beneficiarios_siviru <- readxl::read_excel(
    "data/listados/L_B_Sivirú.xlsx",
    range = "D3:D43",
    col_types = "text"
  ) |>
    janitor::clean_names()

  beneficiarios_siviru
}


select_control_cercano_siviru <- function(
  censo_siviru,
  censo_dotenedo,
  beneficiarios_siviru
) {
  siviru <- dplyr::bind_rows(censo_siviru, censo_dotenedo) |>
    left_join(
      beneficiarios_siviru,
      by = c("numero_documento_de_identificacion" = "cedula"),
      keep = TRUE
    ) |>
    mutate(beneficiaria = ifelse(is.na(cedula), 0, 1))

  stopifnot(sum(siviru$beneficiaria, na.rm = TRUE) == 40)

  control_cercano_siviru <- MatchIt::matchit(
    beneficiaria ~ fecnac,
    data = siviru |>
      filter(sexo_f_o_m == "MUJER") |>
      filter(grepl(
        "CEDULA",
        tipo_de_documento_de_identificacion,
        ignore.case = TRUE
      )) |>
      filter(!is.na(fecnac)) |>
      identity(),
    method = "nearest",
    replace = FALSE,
    ratio = 1,
    exact = "site"
    #caliper = 0.2
  ) |>
    MatchIt::match.data()

  writexl::write_xlsx(
    list(control_cercano_siviru = control_cercano_siviru),
    efun::timestamp_it("output/control_cercano_siviru.xlsx")
  )

  control_cercano_siviru
}

select_control_lejano_siviru <- function(
  censo_siviru,
  censo_dotenedo,
  beneficiarios_siviru,
  censo_usuraga
) {
  siviru <- dplyr::bind_rows(censo_siviru, censo_dotenedo) |>
    left_join(
      beneficiarios_siviru,
      by = c("numero_documento_de_identificacion" = "cedula"),
      keep = TRUE
    ) |>
    mutate(beneficiaria = ifelse(is.na(cedula), 0, 1))

  stopifnot(sum(siviru$beneficiaria, na.rm = TRUE) == 40)

  control_lejano_siviru <- MatchIt::matchit(
    beneficiaria ~ fecnac,
    data = censo_usuraga |>
      filter(sexo_f_o_m == "F") |>
      filter(cabeza_de_familia == "SI") |>
      filter(tipo_di == "CC") |>
      bind_rows(siviru |> filter(beneficiaria == 1)) |>
      filter(!is.na(fecnac)) |>
      identity(),
    method = "nearest",
    replace = FALSE,
    ratio = 1
  ) |>
    MatchIt::match.data()

  writexl::write_xlsx(
    list(control_lejano_siviru = control_lejano_siviru),
    efun::timestamp_it("output/control_lejano_siviru.xlsx")
  )

  control_lejano_siviru
}

# entrevista, encuesta, uso del lenguaje, no confundir

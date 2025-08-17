#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
select_muestra_acapa <- function(beneficiarios_acapa) {
  #' Veredas
  #' - La mayoría de los beneficiarios están en San Sebastián
  #' - un par de personas sin info de vereda
  beneficiarios_acapa$vereda |> efun::tab()

  #' Edad
  #' - Algunos menores de edad
  #' - Mediana 34 y concentrados alrededor de 28
  beneficiarios_acapa |> efun::denstogram(edad, plotly = FALSE)
  beneficiarios_acapa$edad |> hist()

  #' distribución m´sa plana en las otras veredas
  beneficiarios_acapa |> efun::denstogram(edad, facets_rows = vereda)
  beneficiarios_acapa |>
    filter(!is.na(vereda)) |>
    ggplot(aes(x = edad, fill = vereda)) +
    geom_density(alpha = 0.7, color = NA)

  #' Selección de muestra
  set.seed(1)

  sample_n <- beneficiarios_acapa |>
    filter(!is.na(vereda)) |>
    filter(edad >= 18 & !is.na(edad)) |>
    count(vereda, name = "strata_n") |>
    mutate(sample_n = round(40 * strata_n / sum(strata_n)))

  muestra_acapa <- beneficiarios_acapa |>
    filter(!is.na(vereda)) |>
    filter(edad >= 18 & !is.na(edad)) |>
    mutate(total_n = n()) |>
    mutate(strata_n = n(), .by = vereda) |>
    mutate(sample_n = round(40 * strata_n / total_n)) |>
    group_by(vereda) |>
    group_map(~ slice_sample(.x, n = .x$sample_n[1]), .keep = TRUE) |>
    bind_rows()

  reemplazos_acapa <- beneficiarios_acapa |>
    filter(!is.na(vereda)) |>
    filter(edad >= 18 & !is.na(edad)) |>
    anti_join(muestra_acapa, by = c("number")) |>
    mutate(dist = runif(n()))

  writexl::write_xlsx(
    list(muestra = muestra_acapa, reemplazos = reemplazos_acapa),
    efun::timestamp_it("output/muestra_acapa.xlsx")
  )

  muestra_acapa
}

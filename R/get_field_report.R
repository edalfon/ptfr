#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param survey
#' @return
#' @author edalfon
#' @export
get_field_report <- function(survey) {
  conteo <- survey |>
    count(created_by, beneficia) |>
    pivot_wider(names_from = beneficia, values_from = n, values_fill = 0) |>
    dplyr::mutate(Total = rowSums(dplyr::across(where(is.numeric))))

  conteo <- conteo |>
    add_row(summarise(conteo, across(where(is.numeric), sum), created_by = "Total"))

  lista_encuestados <- survey |>
    select(created_by, beneficia, nombre, edad, sexo, longitud, latitud) |>
    identity()

  lista_encuestados <- list(conteo = conteo, lista_encuestados = lista_encuestados)
}

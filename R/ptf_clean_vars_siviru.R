#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
ptf_clean_vars_siviru <- function(survey) {
  # edad
  survey <- survey |>
    dplyr::mutate(sexo = case_when(sexo == "Masculino" ~ "Femenino", TRUE ~ sexo)) |>
    identity()

  survey
}

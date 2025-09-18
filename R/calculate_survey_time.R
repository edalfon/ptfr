#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param survey
#' @return
#' @author edalfon
#' @export
calculate_survey_time <- function(survey) {
  survey |>
    select(created_by, inicio, intermedio, final, beneficia) |>
    mutate(tot_secs = final - inicio) |>
    mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
}

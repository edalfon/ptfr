#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
plan_saija <- function() {
  tar_files_input(saija_survey_file, "data/survey/saija.csv")

  tar_target(saija_survey, {
    #readr::read_csv(saija_survey_file) |> janitor::clean_names()

    epicollect_download_data(
      proj_slug = "ptf-puertosaija",
      client_id = "6752",
      client_secret = "LymWzzPRo6A0TEfVJFuuTy7hMVLKwkHO2E7yGyEs",
      form_ref = "ENCUESTA"
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Kevin") |>
      dplyr::filter(title != "Tania Hurtado")
  })

  # tar_target(saija_times, {
  #   saija_survey |>
  #     select(
  #       created_by,
  #       x1_inicie,
  #       x51_contine,
  #       x122_finalice,
  #       x69_42_la_persona_es
  #     ) |>
  #     mutate(tot_secs = x122_finalice - x1_inicie) |>
  #     mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
  # })
}

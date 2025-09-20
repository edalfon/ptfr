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

  # Download data from Epicollect5
  tar_target(saija_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "ptf-puertosaija",
      client_id = "6752",
      client_secret = "LymWzzPRo6A0TEfVJFuuTy7hMVLKwkHO2E7yGyEs",
      map_index = 0
    ) |>
      identity()
  })

  # Clean and rename variables
  tar_target(saija_survey, {
    saija_survey_epicollect |>
      #ptf_rename_vars() |>
      ptf_rename_vars_saija() |>
      dplyr::filter(title != "Kevin") |>
      dplyr::filter(title != "Tania Hurtado") |>
      ptf_clean_vars() |>
      recode_beneficia_saija() |>
      identity()
  })

  # Field report
  tar_target(saija_field_report, get_field_report(saija_survey))

  # Calculate time spent on survey
  tar_target(saija_times, calculate_survey_time(saija_survey))
}

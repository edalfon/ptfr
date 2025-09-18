#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
plan_mariposas <- function() {
  # Download data from Epicollect5
  tar_target(mariposas_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_MARIPOSAS",
      client_id = "6788",
      client_secret = "rY4q88Xo1mqLcX2I5jdFLvaHtSEPayaXp6hcCfme",
      form_ref = NULL,
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(mariposas_survey, {
    mariposas_survey_epicollect |>
      #ptf_rename_vars() |>
      ptf_rename_vars_mariposas() |>
      dplyr::filter(title != "Tjfh") |>
      ptf_clean_vars() |>
      identity()
  })

  # Field report
  tar_target(mariposas_field_report, get_field_report(mariposas_survey))

  # Calculate time spent on survey
  tar_target(mariposas_times, calculate_survey_time(mariposas_survey))
}

# c(
#   siviru_survey_epicollect,
#   sirenas_survey_epicollect,
#   usaraga_survey_epicollect,
#   acapa_survey_epicollect,
#   saija_survey_epicollect,
#   asogesampa_survey_epicollect,
#   raices_survey_epicollect,
#   mariposas_survey_epicollect
# ) |>
#   names() |>
#   unique() |>
#   efun::clipboard_writeto()

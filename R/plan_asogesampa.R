plan_asogesampa <- function() {
  tar_target(asogesampa_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_ASOGESAMPA",
      client_id = "6785",
      client_secret = "PNnosEcgQVvK7wj4ETMNUuibVUmnzQV7aVeQPP3Y",
      form_ref = NULL,
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(asogesampa_survey, {
    asogesampa_survey_epicollect |>
      ptf_rename_vars() |>
      ptf_rename_vars_asogesampa() |>
      dplyr::filter(title != "Prueba") |>
      dplyr::filter(title != "PRUEBA 1") |>
      #ptf_clean_vars() |>
      identity()
  })

  # Field report
  tar_target(asogesampa_field_report, get_field_report(asogesampa_survey))

  # Calculate time spent on survey
  tar_target(asogesampa_times, calculate_survey_time(asogesampa_survey))
}

plan_acapa <- function() {
  #

  # Download Epicollect5 project metadata
  tar_target(acapa_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_ACAPA",
      client_id = "6787",
      client_secret = "zINAr1AaJhRwCe0SnKNwYZDUye40huOJxjDwumGn"
    )
  })

  # Download data from Epicollect5
  tar_target(acapa_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_ACAPA",
      client_id = "6787",
      client_secret = "zINAr1AaJhRwCe0SnKNwYZDUye40huOJxjDwumGn",
      map_index = 0
    ) |>
      identity()
  })

  # Clean and rename variables
  tar_target(acapa_survey, {
    acapa_survey_epicollect |>
      epicollect_assign_labels(acapa_epicollect_proj) |>
      ptf_rename_vars() |>
      ptf_rename_vars_acapa() |>
      dplyr::filter(title != "Prueba 1") |>
      ptf_clean_vars() |>
      ptf_assign_labels() |>
      identity()
  })

  # Field report
  tar_target(acapa_field_report, get_field_report(acapa_survey))

  # Calculate time spent on survey
  tar_target(acapa_times, calculate_survey_time(acapa_survey))
}

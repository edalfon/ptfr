plan_asogesampa <- function() {
  #

  # Download Epicollect5 project metadata
  tar_target(asogesampa_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_ASOGESAMPA",
      client_id = Sys.getenv("ASOGESAMPA_CLIENT_ID"),
      client_secret = Sys.getenv("ASOGESAMPA_CLIENT_SECRET")
    )
  })

  # Download data from Epicollect5
  tar_target(asogesampa_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_ASOGESAMPA",
      client_id = Sys.getenv("ASOGESAMPA_CLIENT_ID"),
      client_secret = Sys.getenv("ASOGESAMPA_CLIENT_SECRET"),
      form_ref = NULL,
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(asogesampa_survey, {
    asogesampa_survey_epicollect |>
      epicollect_assign_labels(asogesampa_epicollect_proj) |>
      ptf_rename_vars() |>
      ptf_rename_vars_asogesampa() |>
      dplyr::filter(title != "Prueba") |>
      dplyr::filter(title != "PRUEBA 1") |>
      ptf_clean_vars() |>
      ptf_assign_labels() |>
      identity()
  })

  # Field report
  tar_target(asogesampa_field_report, get_field_report(asogesampa_survey))

  # Calculate time spent on survey
  tar_target(asogesampa_times, calculate_survey_time(asogesampa_survey))
}

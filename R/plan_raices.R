plan_raices <- function() {
  #tar_files_input(raices_survey_file, "data/survey/raices.csv")

  # Download Epicollect5 project metadata
  tar_target(raices_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_RAICES",
      client_id = Sys.getenv("RAICES_CLIENT_ID"),
      client_secret = Sys.getenv("RAICES_CLIENT_SECRET")
    )
  })

  # Download data from Epicollect5
  tar_target(raices_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_RAICES",
      client_id = Sys.getenv("RAICES_CLIENT_ID"),
      client_secret = Sys.getenv("RAICES_CLIENT_SECRET"),
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(raices_survey, {
    raices_survey_epicollect |>
      epicollect_assign_labels(raices_epicollect_proj) |>
      ptf_rename_vars() |>
      ptf_rename_vars_raices() |>
      dplyr::filter(title != "Sin nombre") |>
      ptf_clean_vars() |>
      ptf_assign_labels() |>
      identity()
  })

  # Field report
  tar_target(raices_field_report, get_field_report(raices_survey))

  # Calculate time spent on survey
  tar_target(raices_times, calculate_survey_time(raices_survey))
}

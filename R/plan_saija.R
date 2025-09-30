plan_saija <- function() {
  #tar_files_input(saija_survey_file, "data/survey/saija.csv")

  # Download Epicollect5 project metadata
  tar_target(saija_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "ptf-puertosaija",
      client_id = Sys.getenv("SAIJA_CLIENT_ID"),
      client_secret = Sys.getenv("SAIJA_CLIENT_SECRET")
    )
  })

  # Download data from Epicollect5
  tar_target(saija_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "ptf-puertosaija",
      client_id = Sys.getenv("SAIJA_CLIENT_ID"),
      client_secret = Sys.getenv("SAIJA_CLIENT_SECRET"),
      map_index = 0
    ) |>
      identity()
  })

  # Clean and rename variables
  tar_target(saija_survey, {
    saija_survey_epicollect |>
      epicollect_assign_labels(saija_epicollect_proj) |>
      #ptf_rename_vars() |>
      ptf_rename_vars_saija() |>
      dplyr::filter(title != "Kevin") |>
      dplyr::filter(title != "Tania Hurtado") |>
      ptf_clean_vars() |>
      ptf_assign_labels() |>
      recode_beneficia_saija() |>
      identity()
  })

  # Field report
  tar_target(saija_field_report, get_field_report(saija_survey))

  # Calculate time spent on survey
  tar_target(saija_times, calculate_survey_time(saija_survey))
}

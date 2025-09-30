plan_sirenas <- function() {
  #

  # Download Epicollect5 project metadata
  tar_target(sirenas_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_SIRENAS",
      client_id = Sys.getenv("SIRENAS_CLIENT_ID"),
      client_secret = Sys.getenv("SIRENAS_CLIENT_SECRET")
    )
  })

  # Download data from Epicollect5
  tar_target(sirenas_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_SIRENAS",
      client_id = Sys.getenv("SIRENAS_CLIENT_ID"),
      client_secret = Sys.getenv("SIRENAS_CLIENT_SECRET"),
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(sirenas_survey, {
    sirenas_survey_epicollect |>
      epicollect_assign_labels(sirenas_epicollect_proj) |>
      ptf_rename_vars() |>
      ptf_rename_vars_sirenas() |>
      dplyr::filter(title != "Lucia") |>
      dplyr::filter(title != "Eduardo") |>
      ptf_clean_vars() |>
      ptf_assign_labels() |>
      recode_beneficia_sirenas() |>
      identity()
  })

  # Field report
  tar_target(sirenas_field_report, get_field_report(sirenas_survey))

  # times
  tar_target(sirenas_times, calculate_survey_time(sirenas_survey))
}

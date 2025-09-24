plan_mariposas <- function() {
  #

  # Download Epicollect5 project metadata
  tar_target(mariposas_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_MARIPOSAS",
      client_id = "6788",
      client_secret = "rY4q88Xo1mqLcX2I5jdFLvaHtSEPayaXp6hcCfme"
    )
  })

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

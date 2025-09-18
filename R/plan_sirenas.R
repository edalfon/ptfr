plan_sirenas <- function() {
  tar_target(sirenas_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_SIRENAS",
      client_id = "6751",
      client_secret = "UXg1XqKBjbMvia1IzmKMhTSLaaYlFF4KNPZZiv4f",
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(sirenas_survey, {
    sirenas_survey_epicollect |>
      ptf_rename_vars() |>
      ptf_rename_vars_sirenas() |>
      dplyr::filter(title != "Lucia") |>
      dplyr::filter(title != "Eduardo") |>
      ptf_clean_vars() |>
      identity()
  })

  # Field report
  tar_target(sirenas_field_report, get_field_report(sirenas_survey))

  # times
  tar_target(sirenas_times, calculate_survey_time(sirenas_survey))
}

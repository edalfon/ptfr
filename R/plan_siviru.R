plan_siviru <- function() {
  #tar_files_input(siviru_survey_file, "data/survey/siviru.csv")

  # Download Epicollect5 project metadata
  tar_target(siviru_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_SIVIRU",
      client_id = "6749",
      client_secret = "Fno423tb3nHL7dfXDV1zX1UpebUgTfhs1fTrsZxc"
    )
  })

  # Download data from Epicollect5
  tar_target(siviru_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_SIVIRU",
      client_id = "6749",
      client_secret = "Fno423tb3nHL7dfXDV1zX1UpebUgTfhs1fTrsZxc",
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(siviru_survey, {
    siviru_survey_epicollect |>
      epicollect_assign_labels(siviru_epicollect_proj) |>
      ptf_rename_vars() |>
      ptf_rename_vars_siviru() |>
      dplyr::filter(title != "Prueba 1") |>
      ptf_clean_vars() |>
      ptf_assign_labels() |>
      recode_beneficia_siviru() |>
      identity()
  })

  # Field report
  tar_target(siviru_field_report, get_field_report(siviru_survey))

  # Calculate time spent on survey
  tar_target(siviru_times, calculate_survey_time(siviru_survey))

  # Calculate time spent on survey
  tar_target(siviru_abdrige, {
    siviru_survey |> efun::abridge_df(file = "output/abridge/siviru.html")
  })
}

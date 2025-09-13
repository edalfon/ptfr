plan_siviru <- function() {
  tar_files_input(siviru_survey_file, "data/survey/siviru.csv")

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
      ptf_rename_vars() |>
      ptf_rename_vars_siviru() |>
      dplyr::filter(title != "Prueba 1") |>
      ptf_clean_vars() |>
      identity()
  })

  # Calculate time spent on survey
  tar_target(siviru_times, {
    siviru_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
  })

  # Calculate time spent on survey
  tar_target(siviru_abdrige, {
    siviru_survey |> efun::abridge_df(file = "output/abridge/siviru.html")
  })
}

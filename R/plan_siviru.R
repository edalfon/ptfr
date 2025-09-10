plan_siviru <- function() {
  tar_files_input(siviru_survey_file, "data/survey/siviru.csv")

  tar_target(siviru_survey, {
    #readr::read_csv(siviru_survey_file) |> janitor::clean_names()

    epicollect_download_data(
      proj_slug = "PTF_SIVIRU",
      client_id = "6749",
      client_secret = "Fno423tb3nHL7dfXDV1zX1UpebUgTfhs1fTrsZxc"
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Prueba 1") |>
      identity()
  })

  tar_target(siviru_times, {
    siviru_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
  })
}

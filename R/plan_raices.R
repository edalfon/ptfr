plan_raices <- function() {
  tar_files_input(raices_survey_file, "data/survey/raices.csv")

  tar_target(raices_survey, {
    epicollect_download_data(
      proj_slug = "PTF_RAICES",
      client_id = "6753",
      client_secret = "PgEl0OfULPYd2KMHHiC7Aa8mhQKXKEJHjouwzRiY"
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Sin nombre") |>
      identity()
  })

  tar_target(raices_times, {
    raices_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"))
  })
}

plan_raices <- function() {
  tar_files_input(raices_survey_file, "data/survey/raices.csv")

  tar_target(raices_survey, {
    #readr::read_csv(raices_survey_file) |> janitor::clean_names()

    epicollect_download_data(
      proj_slug = "PTF_RAICES",
      client_id = "6753",
      client_secret = "PgEl0OfULPYd2KMHHiC7Aa8mhQKXKEJHjouwzRiY"
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Sin nombre")
  })

  # tar_target(raices_times, {
  #   raices_survey |>
  #     select(
  #       created_by,
  #       x1_inicie,
  #       x102_contine,
  #       x233_finalice,
  #       x190_72_la_persona_es
  #     ) |>
  #     mutate(tot_secs = x233_finalice - x1_inicie) |>
  #     mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
  # })

  # raices_survey |>
  #   count(x143_90_la_persona_es, created_by) |>
  #   pivot_wider(names_from = x143_90_la_persona_es, values_from = n, values_fill = 0)
}

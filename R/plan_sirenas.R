plan_sirenas <- function() {
  tar_target(sirenas_survey, {
    epicollect_download_data(
      proj_slug = "PTF_SIRENAS",
      client_id = "6751",
      client_secret = "UXg1XqKBjbMvia1IzmKMhTSLaaYlFF4KNPZZiv4f",
      map_index = 1
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Lucia") |>
      dplyr::filter(title != "Eduardo")
  })

  tar_target(sirenas_times, {
    sirenas_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"))
  })
}

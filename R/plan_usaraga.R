plan_usaraga <- function() {
  tar_target(usaraga_survey, {
    epicollect_download_data(
      proj_slug = "PTF_USARAGA",
      client_id = "6750",
      client_secret = "tBetQueAv8scIixyKesXyDVN3Tcllb57QHWjqB1S"
    ) |>
      janitor::clean_names() |>
      identity()
  })

  tar_target(usaraga_times, {
    usaraga_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
  })
}

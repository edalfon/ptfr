plan_usaraga <- function() {
  #

  # Download Epicollect5 project metadata
  tar_target(usaraga_epicollect_proj, {
    epicollect_get_project(
      proj_slug = "PTF_USARAGA",
      client_id = "6750",
      client_secret = "tBetQueAv8scIixyKesXyDVN3Tcllb57QHWjqB1S"
    )
  })

  # Download data from Epicollect5
  tar_target(usaraga_survey_epicollect, {
    epicollect_download_data(
      proj_slug = "PTF_USARAGA",
      client_id = "6750",
      client_secret = "tBetQueAv8scIixyKesXyDVN3Tcllb57QHWjqB1S",
      map_index = 0
    )
  })

  # Clean and rename variables
  tar_target(usaraga_survey, {
    usaraga_survey_epicollect |>
      ptf_rename_vars() |>
      ptf_rename_vars_usaraga() |>
      recode_beneficia_usaraga() |>
      ptf_clean_vars() |>
      identity()
  })

  # Field report
  tar_target(usaraga_field_report, get_field_report(usaraga_survey))

  tar_target(usaraga_times, {
    usaraga_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"), )
  })
}

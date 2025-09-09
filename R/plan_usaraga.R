plan_usaraga <- function() {
  tar_target(usaraga_survey, {
    #readr::read_csv(siviru_survey_file) |> janitor::clean_names()

    epicollect_download_data(
      proj_slug = "PTF_USARAGA",
      client_id = "6750",
      client_secret = "tBetQueAv8scIixyKesXyDVN3Tcllb57QHWjqB1S",
      form_ref = "ENCUESTA"
    ) |>
      janitor::clean_names()
  })
}

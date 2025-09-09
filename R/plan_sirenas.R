plan_sirenas <- function() {
  tar_target(sirenas_survey, {
    #readr::read_csv(siviru_survey_file) |> janitor::clean_names()

    epicollect_download_data(
      proj_slug = "PTF_SIRENAS",
      client_id = "6751",
      client_secret = "UXg1XqKBjbMvia1IzmKMhTSLaaYlFF4KNPZZiv4f",
      form_ref = "ENCUESTA"
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Lucia") |>
      dplyr::filter(title != "Eduardo")
  })
}

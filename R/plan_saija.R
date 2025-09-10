#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
plan_saija <- function() {
  tar_files_input(saija_survey_file, "data/survey/saija.csv")

  tar_target(saija_survey, {
    epicollect_download_data(
      proj_slug = "ptf-puertosaija",
      client_id = "6752",
      client_secret = "LymWzzPRo6A0TEfVJFuuTy7hMVLKwkHO2E7yGyEs"
    ) |>
      janitor::clean_names() |>
      dplyr::filter(title != "Kevin") |>
      dplyr::filter(title != "Tania Hurtado") |>
      identity()
  })

  tar_target(saija_times, {
    saija_survey |>
      select(created_by, inicio, intermedio, final, beneficia) |>
      mutate(tot_secs = final - inicio) |>
      mutate(tot_mins = as.numeric(tot_secs, units = "mins"))
  })
}

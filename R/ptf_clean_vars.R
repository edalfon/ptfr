ptf_clean_vars <- function(survey) {
  survey |> dplyr::mutate(edad = dplyr::na_if(edad, 0)) |> identity()
}

ptf_clean_vars <- function(survey) {
  #

  # edad
  survey <- survey |> dplyr::mutate(edad = dplyr::na_if(edad, 0)) |> identity()

  vars <- c(
    "oir",
    "hablar",
    "ver",
    "moverse",
    "manos",
    "cognitiva",
    "autocuidado",
    "interaccion"
  )
  for (v in vars) {
    survey[[paste0(v, "_dummy")]] <- ifelse(
      survey[[v]] %in% c("No puede hacerlo", "Sí, con mucha dificultad"),
      1,
      0
    )
  }

  survey$discapacidad_cnt <- factor(
    x = rowSums(survey[paste0(vars, "_dummy")], na.rm = TRUE),
    levels = 0:8,
    ordered = TRUE
  )

  survey$discapacidad_any <- factor(
    x = apply(survey[paste0(vars, "_dummy")], 1, max, na.rm = TRUE),
    levels = 0:1,
    labels = c("No", "Sí"),
  )

  survey
}

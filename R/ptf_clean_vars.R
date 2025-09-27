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

  survey <- tryCatch(
    survey |>
      mutate(
        mcdo_laboral = case_when(
          actividad_semana == "Trabajando" ~ "Ocupados",
          actividad_semana == "Incapacitado permanente para trabajar" ~
            "Incapacitados permanentes",
          actividad_paga_semana == "Sí" ~ "Ocupados",
          tenia_trabajo_semana == "Sí" ~ "Ocupados",
          trabajo_no_remunerado_semana == "Sí" ~ "Ocupados",
          quiere_trabajo == "No" ~ "Desocupados",
          disponible_semana == "Sí" ~ "Desocupados",
          disponible_semana == "No" ~ "No Activos",
          TRUE ~ NA_character_
        )
      ),
    error = function(e) survey
  )

  survey <- tryCatch(
    {
      survey$ocupacion <- unname(ocupacion_map[survey$ocupacion_desc_txt])
      #df$categoria <- dplyr::coalesce(df$categoria, "Otros / verificar")
      survey
    },
    error = function(e) survey
  )

  survey
}

plan_capacitaciones <- function() {
  list(
    tar_quarto(
      capacita_slides,
      "slides/capacitacion.qmd",
      cue = tar_cue(file = FALSE)
    ),
    tar_quarto(
      capacita_slides_sirenas,
      "slides/capacitacion_Sirenas_PuertoSaija.qmd",
      cue = tar_cue(file = FALSE)
    ),
    tar_quarto(
      capacita_raices,
      "slides/capacitacion_raices.qmd",
      cue = tar_cue(file = FALSE)
    ),
    tar_quarto(
      capacita_acapa,
      "slides/capacitacion_acapa.qmd",
      cue = tar_cue(file = FALSE)
    ),
    NULL
  )
}

list(
  plan_theory_of_change(),
  plan_simulation(),
  plan_sample_selection(),
  tar_quarto(capacita_slides, "slides/capacitacion.qmd"),
  tar_quarto(capacita_slides_sirenas, "slides/capacitacion_Sirenas_PuertoSaija.qmd"),

  NULL
  # flowme::tar_bookdown("report")
)

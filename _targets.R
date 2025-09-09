list(
  plan_theory_of_change(),
  plan_simulation(),
  plan_sample_selection(),
  tar_quarto(capacita_slides, "slides/capacitacion.qmd"),
  tar_quarto(capacita_slides_sirenas, "slides/capacitacion_Sirenas_PuertoSaija.qmd"),
  tar_quarto(capacita_raices, "slides/capacitacion_raices.qmd"),
  tar_quarto(capacita_acapa, "slides/capacitacion_acapa.qmd"),

  #lapply(as.list(body(plan_siviru))[-1], eval),
  tar_fn(plan_siviru),
  tar_fn(plan_usaraga),
  tar_fn(plan_sirenas),
  tar_fn(plan_raices),
  tar_fn(plan_saija),
  NULL,
  flowme::tar_bookdown("report"),
  tar_target(openreport, browseURL("report/_book/index.html"))
)

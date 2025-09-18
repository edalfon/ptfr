list(
  plan_theory_of_change(),
  plan_simulation(),
  plan_sample_selection(),
  tar_quarto(capacita_slides, "slides/capacitacion.qmd"),
  tar_quarto(capacita_slides_sirenas, "slides/capacitacion_Sirenas_PuertoSaija.qmd"),
  tar_quarto(capacita_raices, "slides/capacitacion_raices.qmd"),
  tar_quarto(capacita_acapa, "slides/capacitacion_acapa.qmd"),

  # analysis towards impact evaluation
  tar_fn(plan_siviru),
  tar_fn(plan_usaraga),
  tar_fn(plan_sirenas),
  tar_fn(plan_saija),
  tar_fn(plan_acapa),
  tar_fn(plan_raices),
  tar_fn(plan_mariposas),
  tar_fn(plan_asogesampa),

  # field report
  tar_target(
    field_report,
    build_field_report(
      siviru_field_report,
      usaraga_field_report,
      sirenas_field_report,
      saija_field_report,
      acapa_field_report,
      raices_field_report,
      mariposas_field_report,
      asogesampa_field_report
    )
  ),
  NULL,
  #flowme::tar_bookdown("report"),
  #tar_target(openreport, browseURL("report/_book/index.html")),
  tar_quarto(
    quartobook,
    "quartobook",
    execute_params = list(freeze = "false"),
    # execute_params = list(execute_dir = ".")
    quiet = FALSE
  ),
  # tar_target(
  #   quartobook,
  #   quarto::quarto_render(input = "quartobook", quiet = FALSE, execute_dir = ".")
  # ),
  # quarto render quartobook --execute-dir=.
  NULL
)

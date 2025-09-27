#touch_outdated_quarto_files()
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
  tar_target(xxx, {
    c(
      siviru_survey$ocupacion_desc_txt,
      usaraga_survey$ocupacion_desc_txt,
      sirenas_survey$ocupacion_desc_txt,
      saija_survey$ocupacion_desc_txt,
      acapa_survey$ocupacion_desc_txt,
      raices_survey$ocupacion_desc_txt,
      mariposas_survey$ocupacion_desc_txt,
      asogesampa_survey$ocupacion_desc_txt
    )
  }),
  NULL,
  #flowme::tar_bookdown("report"),
  #tar_target(openreport, browseURL("report/_book/index.html")),
  # tar_target(
  #   touchethemall,
  #   touch_outdated_quarto_files(),
  #   format = "file",
  #   repository = "local",
  #   cue = tar_cue("always")
  # ),
  tar_quarto(
    quartobook,
    "quartobook",
    #execute_params = list(freeze = "false"),
    # execute_params = list(execute_dir = ".")
    quiet = FALSE
  ),
  #  |>
  #   tarchetypes::tar_hook_before(hook = touch_outdated_quarto_files()),
  # tar_target(
  #   quartobook,
  #   quarto::quarto_render(input = "quartobook", quiet = FALSE, execute_dir = ".")
  # ),
  # quarto render quartobook --execute-dir=.
  NULL
)

# c(
#   "siviru" = tar_read(siviru_survey_epicollect),
#   "sirenas" = tar_read(sirenas_survey_epicollect),
#   "usaraga" = tar_read(usaraga_survey_epicollect),
#   "acapa" = tar_read(acapa_survey_epicollect),
#   "saija" = tar_read(saija_survey_epicollect),
#   "asogesampa" = tar_read(asogesampa_survey_epicollect),
#   "raices" = tar_read(raices_survey_epicollect),
#   "mariposas" = tar_read(mariposas_survey_epicollect)
# ) |>
#   names() |>
#   unique() |>
#   paste0(collapse = ", ") |>
#   efun::clipboard_writeto()

plan_sample_selection <- function() {
  list(
    tar_target(censo_siviru, ingest_censo_siviru()),
    tar_target(censo_dotenedo, ingest_censo_dotenedo()),
    tar_target(censo_usuraga, ingest_censo_usuraga()),
    tar_target(beneficiarios_siviru, ingest_beneficiarios_siviru()),
    tar_target(
      control_cercano_siviru,
      select_control_cercano_siviru(
        censo_siviru,
        censo_dotenedo,
        beneficiarios_siviru
      )
    ),
    tar_target(
      control_lejano_siviru,
      select_control_lejano_siviru(
        censo_siviru,
        censo_dotenedo,
        beneficiarios_siviru,
        censo_usuraga
      )
    ),

    # saija
    tar_target(cercano_saija, ingest_cercano_saija()),
    tar_target(lejano_saija, ingest_lejano_saija()),
    tar_target(control_cercano_saija, select_control_cercano_saija(cercano_saija)),
    tar_target(control_lejano_saija, select_control_lejano_saija(lejano_saija)),

    NULL
  )
}

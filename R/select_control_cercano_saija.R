select_control_cercano_saija <- function(cercano_saija) {
  muestra <- cercano_saija |>
    group_by(grado) |>
    mutate(n_benef = sum(as.numeric(beneficiaria))) |>
    ungroup() |>
    filter(beneficiaria == 0) |>
    slice_sample(n = 40, weight_by = n_benef, replace = FALSE)

  remplazos <- cercano_saija |>
    group_by(grado) |>
    mutate(n_benef = sum(as.numeric(beneficiaria))) |>
    ungroup() |>
    filter(beneficiaria == 0) |>
    anti_join(muestra, by = "number") |>
    slice_sample(n = 80, weight_by = n_benef, replace = FALSE)

  writexl::write_xlsx(
    list(muestra = muestra, reemplazos = remplazos),
    efun::timestamp_it("output/control_cercano_saija.xlsx")
  )

  list(muestra = muestra, reemplazos = remplazos)
}


select_control_lejano_saija <- function(lejano_saija) {
  muestra <- lejano_saija |>
    group_by(grado) |>
    mutate(grado_size = n()) |>
    ungroup() |>
    slice_sample(n = 40, weight_by = grado_size, replace = FALSE)

  remplazos <- lejano_saija |> anti_join(muestra, by = "id")

  writexl::write_xlsx(
    list(muestra = muestra, reemplazos = remplazos),
    efun::timestamp_it("output/control_lejano_saija.xlsx")
  )

  list(muestra = muestra, reemplazos = remplazos)
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
build_field_report <- function(
  siviru_field_report,
  usaraga_field_report,
  sirenas_field_report,
  saija_field_report,
  acapa_field_report,
  raices_field_report,
  mariposas_field_report,
  asogesampa_field_report
) {
  siviru_field_report_loc <- siviru_field_report
  usaraga_field_report_loc <- usaraga_field_report
  sirenas_field_report_loc <- sirenas_field_report
  saija_field_report_loc <- saija_field_report
  acapa_field_report_loc <- acapa_field_report
  raices_field_report_loc <- raices_field_report
  mariposas_field_report_loc <- mariposas_field_report
  asogesampa_field_report_loc <- asogesampa_field_report
  names(siviru_field_report_loc) <- paste0("SIVIRU_", names(siviru_field_report))
  names(usaraga_field_report_loc) <- paste0("USARAGA_", names(usaraga_field_report))
  names(sirenas_field_report_loc) <- paste0("SIRENAS_", names(sirenas_field_report))
  names(saija_field_report_loc) <- paste0("SAIJA_", names(saija_field_report))
  names(acapa_field_report_loc) <- paste0("ACAPA_", names(acapa_field_report))
  names(raices_field_report_loc) <- paste0("RAICES_", names(raices_field_report))
  names(mariposas_field_report_loc) <- paste0(
    "MARIPOSAS_",
    names(mariposas_field_report)
  )
  names(asogesampa_field_report_loc) <- paste0(
    "ASOGESAMPA_",
    names(asogesampa_field_report)
  )
  field_report <- c(
    siviru_field_report_loc,
    usaraga_field_report_loc,
    sirenas_field_report_loc,
    saija_field_report_loc,
    acapa_field_report_loc,
    raices_field_report_loc,
    mariposas_field_report_loc,
    asogesampa_field_report_loc
  )
  writexl::write_xlsx(
    field_report,
    efun::timestamp_it("output/registros_subidos.xlsx")
  )
  field_report
}

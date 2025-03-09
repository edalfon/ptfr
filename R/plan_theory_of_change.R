#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#' https://datastorm-open.github.io/visNetwork/layout.html
#'
#' @title
# https://visjs.github.io/vis-network/examples/
#' @return
#' @author edalfon
#' @export
plan_theory_of_change <- function() {
  list(
    tar_target(toc_raw, ingest_graph_data("data/toc/toc.xlsx")),
    tar_target(toc, visualize_graph(toc_raw)),

    # ptf on organizations
    tar_file(toc_ptf_file, "data/toc/toc_ptf.xlsx"),
    tar_target(toc_ptf_raw, ingest_graph_data(toc_ptf_file)),
    tar_target(toc_ptf, visualize_graph(toc_ptf_raw)),

    # PCN
    tar_file(toc_pcn_file, "data/toc/toc_pcn.xlsx"),
    tar_target(toc_pcn_raw, ingest_graph_data(toc_pcn_file)),
    tar_target(toc_pcn, visualize_graph(toc_pcn_raw)),

    # CEAF
    tar_file(toc_ceaf_file, "data/toc/toc_ceaf.xlsx"),
    tar_target(toc_ceaf_raw, ingest_graph_data(toc_ceaf_file)),
    tar_target(toc_ceaf, visualize_graph(toc_ceaf_raw)),

    # JCC
    tar_file(toc_jcc_file, "data/toc/toc_jcc.xlsx"),
    tar_target(toc_jcc_raw, ingest_graph_data(toc_jcc_file)),
    tar_target(toc_jcc, visualize_graph(toc_jcc_raw)),

    # put all tocs together in a single page
    tar_render(toc_all, "notebooks/viz_toc.Rmd"),

    # end
    NULL
  )
}

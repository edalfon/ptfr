#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
ingest_graph_data <- function(filepath = "data/toc.xlsx") {
  nodes_raw <- readxl::read_excel(filepath, sheet = "nodes")
  edges_raw <- readxl::read_excel(filepath, sheet = "edges")

  nodes <- nodes_raw |>
    dplyr::mutate(id = efun::normalize_text(label)) |>
    dplyr::filter(!is.na(label)) |>
    dplyr::mutate(label = stringr::str_wrap(label, 20)) |>
    dplyr::mutate(
      title = title |>
        stringr::str_wrap(50) |>
        stringr::str_replace_all("\n", "<br>")
    ) |>
    dplyr::select(id, label, group, value, title, shape, level)

  edged_nodes <- c(edges_raw$from, edges_raw$to) |>
    na.omit() |>
    unique()
  missing_nodes <- edged_nodes[
    !(efun::normalize_text(edged_nodes) %in% nodes$id)
  ]
  if (length(missing_nodes) > 0) {
    warning(
      "Nodes in edges data.frame, but missing in nodes (adding them!!!): \n",
      paste(missing_nodes, collapse = "\n")
    )
    nodes <- bind_rows(nodes, data.frame(
      id = efun::normalize_text(missing_nodes),
      label = missing_nodes
    ))
  }

  edges <- edges_raw |>
    dplyr::mutate(dplyr::across(c(from, to), efun::normalize_text)) |>
    dplyr::mutate(dashes = as.logical(dashes)) |>
    dplyr::filter(!is.na(from)) |>
    dplyr::filter(!is.na(to)) |>
    dplyr::mutate(
      title = title |>
        stringr::str_wrap(50) |>
        stringr::str_replace_all("\n", "<br>")
    ) |>
    dplyr::select(from, to, label, title, dashes)

  # at least for now, remove all nodes without any edges
  # nodes <- nodes |>
  #   filter(id %in% efun::normalize_text(edged_nodes))


  list(nodes = nodes, edges = edges)
}

#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title
#' @param toc_raw
#' @return
#' @author edalfon
#' @export
visualize_graph <- function(toc_raw) {
  nodes <- toc_raw$nodes
  edges <- toc_raw$edges
  visNetwork::visNetwork(nodes, edges, width = "100%") |>
    visNetwork::visEdges(arrows = "to") |>
    # visNetwork::visLayout(randomSeed = 1) |>
    visNetwork::visInteraction(tooltipDelay = 100, multiselect = TRUE) |>
    visNetwork::visHierarchicalLayout(direction = "LR") |>
    # visNetwork::visPhysics(barnesHut = list(avoidOverlap = 0.1)) |>
    # visNetwork::visIgraphLayout(layout = "layout_nicely",
    #                             physics = FALSE) |>
    # visNetwork::visPhysics(
    #   solver = "forceAtlas2Based",
    #   forceAtlas2Based = list(
    #     gravitationalConstant = -50,
    #     springLength = 200 / 1,
    #     avoidOverlap = 0.00,
    #     springConstant = 0.09
    #   )
    # ) |>
    visNetwork::visOptions(
      # nodesIdSelection = list(enabled = TRUE),
      collapse = FALSE,
      highlightNearest = list(
        enabled = TRUE,
        degree = 7, # list(from = -20, to = 20), # 1,
        algorithm = "hierarchical",
        hideColor = "rgba(200, 200, 200, 0.2)"
      )
    ) |>
    # TODO: here was just trying to control the order of the legend,
    # either via group options or the group variable factor order
    # but it does not seem to work
    # Apparently, what matters is the order in which the nodes appear in the
    # nodes data.frame, so make sure they have the right order
    # visNetwork::visGroups(groupname = "Stakeholder", color = "lightblue") |>
    # visNetwork::visGroups(groupname = "Milestone", color = "red") |>
    visNetwork::visLegend(width = 0.1)
}

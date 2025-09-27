#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
geom_percent <- function(...) {
  geom_text(
    aes(
      y = after_stat(count),
      label = scales::percent(after_stat(count) / sum(after_stat(count)), 0.1)
    ),
    stat = "count",
    vjust = 0, # inward
    #nudge_y = -0.2,
    fontface = "bold",
    ...
  )
}

geom_percent_h <- function(...) {
  geom_text(
    aes(
      x = after_stat(count),
      label = scales::percent(after_stat(count) / sum(after_stat(count)), 0.1)
    ),
    stat = "count",
    hjust = "inward",
    #nudge_y = -0.2,
    fontface = "bold",
    ...
  )
}

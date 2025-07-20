#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
sim_pvalues <- function(n_draws = 100, data_fn, pval_fn, ...) {
  # calculate the fraction of recicla, by tto and cercano
  set.seed(7)
  seeds <- runif(n_draws, 0, n_draws * 1000) |> round() |> unique()

  datasets <- lapply(seeds, data_fn, ...)

  pvalues <- sapply(datasets, pval_fn)
  pvalues
}


#' Generate Multiple Simulated Datasets with Different Parameter Combinations
#'
#' This function creates multiple simulated datasets by combining different
#' parameter values and random seeds. It uses the provided data generation
#' function to create datasets for each unique combination of parameters.
#'
#' @param data_fn A function that generates data. This function should accept
#' parameters that will be passed through the ... argument.
#' @param n_draws Integer. The number of different random seeds to use (default: 10).
#' @param ... Named parameters to be combined for data generation. These
#' parameters will be expanded into a grid of all possible combinations.
#'
#' @return A tibble containing:
#'   * The generated data for each combination (in the 'result' column)
#'   * The seed used for each generation
#'   * The parameter values used for each generation
#'
#' @details
#' The function:
#' 1. Generates a set of unique random seeds
#' 2. Creates all possible combinations of the provided parameters
#' 3. Applies the data generation function to each combination
#' 4. Returns the results in a tidy format
#'
#' @examples
#' # Generate normal distributions with different means and standard deviations
#' sim_data_combinations(
#'   rnorm,
#'   n_draws = 3,
#'   n = 100,
#'   mean = c(0, 1),
#'   sd = c(1, 2)
#' )
sim_data_combinations <- function(data_fn, n_draws = 10, seed_of_seeds = 7, ...) {
  set.seed(seed_of_seeds)
  seed <- runif(n_draws, 0, n_draws * 1000) |> round() |> unique()

  combinations <- tidyr::expand_grid(seed, ...)
  logger::log_info(
    "Generating {nrow(combinations)} datasets ",
    "using {deparse(substitute(data_fn))}()"
  )

  if (rlang::is_interactive()) {
    future::plan(future::sequential)
  } else {
    future::plan(future::multisession)
  }

  tictoc::tic("Generating datasets")
  data_generated <- combinations |>
    # purrr::pmap(data_fn) |>
    furrr::future_pmap(data_fn) |>
    tibble::tibble(data_draw = _) |>
    bind_cols(combinations)
  tictoc::toc()

  data_generated
}

sim_fit_pvalues <- function(sim_data, fit_fn) {
  if (rlang::is_interactive()) {
    future::plan(future::sequential)
  } else {
    future::plan(future::multisession)
  }

  tictoc::tic("Fitting models")
  y <- sim_data |> mutate(pval = furrr::future_map_dbl(data_draw, fit_fn))
  tictoc::toc()

  y
}

plot_power <- function(data) {
  # data <- targets::tar_read(usuraga_pvals)
  data |>
    rowwise() |>
    mutate(power = sum(pval < 0.05) / length(pval)) |>
    #mutate(effect_size = as.character(effect_size)) |>
    group_by(sample_size, effect_size) |>
    summarise(power = mean(power)) |>
    ggplot(aes(
      x = sample_size,
      y = power,
      group = effect_size,
      color = effect_size
    )) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept = 0.8, linetype = "dashed") +
    theme_minimal() +
    scale_color_continuous("Tamaño \n del efecto") +
    #theme(legend.position = "bottom") +
    labs(x = "Tamaño de la muestra", y = "Poder estadístico")
}

sim_appla_data_draw <- function(sim_data) {
  if (rlang::is_interactive()) {
    future::plan(future::sequential)
  } else {
    future::plan(future::multisession)
  }

  y <- sim_data |>
    mutate(furrr::future_map_dfr(data_draw, \(x) {
      x |>
        group_by(grupo) |>
        summarise(autoconsumo = sum(autoconsumo) / n()) |>
        tidyr::pivot_wider(names_from = grupo, values_from = autoconsumo)
    }))

  y |>
    janitor::clean_names() |>
    mutate(sample_size = as.factor(sample_size)) |>
    ggplot(aes(x = sample_size, y = a_tto)) +
    geom_violin() +
    ggbeeswarm::geom_quasirandom(aes(color = effect_size))

  y |>
    janitor::clean_names() |>
    mutate(sample_size = as.factor(sample_size)) |>
    ggplot(aes(x = sample_size, y = b_cercano)) +
    geom_violin() +
    ggbeeswarm::geom_quasirandom(aes(color = effect_size))

  y |>
    janitor::clean_names() |>
    mutate(sample_size = as.factor(sample_size)) |>
    ggplot(aes(x = sample_size, y = c_lejano)) +
    geom_violin() +
    ggbeeswarm::geom_quasirandom(aes(color = effect_size))

  y |>
    janitor::clean_names() |>
    pivot_longer(
      cols = c(a_tto, b_cercano, c_lejano),
      names_to = "grupo",
      values_to = "autoconsumo"
    ) |>
    mutate(sample_size = as.factor(sample_size)) |>
    ggplot(aes(x = sample_size, y = autoconsumo)) +
    geom_violin(aes(fill = grupo), position = position_dodge(width = 0.9)) +
    ggbeeswarm::geom_quasirandom(
      aes(color = grupo),
      dodge.width = 0.9,
      varwidth = TRUE
    )

  y
}

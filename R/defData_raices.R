defData_raices <- function(
  seed = 1,
  sample_size = 150,
  effect_size = 0.5,
  spillover_size = 0.2
) {
  set.seed(seed)
  sim_data <- tibble::tibble(rowid = 1:sample_size) |>
    # mutate(x = rnorm(n(), 0, 1)) |>
    # mutate(y = rnorm(n(), 0, 1)) |>
    mutate(edad = rnorm(n(), 32, 2)) |>
    mutate(amistad = rnorm(n(), 10, 1)) |>
    mutate(cercania = 5 + 0.5 * amistad + rnorm(n(), 0, 1)) |>
    mutate(tto_score = -0.6 * edad + 0.5 * amistad + 0.3) |>
    mutate(tto = tto_score >= quantile(tto_score, 0.67)) |>
    mutate(cercano = cercania >= quantile(cercania, 0.67^2) & tto == 0) |>
    mutate(lejano = tto == 0 & cercano == 0) |>
    efun::assert(tto + cercano + lejano == 1) |>
    mutate(
      recicla_score = edad +
        amistad +
        effect_size * tto +
        spillover_size * cercano +
        rnorm(n(), 0, 1)
    ) |>
    mutate(recicla = recicla_score >= quantile(recicla_score, 0.25)) |>
    identity()

  #efun::abridge_df(sim_data)

  sim_data
}

fit_raices_cercano <- function(sim_data) {
  # fit a model to the data
  sim_data <- sim_data |> dplyr::filter(tto == 1 | cercano == 1)
  model <- glm(recicla ~ tto + edad, data = sim_data, family = binomial)
  broom::tidy(model) |> dplyr::filter(term %in% c("ttoTRUE")) |> pull(p.value)
}
fit_raices_lejano <- function(sim_data) {
  # fit a model to the data
  sim_data <- sim_data |> dplyr::filter(tto == 1 | lejano == 1)
  model <- glm(recicla ~ tto + edad, data = sim_data, family = binomial)
  broom::tidy(model) |> dplyr::filter(term %in% c("ttoTRUE")) |> pull(p.value)
}


gjgj <- function() {
  # calculate the fraction of recicla, by tto and cercano

  # Example vectors
  x <- c("A", "B")
  y <- c(1, 2)
  z <- c("a", "b")

  combinations <- tidyr::expand_grid(
    sample_size = seq(30, 150, 10),
    effect_size = seq(0.1, 0.9, 0.2),
    spillover_size = seq(0.1, 0.9, 0.2)
  )

  withpvals_lejano <- combinations |>
    rowwise() |>
    mutate(
      result = list(sim_pvalues(
        n_draws = 10,
        sample_size = sample_size,
        effect_size = effect_size,
        spillover_size = spillover_size,
        data_fn = defData_raices,
        pval_fn = fit_raices_lejano
      ))
    ) |>
    identity()

  withpvals_cercano <- combinations |>
    rowwise() |>
    mutate(
      result = list(sim_pvalues(
        n_draws = 10,
        sample_size = sample_size,
        effect_size = effect_size,
        spillover_size = spillover_size,
        data_fn = defData_raices,
        pval_fn = fit_raices_cercano
      ))
    ) |>
    identity()

  withpvals_lejano |>
    rowwise() |>
    mutate(power = sum(result < 0.05) / length(result)) |>
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
    geom_hline(yintercept = 0.8, linetype = "dashed")

  withpvals_lejano |>
    rowwise() |>
    mutate(power = sum(result < 0.05) / length(result)) |>
    group_by(sample_size, spillover_size) |>
    summarise(power = mean(power)) |>
    ggplot(aes(
      x = sample_size,
      y = power,
      group = spillover_size,
      color = spillover_size
    )) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept = 0.8, linetype = "dashed")

  withpvals_cercano <- combinations |>
    rowwise() |>
    mutate(
      result = list(sim_pvalues(
        sample_size = sample_size,
        spillover_size = spillover_size,
        data_fn = defData_raices,
        pval_fn = fit_raices_cercano,
      ))
    ) |>
    identity()

  withpvals_cercano |>
    rowwise() |>
    mutate(power = sum(result < 0.05)) |>
    ggplot(aes(
      x = sample_size,
      y = power,
      group = effect_size,
      color = effect_size
    )) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept = 80, linetype = "dashed")
}

# after fiddling with simstudy::logisticCoefs and so on, it seems to me that
# the convenience of simstudy does not compensate the loss on flexibility
# so I will just do it in plain R and tidyverse

# simstudy::defData("edad", 30, 2, "normal") |>
# # simstudy::defData("mujer", "-2 + edad * 0.1", 0, "binary", "logit") |>
# simstudy::defData("amistad", 10, 1, "normal") |>

# tratamiento_coefs <- simstudy::logisticCoefs(data_defs, c(-0.6, 0.5, 0), 0.3)
# names(tratamiento_coefs)[1] <- 1
# tratamiento_formula <- paste(
#   sprintf("%f * %s", tratamiento_coefs, names(tratamiento_coefs)),
#   collapse = " + "
# )
# data_defs <- data_defs |>
#   simstudy::defData(
#     "tratamiento",
#     tratamiento_formula,
#     0,
#     "binary",
#     "logit"
#   )
# |>
#   simstudy::defData(
#     varname = "cercano",
#     formula = "-1 + 0.5 * amistad * (1 - tratamiento)",
#     dist = "binary",
#     link = "logit"
#   ) |>
#   simstudy::defData(
#     "recicla",
#     "2 - 0.2 * edad + 0.3 * mujer + 0.7 * tratamiento",
#     0,
#     "binary",
#     "logit"
#   ) |>
#   identity()

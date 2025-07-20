sim_acapa <- function() {
  # simulate data
  tar_target(
    acapa_data,
    sim_data_combinations(
      data_fn = sim_data_acapa,
      n_draws = 100,
      sample_size = seq(30, 150, 10),
      base_rate = 0.169,
      effect_size = seq(0.05, 0.30, 0.05)
      #spillover_size = seq(0.1, 0.9, 0.2)
    )
  )

  # fit model to simulated data
  tar_target(withpvals_lejano, sim_fit_pvalues(acapa_data, fit_acapa_lejano))
  #tar_target(withpvals_cercano, sim_fit_pvalues(acapa_data, fit_acapa_cercano))

  tar_target(acapa_power_plot, plot_power(withpvals_lejano))
  #tar_target(plot_me2, plot_power(withpvals_cercano))
}

sim_data_acapa <- function(
  seed = 1,
  sample_size = 150,
  base_rate = 0.529,
  effect_size = 0.05,
  spillover_size = 0.01
) {
  set.seed(seed)
  sim_data <- tibble::tibble(rowid = 1:sample_size) |>
    mutate(
      # Covariates
      edad = rnorm(n(), 40, 4),
      ingreso = rgamma(n(), 10, 1),
      amistad = rnorm(n(), 10, 1), # not observable

      # Treatment assignment
      log_odds_tto = qlogis(0.33) + -0.15 * scale(edad) + 0.9 * scale(amistad),
      p_tto = 1 / (1 + exp(-log_odds_tto)),
      tto = rbinom(n = n(), size = 1, prob = p_tto),

      cercania = qlogis(0.60) + 0.99 * scale(amistad) - 100 * tto,
      p_cercano = 1 / (1 + exp(-cercania)),
      cercano = rbinom(n = n(), size = 1, prob = p_cercano),
      #cercano = cercania >= quantile(cercania, 0.67^2) & tto == 0,

      lejano = as.integer(tto == 0 & cercano == 0),
      grupo = case_when(
        tto == 1 ~ "A. tto",
        cercano == 1 ~ "B. cercano",
        lejano == 1 ~ "C. lejano"
      ),

      b_edad = 1.7,
      b_amistad = 1.8,
      b_ingreso = -1.9,
      logodds_mean = 0 +
        b_edad * mean(scale(edad)) +
        b_amistad * mean(scale(amistad)) +
        b_ingreso * mean(scale(ingreso)),

      b_0 = logit(base_rate) - logodds_mean,
      b_tto = logit(base_rate + effect_size) - logit(base_rate),
      b_spillover = logit(base_rate + spillover_size) - logit(base_rate),

      autoconsumo_score = b_0 +
        b_edad * scale(edad) +
        b_amistad * scale(amistad) -
        b_ingreso * scale(ingreso) +
        b_tto * tto +
        b_spillover * cercano,
      p_autoconsumo = 1 / (1 + exp(-autoconsumo_score)),
      autoconsumo = rbinom(n = n(), size = 1, prob = p_autoconsumo)
    ) |>
    efun::assert(tto + cercano + lejano == 1) |>
    identity()

  sim_data
}

logit <- function(p) log(p / (1 - p))
inv_logit <- function(x) 1 / (1 + exp(-x))

x <- function() {
  devtools::load_all()
  sim_data <- sim_data_acapa(round(runif(1) * 500))
  efun::abridge_df(sim_data)
  sim_data |> group_by(grupo) |> summarise(autoconsumo = sum(autoconsumo) / n())
  # Fit the model
  mod <- glm(tto ~ edad + amistad + ingreso, data = sim_data, family = binomial)
  summary(mod)
  plot(effects::Effect("edad", mod), type = "response")
  plot(effects::Effect("amistad", mod), type = "response")
  plot(effects::Effect("ingreso", mod), type = "response")
  mod <- glm(
    autoconsumo ~ tto + edad + ingreso,
    data = sim_data |> dplyr::filter(cercano == 0),
    family = binomial
  )
  summary(mod)
  mod <- glm(autoconsumo ~ tto, data = sim_data, family = binomial)
  summary(mod)
  plot(effects::Effect("tto", mod), type = "response")
}

#microbenchmark::microbenchmark(sim_data_acapa(), sim_data_acapa2())

fit_acapa_cercano <- function(sim_data) {
  #sim_data <- sim_data |> dplyr::filter(tto == 1 | cercano == 1)
  model <- glm(
    autoconsumo ~ tto + cercano + edad + ingreso,
    data = sim_data,
    family = binomial
  )
  broom::tidy(model) |> dplyr::filter(term %in% c("tto")) |> pull(p.value)
}

fit_acapa_lejano <- function(sim_data) {
  sim_data <- sim_data |> dplyr::filter(tto == 1 | lejano == 1)
  model <- glm(
    autoconsumo ~ tto + edad + ingreso,
    data = sim_data,
    family = binomial
  )
  broom::tidy(model) |> dplyr::filter(term %in% c("tto")) |> pull(p.value)
}

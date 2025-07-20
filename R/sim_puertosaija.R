sim_puertosaija <- function() {
  # simulate data
  tar_target(
    puertosaija_data,
    sim_data_combinations(
      data_fn = sim_data_puertosaija,
      n_draws = 100,
      sample_size = seq(30, 150, 10),
      base_rate = 0.739,
      effect_size = seq(0.05, 0.25, 0.05)
      #spillover_size = seq(0.1, 0.9, 0.2)
    )
  )

  # fit model to simulated data
  tar_target(
    puertosaija_pvals,
    sim_fit_pvalues(puertosaija_data, fit_puertosaija_lejano)
  )
  #tar_target(withpvals_cercano, sim_fit_pvalues(acapa_data, fit_acapa_cercano))

  tar_target(puertosaija_power_plot, plot_power(puertosaija_pvals))
  #tar_target(plot_me2, plot_power(withpvals_cercano))
}

# TODO:
# Improvement: Introduce interactions between treatment/spillover indicators and covariates in the outcome equation to simulate heterogeneous effects. For example, the treatment effect could be larger for individuals with higher education.
# Why: Many real-world interventions have effects that vary across individuals. Simulating heterogeneous effects allows testing methods that can estimate these variations.
# Clustering: If treatment or spillovers operate at a group level, explicitly simulate data with a clustered structure.

sim_data_puertosaija <- function(
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
      educ = rgamma(n(), 10, 1),
      amistad = rnorm(n(), 10, 1), # not observable

      #standardize
      edad_s = scale(edad)[, 1],
      educ_s = scale(educ)[, 1],
      amistad_s = scale(amistad)[, 1],

      # Treatment assignment
      log_odds_tto = qlogis(0.33) + -0.6 * edad_s + 0.9 * amistad_s + 0.7 * educ_s,
      p_tto = plogis(log_odds_tto),
      tto = rbinom(n = n(), size = 1, prob = p_tto),

      #cercania = qlogis(0.60) + 0.99 * amistad_s - 100 * tto,
      #p_cercano = 1 / (1 + exp(-cercania)),
      p_cercano = plogis(qlogis(0.60) + 0.99 * amistad_s),
      p_cercano = if_else(tto == 1, 0, p_cercano),
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
      b_educ = -1.9,
      logodds_mean = 0 +
        b_edad * mean(edad_s) +
        b_amistad * mean(amistad_s) +
        b_educ * mean(educ_s),

      b_0 = qlogis(base_rate) - logodds_mean,
      b_tto = qlogis(base_rate + effect_size) - qlogis(base_rate),
      b_spillover = qlogis(base_rate + spillover_size) - qlogis(base_rate),

      recicla_score = b_0 +
        b_edad * edad_s +
        b_amistad * amistad_s -
        b_educ * educ_s +
        b_tto * tto +
        b_spillover * cercano,
      p_recicla = plogis(recicla_score),
      recicla = rbinom(n = n(), size = 1, prob = p_recicla)
    ) |>
    efun::assert(tto + cercano + lejano == 1) |>
    identity()

  sim_data
}

logit <- function(p) log(p / (1 - p)) # qlogis
inv_logit <- function(x) 1 / (1 + exp(-x)) # plogis

x <- function() {
  devtools::load_all()
  sim_data <- sim_data_puertosaija(round(runif(1) * 500))
  efun::abridge_df(sim_data)
  sim_data |> group_by(grupo) |> summarise(recicla = sum(recicla) / n())
  # Fit the model
  mod <- glm(tto ~ edad + amistad + educ, data = sim_data, family = binomial)
  summary(mod)
  plot(effects::Effect("edad", mod), type = "response")
  plot(effects::Effect("amistad", mod), type = "response")
  plot(effects::Effect("educ", mod), type = "response")
  mod <- glm(
    recicla ~ tto + edad + educ,
    data = sim_data |> dplyr::filter(cercano == 0),
    family = binomial
  )
  summary(mod)
  mod <- glm(recicla ~ tto, data = sim_data, family = binomial)
  summary(mod)
  plot(effects::Effect("tto", mod), type = "response")
}

#microbenchmark::microbenchmark(sim_data_acapa(), sim_data_acapa2())

fit_puertosaija_cercano <- function(sim_data) {
  #sim_data <- sim_data |> dplyr::filter(tto == 1 | cercano == 1)
  model <- glm(
    recicla ~ tto + cercano + edad + educ,
    data = sim_data,
    family = binomial
  )
  broom::tidy(model) |> dplyr::filter(term %in% c("tto")) |> pull(p.value)
}

fit_puertosaija_lejano <- function(sim_data) {
  sim_data <- sim_data |> dplyr::filter(tto == 1 | lejano == 1)
  model <- glm(recicla ~ tto + edad + educ, data = sim_data, family = binomial)
  broom::tidy(model) |> dplyr::filter(term %in% c("tto")) |> pull(p.value)
}

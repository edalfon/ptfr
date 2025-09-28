x <- function() {
  tar_target(A, mtcars)
}


plan_simulation <- function() {
  list(
    #tar_target(firsim, defData_raices()),

    #lapply(as.list(body(x))[-1], eval),
    lapply(as.list(body(sim_acapa))[-1], eval),
    lapply(as.list(body(sim_raices))[-1], eval),
    lapply(as.list(body(sim_sirenas))[-1], eval),
    lapply(as.list(body(sim_asogesampa))[-1], eval),
    lapply(as.list(body(sim_mariposas))[-1], eval),
    lapply(as.list(body(sim_puertosaija))[-1], eval),
    lapply(as.list(body(sim_siviru))[-1], eval),
    lapply(as.list(body(sim_usuraga))[-1], eval),

    tar_quarto(sim_slides, "slides/slides.qmd", quiet = FALSE),

    #sim_acapa(),

    tar_target(sdfsdf, {
      return(1)
      library(simstudy)
      #library(data.table)
      library(dplyr)
      library(broom)

      # ----- 1. Definición de la Generación de Datos con simstudy -----

      # Definimos las características base de la población
      def <- defData(
        varname = "edad", # Nombre de la variable
        formula = 35, # Media de edad
        variance = 50, # Varianza de edad (DE approx 7 años)
        dist = "normal"
      ) # Distribución normal

      def <- defData(
        def,
        varname = "mujer", # Variable binaria para género (1=mujer, 0=otro)
        formula = 0.5, # Proporción esperada de mujeres
        dist = "binary"
      ) # Distribución binaria

      def <- defData(
        def,
        varname = "habilidad", # Otra variable de caracterización (ej. habilidad inicial)
        formula = "5;15", # Rango de la variable (uniforme entre 5 y 15)
        dist = "uniform"
      ) # Distribución uniforme

      # Definimos una variable latente de 'amistad' (ej. puntuación de conexión social)
      # Podría depender de características base, pero la haremos independiente por simplicidad
      def <- defData(
        def,
        varname = "amistad_score",
        formula = 0, # Media
        variance = 1, # Varianza (DE=1)
        dist = "normal"
      )

      # Definimos la asignación al tratamiento (Z)
      # Queremos que esté positivamente relacionada con 'amistad_score'
      # Usaremos una función logística. Ajustaremos el intercepto para que P(Z=1) sea aprox 1/3.
      # plogis(intercepto + coef_amistad * amistad_score)
      # Probemos con intercepto = -1 y coef_amistad = 0.8 (positivo)
      # Un intercepto de -0.7 da una probabilidad media cercana a 1/3 si amistad_score es N(0,1)
      def <- defData(
        def,
        varname = "Z",
        formula = "-0.7 + 0.8 * amistad_score",
        dist = "binary.logit"
      ) # Genera variable binaria usando enlace logit

      # Definimos la variable de resultado (outcome 'Y')
      # Dependerá de características base y del tratamiento (Z)
      # Asumimos un efecto del tratamiento de +4 unidades en Y
      efecto_tratamiento_real <- 4
      def <- defData(
        def,
        varname = "Y",
        formula = "10 + 0.2*edad - 1.5*mujer + 0.8*habilidad + ..efecto_tratamiento_real*Z",
        variance = 9
      ) # Ruido aleatorio con DE=3

      # ----- 2. Generación de los Datos -----

      set.seed(123) # Para reproducibilidad
      N <- 150 # Tamaño de la muestra (aproximadamente divisible por 3)

      dtSim <- genData(N, def)

      # ----- 3. Creación de los Grupos: Tratamiento, Control Cercano, Control Lejano -----

      # Los controles (Z=0) se dividirán aleatoriamente en 'Cercano' y 'Lejano'
      # Queremos que cada uno de los 3 grupos finales (Tratamiento, C. Cercano, C. Lejano)
      # tenga aproximadamente 1/3 de la muestra total.

      # Primero, identificamos a los controles
      controles_idx <- which(dtSim$Z == 0)
      n_controles <- length(controles_idx)

      # Asignamos aleatoriamente la mitad de los controles a 'Cercano' (1) y la otra a 'Lejano' (0)
      set.seed(456) # Otra semilla para esta asignación
      asignacion_control <- sample(
        c(1, 0),
        size = n_controles,
        replace = TRUE,
        prob = c(0.5, 0.5)
      )

      # Creamos la variable 'tipo_control' (1=Cercano, 0=Lejano, NA si Tratamiento)
      dtSim[, tipo_control := NA_integer_]
      dtSim[controles_idx, tipo_control := asignacion_control]

      # Creamos la variable categórica final 'grupo'
      dtSim[,
        grupo := factor(
          fifelse(
            Z == 1,
            "Tratamiento",
            fifelse(tipo_control == 1, "Control Cercano", "Control Lejano")
          ),
          levels = c("Tratamiento", "Control Cercano", "Control Lejano")
        )
      ]

      # Verificamos los tamaños de los grupos (deberían ser cercanos a N/3)
      cat("\nTamaño de los grupos generados:\n")
      print(dtSim[, .N, by = grupo])
      cat("\nProporción en cada grupo:\n")
      print(dtSim[, .N / nrow(dtSim), by = grupo])

      # ----- 4. Estimación del Efecto del Tratamiento usando Modelos Lineales -----

      # Queremos estimar E[Y|Z=1] - E[Y|Control Cercano] y E[Y|Z=1] - E[Y|Control Lejano]
      # ajustando por las covariables de caracterización (edad, mujer, habilidad)

      # --- Modelo 1: Comparando Tratamiento vs. Control Cercano ---

      # Filtramos los datos para incluir solo Tratamiento y Control Cercano
      dt_vs_cercano <- dtSim[grupo %in% c("Tratamiento", "Control Cercano")]

      # Ajustamos el modelo lineal. R usará 'Control Cercano' como referencia por defecto
      # si reordenamos los niveles o si viene primero alfabéticamente después de filtrar.
      # O podemos especificar la referencia explícitamente.
      dt_vs_cercano[, grupo := relevel(grupo, ref = "Control Cercano")]

      modelo_cercano <- lm(
        Y ~ grupo + edad + mujer + habilidad,
        data = dt_vs_cercano
      )

      cat("\n--- Resumen del Modelo: Tratamiento vs. Control Cercano ---\n")
      summary(modelo_cercano)

      # Extraer el coeficiente de interés (efecto de Tratamiento vs Control Cercano)
      tidy_cercano <- tidy(modelo_cercano)
      efecto_estimado_cercano <- tidy_cercano %>% filter(term == "grupoTratamiento")

      cat("\nEstimación del Efecto (Tratamiento vs Control Cercano):\n")
      print(efecto_estimado_cercano)

      # --- Modelo 2: Comparando Tratamiento vs. Control Lejano ---

      # Filtramos los datos para incluir solo Tratamiento y Control Lejano
      dt_vs_lejano <- dtSim[grupo %in% c("Tratamiento", "Control Lejano")]

      # Ajustamos el modelo lineal, poniendo 'Control Lejano' como referencia
      dt_vs_lejano[, grupo := relevel(grupo, ref = "Control Lejano")]

      modelo_lejano <- lm(Y ~ grupo + edad + mujer + habilidad, data = dt_vs_lejano)

      cat("\n--- Resumen del Modelo: Tratamiento vs. Control Lejano ---\n")
      summary(modelo_lejano)

      # Extraer el coeficiente de interés (efecto de Tratamiento vs Control Lejano)
      tidy_lejano <- tidy(modelo_lejano)
      efecto_estimado_lejano <- tidy_lejano %>% filter(term == "grupoTratamiento")

      cat("\nEstimación del Efecto (Tratamiento vs Control Lejano):\n")
      print(efecto_estimado_lejano)

      # --- Comparación y Conclusión ---
      cat("\n--- Comparación de Estimaciones ---\n")
      cat(sprintf(
        "Efecto Real del Tratamiento (simulado): %.2f\n",
        efecto_tratamiento_real
      ))
      cat(sprintf(
        "Efecto Estimado (Tratamiento vs Control Cercano): %.2f (p=%.3f)\n",
        efecto_estimado_cercano$estimate,
        efecto_estimado_cercano$p.value
      ))
      cat(sprintf(
        "Efecto Estimado (Tratamiento vs Control Lejano): %.2f (p=%.3f)\n",
        efecto_estimado_lejano$estimate,
        efecto_estimado_lejano$p.value
      ))

      # Nota: Las diferencias entre las estimaciones vs Control Cercano y vs Control Lejano
      # pueden surgir si la variable 'amistad_score' (que influye en Z) también está
      # correlacionada (directa o indirectamente a través de otras variables omitidas)
      # con el resultado 'Y' de una forma no capturada completamente por las covariables
      # incluidas en el modelo. En esta simulación simple, donde 'amistad_score' no entra
      # directamente en la fórmula de Y, las estimaciones deberían ser similares y cercanas
      # al efecto real (+4), dentro del error muestral.
    }),

    NULL
  )
}

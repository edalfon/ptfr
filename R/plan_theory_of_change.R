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

# Pregunta 2:
# ¿Cómo ha impactado el programa en el fortalecimiento de capacidades del equipo humano de las organizaciones?

# Evidencias cuantitativas:
# Número de capacitaciones ofrecidas y porcentaje de participación.
# Cantidad de horas de formación recibidas por persona.
# Cambio en la percepción de competencias antes y después del programa (medido en encuestas).
# Número de nuevas habilidades adquiridas por los equipos según autoevaluación.
# Categorías cualitativas:
# Tipos de conocimientos y habilidades adquiridos.
# Utilidad percibida de la formación en el trabajo diario.
# Limitaciones en la aplicación de lo aprendido.
# Demandas adicionales de formación no cubiertas por el programa.
# Si quieres más preguntas o ajustar las existentes, dime cómo seguimos.

# Pregunta 2:
# ¿Cómo ha impactado el acceso a recursos tecnológicos en la ejecución de los proyectos?

# Evidencias cuantitativas:
# Número de tareas o procesos optimizados gracias a la tecnología.
# Porcentaje de organizaciones que reportan mejoras en eficiencia debido a recursos tecnológicos.
# Cantidad de capacitaciones realizadas sobre el uso de tecnología.
# Nivel de adopción de nuevas herramientas digitales antes y después del programa.
# Categorías cualitativas:
# Principales usos de la tecnología dentro del programa.
# Beneficios percibidos en términos de comunicación, gestión y monitoreo.
# Barreras para la adopción tecnológica (falta de formación, costos, resistencia al cambio).
# Necesidades tecnológicas no cubiertas por el programa.
# Dime si quieres más detalles o ajustar algo.

#

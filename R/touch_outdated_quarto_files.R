#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
touch_outdated_quarto_files <- function() {
  {
    quarto_dir <- "quartobook"
    pattern <- "\\.(qmd|Rmd)$"
    # Get outdated targets
    outdated_targets <- tar_outdated()
    print("___________________________________________")
    print("Outdated targets:")
    print(outdated_targets)
    print("___________________________________________")

    if (length(outdated_targets) == 0) {
      return(character(0))
    }

    # Find all Quarto files
    quarto_files <- list.files(
      path = quarto_dir,
      pattern = pattern,
      recursive = TRUE,
      full.names = TRUE
    )

    if (length(quarto_files) == 0) {
      return(character(0))
    }

    # Check each Quarto file
    files_with_outdated <- character(0)

    for (file in quarto_files) {
      targets_in_file <- tarchetypes::tar_knitr_deps(file)

      # Check if any targets in this file are outdated
      if (any(targets_in_file %in% outdated_targets)) {
        files_with_outdated <- c(files_with_outdated, file)
      }
    }

    print("===============================================")
    print("Quarto files with outdated targets:")
    print(files_with_outdated)
    print("===============================================")

    # Append a new line to each file to update its timestamp
    #fs::file_touch(files_with_outdated)
    for (f in files_with_outdated) {
      write("\n", file = f, append = TRUE)
    }

    files_with_outdated
  }
}

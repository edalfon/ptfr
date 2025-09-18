#' Recode Beneficiario Usaraga
#'
#' This function recodes the "beneficiario usaraga" variable to address a limitation in the original data collection process. Initially, the survey only asked whether a respondent was a beneficiary or not, without distinguishing between "control cercano" and "control lejano" groups. To resolve this, the function matches respondents with the sample to assign the appropriate control group classification.
#'
#' This recoding ensures accurate group assignment for subsequent analyses and reporting.
#'
#' @title Recode Beneficiario Usaraga
#' @return A data frame with updated group classifications for each respondent.
#' @author edalfon
#' @export
recode_beneficia_usaraga <- function(usaraga_survey) {
  cercano <- c(
    "e117ec9b-14e7-42ac-bf1f-18fb9a304586", #
    "1c4a0152-c96c-40b7-b3c8-3aa7f4726111", #
    "f8fea69d-99d5-4b61-b0cc-99fcf7f838dc", #
    "59d4b2a4-8cfa-45e5-9433-934eb4462182", #
    "eb1d26f3-98e8-4c2b-bea2-dcd1a1a86cd2", #
    "df9bb1f7-d991-44e2-8f80-46e40f0dd068", #
    "ca6643a3-5c8b-414d-85fc-fb937e8f16cc", #
    "16cd78d5-5a87-47bb-8ef0-5ad2e0e85d19", #
    "1c446f33-4a69-4406-b26e-0b572f8af048", #
    "68beeea3-5210-4886-8d4a-4a6222192fb7" #
  )

  lejano <- c(
    "dc943e14-e48f-4eae-b3ce-0bf1c9742f6f",
    "35e87d49-7594-4844-98cd-121aba74572a",
    "5dde7bb4-042b-40b0-b084-051042799de0",
    "c7c8da9d-bddf-418d-854a-939e0c688631",
    "62330a63-9339-41ea-a760-53b50911cc4a",
    "452ffdbb-6b87-4265-8484-40ac483c78a5",
    "78a183e1-ec31-4387-8f2a-164ff27dbc94",
    "371c5477-c1a6-4b99-8316-3fb5ae2fbd18"
  )

  usaraga_survey |>
    filter(beneficia == "No") |>
    select(ec5_uuid, nombre) |>
    efun::clipboard_writeto()

  usaraga_survey |> filter(beneficia == "No") |> pull(ec5_uuid) |> dput()

  usaraga_survey |>
    mutate(
      beneficia = case_when(
        ec5_uuid %in% cercano & beneficia == "No" ~ "Control Cercano",
        ec5_uuid %in% lejano & beneficia == "No" ~ "Control Lejano",
        beneficia == "Sí" ~ "Beneficiaria/o",
        TRUE ~ "Control Lejano" # TODO: check this
      )
    )
}

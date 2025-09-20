#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
recode_beneficia_sirenas <- function(sirenas_survey) {
  cercano <- c(
    "dd62eb0d-3a8f-4d37-b0ed-df1ddee6330d",
    "4bfbdba3-c1ba-4040-8d30-db89c78f60cb",
    "7350e8ef-be92-4b22-8503-f148fddd4f9f",
    "49b11e84-b0b4-4cd8-b5df-bc42d3abcb0f",
    "ff27aa07-27e1-4ecc-8876-8ac22cb1f14d",
    "b44d0943-3f63-4db3-89ae-afeb16665c47",
    "23956033-0630-4ece-b460-f2042e1c4f71",
    "b5c43d57-07b5-40b4-9a38-a953e1103c40",
    "c30dbbcb-6686-458c-ba02-ff35b08b310f",
    "dfaf031e-9082-460f-b2da-fbf5c4267197",
    "c6fd35b5-451c-4495-97e3-f1572302d0c5",
    "5f2ef3bc-a54a-4769-89f5-519db7e21b36",
    "497a5252-5f22-4adf-8315-11d60ca950b5",
    "90fcaa2b-dcd0-4904-8bd3-0c7a31e959a8",
    "af09f082-88fd-4afd-95d7-9d60dc9a5acc",
    "145844f7-5047-4b61-8206-0ea46577103b",
    "bbfa04a0-190c-4136-92d6-771f9ea28c8b"
  )

  lejano <- c(
    "e985bb19-afdb-48cd-a9a5-a2f1e3328c17", # Carmenza Olaya Orobio ≈ CARMENZA OLAYA
    "6fb4f5c5-23dc-47d9-a49a-befe1d3b4d95", # Díana Katerine Orobio Ortiz ≈ OLIVIA OROBIO
    "31c363dd-4528-447e-9837-3fb3090fc1b9", # Mitelia Sinisterra Segura ≈ MARLENI / YOLIMA SINISTERRA
    "af09f082-88fd-4afd-95d7-9d60dc9a5acc", # Ventura Moreno ≈ VENTURA MORAN
    "98b0b1b7-1b8e-4f6b-873c-197449279db2", # Ingrid Lorena Montaño Cortes ≈ INGRI LORENA MONTAÑO CORTEZ
    "20e711ef-7b35-4030-bec9-a9321de6470d", # Kelly Elisa ILLERAS Guerrero ≈ KELLY ELIZA ILLERAS GUERRERO
    "a5b54e67-f318-4899-8875-ab7006efd881", # Diana Marcela ILLERAS Guerreros ≈ DIANA MARCELA ILLERAS GUERRERO
    "9764f906-42d3-4677-aa86-b52fe15d5bf2", # Luisa Fernanda Caicedo Rengifo ≈ LUISA FERNANDA CAICEDO RINCON
    "712f209b-0f78-4fce-902e-3caed350f926", # Angie Lorena Lerma Solis ≈ ANGIE LORENA LERMA SOLIS
    "a97778a0-8863-409e-bf3d-270714b4eca0", # Keilin Dayana Lerma Solís ≈ KEILIN DAYANA LERMA SOLIS
    "371e4629-6729-4e21-8ce8-7c20135b451f", # Emir Indiana Rentería Torres ≈ EMIR RENTERIA
    "c40fea96-67db-4c0c-a643-a39ae523dfee", # Luz Marina Lerma Segura ≈ LUZ MARINA
    "daa8a0d7-2e6f-48e7-8322-ceec93bdd503", # Teodora Sinisterra Asprilla ≈ TEODORA SINISTERRA ASPRILLA
    "bbfa04a0-190c-4136-92d6-771f9ea28c8b" # Elvira TorresCampaz ≈ ELVIRA TORRES
  )

  # sirenas_survey_epicollect |>
  #   ptf_rename_vars() |>
  #   ptf_rename_vars_sirenas() |>
  #   filter(beneficia == "No") |>
  #   select(ec5_uuid, nombre) |>
  #   efun::clipboard_writeto()

  sirenas_survey |> filter(beneficia == "No") |> pull(ec5_uuid) |> dput()

  sirenas_survey |>
    mutate(
      beneficia = case_when(
        ec5_uuid %in% cercano & beneficia == "No" ~ "Control Cercano",
        ec5_uuid %in% lejano & beneficia == "No" ~ "Control Lejano",
        beneficia == "Sí" ~ "Beneficiaria/o",
        TRUE ~ NA_character_ # TODO: check this
      )
    )
}

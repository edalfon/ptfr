#' .. content for \description{} (no empty lines) ..
#'
#' .. content for \details{} ..
#'
#' @title

#' @return
#' @author edalfon
#' @export
recode_beneficia_saija <- function(saija_survey) {
  cercano <- c(
    "7434f5ea-2f54-4690-8626-b11cdc4e92a2",
    "b18cd351-adc3-4b60-a3a3-0418a8b0e8e4",
    "8d0e47c4-afb1-4fd1-a9b7-bba6604068f0",
    "6e692fec-4bb0-4e3c-ac1d-0f51c9ebcebf",
    "ec98b9c0-6d08-4bfd-92ff-9fe2f99cc259",
    "96f366f1-3f55-4511-af64-fe306e12d0c7",
    "c9afbf4e-8e13-4068-9e91-e2318b4dbea8",
    "f43876cc-c81d-4099-8418-f6186c477bae",
    "4cd7463d-426b-4dc0-845c-83b92016e4e0",
    "8f2cb42b-999c-4d8f-9cea-c9fa4dc89ac8",
    "f63ef713-29f5-4c3d-8958-6ed7765ab72c",
    "131fd804-54d6-49a7-ba2d-17ebfb71e480",
    "83655c87-ecac-42bb-aed4-a3a77f3d5d51",
    "8201915a-7dec-4161-b13f-390f4ae2df18",
    "87c89658-5cba-4141-a205-533eb30fd94c",
    "1ec5d56d-08d0-432c-b20c-6471c7c615b9",
    "1b98aec5-769e-448f-8694-fe18d697767a",
    "01f6c5f7-316e-4553-b6cc-459dc1847e07",
    "062ab669-4d0a-4b72-b03e-3de68d226a56",
    "1db0e372-be28-49cf-ad78-bd327c9b230e",
    "94aa65f6-5f9b-4b72-a861-9282c44fea95",
    "09b17007-d780-455b-8253-2865f0352180",
    "8f299623-2e0b-4d69-a10a-983b962dbf7e",
    "28c2d4fd-1a9f-4c29-a8de-2ff00edd3fab",
    "3261b8d9-84c3-4c83-a961-603366282c46",
    "9f9b5b70-6039-41ae-bcec-408a34e4001b",
    "8ae91527-4bfe-4f88-9156-ddd82515f2dc",
    "f9bd7bb0-a0b7-4358-8f22-25b20fd090a6",
    "97f94443-7d63-4185-aee0-e99d957036ab",
    "7900c87a-bfce-4e84-bc9e-955300330eba",
    "eda61185-caa3-49a3-8ccb-d32b5a739462",
    "3399e68b-c73e-4067-a45d-518b940814fa"
  )

  lejano <- coincidencias <- c(
    "8d0e47c4-afb1-4fd1-a9b7-bba6604068f0",
    "4cd7463d-426b-4dc0-845c-83b92016e4e0",
    "1db0e372-be28-49cf-ad78-bd327c9b230e",
    "94aa65f6-5f9b-4b72-a861-9282c44fea95",
    "09b17007-d780-455b-8253-2865f0352180",
    "8f299623-2e0b-4d69-a10a-983b962dbf7e",
    "28c2d4fd-1a9f-4c29-a8de-2ff00edd3fab",
    "8ae91527-4bfe-4f88-9156-ddd82515f2dc",
    "f9bd7bb0-a0b7-4358-8f22-25b20fd090a6",
    "97f94443-7d63-4185-aee0-e99d957036ab",
    "7900c87a-bfce-4e84-bc9e-955300330eba",
    "eda61185-caa3-49a3-8ccb-d32b5a739462",
    "3399e68b-c73e-4067-a45d-518b940814fa",
    "e9335145-04d6-4bd2-8574-45cefffdd4e9",
    "c20a4b0a-1e07-4403-9db7-538ac966a3c4",
    "cadd0257-13e9-415a-907a-92010cd41eb8",
    "3871c966-1388-4482-be43-a0aceb3122b3",
    "b6a5425b-02f8-493b-a193-b1e0ba17d545",
    "20ebc100-d557-4ebb-8312-e21f3c5b18ea",
    "da8f7201-d894-48b7-8892-95a9e9fa54cf",
    "ca4764e9-f288-47f6-9da9-45ca0053bb23",
    "ee2e295f-8f55-45d5-8f51-42f19a9f46bb",
    "367f8b3d-cffd-458e-a6b1-8344615a4d58",
    "40d09951-5d70-447e-80cd-457fa3a9c618",
    "67588618-64c6-437f-bc2c-70f853aa6da5",
    "25958f67-e232-403c-987a-38742f84ec2c",
    "f19ae968-eabe-4e4e-b4a3-2dd0fa6e6983",
    "75d9b6b1-459f-46e6-99d4-bbe3f133f5ad",
    "1bbc95ba-4665-4fbb-90ae-2d7187cc283d",
    "baab7556-84e2-4438-b789-a04e2abb9399",
    "85996934-9b24-4272-ae39-bd64110b37dc",
    "95da61fd-5986-4b39-a91d-8bc5064a5a9c",
    "f57e82ee-cf46-44c3-9738-0c8f50e29795",
    "0d9559cb-e761-4b8d-b76a-489dff675c87",
    "6caaf283-c963-478f-b16c-be28bc3485a1",
    "80dc3fde-ed4e-40ef-a19a-1c6475ceee9b",
    "a97ab8bb-09d5-4e55-a8c4-ded53f198f49",
    "28f5b1bb-7334-4878-87bd-6d75ffc5b73d",
    "8dd00af6-0c61-43cc-9eb1-4266eff3e46d"
  )

  saija_survey |>
    filter(beneficia == "No") |>
    select(ec5_uuid, nombre) |>
    efun::clipboard_writeto()

  saija_survey |> filter(beneficia == "No") |> pull(ec5_uuid) |> dput()

  saija_survey |>
    mutate(
      beneficia = case_when(
        ec5_uuid %in% cercano & beneficia == "No" ~ "Control Cercano",
        ec5_uuid %in% lejano & beneficia == "No" ~ "Control Lejano",
        beneficia == "Sí" ~ "Beneficiaria/o",
        TRUE ~ "Control Lejano" # TODO: check this
      )
    )
}

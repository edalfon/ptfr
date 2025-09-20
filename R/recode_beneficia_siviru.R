#' Recode Beneficiario Siviru
#'
#' This function recodes the "beneficiario siviru" variable to address a limitation in the original data collection process. Initially, the survey only asked whether a respondent was a beneficiary or not, without distinguishing between "control cercano" and "control lejano" groups. To resolve this, the function matches respondents with the sample to assign the appropriate control group classification.
#'
#' This recoding ensures accurate group assignment for subsequent analyses and reporting.
#'
#' @title Recode Beneficiario Siviru
#' @return A data frame with updated group classifications for each respondent.
#' @author edalfon
#' @export
recode_beneficia_siviru <- function(siviru_survey) {
  cercano <- c(
    "dff148c9-b7b1-40f2-adaa-3523b7534b64",
    "974c17de-50b4-4182-b9a4-aebc715ab3e4",
    "6b08ae6c-04d5-4be0-965f-2bd5ed9c079a",
    "49edc061-f280-44fc-9c14-64f514aace0b",
    "609247af-a31e-4e29-b41a-f39896538f37",
    "fb9cd22b-b7a2-4e62-bb0f-e2c2b0250875",
    "3933b448-12c1-4bf1-8727-fe22b77f9782",
    "03e0c714-109a-4b5e-bb99-84f8a4402021",
    "230419c9-6bef-4d3b-8e1c-43c07a0a7749",
    "3d2d34a4-96ab-4f24-94bf-5e195ad5ac82",
    "5f4530ce-c9d6-4b8d-9566-b471f2a15ea1",
    "6182ba73-fa0a-49d6-a7f4-11e9c470b2e4",
    "17d70405-2824-4b95-97b3-17eb7a19901a",
    "f4bc8954-1c29-4689-9b1e-813036bcefbb",
    "fbf731ca-d4de-4821-a58e-58d66c2c099e",
    "e184d191-1c53-441d-95d1-35218ce03246",
    "a8530341-50bd-4940-9ebd-d48d39b39971",
    "4e53149e-d6ca-4a2c-a446-5bc9312c2103",
    "d140329c-3f33-4a8b-b497-efe4cb805ac8",
    "98cb72a0-27d8-4639-b885-008d4921a8f8",
    "69787e01-9839-4e0a-80bd-132d9db76a97",
    "f462cb43-1011-4d97-9855-d1680331b5d8",
    "deaa439c-18ed-4c14-9d42-c9adff87943c",
    "9837201c-cc2f-4a3e-a8ff-f60251a0ee8e",
    "96144d07-441d-4c19-9cfd-d553bfa555b1",
    "78bc7ea7-a21f-4eaf-af0a-517442aa5119",
    "91080fb5-6c7a-4923-b959-b0f94332dd65",
    "6deb5ba2-601f-4d01-92c7-5595549fee0e",
    "c9a4bc97-64ab-4c7e-971c-8d0997c12df1",
    "ee592cb8-2c3a-4968-b864-da29a25cf2c4",
    "b2aef0b3-938a-4965-b525-edf464988117",
    "5b41cf76-8665-4d29-8010-f40bfb24fe6d",
    "4b94be47-a789-46f6-85a4-4cd67697297e",
    "0bb2c03a-3424-409e-b8b8-fd046bd63764",
    "71f61160-2d73-4bc6-88d4-209ca2370335",
    "468269e9-5981-4363-89bd-fa031765ae37",
    "dec428ba-7c90-421a-8776-fae6610dc014"
  )

  lejano <- c(
    "fcc40be0-ea6e-4a0e-811b-3f4e94b4cbaa",
    "df480c1d-56e9-41e5-a1f0-e2c706db63ce",
    "b719540d-3b44-4aef-b578-1dd48cff6f04",
    "7548ea71-b879-47b2-8d91-2b0618cba304",
    "533c4fce-0667-48d8-a13d-9c5382b54f2f",
    "0f52d516-d9f9-426e-89f8-5bde5f11e7d4",
    "102bc82c-47a8-4fcb-825f-c67545465690",
    "302c8a30-6531-4be2-a03f-de252694c106",
    "cc1f4976-2ffd-421a-83d5-c2560e7ae253",
    "ce98eb3c-f98e-4199-885b-7acd92c38a75",
    "3dbc5c03-c87f-4f08-a1f0-5f5cd07027cb",
    "ccdc36e2-9f58-4ff5-95e2-14157559b892",
    "d89dab8d-97c5-41a2-9750-39472c007c5c",
    "db3f5b94-9743-4eb4-abbd-3dabf270113b",
    "63f5ab32-b936-4144-9008-3fa96021d4f8",
    "38cd9120-1efe-4454-92f0-1a413e5cb5aa",
    "1424e240-b9c5-4b12-813a-667830e1b1b6",
    "95e13faa-f583-46a5-bdae-f6b0ee1e9868",
    "a921bb4e-8e02-4cd9-b88f-542ed40fb2ec",
    "264994c8-fb9d-437f-938e-9438179f1e3a",
    "6f45dd1b-3a39-48d1-af74-e371c1b0560a",
    "b14bd899-8c1b-46b6-b190-92ff8f0be7a6"
  )

  siviru_survey |>
    filter(beneficia == "No") |>
    select(ec5_uuid, nombre) |>
    efun::clipboard_writeto()

  siviru_survey |> filter(beneficia == "No") |> pull(ec5_uuid) |> dput()

  siviru_survey |>
    mutate(
      beneficia = case_when(
        ec5_uuid %in% cercano & beneficia == "No" ~ "Control Cercano",
        ec5_uuid %in% lejano & beneficia == "No" ~ "Control Lejano",
        beneficia == "Sí" ~ "Beneficiaria/o",
        TRUE ~ "Control Lejano" # TODO: check this
      )
    )
}

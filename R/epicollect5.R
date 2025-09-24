epicollect_download_data <- function(
  proj_slug,
  client_id = NULL,
  client_secret = NULL,
  form_ref = NULL,
  map_index = NULL
) {
  # retrive token
  # https://developers.epicollect.net/api-authentication/retrieve-token
  res_token <- httr::POST(
    "https://five.epicollect.net/api/oauth/token",
    body = list(
      grant_type = "client_credentials",
      client_id = client_id,
      client_secret = client_secret
    )
  )
  httr::message_for_status(res_token)
  stopifnot(res_token$status_code == 200)
  token <- httr::content(res_token)$access_token

  # get entries
  # https://developers.epicollect.net/entries/entries
  base_url <- paste0(
    "https://five.epicollect.net/api/export/entries/",
    proj_slug,
    "?format=csv&headers=true&per_page=1000"
  )
  # Add form_ref and map_index as query parameters if not NULL
  query_params <- c()
  if (!is.null(form_ref)) {
    query_params <- c(query_params, paste0("form_ref=", form_ref))
  }
  if (!is.null(map_index)) {
    query_params <- c(query_params, paste0("map_index=", map_index))
  }

  full_url <- paste(c(base_url, query_params), collapse = "&")

  res_csv <- httr::GET(
    full_url,
    httr::add_headers("Authorization" = paste("Bearer", token))
  )
  stopifnot(res_csv$status_code == 200)
  rawToChar(res_csv$content) |> readr::read_csv() |> identity()
}

# https://developers.epicollect.net/project/export-project
epicollect_get_project <- function(
  proj_slug,
  client_id = NULL,
  client_secret = NULL
) {
  # retrive token
  # https://developers.epicollect.net/api-authentication/retrieve-token
  res_token <- httr::POST(
    "https://five.epicollect.net/api/oauth/token",
    body = list(
      grant_type = "client_credentials",
      client_id = client_id,
      client_secret = client_secret
    )
  )
  httr::message_for_status(res_token)
  stopifnot(res_token$status_code == 200)
  token <- httr::content(res_token)$access_token

  # get entries
  # https://developers.epicollect.net/entries/entries
  full_url <- paste0("https://five.epicollect.net/api/export/project/", proj_slug)
  res_csv <- httr::GET(
    full_url,
    httr::add_headers("Authorization" = paste("Bearer", token))
  )
  stopifnot(res_csv$status_code == 200)
  proj_json <- rawToChar(res_csv$content) |> jsonlite::fromJSON()

  jsonlite::write_json(
    proj_json,
    paste0("output/epicollect_proj_", proj_slug, ".json"),
    pretty = TRUE,
    auto_unbox = TRUE
  )

  proj_json
}

epicollect_assign_labels <- function(target_data, proj_metadata) {
  # get all the questions (inputs) in a data frame
  inputs <- tibble(proj_metadata$data$project$forms$inputs[[1]])

  # and get also the mapping into a data frame
  mapping <- proj_metadata$meta$project_mapping |>
    filter(map_index == 0) |>
    pull(forms)

  ref_map_to <- tibble(
    ref = names(mapping[[1]]),
    map_to = sapply(mapping[[1]], function(x) x$map_to)
  )

  labels_map <- inputs |> left_join(ref_map_to, by = c("ref" = "ref"))

  for (col in names(target_data)) {
    # col <- "33_19_Usted_o_algn_m"
    label_row <- labels_map |> filter(map_to == col)
    if (nrow(label_row) == 1) {
      if (label_row$type == "radio") {
        target_data[, col] <- factor(
          target_data[[col]],
          levels = label_row$possible_answers[[1]]$answer
        )
      }
      if (!is.na(label_row$question)) {
        # Remove leading numbers, points (including decimals), and a
        # single space from the question label
        clean_label <- sub("^\\d+(?:\\.\\d+)*\\.\\s?", "", label_row$question)
        attr(target_data[[col]], "label") <- clean_label
      }
      attr(target_data[[col]], "varname") <- col
      attr(target_data[[col]], "type") <- label_row$type
      attr(target_data[[col]], "is_required") <- label_row$is_required
    }
  }

  target_data
}

# Danke für deinen Einkauf bei Brille24
# Bitte notiere deine Bestellnummer: 1000923022.

# Bestellnummer: 1000923022

# Eduardo Alfonso (+ 015237355471)

# Edelweißstraße 28, Brannenburg, 83098, Germany

# 1 Artikel

# Deine Bestelldaten wurden für unsere Aufzeichnungen an dich gesandt. Du solltest deine Brille(n) innerhalb von 7-14 Werktagen erhalten, abhängig von der Komplexität deiner Bestellung und Sehstärke.

# Einer unserer qualifizierten Optiker wird sich unter Umständen in Bezug auf deine Brille(n) oder deine Bestelldaten mit dir in Verbindung setzen.

# Schaue dir deinen Bestellstatus an unter Mein Konto oder Meine Bestellung verfolgen.

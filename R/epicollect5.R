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
  rawToChar(res_csv$content) |> readr::read_csv()
}

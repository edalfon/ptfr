# R Script to plot Latitude and Longitude points on an interactive map using leaflet

# --- 1. Dependencies Setup ---
# Uncomment the line below if you do not have the 'leaflet' package installed
# install.packages("leaflet")
# NOTE: We are now using leaflet::addAwesomeMarkers and leaflet::makeAwesomeIcon,
# which are reliably exported by the leaflet package.

# Load the required libraries
library(leaflet)

# --- 2. The Plotting Function ---

#' Plot Latitude and Longitude Points on an Interactive Map
#'
#' This function takes a data frame and column names for latitude and longitude
#' and generates an interactive Leaflet map with standard Awesome Markers (person icon).
#'
#' @param data A data frame containing location data.
#' @param lat_col Name of the column containing latitude values (as a string).
#' @param lon_col Name of the column containing longitude values (as a string).
#' @param popup_col Optional. Name of the column to use for popup labels (as a string).
#'                  If NULL (default), no popups are shown.
#' @return A leaflet map object.
#' @examples
#' # See example data and function call in Section 3 below.
plot_map <- function(data, lat_col, lon_col, popup_col = NULL) {
  # Input validation: Check if latitude and longitude columns exist
  if (!(lat_col %in% names(data) && lon_col %in% names(data))) {
    stop("Latitude or Longitude column not found in the data frame.")
  }

  # 1. Initialize the Leaflet map with the data
  # Uses fully qualified call: leaflet::leaflet
  map <- leaflet::leaflet(data = data) %>%
    # 2. Add default map tiles (OpenStreetMap)
    # Uses fully qualified calls: leaflet::addTiles, leaflet::tileOptions
    leaflet::addTiles(options = leaflet::tileOptions(detectRetina = TRUE)) %>%
    # 3. Focus the map on the extent of the points
    # Uses fully qualified call: leaflet::fitBounds
    leaflet::fitBounds(
      lng1 = min(data[[lon_col]], na.rm = TRUE),
      lat1 = min(data[[lat_col]], na.rm = TRUE),
      lng2 = max(data[[lon_col]], na.rm = TRUE),
      lat2 = max(data[[lat_col]], na.rm = TRUE)
    )

  # 4. Add Awesome Markers (using the custom icon)
  # Uses fully qualified call: leaflet::addAwesomeMarkers
  map <- map %>%
    leaflet::addAwesomeMarkers(
      lng = ~ data[[lon_col]],
      lat = ~ data[[lat_col]],
      icon = awesomeIcons(
        icon = 'user',
        library = 'fa',
        markerColor = 'white',
        squareMarker = TRUE,
        iconColor = 'black',
        spin = FALSE
      ),
      options = markerOptions(opacity = 0.5)
    )

  # Return the final map object
  return(map)
}

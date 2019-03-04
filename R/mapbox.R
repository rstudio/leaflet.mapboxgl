#' @importFrom htmltools htmlDependency
htmldeps <- function() {
  list(
    htmlDependency(
      "mapbox-gl",
      "0.53.1",
      src = "node_modules/mapbox-gl/dist",
      package = "leaflet.mapboxgl",
      script = "mapbox-gl.js",
      stylesheet = "mapbox-gl.css",
      all_files = FALSE
    ),
    htmlDependency(
      "mapbox-gl-leaflet",
      "0.0.4",
      src = "node_modules/mapbox-gl-leaflet",
      package = "leaflet.mapboxgl",
      script = "leaflet-mapbox-gl.js"
    )
  )
}

#' @export
mapboxOptions <- function(accessToken = getOption("mapbox.accessToken"),
  style = NULL, ...) {

  opts <- list(
    accessToken = accessToken,
    style = style
  )

  # Filter out NULL
  opts[!vapply(opts, is.null, logical(1))]
}

#' Add a Mapbox GL layer to a Leaflet map
#'
#' @examples
#' leaflet(quakes) %>%
#'   addMapboxGL(options = mapboxOptions(
#'     style = "mapbox://styles/mapbox/light-v9"
#'   )) %>%
#'   addMarkers()
#' @export
addMapboxGL <- function(map, options) {
  if (is.null(options[["accessToken"]])) {
    # TODO: Don't require an access token?
    accessToken <- getOption("mapbox.accessToken")
    if (is.null(accessToken)) {
      stop("Please supply addMapboxGL() with a Mapbox access token, either via `options(mapbox.accessToken = \"...\")` or directly on the options argument.")
    }
    options$accessToken <- accessToken
  }
  map$dependencies <- c(
    map$dependencies,
    htmldeps()
  )

  map <- htmlwidgets::onRender(map, "function(el, x, options) {
    debugger;
    L.mapboxGL(options).addTo(this);
  }", options)

  map
}

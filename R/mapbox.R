#' @importFrom htmltools htmlDependency
#' @importFrom utils packageVersion
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
      script = "leaflet-mapbox-gl.js",
      all_files = FALSE
    ),
    htmlDependency(
      "leaflet_mapboxgl",
      packageVersion("leaflet.mapboxgl"),
      src = "binding",
      package = "leaflet.mapboxgl",
      script = "leaflet_mapboxgl.js",
      stylesheet = "leaflet_mapboxgl.css",
      all_files = FALSE
    )
  )
}

# # Download the style layer (including mapbox URLs) and json-decode
# getStyleLayer <- function(url, accessToken) {
#   match <- regexec("^mapbox://styles/([^/]+)/([^/?]+)$", url)
#   match <- regmatches(url, match)[[1]]
#   if (length(match) > 0) {
#     username <- match[[2]]
#     style_id <- match[[3]]
#     url <- paste0(
#       "https://api.mapbox.com/styles/v1/",
#       username,
#       "/",
#       style_id,
#       "?access_token=",
#       utils::URLencode(accessToken, reserved = TRUE, repeated = TRUE)
#     )
#   }
#
#   jsonlite::fromJSON(url)
# }

#' @param accessToken A [Mapbox access
#'   token](https://docs.mapbox.com/help/how-mapbox-works/access-tokens/#creating-and-managing-access-tokens),
#'   or `NA` to explicitly pass no token. You can also set a token globally by
#'   calling `options(mapbox.accessToken = "...")`.
#' @param ... Other options to pass to Mapbox GL JS.
#'
#' @rdname addMapboxGL
#' @export
mapboxOptions <- function(accessToken = NULL, ...) {

  opts <- list(
    accessToken = accessToken,
    ...
  )

  # Filter out NULL
  opts[!vapply(opts, is.null, logical(1))]
}

#' Adds a Mapbox GL layer to a Leaflet map
#'
#' Uses the [Mapbox GL Leaflet plugin](https://github.com/mapbox/mapbox-gl-leaflet)
#' to add a Mapbox GL layer to a Leaflet map.
#'
#' @param map The Leaflet R object (see [leaflet::leaflet()]).
#' @param style Tile vector URL; can begin with `http://`, `https://`, or
#'   `mapbox://`.
#' @param layerId A layer ID; see
#'   [docs](https://rstudio.github.io/leaflet/showhide.html).
#' @param group The name of the group the newly created layer should belong to
#'   (for [leaflet::clearGroup()] and [leaflet::addLayersControl()] purposes).
#'   (Warning: Due to the way Leaflet and Mapbox GL JS integrate, showing/hiding
#'   a GL layer may give unexpected results.)
#' @param setView If `TRUE` (the default), drive the map to the center/zoom
#'   specified in the style (if any). Note that this will override any
#'   [leaflet::setView()] or [leaflet::fitBounds()] calls that occur between
#'   the `addMapboxGL` call and when the style finishes loading; use
#'   `setView=FALSE` in those cases.
#' @param options A list of Map options. See the
#'   [Mapbox GL JS documentation](https://docs.mapbox.com/mapbox-gl-js/api/#map)
#'   for more details. Not all options may work in the context of Leaflet.
#'
#' @examples
#' # Before running, set your Mapbox access token using:
#' # `options(mapbox.accessToken = "...")`
#'
#' library(leaflet)
#' \donttest{
#' leaflet(quakes) %>%
#'   addMapboxGL(style = "mapbox://styles/mapbox/streets-v9") %>%
#'   addCircleMarkers(weight = 1, fillOpacity = 0, radius = 3)
#' }
#' @export
#' @import leaflet
addMapboxGL <- function(map, style = "mapbox://styles/mapbox/streets-v9",
  accessToken = getOption("mapbox.accessToken"),
  layerId = NULL, group = NULL, setView = TRUE,
  options = mapboxOptions()) {

  map$dependencies <- c(
    map$dependencies,
    htmldeps()
  )

  options$style <- style
  options$accessToken <- accessToken

  if (is.null(options[["accessToken"]])) {
    stop("Please supply addMapboxGL() with a Mapbox access token, ",
      "either via `options(mapbox.accessToken = \"...\")` or as an ",
      "argument to `addMapboxGL()`. (If you're not using Mapbox ",
      "URLs, you can set the access token to `NA`.)")
  }

  invokeMethod(map, getMapData(map), "addMapboxGL", setView, layerId, group, options)
}

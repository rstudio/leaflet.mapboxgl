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

#' @param accessToken A [Mapbox access
#'   token](https://docs.mapbox.com/help/how-mapbox-works/access-tokens/#creating-and-managing-access-tokens),
#'   or `NA` to explicitly pass no token. You can also set a token globally by
#'   calling `options(mapbox.accessToken = "...")`.
#' @param style Tile vector URL; can begin with `http://`, `https://`, or
#'   `mapbox://`.
#' @rdname addMapboxGLRaw
#' @export
mapboxOptions <- function(accessToken = NULL,
  style = NULL, ...) {

  opts <- list(
    accessToken = accessToken,
    style = style,
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
#' @param layerId A layer ID; see
#'   [docs](https://rstudio.github.io/leaflet/showhide.html).
#' @param group The name of the group the newly created layer should belong to
#'   (for [leaflet::clearGroup()] and [leaflet::addLayersControl()] purposes).
#'   (Warning: Due to the way Leaflet and Mapbox GL JS integrate, showing/hiding
#'   a GL layer may give unexpected results.)
#' @param options A list of Map options. See the
#'   [Mapbox GL JS documentation](https://docs.mapbox.com/mapbox-gl-js/api/#map)
#'   for more details. Not all options may work in the context of Leaflet.
#'
#' @examples
#' # Before using, set your Mapbox access token using:
#' # `options(mapbox.accessToken = "...")`
#'
#' leaflet(quakes) %>%
#'   addMapboxGLRaw(options = mapboxOptions(
#'     style = "mapbox://styles/mapbox/streets-v9"
#'   )) %>%
#'   addCircleMarkers(weight = 1, fillOpacity = 0, radius = 3)
#' @export
addMapboxGLRaw <- function(map, layerId = NULL, group = NULL, options = mapboxOptions()) {
  map$dependencies <- c(
    map$dependencies,
    htmldeps()
  )

  if (is.null(options[["accessToken"]])) {
    accessToken <- getOption("mapbox.accessToken")
    if (is.null(accessToken)) {
      stop("Please supply addMapboxGL() with a Mapbox access token, ",
        "either via `options(mapbox.accessToken = \"...\")` or as an ",
        "argument to `mapboxOptions()`. (If you're not using Mapbox ",
        "URLs, you can set the access token to `NA`.)")
    }
    options$accessToken <- accessToken
  }

  invokeMethod(map, getMapData(map), "addMapboxGL", layerId, group, options)
}

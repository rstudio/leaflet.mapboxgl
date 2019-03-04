# leaflet.mapboxgl

Provides an R interface to extend the [R Leaflet](https://rstudio.github.io/leaflet/) package with the [Mapbox GL Leaflet](https://github.com/mapbox/mapbox-gl-leaflet) plugin.

## Installation

This package is not yet available on CRAN.

```r
devtools::install_github("rstudio/leaflet.mapboxgl")
```

## Usage

First, you must provide your [Mapbox access token](https://docs.mapbox.com/help/how-mapbox-works/access-tokens/#creating-and-managing-access-tokens) as a global R option. (If you are using non-Mapbox datasource, you still need to provide a value, but it can just be `NA`.)

```r
options(mapbox.accessToken = "...")
```

Then, create your Leaflet map, and call the `addMapboxGL` function.

```r
library(leaflet)
library(leaflet.mapboxgl)

leaflet(quakes) %>%
  addMapboxGL(style = "mapbox://styles/mapbox/streets-v9") %>%
  addCircleMarkers(weight = 1, fillOpacity = 0, radius = 3)
```

## License

MIT

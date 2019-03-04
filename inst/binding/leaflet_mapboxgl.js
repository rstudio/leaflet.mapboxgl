LeafletWidget.methods.addMapboxGL = function(layerId, group, options) {
  if (options.accessToken === null) {
    options.accessToken = "na";
  }
  var layer = L.mapboxGL(options);
  this.layerManager.addLayer(layer, "mapbox-gl-js", layerId, group);
};

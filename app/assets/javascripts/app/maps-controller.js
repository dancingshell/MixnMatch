mixnApp.controller('MapCtrl', ['$scope', function($scope) {

  // Map
  var map;
  var marker;
  var mapOptions = {
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    minZoom: 3,
    zoom: 8,
    center: new google.maps.LatLng(-34.397, 150.644)
  };

  // Google Maps Initialize
  $scope.mapInit = function() {

    // Map Canvas
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  }();

}]);
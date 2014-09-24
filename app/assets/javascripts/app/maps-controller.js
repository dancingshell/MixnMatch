mixnApp.controller('MapCtrl', ['$scope', function($scope) {
  

var x = document.getElementById("demo");
$scope.getLocation = function() {
  alert("test");
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}
function showPosition(position) {
    x.innerHTML = "Latitude: " + position.coords.latitude + 
    "<br>Longitude: " + position.coords.longitude; 
}

  // Map
  var map;
  var marker;
  var mapOptions = {
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    mapTypeControl: false,
    minZoom: 3,
    zoom: 8,
    center: new google.maps.LatLng(34.120655, -118.296199),
    styles: [{"featureType":"landscape.natural","stylers":[{"visibility":"on"},{"color":"#ecd5c3"}]},{"featureType":"water","stylers":[{"visibility":"on"},{"color":"#32c4fe"}]},{"featureType":"landscape.natural","stylers":[{"visibility":"simplified"}]},{"featureType":"transit","stylers":[{"visibility":"off"}]},{"featureType":"poi","stylers":[{"visibility":"off"}]},{"featureType":"road.arterial","elementType":"geometry.fill","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"road.arterial","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},{"featureType":"road.local","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},{"featureType":"landscape.man_made","stylers":[{"visibility":"off"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.fill","stylers":[{"color":"#baaca2"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"visibility":"off"}]},{"featureType":"road.highway.controlled_access","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":"#ffffff"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#565757"},{"visibility":"on"}]},{"featureType":"road.local","elementType":"labels.text.stroke","stylers":[{"color":"#808080"},{"visibility":"off"}]},{"featureType":"road.arterial","elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]},{"featureType":"administrative.neighborhood","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"visibility":"on"},{"color":"#535555"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#fffffe"}]},{"featureType":"road.highway","elementType":"labels.text.stroke","stylers":[{"visibility":"off"}]},{"featureType":"road.highway","elementType":"labels.icon","stylers":[{"visibility":"on"}]},{"featureType":"road","elementType":"labels.icon","stylers":[{"visibility":"on"},{"saturation":-100},{"lightness":17}]},{}]

  };


  // Google Maps Initialize
  $scope.mapInit = function() {

    // Map Canvas
    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);

  }();

  // function createImage(url){
  //   var image = {
  //     url: url,
  //     // This marker is 32 pixels wide by 32 pixels tall.
  //     size: new google.maps.Size(32, 32),
  //     // The origin for this image is 0,0.
  //     origin: new google.maps.Point(0,0),
  //     // The anchor for this image is the base of the flagpole at 0,32.
  //     anchor: new google.maps.Point(5, 32)
  //   };
  //   return image;
  // }

  function createInfoWindow(text){
    var infowindow = new google.maps.InfoWindow({
      content: text
    });
    return infowindow;
  }

  var marker;
  function createMarker(coords, map, title){
    marker = new google.maps.Marker({
      position: coords,
      map: map,
      title: title,
      animation: google.maps.Animation.DROP,
    });
    google.maps.event.addListener(marker, 'click', toggleBounce);
  }
  function toggleBounce() {

    if (marker.getAnimation() != null) {
      marker.setAnimation(null);
    } else {
      marker.setAnimation(google.maps.Animation.BOUNCE);
    }
  }

  createMarker({lat: 34.120655, lng: -118.296199}, map, "event");
  google.maps.event.addDomListener(window, 'load', $scope.mapInit());

}]);
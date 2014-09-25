mixnApp.controller('MapCtrl', ['$scope', '$http', 'EventData', function($scope, $http, EventData) {

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

  };

  var marker;
  var infowindow;
 
  google.maps.event.addDomListener(window, 'load', $scope.mapInit());

  EventData.getData().then(function(json){
    $scope.events_json = json.data;
    $scope.events = $scope.events_json.events;

    function createMarker(coords, map, artist, venue, date, marker_text){
      marker = new google.maps.Marker({
        position: coords,
        map: map,
        artist: artist,
        venue: venue,
        date: date,
        marker_text: marker_text,
        animation: google.maps.Animation.DROP

      });
      // google.maps.event.addListener(marker, 'click', toggleBounce);
    }
    
    for (var i = 0; i < $scope.events.length; i++) {
      $scope.concert = $scope.events[i];
      $scope.eventText = $scope.concert.venue;

      $scope.markerText = '<h4>Artist: ' + $scope.concert.title + '</h4>' +
        '<p class="addr-text">Venue: ' + $scope.concert.venue + '</p>';

      infowindow = new google.maps.InfoWindow({
        content: $scope.markerText
      });

      createMarker({lat: parseInt($scope.concert.lat), lng: parseInt($scope.concert.long)}, map, $scope.concert.title, $scope.concert.venue, $scope.concert.date, $scope.markerText);
      
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map, marker);
        infowindow.setContent(marker.marker_text);
        console.log("test");
      });
    }
  
    

  });
  
}]);

mixnApp.factory('EventData', ['$http', function($http){
  var events = {};

  events.getData = function(){
    var domain = window.location.hostname;
    var url;
    var hostname;
    
    if (domain == "localhost") {
      hostname = "localhost:3000"
    }
    else {
      hostname = "mixnmatch.herokuapp.com"
    }

    url = "http://"+ hostname + "/api/events/";
    var endpoint = url; 
    return $http({ method: 'GET', url: endpoint });
  };

  return events;

}]);
mixnApp.controller('MixnMatchCtrl', ['$scope', 'MatchData', '$http', function($scope, MatchData, $http) {

  // Angular Loaded
 
  var duration = 1; // track the duration of the currently playing track
  $(document).ready(function() {
    $('#api').bind('ready.rdio', function() {
      $('#art').attr('src', $scope.artist_image);
    });
    $('#api').bind('playingTrackChanged.rdio', function(e, playingTrack, sourcePosition) {
      if (playingTrack) {
        console.log(playingTrack);
        duration = playingTrack.duration;
        $('#art').attr('src', playingTrack.icon);
        $('#track').text(playingTrack.name);
        $('#album').text(playingTrack.album);
        $('#artist').text(playingTrack.artist);
      }
      else {
      }
      });
    $('#api').bind('positionChanged.rdio', function(e, position) {
      $('#position').css('width', Math.floor(100*position/duration)+'%');
    });
    $('#api').bind('playStateChanged.rdio', function(e, playState) {
      if (playState == 0) { // paused
        $('#play').show();
        $('#pause').hide();
      } else {
        $('#play').hide();
        $('#pause').show();
      }
    });
    // playback token for heroku site
    if (window.location.hostname != "localhost") {
    	$('#api').rdio('GBdUIcnK_____2R2cHlzNHd5ZXg3Z2M0OXdoaDY3aHdrbm1peG5tYXRjaC5oZXJva3VhcHAuY29t_MDD2Jq5eqMoaoXEvAwRww==');
    }
    // playback token for localhost
    else { 
    	$('#api').rdio('GAlNi78J_____zlyYWs5ZG02N2pkaHlhcWsyOWJtYjkyN2xvY2FsaG9zdEbwl7EHvbylWSWFWYMZwfc=');
    }

    $('#previous').click(function() { $('#api').rdio().previous(); });
    
    $('#pause').click(function() {
    	$('#api').rdio().pause();
    	$scope.active_player = true;
    });
    // check to start play or resume play
    if ($scope.active_player == true) {
    	$('#play').click(function() { $('#api').rdio().play(); });
    }
    else {
    	$('#play').click(function() { $('#api').rdio().play($scope.my_top_songs_key); });
    }

    $('#next').click(function() { $('#api').rdio().next(); });
  });

  //Variables
  $scope.matches = {};
  $scope.checkDistances = [];
  $scope.matches = {};

  //Filter options
  $scope.option = {
    choices: [
    {name: 'Show All'},
    {name: 'Just Friends', friendship: true},
    {name:'Men who like Women', gender: 'Male', orientation: 'Straight'}, 
    {name:'Women who like Men', gender: 'Female', orientation: 'Straight'},
    {name:'Men who like Men', gender: 'Male', orientation: 'Gay'},
    {name:'Women who like Women', gender: 'Female', orientation: 'Gay'}
    ]
  };

  $scope.ageminoption = {
    choices: [
    {age: 'Show All'}, {age: 18}, {age: 19}, {age: 20}, {age: 21}, {age: 22}, {age: 23}, {age: 24}, {age: 25}, {age: 26}, {age: 27}, {age: 28}, {age: 29}, {age: 30}, {age: 31}, {age: 32}, {age: 33}, {age: 34}, {age: 35}, {age: 36}, {age: 37}, {age: 38}, {age: 39}, {age: 40}, {age: 41}, {age: 42}, {age: 43}, {age: 44}, {age: 45}
    ]
  };

  $scope.agemaxoption = {
    choices: [
    {age: 'Show All'}, {age: 18}, {age: 19}, {age: 20}, {age: 21}, {age: 22}, {age: 23}, {age: 24}, {age: 25}, {age: 26}, {age: 27}, {age: 28}, {age: 29}, {age: 30}, {age: 31}, {age: 32}, {age: 33}, {age: 34}, {age: 35}, {age: 36}, {age: 37}, {age: 38}, {age: 39}, {age: 40}, {age: 41}, {age: 42}, {age: 43}, {age: 44}, {age: 45}
    ]
  };
  
  $scope.distanceOption = {
    choices: [
    {name: 'Show All'}, {name: "Within 10 miles", distance: 10 }, {name: "Within 20 miles", distance: 20 }, {name: "Within 35 miles", distance: 35 }, {name: "Within 50 miles", distance: 50 }, {name: "Within 75 miles", distance: 75 }
    ]
  };
   //Mapped to the model to filter
  $scope.filterItem = {
    choice: $scope.option.choices[0]
  }
  
  $scope.filterAgemin = {
    choice: $scope.ageminoption.choices[0]
  }

  $scope.filterAgemax = {
    choice: $scope.agemaxoption.choices[0]
  }

  $scope.filterDistance = {
    choice: $scope.distanceOption.choices[0]
  }
  
  //Filter Functions
  $scope.orientationFilter = function (m) {
    if ((m[1][1].gender === $scope.filterItem.choice.gender) && (m[1][1].orientation === $scope.filterItem.choice.orientation)) {
      return true;
    } else if ($scope.filterItem.choice.name === "Show All") {
      return true;
    } else if (m[1][1].friendship === $scope.filterItem.choice.friendship) {
      return true;
    } else {
      return false;
    }
  };  

    $scope.ageminFilter = function (m) {
    if (m[1][2] >= $scope.filterAgemin.choice.age) {
      return true;
    } else if ($scope.filterAgemin.choice.age === "Show All") {
      return true;
    }
     else {
      return false;
    }
  }; 

    $scope.agemaxFilter = function (m) {
    if (m[1][2] <= $scope.filterAgemax.choice.age)  {
      return true;
    } else if ($scope.filterAgemax.choice.age === "Show All") {
      return true;
    }
     else {
      return false;
    }
  }; 


    $scope.distanceFilter = function (m) {
    if (m[2] <= $scope.filterDistance.choice.distance)  {
      return true;
    } else if ($scope.filterDistance.choice.name === "Show All") {
      return true;
    }
     else {
      return false;
    }
  }; 
  

    
  //Factory call to get match data back
  MatchData.getData().then(function(json){
    $scope.matches = json.data;
    $scope.matches = $scope.matches.matches
    $scope.matchLocations();
    console.log($scope.zipcode);

  });

  // Calculate Distance
  $scope.matchLocations = function(){
    $scope.matches.forEach(function(m) {
      console.log(m[1][1].zipcode)
    $scope.checkDistances.push(m[1][1].zipcode.toString());
    });
    console.log($scope.checkDistances);
    $scope.userzipcode = $scope.zipcode.toString();
    $scope.calculateDistances([$scope.userzipcode], $scope.checkDistances);
  };

  $scope.calculateDistances = function(matcher, matchees) {
    var service = new google.maps.DistanceMatrixService();
    service.getDistanceMatrix(
      {
        origins: matcher,
        destinations: matchees,
        travelMode: google.maps.TravelMode.DRIVING,
        unitSystem: google.maps.UnitSystem.IMPERIAL
      }, $scope.callback);
  };

  $scope.callback = function(response, status) {
    console.log($scope.checkDistances)
    if (status != google.maps.DistanceMatrixStatus.OK) {
      alert('Error was: ' + status);
    } else {
      var origins = response.originAddresses;
      var destinations = response.destinationAddresses;
      $scope.finalMatches = $scope.matches
      $scope.$apply()
      for (var i = 0; i < origins.length; i++) {
        var results = response.rows[i].elements;
        for (var j = 0; j < results.length; j++) {
          var miles = results[j].distance['text'].replace(/ mi/g, '').replace(/,/g, '')
          if (miles === '1 ft') {
            $scope.finalMatches[j].push('0');
          } else {
            $scope.finalMatches[j].push(miles);
          }
        }
      }
      $scope.$apply();
      console.log($scope.finalMatches);
    }
  }




}]);

mixnApp.factory('MatchData', ['$http', function($http){
  var matches = {};

  matches.getData = function(){
    var url = 'http://localhost:3000/api/matches/';
    var endpoint = url; 
    return $http({ method: 'GET', url: endpoint });
  };

  return matches;

}]);





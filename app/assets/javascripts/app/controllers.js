mixnApp.controller('MixnMatchCtrl', ['$scope', '$http', function($scope, $http) {

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

 	$http({method: 'GET', url: '#{rdio}().search("Feist")'}).
	success(function(data, status, headers, config) {
		console.log(data.body);
	  // this callback will be called asynchronously
	  // when the response is available
	}).
	error(function(data, status, headers, config) {
	  // called asynchronously if an error occurs
	  // or server returns response with an error status.
	});

}]);

mixnApp.controller('MixnMatchCtrl', ['$scope', 'MatchData', function($scope, MatchData) {

  // Angular Loaded
  console.log('angular loaded!');

  //Get Matches
  $scope.matches = {};
  $scope.lookingfor = {};
  $scope.filtered = [];
  $scope.agemin = '';
  $scope.agemax = '';
  $scope.option = {
    choices: [
    {name: 'Show All'},
    {name:'Men who like Women', gender: 'Male', orientation: 'Straight'}, 
    {name:'Women who like Men', gender: 'Female', orientation: 'Straight'},
    {name:'Women who like Men', gender: 'Male', orientation: 'Straight'}
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
  
  $scope.orientationFilter = function (m) {
    if ((m[1][1].gender === $scope.filterItem.choice.gender) && (m[1][1].orientation === $scope.filterItem.choice.orientation)) {
      return true;
    } else if ($scope.filterItem.choice.name === "Show All") {
      return true;
    }
     else {
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
  

    

  MatchData.getData().then(function(json){
    $scope.matches = json.data;
    $scope.matches = $scope.matches.matches

  });


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





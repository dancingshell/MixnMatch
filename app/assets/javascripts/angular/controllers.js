mnmApp.controller('MnMCtrl', ['$scope', function($scope) {

  // Angular Loaded
  console.log('angular loaded!');


  // Sign Up Form Steps
  $scope.stepNext = function() {
    if ($scope.step1) {
      $scope.step1 = false;
      $scope.step2 = true;
    }
    else if ($scope.step2) {
      $scope.step2 = false;
      $scope.step3 = true;
    }
  };

  $scope.stepPrev = function() {
    if ($scope.step2) {
      $scope.step1 = true;
      $scope.step2 = false;
    }
    else if ($scope.step3) {
      $scope.step2 = true;
      $scope.step3 = false;
    }
  };


}]);

SessionsController = function ($scope) {
  $scope.$on('auth:login-error', function(ev, reason) {
    $scope.error = reason.errors[0];
  });
};

SessionsController.$inject = ['$scope'];

angular.module('shop').controller('SessionsController', SessionsController);

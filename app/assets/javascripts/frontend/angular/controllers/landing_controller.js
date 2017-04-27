LandingController = function ($scope, Product, $location, $rootScope, ipCookie, $state) {
  $scope.cart = $rootScope.cart;

  // recreate array for displaying in columns
  function chunk(arr, size) {
    var newArr = [];
    for (var i=0; i<arr.length; i+=size) {
      newArr.push(arr.slice(i, i+size));
    }
    return newArr;
  };

  // get all products
  Product.query('', function(data){
    $rootScope.products = data;
    $scope.products = chunk($rootScope.products, 3);
  });

  // set 'active' class to menu item depending on current url
  $scope.getClass = function(path) {
    return ($location.path().substr(0, path.length) === path) ? 'active' : '';
  };

  $scope.handleSignOut = function() {
    $scope.signOut();
    $state.go('landing');
  }
};

LandingController.$inject = ['$scope', 'Product', '$location', '$rootScope', 'ipCookie', '$state'];

angular.module('shop').controller('LandingController', LandingController);

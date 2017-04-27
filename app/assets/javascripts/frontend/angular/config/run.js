angular.module('shop').run(['$rootScope', '$location', 'ipCookie', function($rootScope, $location, ipCookie) {
  $rootScope.location = $location;

  if ($rootScope.cart === undefined) {
    if (ipCookie('cart') != undefined) {
      $rootScope.cart = ipCookie('cart');
    } else {
      $rootScope.cart = [];
    }
  }

  $rootScope.$on('auth:login-success', function() {
    $location.path('/');
  });
}]);

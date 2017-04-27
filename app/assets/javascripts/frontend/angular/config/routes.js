angular.module('shop').config(['$stateProvider', '$urlRouterProvider', function ($stateProvider, $urlRouterProvider){

  $urlRouterProvider.otherwise('/');

  $stateProvider
    .state('landing', {
      url: '/',
      controller: 'LandingController',
      templateUrl: 'layout.html'
    })
    .state('sign_in', {
      url: '/sign_in',
      controller: 'SessionsController',
      templateUrl: 'sessions/new.html'
    })
    .state('sign_up', {
      url: '/sign_up',
      controller: 'RegistrationsController',
      templateUrl: 'registrations/new.html'
    })
    .state('product', {
      url: '/product/:id',
      controller: 'ProductsController',
      templateUrl: 'products/show.html'
    })
    .state('product-edit', {
      url: '/product/edit/:id',
      controller: 'ProductsController',
      templateUrl: 'products/edit.html'
    })
    .state('product-new', {
      url: '/new',
      controller: 'ProductsController',
      templateUrl: 'products/new.html'
    })
    .state('cart', {
      url: '/cart',
      controller: 'CartsController',
      templateUrl: 'cart.html'
    })
    .state('user', {
      url: '/user',
      controller: 'UsersController',
      templateUrl: 'users/show.html'
    })
    .state('order', {
      url: '/order/:id',
      controller: 'OrdersController',
      templateUrl: 'orders/show.html'
    })
}]);

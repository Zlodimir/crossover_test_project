angular.module('shop').config(function($httpProvider) {
  return $httpProvider.interceptors.push('AuthInterceptor');
});

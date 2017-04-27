angular.module('shop').factory('AuthInterceptor', ['$q', '$injector', function($q, $injector) {
  return {
    request: function(config) {
      var token = localStorage.getItem('auth_token');
      config.headers = config.headers || {};
      if (token) {
        config.headers.Authorization = 'Bearer ' + token;
      }
      return config || $q.when(config);
    },
    responseError: function(response) {
      var $state = $injector.get('$state');
      var matchesAuthenticatePath = response.config && response.config.url.match(new RegExp('/auth'));
      if (!matchesAuthenticatePath) {
        if (response.status == 401 || response.status == 403 || response.status == 419) {
          localStorage.removeItem('auth_token');
          $state.go('sign_in');
        }
        if (response.status == 302) {
          console.log('scuga ebad!')
        }
      }
      return $q.reject(response);
    }
  };
}]);

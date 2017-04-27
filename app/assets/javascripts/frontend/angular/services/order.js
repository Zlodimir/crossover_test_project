angular.module('shop').factory('Order', ['$resource', function($resource){
  return $resource('/api/orders/:id.json', { id: '@id' }, {
    'payment': {method: 'PUT', url: '/api/orders/:id/payment.json'}
  });
}]);

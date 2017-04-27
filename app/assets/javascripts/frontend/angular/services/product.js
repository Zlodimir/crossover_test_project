angular.module('shop').factory('Product', ['$resource', function($resource){
  return $resource('/api/products/:id.json', { id: '@id' }, {
    update: {method: 'PUT', url: '/api/products/:id.json'}
  });
}]);

ProductsController = function ($scope, Product, $stateParams, $state, $rootScope) {
  //Get ID of current product
  var currentId = $stateParams.id;
  if (currentId != undefined) {
    $scope.product = Product.get({id: currentId});
  };

  $scope.saveProduct = function(product) {
    if(product.id === undefined) {
      Product.save({product: product}, function(){
        $state.go('landing');
      });
    } else {
      Product.update({id: product.id, product: product}, function() {
        $rootScope.products = Product.query(); 
        $state.go('product', {id: product.id});
      });
    };
  };
};

ProductsController.$inject = ['$scope', 'Product', '$stateParams', '$state', '$rootScope'];

angular.module('shop').controller('ProductsController', ProductsController);

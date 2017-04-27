CartsController = function ($scope, $rootScope, ipCookie, Order, $state) {
  $scope.addToCart = function(product) {
    var cart = ipCookie('cart');
    if (cart === undefined) {
      cart = []
    };
    
    cart.push(product)
    // save cart items in cookies
    ipCookie('cart', cart);
    $rootScope.cart.push(product);
  };

  $scope.deleteFromCart = function(product) {
    // delete item from global array
    var index = $rootScope.cart.indexOf(product);
    $rootScope.cart.splice(index, 1);

    // delete item from cart in cookies
    var cart = ipCookie('cart');
    cart.splice(index, 1);
    ipCookie('cart', cart);
  }

  // calculate total sum of order
  $scope.grantTotal = function() {
    var total = 0;

    for(var count = 0; count < $rootScope.cart.length; count++){
      var product = $rootScope.cart[count];
      total += (product.price * product.quantity);
    }
    return total;
  }

  $scope.createOrder = function() {
    var successCallback = function(data){
      // empty cart after order was created
      ipCookie('cart', []);
      $rootScope.cart.length = 0;

      $state.go('user');
    };

    var orderLines = [];
    for(var count = 0; count < $rootScope.cart.length; count++){
      orderLines.push({product_id: $rootScope.cart[count].id, qty: $rootScope.cart[count].quantity})
    };

    var newOrder = {
      order_lines_attributes: orderLines
    }
    Order.save({order: newOrder}, successCallback);
  };

  $scope.cart = $rootScope.cart;
  $scope.cookieCart = ipCookie('cart');

  $scope.items = [{ key: '1', value: '1'}, { key: '2', value: '2'}, { key: '3', value: '3'}, { key: '4', value: '4'}, { key: '5', value: '5'}];
};

CartsController.$inject = ['$scope', '$rootScope', 'ipCookie', 'Order', '$state'];

angular.module('shop').controller('CartsController', CartsController);

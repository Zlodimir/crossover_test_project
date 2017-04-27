UsersController = function ($scope, Order, $window, $http, $location) {
  $scope.orders = Order.query();

  $scope.checkOut = function(order) {
    Order.payment({
      // we need to pass order ID and the url where where we woulbe redirectd after payment
      id: order.id,
      back_after_payment_url: 'http://localhost:3000/#/order/' + order.id
    }, function(data) {
        // let's move to the payment gateway
        window.location.href = data.location;
    });
  };
};

UsersController.$inject = ['$scope', 'Order', '$window', '$http', '$location'];

angular.module('shop').controller('UsersController', UsersController);

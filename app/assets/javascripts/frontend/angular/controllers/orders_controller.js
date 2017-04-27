OrdersController = function ($scope, Order, $stateParams) {
  //Get ID of current order
  var currentId = $stateParams.id;
  if (currentId != undefined) {
    $scope.order = Order.get({id: currentId});
  };
};

OrdersController.$inject = ['$scope', 'Order', '$stateParams'];

angular.module('shop').controller('OrdersController', OrdersController);

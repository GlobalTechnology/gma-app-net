
(function () {
    //Find existing Module instance named 'gcmApp'
    var app = angular.module("gcmApp");

    var church_controller = function ($scope, church_service) {
        $scope.$parent.is_loaded = false;
        $scope.edit_church = {};

      




        $scope.loadChurches = function () {
            console.log('loading churches');
            var extras = '&ministry_id=' + $scope.assignment.ministry_id


            church_service.getChurches($scope.user.session_ticket, null, extras).then($scope.onGetChurches, $scope.onError);

        };

      //  $scope.loadChurches();





        $scope.$watch('assignment', function (a) {
            $scope.loadChurches();


        }, true);










        $scope.onGetChurches = function (response) {
            $scope.churches = response;
            console.log('got churches');



        };




    };


    app.controller("churchController", ["$scope", "church_service", church_controller]);

}());
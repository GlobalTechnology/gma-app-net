(function () {

    //Find existing Module instance named 'gcmApp'
    var app = angular.module("gcmApp");

    var training_controller = function ($scope, training_service) {
        $scope.newTraining = {};
        $scope.deleteTraining = {};
        $scope.show_all = "year";
        $scope.show_tree = false;
        $scope.deleteTrainingCompletion = {};
        $scope.onGetTraining = function (response) {
            $scope.assignment.trainings = response;
            angular.forEach($scope.assignment.trainings, function (training) {
                training.current_stage = getHighest(training.gcm_training_completions)+1;
                training.editMode = false;
            });

        }
        $scope.onSaveTraining = function (response) { };
        $scope.onSaveTrainingCompletion = function (response) { };
        $scope.onAddTrainingCompletion = function (response) {
            response.editMode = false;

            angular.forEach($scope.assignment.trainings, function (training) {
                if(training.Id== response.training_id){
                    training.gcm_training_completions.push(response);
                    training.current_stage = response.phase + 1;
                }
            });
            

        };
        $scope.onAddTraining = function (response) {
            response.current_stage = getHighest(response.gcm_training_completions) + 1;
            response.editMode = false;
            $scope.assignment.trainings.push(response);
            $scope.newTraining = {};
  
        };
        $scope.onDeleteTraining = function () {
            $scope.assignment.trainings.splice($scope.assignment.trainings.indexOf($scope.deleteTraining), 1);
            $scope.deleteTraining = {};
        };
        $scope.onDeleteTrainingCompletion = function () {
            angular.forEach($scope.assignment.trainings, function (training) {
                if (training.Id == $scope.deleteTrainingCompletion.training_id) {
                    training.gcm_training_completions.splice(training.gcm_training_completions.indexOf($scope.deleteTrainingCompletion), 1);
                    training.current_stage = $scope.deleteTrainingCompletion.phase;
                    console.log(training.current_stage);
                }
            });
            
            $scope.deleteTraining = {};
            $scope.deleteTrainingCompletion = {};
        };

        $scope.$watch('assignment.ministry_id', function (a) {
            $scope.reloadTraining();

        });

        $scope.reloadTraining = function () {
            if ($scope.assignment) {
                training_service.getTrainings($scope.user.session_ticket, $scope.assignment.ministry_id, $scope.show_all == "all", $scope.show_tree).then($scope.onGetTraining, $scope.onError);
            }
        };

        $scope.getTrainingTotal = function (t) {
            var rtn = 0;
            if($scope.assignment){
            angular.forEach($scope.assignment.trainings, function (training) {
                if(training.type==t){
                    rtn+=getHighestCount(training.gcm_training_completions);
                }
            });
        }
            return rtn;
        };

        $scope.training_types = [
   { value: "MC2", text: 'MC2' },
   { value: "T4T", text: 'T4T' },
   { value: "CPMI", text: 'CPMI' },
   { value: "", text: 'Other' }
        ];

        $scope.saveTraining = function (data) {
            training_service.updateTraining($scope.user.session_ticket, data).then($scope.onSaveTraining, $scope.onError);
        };
        $scope.saveTrainingCompletion = function (data) {
            training_service.updateTrainingCompletion($scope.user.session_ticket, data).then($scope.onSaveTrainingCompletion, $scope.onError);
        };
        $scope.addTrainingStage = function (training) {
            var newPhase= {
                phase: training.current_stage,
                date: training.insert.date,
                number_completed: training.insert.number_completed,
                training_id: training.Id
                
            };
            training_service.addTrainingCompletion($scope.user.session_ticket, newPhase ).then($scope.onAddTrainingCompletion, $scope.onError);
           
            training.insert.date = "";
            training.insert.number_completed = 0;

        };
        $scope.addTraining = function () {
            angular.extend($scope.newTraining, { ministry_id: $scope.assignment.ministry_id });
            training_service.addTraining($scope.user.session_ticket, $scope.newTraining).then($scope.onAddTraining, $scope.onError);
            
        };
        $scope.removeTraining = function () {
          
            training_service.deleteTraining($scope.user.session_ticket, $scope.deleteTraining).then($scope.onDeleteTraining, $scope.onError);
        };

        $scope.removeTrainingCompletion = function () {
            
            training_service.deleteTrainingCompletion($scope.user.session_ticket, $scope.deleteTrainingCompletion).then($scope.onDeleteTrainingCompletion, $scope.onError);
        };
        // $scope.Math = window.Math;
        //$scope.training_activities = [
        // { Id: '1', name: 'First Training', training_type: "mc2", start_date: "2014-09-02", completion: [{ stage: "1", date: "2014-09-07", number_completed: 9 }, { stage: "2", date: "2014-09-07", number_completed: 8 }, { stage: "3", date: "2014-09-07", number_completed: 7 }] },
        // { Id: '2', name: 'Second Training', training_type: "mc2", start_date: "2014-09-07", completion: [{ stage: "2", date: "2014-09-07", number_completed: 8 }] },
        // { Id: '3', name: 'Third Training', training_type: "mc2", start_date: "2014-09-30", completion: [{ stage: "3", date: "2014-09-07", number_completed: 7 }] }
        //];






    };

    app.controller("trainingController", ["$scope", "training_service", training_controller]);
    function getHighest(array) {
        var max = 0;
        for (var i = 0; i < array.length; i++) {
            if (array[i].phase > (max || 0))
                max = array[i].phase;
        }
       
        return max;
    }
    function getHighestCount(array) {
        var max = 0;
        for (var i = 0; i < array.length; i++) {
            if (array[i].number_completed > (max || 0))
                max = array[i].number_completed;
        }
       
        return max;
    }
}());
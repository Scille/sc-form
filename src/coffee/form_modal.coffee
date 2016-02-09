'use strict'

angular.module('sc-form-modal', ['ui.bootstrap'])

  .controller 'arrayInputModalController', ($scope, $modalInstance, jsonData) ->
    $scope.modalModel = {}
    $scope.jsonData = {}
    if jsonData?
      $scope.jsonData = angular.copy(jsonData)

    $scope.valid = ->
      $modalInstance.close($scope.modalModel)

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

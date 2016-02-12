'use strict'

angular.module('sc-form-modal', ['ui.bootstrap'])

  .controller 'arrayInputModalController', ($scope, $modalInstance, jsonData, modalModel) ->
    $scope.jsonData = {}
    $scope.modalModel = {}

    if jsonData?
      $scope.jsonData = angular.copy(jsonData)

    if modalModel?
      $scope.modalModel = angular.copy(modalModel)

    $scope.valid = ->
      $modalInstance.close($scope.modalModel)

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

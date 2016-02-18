'use strict'

angular.module('sc-array-input-modal', ['ui.bootstrap', 'array_input_modalTemplate'])

  .controller 'scArrayInputModalController', ($scope, $modalInstance, jsonData, modalModel) ->
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

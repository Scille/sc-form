'use strict'

angular.module('sc-file-input-modal', ['ui.bootstrap', 'file_input_modalTemplate'])
  .controller 'scFileInputModalController', ($scope, $modalInstance, modalModel) ->
    $scope.ok = ->
      $modalInstance.close()

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

.directive 'file-info', -> {
  restrict: 'EA'
  scope: {
    file: '=?'
  }

  link: (scope, iElement, iAttrs) ->
    console.log('toto')
}

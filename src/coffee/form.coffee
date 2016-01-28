'use strict'

angular.module('sc-form', ['sc-form-template'])

.directive 'textInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/text_input_template.html'
    controller: 'textInputController'
    require: 'ngModel'
    scope:
      isDisabled: '=?'
      label: '@'
      icon: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      upperFirstLetter: '=?'
      localModel: '=ngModel'

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'

      if (angular.isUndefined(tAttrs.upperFirstLetter))
        tAttrs.upperFirstLetter = 'false'

      postLink = (scope, iElement, iAttrs, ngModelCtrl) ->
        # Check if we must create a popover.
        if scope.popoverMsg && scope.popoverMsg != ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  .controller 'textInputController', ($scope) ->
    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)

    $scope.onBlur = ->
      if $scope.localModel && $scope.localModel != ''
        $scope.localModel = $scope.localModel.trim()
        if $scope.upperFirstLetter == true
          $scope.localModel = $scope.localModel.charAt(0).toUpperCase() + $scope.localModel.slice(1)

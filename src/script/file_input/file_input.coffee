'use strict'

angular.module('sc-text-input',  ['text_inputTemplate'])

  .directive 'scTextInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/text_input/text_input_template.html'
    controller: 'scTextInputController'
    require: 'ngModel'
    scope: {
      icon: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      upperFirstLetter: '=?'
      localModel: '=ngModel'
    }

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'

      if (angular.isUndefined(tAttrs.upperFirstLetter))
        tAttrs.upperFirstLetter = 'false'

      postLink = (scope, iElement, iAttrs) ->
        # Check if we must create a popover.
        if scope.popoverMsg and scope.popoverMsg isnt ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  }
  .controller 'scTextInputController', ($scope) ->
    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)

    $scope.onBlur = ->
      if $scope.localModel and $scope.localModel isnt ''
        $scope.localModel = $scope.localModel.trim()
        if $scope.upperFirstLetter is true
          $scope.localModel = $scope.localModel.charAt(0).toUpperCase() + $scope.localModel.slice(1)

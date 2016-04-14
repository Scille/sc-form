'use strict'

angular.module('sc-list-text-input',  ['list_text_inputTemplate'])

  .directive 'scListTextInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/list_text_input/list_text_input_template.html'
    controller: 'scListTextInputController'
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

      postLink = (scope, iElement, iAttrs, ngModelCtrl) ->
        # The $formatters pipeline. Convert a real model value into a value our
        # view can use.
        ngModelCtrl.$formatters.push (modelValue) ->
          return modelValue

        # The $parsers Pipeline. Converts the $viewValue into the $modelValue.
        ngModelCtrl.$parsers.push (viewValue) ->
          return viewValue

        # Updating the UI to reflect $viewValue
        ngModelCtrl.$render = ->
          scope.localModel = ngModelCtrl.$viewValue

        # Updating $viewValue when the UI changes
        scope.$watch 'localModel', (value) ->
          ngModelCtrl.$setViewValue(value)

        # Check if we must create a popover.
        if scope.popoverMsg and scope.popoverMsg isnt ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  }
  .controller 'scListTextInputController', ($scope) ->
    ### Define newValue ###
    $scope.newValue = undefined

    $scope.keyDown = (keyEvent) ->
      # Press Enter Button
      if keyEvent.which is 13
        $scope.onBlur()

    $scope.onBlur = ->
      if $scope.newValue and $scope.newValue isnt ''
        $scope.newValue = $scope.newValue.trim()
        if $scope.upperFirstLetter is true
          $scope.newValue = $scope.newValue.charAt(0).toUpperCase() + $scope.newValue.slice(1)

        if $scope.localModel is undefined
          $scope.localModel = []

        $scope.localModel.push($scope.newValue)
        $scope.newValue = ''

    $scope.deleteValue = (key) ->
      $scope.localModel.splice(key, 1)

      if $scope.localModel.length is 0
        delete $scope.localModel

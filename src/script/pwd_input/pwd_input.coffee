'use strict'

angular.module('sc-pwd-input',  ['pwd_inputTemplate'])

  .directive 'scPwdInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/pwd_input/pwd_input_template.html'
    controller: 'scPwdInputController'
    require: 'ngModel'
    scope: {
      icon: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      strength: '=?'
      localModel: '=ngModel'
    }

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.strength))
        tAttrs.strength = '{regex: "^.+$", error: "Should contain at least one character"}'

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
          scope.newValue = ngModelCtrl.$viewValue

        # Updating $viewValue when the UI changes
        scope.$watch 'localModel', (value) ->
          ngModelCtrl.$setViewValue(value)
          if value
            scope.strength.match = !!value.match(scope.strength.regex)
          else
            scope.strength.match = true

        # Check if we must create a popover.
        if scope.popoverMsg and scope.popoverMsg isnt ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  }
  .controller 'scPwdInputController', ($scope, uuid) ->
    ### Get UUID ###
    $scope.uuid = uuid.new()

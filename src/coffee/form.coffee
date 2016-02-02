'use strict'

guid = ->
  s4 = ->
    Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
  s4() + s4() + '_' + s4() + '_' + s4() + '_' + s4() + '_' + s4() + s4() + s4()


angular.module('sc-form', ['sc-form-template'])

# Text Input
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

      postLink = (scope, iElement, iAttrs) ->
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


# Number Input
.directive 'numberInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/number_input_template.html'
    controller: 'numberInputController'
    require: 'ngModel'
    scope:
      isDisabled: '=?'
      label: '@'
      icon: '@'
      placeholder: '@'
      popoverMsg: '@'
      step: '=?'
      errorMsg: '=?'
      localModel: '=ngModel'

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'

      postLink = (scope, iElement, iAttrs) ->
        # Check if we must create a popover.
        if scope.popoverMsg && scope.popoverMsg != ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  .controller 'numberInputController', ($scope) ->
    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)


# Date Input
.directive 'dateInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/date_input_template.html'
    controller: 'dateInputController'
    require: 'ngModel'
    scope:
      isDisabled: '=?'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      format: '@'
      errorMsg: '=?'
      localModel: '=ngModel'
      approximativeModel: '=?'

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'

      if (angular.isUndefined(tAttrs.format))
        tAttrs.format = 'DD/MM/YYYY HH:mm'

      postLink = (scope, iElement, iAttrs) ->
        # Check if we must create a popover.
        if scope.popoverMsg && scope.popoverMsg != ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

        # Create datetimepicker ID
        scope.dateTimePickerId = guid()

        # Check Approximative Model
        scope.isApproximative = !angular.isUndefined(iAttrs.approximativeModel)

  .controller 'dateInputController', ($scope) ->
    ### Define origin Model and dateTimePickerText###
    $scope.originModel = angular.copy($scope.localModel)
    $scope.dateTimePickerText = undefined

    # Create a DateTimePicker
    $scope.createDateTimePicker = () ->
      # For displaying datepicker
      angular.element("##{$scope.dateTimePickerId}").datetimepicker(
        date: $scope.localModel
        format: $scope.format
        useCurrent: true
        sideBySide: true
        viewMode: 'years'
      )
      # Getting input value
      angular.element("##{$scope.dateTimePickerId}").on("dp.hide", () ->
        $scope.localModel = angular.element("##{$scope.dateTimePickerId}").data("DateTimePicker").date().format($scope.format)
      )
      return

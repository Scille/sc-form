'use strict'

guid = ->
  s4 = ->
    Math.floor((1 + Math.random()) * 0x10000).toString(16).substring 1
  s4() + s4() + '_' + s4() + '_' + s4() + '_' + s4() + '_' + s4() + s4() + s4()

angular.module('sc-form', ['sc-form-template', 'sc-form-modal'])

  # Text Input
  .directive 'textInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/text_input_template.html'
    controller: 'textInputController'
    require: 'ngModel'
    scope:
      icon: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      isDisabled: '=?'
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


  # List Text Input
  .directive 'listTextInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/list_text_input_template.html'
    controller: 'listTextInputController'
    require: 'ngModel'
    scope:
      icon: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      upperFirstLetter: '=?'
      localModel: '=ngModel'

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
        if scope.popoverMsg && scope.popoverMsg != ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  .controller 'listTextInputController', ($scope) ->
    ### Define local Model and newValue ###
    $scope.newValue = undefined

    $scope.onBlur = ->
      if $scope.newValue && $scope.newValue != ''
        $scope.newValue = $scope.newValue.trim()
        if $scope.upperFirstLetter == true
          $scope.newValue = $scope.newValue.charAt(0).toUpperCase() + $scope.newValue.slice(1)

        if $scope.localModel == undefined
          $scope.localModel = []

        $scope.localModel.push($scope.newValue)
        $scope.newValue = ''

    $scope.deleteValue = (key) ->
      $scope.localModel.splice(key, 1)

      if $scope.localModel.length == 0
        delete $scope.localModel

  # Number Input
  .directive 'numberInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/number_input_template.html'
    controller: 'numberInputController'
    require: 'ngModel'
    scope:
      icon: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      step: '=?'
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
      format: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      approximativeModel: '=?'
      errorMsg: '=?'
      isDisabled: '=?'
      localModel: '=ngModel'

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
    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)
    $scope.dateTimePickerModel = undefined

    $ ->
      angular.element("##{$scope.dateTimePickerId}").keydown(false)
      angular.element("##{$scope.dateTimePickerId}").datetimepicker(
        format: $scope.format
        allowInputToggle:true
        sideBySide: true
        viewMode: 'years'
      )
      angular.element("##{$scope.dateTimePickerId}").on('dp.change', ->
        $scope.localModel = angular.element("##{$scope.dateTimePickerId}").data("DateTimePicker").date().format($scope.format)
        $scope.$apply()
        return
      )
      return


  # Array Input
  .directive 'arrayInputDirective', ->
    restrict: 'EA'
    templateUrl: 'src/html_template/array_input_template.html'
    controller: 'arrayInputController'
    require: 'ngModel'
    scope:
      addButton: '@'
      json: '@'
      label: '@'
      isDisabled: '=?'
      localModel: '=ngModel'

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.addButton))
        tAttrs.addButton = 'Add'

      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'

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

  .controller 'arrayInputController', ($scope, $modal, $http) ->
    ### Define local Model and jsonData ###
    $scope.jsonData = undefined

    # Read data from a specific json file
    $http.get($scope.json)
      .success( (data) ->
        $scope.jsonData = angular.copy(data)
      )
      .error( (data, status) ->
        $scope.errorMsg = "Le fichier JSON (" + $scope.json + ") n'a pa pu être récupéré."
      )

    $scope.addValue = ->
      modalInstance = $modal.open(
        templateUrl: 'src/html_template/array_input_modal_template.html'
        controller: 'arrayInputModalController'
        resolve:
          jsonData: ->
            return $scope.jsonData
          modalModel: ->
            return null
      )
      modalInstance.result.then(
        (result) ->
          if !angular.equals({}, result)
            if $scope.localModel == undefined
              $scope.localModel = []

            $scope.localModel.push(result)
      )

    $scope.editValue = (key) ->
      modalInstance = $modal.open(
        templateUrl: 'src/html_template/array_input_modal_template.html'
        controller: 'arrayInputModalController'
        resolve:
          jsonData: ->
            return $scope.jsonData
          modalModel: ->
            return angular.copy($scope.localModel[key])
      )
      modalInstance.result.then(
        (result) ->
          $scope.localModel[key] = angular.copy(result)
      )

    $scope.deleteValue = (key) ->
      $scope.localModel.splice(key, 1)

      if $scope.localModel.length == 0
        delete $scope.localModel

'use strict'

angular.module('sc-array-input',  ['array_inputTemplate', 'sc-array-input-modal'])

  .directive 'scArrayInputDirective', ->
    restrict: 'EA'
    templateUrl: 'script/array_input/array_input_template.html'
    controller: 'scArrayInputController'
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

  .controller 'scArrayInputController', ($scope, $modal, $http) ->
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
        templateUrl: 'script/array_input/modal/array_input_modal_template.html'
        controller: 'scArrayInputModalController'
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
        templateUrl: 'script/array_input/modal/array_input_modal_template.html'
        controller: 'scArrayInputModalController'
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

'use strict'

angular.module('sc-list-select-input',  ['list_select_inputTemplate'])

  .directive 'scListSelectInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/list_select_input/list_select_input_template.html'
    controller: 'scListSelectInputController'
    require: 'ngModel'
    scope: {
      icon: '@'
      optionsJson: '@'
      label: '@'
      changePosition: '=?'
      errorMsg: '=?'
      isDisabled: '=?'
      localModel: '=ngModel'
      optionsModel: "=?"
    }

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.changePosition))
        tAttrs.changePosition = 'false'

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
  }
  .controller 'scListSelectInputController', ($scope, $http, uuid) ->
    ### Get UUID ###
    $scope.uuid = uuid.new()

    ### Define newValue ###
    $scope.newValue = undefined
    ### Get options values ###
    if $scope.optionsJson? and $scope.optionsJson isnt ''
      $http.get($scope.optionsJson)
        .success( (data) ->
          $scope.localOptionsModel = data
        )
        .error( (data, status) ->
          $scope.localOptionsModel = [{libelle: "No options", value: null}]
          $scope.errorMsg = "Le fichier JSON (" + $scope.optionsJson + ") n'a pa pu être récupéré."
        )
    else
      $scope.$watch 'optionsModel', (value) ->
        if not value?
          $scope.localOptionsModel = [{libelle: "No options", value: null}]
        else
          $scope.localOptionsModel = []
          if Object.prototype.toString.call(value) is '[object Array]'
            if Object.prototype.toString.call(value[0]) is '[object Object]'
              $scope.localOptionsModel = angular.copy(value)
            else
              $scope.localOptionsModel.push({libelle: elt, value: elt}) for elt in value

    ### Add new value ###
    $scope.$watch 'newValue', (value) ->
      if value? and value isnt ''
        if $scope.localModel is undefined
          $scope.localModel = []

        $scope.localModel.push(value)
        $scope.newValue = ''

    ### Change value position ###
    $scope.upValue = (key) ->
      if key > 0
        temp = $scope.localModel[key]
        $scope.localModel[key] = $scope.localModel[key - 1]
        $scope.localModel[key - 1] = temp

    $scope.downValue = (key) ->
      if key < $scope.localModel.length - 1
        temp = $scope.localModel[key]
        $scope.localModel[key] = $scope.localModel[key + 1]
        $scope.localModel[key + 1] = temp

    ### Delete value ###
    $scope.deleteValue = (key) ->
      $scope.localModel.splice(key, 1)

      if $scope.localModel.length is 0
        delete $scope.localModel

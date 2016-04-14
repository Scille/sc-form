'use strict'

angular.module('sc-select-input',  ['select_inputTemplate'])

  .directive 'scSelectInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/select_input/select_input_template.html'
    controller: 'scSelectInputController'
    require: 'ngModel'
    scope: {
      icon: '@'
      optionsJson: '@'
      label: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      localModel: '=ngModel'
      optionsModel: "=?"
    }

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'
  }
  .controller 'scSelectInputController', ($scope, $http) ->
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
      console.log("watch")
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

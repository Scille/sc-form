'use strict'

angular.module('sc-file-input',  ['file_inputTemplate'])

  .directive 'scFileInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/file_input/file_input_template.html'
    controller: 'scFileInputController'
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
  .controller 'scFileInputController', ($scope) ->
    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)

    $scope.onBlur = ->
      if $scope.localModel and $scope.localModel isnt ''
        $scope.localModel = $scope.localModel.trim()
        if $scope.upperFirstLetter is true
          $scope.localModel = $scope.localModel.charAt(0).toUpperCase() + $scope.localModel.slice(1)

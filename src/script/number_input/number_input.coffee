'use strict'

angular.module('sc-number-input',  ['number_inputTemplate'])

  .directive 'scNumberInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/number_input/number_input_template.html'
    controller: 'scNumberInputController'
    require: 'ngModel'
    scope: {
      icon: '@'
      label: '@'
      placeholder: '@'
      popoverMsg: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      step: '=?'
      localModel: '=ngModel'
    }

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.isDisabled))
        tAttrs.isDisabled = 'false'

      postLink = (scope, iElement, iAttrs) ->
        # Check if we must create a popover.
        if scope.popoverMsg and scope.popoverMsg isnt ''
          $(iElement).popover({
            trigger: 'focus'
            content: scope.popoverMsg
            placement: 'top'
          })

  }
  .controller 'scNumberInputController', ($scope, uuid) ->
    ### Get UUID ###
    $scope.uuid = uuid.new()

    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)

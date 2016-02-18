'use strict'

angular.module('sc-date-input',  ['date_inputTemplate'])

  .directive 'scDateInputDirective', ->
    restrict: 'EA'
    templateUrl: 'script/date_input/date_input_template.html'
    controller: 'scDateInputController'
    require: 'ngModel'
    scope:
      icon: '@'
      label: '@'
      popoverMsg: '@'
      type: '@'
      approximativeModel: '=?'
      errorMsg: '=?'
      isDisabled: '=?'
      localModel: '=ngModel'

    compile: (tElement, tAttrs) ->
      if (angular.isUndefined(tAttrs.type))
        tAttrs.type = 'date'
      else if (!tAttrs.type.match("^(date|datetime-local)$"))
        console.log("Error: type must date|datetime-local")
        tAttrs.type = 'date'

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

        # Check Approximative Model
        scope.isApproximative = !angular.isUndefined(iAttrs.approximativeModel)

  .controller 'scDateInputController', ($scope, $timeout) ->
    ### Define origin Model ###
    $scope.originModel = angular.copy($scope.localModel)

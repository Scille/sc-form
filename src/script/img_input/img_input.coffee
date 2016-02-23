'use strict'

angular.module('sc-img-input',  ['img_inputTemplate', 'sc-img-input-modal'])

  .directive 'scImgInputDirective', ->
    restrict: 'EA'
    templateUrl: 'script/img_input/img_input_template.html'
    controller: 'scImgInputController'
    require: 'ngModel'
    scope:
      height: '@'
      label: '@'
      placeholder: '@'
      width: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      localModel: '=ngModel'

    compile: (tElement, tAttrs) ->

      if (angular.isUndefined(tAttrs.placeholder))
        tAttrs.placeholder = 'Drop images here'

      if (angular.isUndefined(tAttrs.height))
        tAttrs.height = '200px'

      if (angular.isUndefined(tAttrs.width))
        tAttrs.width = '200px'

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
        scope.$watchCollection 'localModel', (value) ->
          ngModelCtrl.$setViewValue(value)

          $('.dropzone img', iElement).remove()
          if (value? and value.data?)
            img = $('<img />').attr('src', value.data).fadeIn()
            $('.dropzone div', iElement).html(img)
          else
            $('.dropzone div', iElement).html(scope.placeholder)


        $('.dropzone input', iElement).on('change', (e) ->
          file = this.files[0]

          if (file? and file.type.match('image.*'))
            reader = new FileReader(file)
            reader.readAsDataURL(file)

            reader.onload = (e) ->
              scope.$apply(
                scope.localModel =
                  file: file.name
                  data: e.target.result
              )
        )

  .controller 'scImgInputController', ($scope, $modal) ->

    $scope.editValue = () ->
      modalInstance = $modal.open(
        templateUrl: 'script/img_input/modal/img_input_modal_template.html'
        controller: 'scImgInputModalController'
        resolve:
          modalModel: ->
            return angular.copy($scope.localModel.data)
      )
      modalInstance.result.then(
        (result) ->
          $scope.localModel.data = angular.copy(result)
      )

    $scope.deleteValue = () ->
      delete $scope.localModel

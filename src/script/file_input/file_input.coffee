'use strict'

angular.module('sc-file-input',  ['file_inputTemplate', 'sc-file-input-modal'])

  .directive 'scFileInputDirective', -> {
    restrict: 'EA'
    templateUrl: 'script/file_input/file_input_template.html'
    controller: 'scFileInputController'
    require: 'ngModel'
    scope: {
      height: '@'
      label: '@'
      placeholder: '@'
      width: '@'
      errorMsg: '=?'
      isDisabled: '=?'
      localModel: '=ngModel'
    }

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

          $('.dropzone file', iElement).remove()
          if (value? and value.data?)
            file = $('<file />').attr('src', value.data).fadeIn()
            $('.dropzone div', iElement).html(file)
          else
            $('.dropzone div', iElement).html(scope.placeholder)


        $('.dropzone input', iElement).on('change', (e) ->
          file = this.files[0]

          if (file? and file.type.match('image.*'))
            scope.openModal(file)
        )

  }
  .controller 'scFileInputController', ($scope, $modal) ->

    $scope.openModal = (file) ->
      reader = new FileReader(file)
      reader.readAsDataURL(file)

      reader.onload = (e) ->
        modalInstance = $modal.open({
          templateUrl: 'script/file_input/modal/file_input_modal_template.html'
          controller: 'scFileInputModalController'
          resolve: {
            modalModel: ->
              return e.target.result
          }
        })
        modalInstance.result.then(
          # Close with file result
          (result) ->
            $scope.localModel = {file: file.name, data: result}
          # Dismiss
          ->
            return
        )

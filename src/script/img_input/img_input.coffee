'use strict'

angular.module('sc-img-input',  ['img_inputTemplate'])

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

  .controller 'scImgInputController', ($scope, $timeout) ->

    $('.dropzone input').on('change', (e) ->
      file = this.files[0]
      $('.dropzone img').remove()

      if (file?)
        reader = new FileReader(file)
        reader.readAsDataURL(file)

        reader.onload = (e) ->
          data = e.target.result
          $img = $('<img />').attr('src', data).fadeIn()

          $('.dropzone div').html($img)
      else
        $('.dropzone div').html($scope.placeholder)
    )

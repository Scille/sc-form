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
      files: '=?'
    }

    compile: (tElement, tAttrs) ->

      if (angular.isUndefined(tAttrs.placeholder))
        tAttrs.placeholder = 'Drop files here'

      if (angular.isUndefined(tAttrs.height))
        tAttrs.height = '200px'

      if (angular.isUndefined(tAttrs.width))
        tAttrs.width = '300px'

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
            #scope.openModal(this.files)
            #scope.addFiles(this.files)
        )

  }
  .controller 'scFileInputController', ($scope, $modal) ->
    $scope.addFiles = (files) ->
      #console.log(files)
      $scope.files = files
    $scope.openModal = (files) ->
      ###
      imgs = []
      for file in files
        reader = new FileReader(file)
        reader.readAsDataURL(file)
        reader.fileName = file.name

        reader.onload = (e) ->
          imgs.push({name:e.target.fileName, data:e.target.result, canvas:{}})
      ###

      modalInstance = $modal.open({
        templateUrl: 'script/file_input/modal/file_input_modal_template.html'
        controller: 'scFileInputModalController'
        resolve: {
          files: ->
            return files
        }
      })
      modalInstance.result.then(
        # Close with img result
        (result) ->
          $scope.localModel = result
        # Dismiss
        ->
          return
      )
.directive 'fileInfo', -> {
  restrict: 'EA'
  scope: {
    files: '=?'
  }

  link: (scope, iElement, iAttrs) ->
    #console.log(scope.files)
}

.filter 'size',  ->
  return (input) ->
    out = ""
    size = parseInt(input)

    if (isNaN(size))
      return "0"

    unit = ["o","KiB","MiB","GiB","TiB"]
    i = 0
    while (size >= 1024)
        i++
        size = size/1024

    out = size.toFixed(2) + ' ' + unit[i]
    return out

.filter 'type',  ->
  return (input) ->
    out = ""
    icons = {
      "text": "file-text-o"
      "video": "file-video-o"
      "audio": "file-audio-o"
      "image": "file-image-o"
      "application/pdf": "file-pdf-o"
      "application/zip": "file-zip-o"
      "application/msword": "file-word-o"
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document": "file-word-o"
      "application/vnd.oasis.opendocument.text": "file-word-o"
      "application/vnd.ms-excel": "file-excel-o"
      "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet": "file-excel-o"
      "application/vnd.oasis.opendocument.spreadsheet": "file-excel-o"
      "application/vnd.ms-powerpoint": "file-powerpoint-o"
      "application/vnd.openxmlformats-officedocument.presentationml.presentation": "file-powerpoint-o"
      "application/vnd.oasis.opendocument.presentation": "file-powerpoint-o"
      "files": "files-o"
      "default": "file-o"
      #"": "file-code-o"
    }

    unless (input?)
      return "ERROR"

    if (icons[input]?)
      out = icons[input]
    else if (input.match("(.*?)/")?)
      exp = input.match("(.*?)/")[1]
      if (icons[exp]?)
        out = icons[exp]

    if (out == "")
      out = icons["default"]

    return out

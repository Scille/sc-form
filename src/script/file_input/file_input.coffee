'use strict'

angular.module('sc-file-input',  ['file_inputTemplate'])
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
        tAttrs.placeholder = 'Drop files here'

      if (angular.isUndefined(tAttrs.height))
        tAttrs.height = '200px'

      if (angular.isUndefined(tAttrs.width))
        tAttrs.width = '500px'

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

          $('.file-dropzone file', iElement).remove()
          if (value? and value.data?)
            file = $('<file />').attr('src', value.data).fadeIn()
            $('.file-dropzone div', iElement).html(file)
          else
            $('.file-dropzone div', iElement).html(scope.placeholder)


        $('.file-dropzone input', iElement).on('change', (e) ->
          scope.addFiles(this.files)
        )

  }
  .controller 'scFileInputController', ($scope, $modal) ->
    $scope.addFiles = (files) ->
      filelist = []
      for file in files
        filelist.push(file)
      $scope.files = filelist
      $scope.localModel = $scope.files
      $scope.$apply()

    $scope.download = () ->
      file = this.file
      if (file?)
        reader = new FileReader(file)
        reader.readAsDataURL(file)
        reader.fileName = file.name
        reader.onload = (e) ->
          hiddenElement = document.createElement('a')
          hiddenElement.href = e.target.result
          hiddenElement.target = '_blank'
          hiddenElement.download = e.target.fileName
          hiddenElement.click()

    $scope.reset = () ->
      $scope.files = []
      $scope.localModel = $scope.files

    $scope.delete = () ->
      file = this.file
      if (file?)
        $scope.files = $scope.files.filter (f) -> f isnt file
        $scope.localModel = $scope.files

  .directive 'fileInfo', -> {
    restrict: 'EA'
  }

  .filter 'name',  ->
    return (input) ->
      out = input
      if (input.length > 25)
        out = input.substr(0, 15) + '...' + input.slice(-9)

      return out

  .filter 'size',  ->
    return (input) ->
      out = ""
      size = parseInt(input)

      if (isNaN(size))
        return "0"

      unit = ["B", "KiB", "MiB", "GiB", "TiB"]
      i = 0
      while (size >= 1024)
        i++
        size = size / 1024

      out = size.toFixed(1) + ' ' + unit[i]
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

      if (out is "")
        out = icons["default"]

      return out

  .filter 'progress', ->
    return (input) ->
      out = ""
      progress = parseInt(input)

      if (isNaN(progress) or progress is 0)
        return ""

      out = progress + '%'

      return out

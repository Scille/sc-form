'use strict'

angular.module('sc-file-input-modal', ['ui.bootstrap', 'file_input_modalTemplate'])
  .controller 'scFileInputModalController', ($scope, $modalInstance, files) ->
    $scope.files = files
    $scope.ok = ->
      $modalInstance.close()

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

.directive 'fileInfo', -> {
  restrict: 'EA'
  scope: {
    files: '=?'
  }

  link: (scope, iElement, iAttrs) ->
    console.log('toto')
    console.log(scope.files)
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

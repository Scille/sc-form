'use strict'

angular.module('sc-img-input-modal', ['ui.bootstrap', 'img_input_modalTemplate'])

  .directive 'imgCanvas', ->
    restrict: 'EA'
    scope:
      canvas: '=?'

    link: (scope, iElement, iAttrs, ngModelCtrl) ->
      scope.canvas = iElement[0]

  .controller 'scImgInputModalController', ($scope, $modalInstance, modalModel) ->
    ctx = null
    dradding = false
    ratio = 0
    width_ori = 0
    height_ori = 0
    sx = 0
    sy = 0
    swidth = 0
    sheight = 0
    x = 0
    y = 0
    width = 0
    height = 0

    $scope.$watch 'canvas', (canvas) ->
      if (canvas?)
        ctx = canvas.getContext("2d")

    photo = new Image()
    photo.src = modalModel
    photo.onload = ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      # http://www.w3schools.com/tags/canvasdrawimage.asp
      width_ori = this.width
      height_ori = this.height
      # display the all image inside canvas
      ratio = height_ori / width_ori
      sx = 0
      sy = 0
      swidth = width_ori
      sheight = height_ori

      # compute new size image
      if ratio < $scope.canvas.height / $scope.canvas.width
        width = $scope.canvas.width
        height = width * ratio
      else
        height = $scope.canvas.height
        width = height / ratio

      # place image
      if width == $scope.canvas.width
        x = 0
      else
        x = ($scope.canvas.width - width)/2
      if height == $scope.canvas.height
        y = 0
      else
        y = ($scope.canvas.height - height)/2
      # display image
      ctx.drawImage(photo, x, y, width, height)

    $scope.zoomIn = (pixels = 10) ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      width += 2*pixels
      height = width * ratio
      x -= pixels
      y -= pixels * ratio
      ctx.drawImage(photo, x, y, width, height)

    $scope.zoomOut = (pixels = 10) ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      width -= 2*pixels
      height = width * ratio
      x += pixels
      y += pixels * ratio
      ctx.drawImage(photo, x, y, width, height)

    $scope.goUp = (pixels = 10) ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      y += pixels
      ctx.drawImage(photo, x, y, width, height)

    $scope.goDown = (pixels = 10) ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      y -= pixels
      ctx.drawImage(photo, x, y, width, height)

    $scope.goLeft = (pixels = 10) ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      x += pixels
      ctx.drawImage(photo, x, y, width, height)

    $scope.goRight = (pixels = 10) ->
      ctx.clearRect(0, 0, $scope.canvas.width, $scope.canvas.height)
      x -= pixels
      ctx.drawImage(photo, x, y, width, height)

    $scope.valid = ->
      dataURL = $scope.canvas.toDataURL()
      frontier = dataURL.search(',')
      shortDataUrl = dataURL.substr(frontier+1)
      decoded = atob(shortDataUrl)
      length = decoded.length
      ab = new ArrayBuffer(length)
      ua = new Uint8Array(ab)
      for i in [0..length-1]
        ua[i] = decoded.charCodeAt(i)
      blob = new Blob([ua], {type: 'image/png'})
      reader = new FileReader(blob)
      reader.readAsDataURL(blob)

      reader.onload = (e) ->
        $modalInstance.close(e.target.result)



    $scope.cancel = ->
      $modalInstance.dismiss('cancel')

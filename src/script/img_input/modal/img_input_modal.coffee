'use strict'

angular.module('sc-img-input-modal', ['ui.bootstrap', 'img_input_modalTemplate'])
  .controller 'scImgInputModalController', ($scope, $modalInstance, modalModel) ->
    $scope.canvas = {
      image: modalModel
    }

    $scope.$watch 'zoom', (value) ->
      if value?
        $scope.canvas.zoom(value / 100)

    $scope.ok = ->
      dataURL = $scope.canvas.getDataURL()
      frontier = dataURL.search(',')
      shortDataUrl = dataURL.substr(frontier + 1)
      decoded = atob(shortDataUrl)
      length = decoded.length
      ab = new ArrayBuffer(length)
      ua = new Uint8Array(ab)
      for i in [0 .. length - 1]
        ua[i] = decoded.charCodeAt(i)
      blob = new Blob([ua], {type: 'image/png'})
      reader = new FileReader(blob)
      reader.readAsDataURL(blob)

      reader.onload = (e) ->
        $modalInstance.close(e.target.result)

    $scope.cancel = ->
      $modalInstance.dismiss('cancel')


  .directive 'imgCanvas', -> {
    restrict: 'EA'
    scope: {
      canvas: '=?'
    }

    link: (scope, iElement, iAttrs) ->
      canvasWidth = iElement[0].width
      canvasHeight = iElement[0].height
      ctx = iElement[0].getContext('2d')

      # Variable that decides if img should be moved on mousemove
      moving = false

      # The last coordinates before the current move
      lastX = undefined
      lastY = undefined

      # Img variable
      ratio = 0
      x = 0
      y = 0
      width = 0
      height = 0
      # Original size image used in zoom function
      width_ori = 0
      height_ori = 0

      # Load Image
      photo = new Image()
      photo.src = scope.canvas.image
      photo.onload = ->
        ctx.clearRect(0, 0, canvasWidth, canvasHeight)
        # http://www.w3schools.com/tags/canvasdrawimage.asp
        width_ori = this.width
        height_ori = this.height
        # display the all image inside canvas
        ratio = height_ori / width_ori

        # compute new size image
        if ratio < canvasHeight / canvasWidth
          width = canvasWidth
          height = width * ratio
        else
          height = canvasHeight
          width = height / ratio

        # save new size image (used in zoom function)
        width_ori = width
        height_ori = height

        # place image
        if width is canvasWidth
          x = 0
        else
          x = (canvasWidth - width) / 2
        if height is canvasHeight
          y = 0
        else
          y = (canvasHeight - height) / 2
        # display image
        ctx.drawImage(photo, x, y, width, height)



      iElement.bind('mousedown', (event) ->
        if event.offsetX isnt undefined
          lastX = event.offsetX
          lastY = event.offsetY
        else
          # Firefox compatibility
          lastX = event.layerX - event.currentTarget.offsetLeft
          lastY = event.layerY - event.currentTarget.offsetTop

        moving = true
      )

      iElement.bind('mousemove', (event) ->
        if moving
          # Get current mouse position
          if event.offsetX isnt undefined
            currentX = event.offsetX
            currentY = event.offsetY
          else
            currentX = event.layerX - event.currentTarget.offsetLeft
            currentY = event.layerY - event.currentTarget.offsetTop

          _move(lastX, lastY, currentX, currentY)

          # Set current coordinates to last one
          lastX = currentX
          lastY = currentY
      )

      iElement.bind('mouseup', (event) ->
        # stop moving
        moving = false
      )

      iElement.bind("mouseover", (event) ->
        # stop moving
        moving = false
      )

      scope.canvas.getDataURL = ->
        return iElement[0].toDataURL()

      scope.canvas.zoom = (scale) ->
        ctx.clearRect(0, 0, canvasWidth, canvasHeight)

        x += (width - width_ori * scale) / 2
        y += (height - height_ori * scale) / 2

        width = width_ori * scale
        height = height_ori * scale

        ctx.drawImage(photo, x, y, width, height)

      _move = (lX, lY, cX, cY) ->
        ctx.clearRect(0, 0, canvasWidth, canvasHeight)

        x += cX - lX
        y += cY - lY

        x = if x < -width then -width else if x > canvasWidth then canvasWidth else x
        y = if y < -height then -height else if y > canvasHeight then canvasHeight else y

        ctx.drawImage(photo, x, y, width, height)
  }

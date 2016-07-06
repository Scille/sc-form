'use strict'

angular.module('sc-form',
  [
    'sc-text-input'
    'sc-list-text-input'
    'sc-pwd-input'
    'sc-number-input'
    'sc-date-input'
    'sc-select-input'
    'sc-list-select-input'
    'sc-array-input'
    'sc-img-input'
  ])
  .factory('uuid', ->
    class UUID
      constructor: ->
        @name = 'sc-input-'
      new: ->
        _uuid = ->
          'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) ->
            r = Math.random() * 16 | 0
            v = if c is 'x' then r else (r & 0x3 | 0x8)
            v.toString(16)
          )
        return @name + _uuid()


    new UUID()
  )

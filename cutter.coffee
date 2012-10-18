class window.Cutter extends Backbone.View
  _.extend @, Backbone.Events

  settings:
    onNoBrowserSupport: null
    aspectRatio: null
    geometryFields:
      x: null
      y: null
      w: null
      h: null

  jCrop: null

  $img: null
  $container: null

  initialize: (options) ->
    @options = $.extend({}, @settings, options)
    delete @options.el # el is stored on the object, not in options

    @$container = @$(".js-image_container")
    @$img = @$(".js-image")

    @$("input[type=file]").showoff(
      destination: @$img
      onNoBrowserSupport: =>
        @trigger("noBrowserSupport")
        @options.onNoBrowserSupport() if @options.onNoBrowserSupport
      onInvalidFiletype: (filetype) =>
        @trigger("invalidFiletype", filetype)
      onFileReaderError: (error) =>
        @trigger("fileReaderError", error)
      onDestinationUpdate: @_onShowoffUpdate
    )

  _onShowoffUpdate: =>
    @trigger("destinationUpdate")

    # Destroy jCrop if we have one
    if @jCrop?
      @jCrop.destroy()
      @$img.removeAttr("style")

    @$container.show()

    jcropOptions =
      onChange: @_onCropChange
      onSelect: @_onCropChange

    if @options.aspectRatio
      jcropOptions.aspectRatio = @options.aspectRatio
      jcropOptions.setSelect = [0, 0, @$img.width()]

    that = @
    @$img.Jcrop(jcropOptions, ->
      that.jCrop = this
    )

  _onCropChange: (event) =>
    width = @$img.width()
    height = @$img.height()

    relativeCoords =
      w: event.w / width
      h: event.h / height
      x: event.x / width
      y: event.y / height

    $el.val(relativeCoords[coord]) for coord, $el of @options.geometryFields
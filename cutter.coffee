class window.Cutter extends Backbone.View

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

    # --NOTE: Bug in Jcrop--
    # If we don't use an aspectRatio here, Jcrop stretches the image incorrectly
    # in the case that the rendered dimensions of the image are different than
    # the real dimensions (ie CSS affecting dimensions--el.width vs $(el).width)
    # Offending code is in Jcrop lines 300-312.

    @$("input[type=file]").showoff(
      destination: @$img
      onNoBrowserSupport: =>
        @options.onNoBrowserSupport() if @options.onNoBrowserSupport
      onDestinationUpdate: @_onShowoffUpdate
    )

  _onShowoffUpdate: =>
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
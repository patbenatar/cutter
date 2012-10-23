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

  crop: null

  $img: null
  $container: null

  initialize: (options) ->
    @options = $.extend({}, @settings, options)
    delete @options.el # el is stored on the object, not in options

    @$container = @$(".js-image_container")
    @$img = @$(".js-image")

    # Make sure @$container has position relative
    @$container.css("position", "relative")

    @$("input[type=file]").showoff(
      destination: @$img
      onNoBrowserSupport: =>
        @options.onNoBrowserSupport() if @options.onNoBrowserSupport
      onInvalidFiletype: (filetype) =>
        @trigger("invalidFiletype", filetype)
      onFileReaderError: (error) =>
        @trigger("fileReaderError", error)
      onDestinationUpdate: @_onShowoffUpdate
    )

  _onShowoffUpdate: =>
    # Set a short timeout to avoid the race condition where we sometimes try to
    # get the image dimensions before the DOM is fully updated with the new img
    setTimeout(=>
      @trigger("destinationUpdate")

      @$container.show()

      # If we've already setup the cropper, just update it
      if @crop
        @crop.update()
        return

      cropOptions =
        instance: true
        handles: true
        onSelectChange: @_onCropChange
        parent: @$container

      # Determine size of initial crop area based on aspect ratio
      width = @$img.width()
      height = Math.round(@$img.width() / @options.aspectRatio)
      if height > @$img.height()
        height = @$img.height()
        width = Math.round(height * @options.aspectRatio)

      if @options.aspectRatio
        $.extend(cropOptions, cropOptions,
          aspectRatio: "#{@options.aspectRatio}:1"
          x1: 0
          y1: 0
          x2: width
          y2: height
        )

      @crop = @$img.imgAreaSelect(cropOptions)
    , 50)

  _onCropChange: (img, event) =>
    width = @$img.width()
    height = @$img.height()

    relativeCoords =
      w: event.width / width
      h: event.height / height
      x: event.x1 / width
      y: event.y1 / height

    $el.val(relativeCoords[coord]) for coord, $el of @options.geometryFields
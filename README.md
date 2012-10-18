# Cutter

Cutter is a `Backbone.View` for image upload fields that combines the power of
[patbenatar/showoff](https://github.com/patbenatar/showoff) and
[tapmodo/Jcrop](https://github.com/tapmodo/Jcrop) to create a quick and easy
user experience for cropping before uploading the image.

## Dependencies

* Backbone.js (and therefore Underscore.js)
* jQuery
* [jquery.showoff](https://github.com/patbenatar/showoff)
* [jquery.Jcrop](https://github.com/tapmodo/Jcrop)

## Browser Support

* Depends on the HTML5 `FileReader` API.

## Installation

1. Download your flavor (JS or Coffee) and include it in your app

## Basic Usage

```html
<div class="js-my_image">
  <input type="file">
  <div class="js-image_container">
    <h3>Crop it</h3>
    <img src="" class="js-image">
    <input type="hidden" name="my_image_crop_x">
    <input type="hidden" name="my_image_crop_y">
    <input type="hidden" name="my_image_crop_w">
    <input type="hidden" name="my_image_crop_h">
  </div>
</div>
```

```javascript
new Cutter({
  el: $(".js-my_image"),
  aspectRatio: 4/6,
  geometryFields: {
    x: $(".js-my_image input[name$='_crop_x']"),
    y: $(".js-my_image input[name$='_crop_y']"),
    w: $(".js-my_image input[name$='_crop_w']"),
    h: $(".js-my_image input[name$='_crop_h']")
  }
})
```

## Options & Callbacks

#### `el`

Standard Backbone. The container element to initialize the view on.

* __Required:__ Yes
* __Type:__ jQuery Object, selector string
* __Default:__ `null`

#### `geometryFields`

The four text or hidden fields in which Cutter will place the values of the
Jcrop selection.

```javascript
{
  x: <jQuery Object>,
  y: <jQuery Object>,
  w: <jQuery Object>,
  h: <jQuery Object>
}
```

* __Required:__ Yes
* __Type:__ Hash
* __Default:__ `{ x: null, y: null, w: null, h: null }`

#### `aspectRatio`

Restricts the Jcrop selection to an aspect ratio.

* __Required:__ No
* __Type:__ Number
* __Default:__ `null`

##### Caveats
Due to a bug in Jcrop, if we don't use an aspectRatio here Jcrop stretches the
image incorrectly in the case that the rendered dimensions of the image are
different than the real dimensions (ie CSS affecting dimensions--el.width vs
$(el).width). As of this writing, offending code is in Jcrop lines 300-312.

#### `onNoBrowserSupport`

Called during initialization if browser is incompatible with jquery.showoff

* __Required:__ No
* __Type:__ Function()
* __Default:__ `null`

## Events

The following events are proxied through from showoff.

* `invalidFiletype`
* `fileReaderError`
* `destinationUpdate`
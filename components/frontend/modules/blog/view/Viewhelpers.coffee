define ['underscore'], (_) ->

  Viewhelpers =

    getFile: (key) ->
      _.find @files, (file)->
        file.key == key

    formatDate: (date)->
      date = (new Date(date)).toString().split(" ")
      return '<div class="number">'+date[2]+'</div><div class="month">'+date[1]+'</div>'

    getFilesByType: (type) ->
      _.filter @files, (file)->
        file.type == 'image/png' or 'image/jpeg'

    renderImage: (key, size) ->
      if size? then size = 'smallPic'
      if typeof key is 'string'
        image = @getFile key
      else
        image = key
      '<img src="/public/files/'+image[size]+ '" alt="'+image.alt+'"/>'

    renderImages: ->
      images = @getFilesByType 'image'
      that = @
      i = 0
      str = '<div class="row">'
      _.each images, (image) ->
        str += '<div class="col-md-3 col-xs-6"><a href="/public/files/'+image.bigPic+'" rel="gallery" class="thumbnail">' + that.renderImage(image, 'thumbnail') + '</a></div>'
      str += '</div>'

    fileKeyExists: (key) ->
      !!@getFile(key)
define ['underscore'], (_) ->

  Viewhelpers =

    get:(field)->
      @fields[field].value

    getFile: (key) ->
      @fields[key]?.value?.fields

    fileKeyExists: (key) ->
      !!@getFile(key)

    formatDate: (date)->
      date = (new Date(date)).toString().split(" ")
      return '<div class="number">'+date[2]+'</div><div class="month">'+date[1]+'</div>'

    getFilesByType: (type) ->
      _.filter @fields.files, (file)->
        if type is 'image'
          return file.fields.type.value == 'image/png' or 'image/jpeg'

    renderImage: (key, size) ->
      if size? then size = 'smallPic'
      if typeof key is 'string'
        image = @getFile key
      else
        image = key
      '<img src="/public/files/'+image[size].value+ '" alt="'+image.alt.value+'"/>'

    renderImages: ->
      images = @getFilesByType 'image'
      that = @
      i = 0
      str = '<div class="row">'
      _.each images, (image) ->
        str += '<div class="col-md-3 col-xs-6"><a href="/public/files/'+image.fields.bigPic.value+'" rel="gallery" class="thumbnail">' + that.renderImage(image.fields, 'thumbnail') + '</a></div>'
      str += '</div>'


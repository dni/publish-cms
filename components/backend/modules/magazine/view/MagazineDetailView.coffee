define [
  'cs!Publish'
  'underscore'
], (Publish, _) ->
  class MagazineDetailView extends Publish.View.DetailView
    events: _.extend {}, Publish.View.DetailView.prototype.events,
      "change [name=title]": "changeName"

    changeName:->
      title = @ui.title.val()
      @model.set "name", title.replace(/[^a-z0-9]/gi, '_').toLowerCase()
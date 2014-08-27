define [
  'cs!Publish'
  'tpl!lib/templates/detail.html'
], (Publish, Template) ->
	class MagazineDetailView extends Publish.View.DetailView
		initialize:(args)->
			super.initialize(args)

		events:
			"change @ui.title": "changeName"
		changeName:->
			title = @model.getValue "title"
			@model.setValue "name", title.replace(/[^a-z0-9]/gi, '_').toLowerCase()

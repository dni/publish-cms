define [
  'cs!Publish'
  'cs!../view/MagazineDetailView'
  'cs!modules/pages/view/RelatedPageView'
  'cs!modules/files/view/RelatedFileView'
], ( Publish, MagazineDetailView, RelatedPageView, RelatedFileView ) ->

  class MagazineController extends Publish.Controller.LayoutController
    RelatedViews:
      FileView: RelatedFileView

    newDetailView:(model)->
      new MagazineDetailView
        model: model
        Config: @Config
        i18n: @i18n



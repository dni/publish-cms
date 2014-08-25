define [
  'cs!Publish'
  'cs!modules/pages/view/RelatedPageView'
  'cs!modules/files/view/RelatedFileView'
], ( Publish, RelatedPageView, RelatedFileView ) ->
  class MagazineController extends Publish.Controller.LayoutController
    RelatedViews:
      FileView: RelatedFileView

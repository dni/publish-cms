define [
    'cs!Publish'
    'cs!modules/files/view/RelatedFileView'
], ( Publish, FileView ) ->
  class ArticleController extends Publish.Controller.LayoutController
    RelatedViews:
      fileView: FileView


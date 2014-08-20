define [
    'cs!Publish'
    'cs!modules/files/view/PreviewView'
], ( Publish, PreviewView ) ->
  class ArticleController extends Publish.Controller.LayoutController
    RelatedViews:
      fileView: PreviewView


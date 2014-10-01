define [
  'cs!Publish'
  'cs!../view/MagazineDetailView'
  'cs!modules/pages/view/RelatedPageView'
  'cs!modules/files/view/RelatedFileView'
  'cs!../view/RelatedPreviewView'
], ( Publish, MagazineDetailView, RelatedPageView, RelatedFileView, RelatedPreviewView ) ->

  class MagazineController extends Publish.Controller.LayoutController
    RelatedViews:
      PreviewView: RelatedPreviewView
      FileView: RelatedFileView
      PageView: RelatedPageView
    DetailView: MagazineDetailView



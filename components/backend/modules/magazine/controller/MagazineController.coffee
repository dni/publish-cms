define [
  'cs!Publish'
  'cs!../view/MagazineDetailView'
  'cs!modules/pages/view/RelatedPageView'
  'cs!modules/files/view/RelatedFileView'
], ( Publish, MagazineDetailView, RelatedPageView, RelatedFileView ) ->
  class MagazineController extends Publish.Controller.LayoutController
  	#DetailView: MagazineDetailView
    RelatedViews:
      FileView: RelatedFileView

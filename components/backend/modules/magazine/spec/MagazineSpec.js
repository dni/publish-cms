define([
    'cs!modules/magazine/controller/MagazineController',
    'cs!modules/magazine/model/Magazine',
    'cs!modules/magazine/model/Magazines',
    'cs!modules/magazine/view/MagazineDetailView',
    'cs!modules/magazine/view/MagazineListView',
    'cs!modules/magazine/view/MagazineLayout',
    'cs!modules/magazine/view/PageListView'
], function( Controller, Model, Collection, DetailView, ListView, Layout, PageView){

    describe('Testcases Magazine Module', function() {

        it('new Model() is working', function() {
          expect(new Model()).toBeTruthy();
        });
        it('new Collection() is working', function() {
            expect(new Collection()).toBeTruthy();
        });
        it('new Controller() is working', function() {
            expect(new Controller()).toBeTruthy();
        });
        it('new ListView() is working', function() {
            expect(new ListView()).toBeTruthy();
        });
        it('new Layout() is working', function() {
            var layout = new Layout();
            expect(layout).toBeTruthy();
        });
    });

});
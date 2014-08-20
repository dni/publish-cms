define([
    'cs!modules/publish/model/NavigationItem',
    'cs!modules/publish/model/NavigationItems',
    'cs!modules/publish/view/NavigationView',
], function( Model, Collection, ListView){

    describe('Testcases Publish Module', function() {

        it('new Model() is working', function() {
          expect(new Model()).toBeTruthy();
        });
        it('new Collection() is working', function() {
            expect(Collection).toBeTruthy();
        });
        it('new NavigationView() is working', function() {
            expect(new ListView()).toBeTruthy();
        });
    });

});
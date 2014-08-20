define([
    "cs!modules/publish/Regions",
    "cs!modules/publish/Events",
    "cs!modules/publish/Socket",
], function( Regions, Events, Socket){

    describe('Testcases App Setup', function() {

        it('Regions are working', function() {
          expect(Regions).toBeTruthy();
        });
        it('Events are working', function() {
            expect(Events).toBeTruthy();
        });
        it('Socket is working', function() {
            expect(Socket).toBeTruthy();
        });
    });

});
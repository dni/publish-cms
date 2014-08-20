$(function(){
	var userAgent = navigator.userAgent
	if (userAgent.match(/PhantomJS/g)) {
		$("body").addClass('print');
	}
});
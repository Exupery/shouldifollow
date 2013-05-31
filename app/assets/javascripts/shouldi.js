$(document).ready(function() {
	$("#username").focus(function(event) {
		$(this).attr("placeholder", "");
	});

	$("#username").blur(function(event) {
		$(this).attr("placeholder", "username");
	});

});

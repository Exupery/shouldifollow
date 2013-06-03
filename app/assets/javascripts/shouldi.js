$(document).ready(function() {
	$("#username").focus(function(event) {
		$(this).attr("placeholder", "");
	});

	$("#username").blur(function(event) {
		$(this).attr("placeholder", "username");
	});

	update_times(0);

});

function update_times(offset) {
	$(".time-header").each( function() {
		var h = $(this).attr("data-utc");
		if (h == 0) {
			$(this).text("M");
			$(this).attr("title", "midnight");
		} else if (h == 12) {
			$(this).text("N");
			$(this).attr("title", "noon");
		} else if (h > 12) {
			$(this).text(h-12);
			$(this).attr("title", (h-12)+"PM");
		} else {
			$(this).attr("title", h+"AM");
		}
	}); 
}

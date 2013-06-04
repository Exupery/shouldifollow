$(document).ready(function() {
	$("#username").focus(function(event) {
		$(this).attr("placeholder", "");
	});

	$("#username").blur(function(event) {
		$(this).attr("placeholder", "username");
	});

	update_headers();
	update_times(0);	//TODO: get initial from cookie for returning visitors

});

function update_headers() {
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

function update_times(offset) {
	if (!offset || isNaN(offset)) {
		offset = 0;
	} else {
		offset = -offset;
	}
	$(".time-data").each( function() {
		var utc_hour = parseInt($(this).attr("data-utc"));
		var adj = 0;
		if (utc_hour+offset < 0) {
			adj = 24 + offset;
		} else if (utc_hour+offset > 23) {
			adj = -1 + offset;
		} else {
			adj = utc_hour + offset;
		}
		var v = $("#"+$(this).attr("data-day")+"-utc"+adj).attr("data-base");
		var a = $("#"+$(this).attr("data-day")+"-utc"+adj).attr("data-alpha");
		$(this).css("background-color", "rgba(13, 51, 63, "+a+")");
		$(this).attr("title", v+"% of activity");
	});
}

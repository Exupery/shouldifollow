$(document).ready(function() {
	$("#username").focus(function(event) {
		$(this).attr("placeholder", "");
	});

	$("#username").blur(function(event) {
		$(this).attr("placeholder", "username");
	});

	update_headers();
	update_times(0);

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
	$(".time-data").each( function() {
		var h = $(this).attr("data-utc");
		var adj = 0;
		if (h+offset < 0) {
			adj = 25 + offset;
		} else if (h+offset > 23) {
			adj = 0 + offset;
		} else {
			adj = h + offset;
		}
		var v = $("#"+$(this).attr("data-day")+"-utc"+adj).attr("data-base");
		console.log("#"+$(this).attr("data-day")+"-utc"+adj);	//DELME
		console.log("h"+h+" w/offset "+offset+" = adj "+adj+" for v="+v);	//DELME
	});
}

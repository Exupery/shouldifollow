var ready = function() {
	$("#search-form").submit(function(e) {
		e.preventDefault();
		// Prevent page width from changing once content is hidden
		$("#page").css("width", $("#page").css("width"));
		$("#stats").slideUp(900);
		$("#loading").slideDown();
		Turbolinks.visit("/" + $("#username").val());
	});

	$("#username").focus(function(event) {
		$(this).attr("placeholder", "");
	});

	$("#username").blur(function(event) {
		$(this).attr("placeholder", "username");
	});

	$("#timezones-offsets").change(function() {
		var offset = $("#timezones-offsets option:selected").val();
		updateTimes(offset);
		$.cookie("utc-offset", offset, {expires: 30, path: "/"});
	});

	adjustFontSize();
	updateHeaders();
	var offset = ($.cookie("utc-offset")) ? $.cookie("utc-offset") : getUtcOffset();
	updateTimes(offset);
	$("#timezones-offsets").val(offset);
};
/* Needed so jQuery's ready plays well with Rails turbolinks */
$(document).ready(ready);
$(document).on('page:load', ready);

function adjustFontSize() {
	var fontSize = parseInt($(".auto-size").css("font-size"));
	while ($(".metrics-table").width() > $("#stats").width() && fontSize > 10) {
		$(".auto-size").css("font-size", --fontSize + "px");
	}
}

function updateHeaders() {
	$(".time-header").each(function() {
		var h = $(this).attr("data-utc");
		if (h == 0) {
			$(this).text("M");
			$(this).attr("title", "midnight");
		} else if (h == 12) {
			$(this).text("N");
			$(this).attr("title", "noon");
		} else if (h > 12) {
			$(this).text(h - 12);
			$(this).attr("title", (h - 12)+"PM");
		} else {
			$(this).attr("title", h + "AM");
		}
	}); 
}

function getUtcOffset() {
	var mins = (new Date()).getTimezoneOffset();
	return (mins != 0) ? -(mins / 60) : 0;
}

function updateTimes(offset) {
	if (!offset || isNaN(offset)) {
		offset = 0;
	} else {
		offset = -offset;
	}
	$(".time-data").each(function() {
		var utc_hour = parseInt($(this).attr("data-utc"));
		var adj = 0;
		if (utc_hour + offset < 0) {
			adj = utc_hour + offset + 24;
		} else if (utc_hour + offset > 23) {
			adj = utc_hour + offset - 24;
		} else {
			adj = utc_hour + offset;
		}
		var v = $("#"+$(this).attr("data-day")+"-utc"+adj).attr("data-base");
		var a = $("#"+$(this).attr("data-day")+"-utc"+adj).attr("data-alpha");
		$(this).css("background-color", "rgba(85, 172, 238, "+a+")");
		$(this).attr("title", v+"% of activity");
	});
}

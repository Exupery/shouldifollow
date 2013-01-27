$(document).ready(function() {
	if ($('#expl').length) {
		$('#username').val('username');
	}

	$('#username').focus(function(event) {
		$('#username').css({
			'color': '#000000', 
			'font-style': 'normal'
		});
		if ($('#username').val() == 'username') {
			$('#username').val('');
		} else {
			$(this).select();
		}
	}).mouseup(function(e) {
		e.preventDefault();
	});

	$('#username').blur(function(event) {
		if ($('#username').val() == '') {
			$('#username').val('username');
			$('#username').css({
				'color': '#959595', 
				'font-style': 'italic'
			});
		}
	});

});

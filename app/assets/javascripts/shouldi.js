$(document).ready(function() {
	/*$('#username').keyup(function(event) {
		if (event.keyCode == '13') { 
			console.log('bar');
		}
	});*/

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

function noSelection() {
	if (window.getSelection && window.getSelection().type=='Range') {
		return false;
	}
	if (document.selection && document.selection.createRange()) {
		return false;
	}
	return true;
}

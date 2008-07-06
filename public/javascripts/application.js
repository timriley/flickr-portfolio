$(document).ready(function() {
	// AJAX paginatation - http://ozmm.org/posts/ajax_will_paginate_jq_style.html
	// Using $.get instead of .load() to work around a safari bug introduced in http://dev.jquery.com/changeset/4155
	$('.pagination a').livequery('click', function() {		
		$.get(this.href, function(data) {
			$('#live_table').fadeOut('fast').html(data).fadeIn('fast');
		});
		return false;
	});
});
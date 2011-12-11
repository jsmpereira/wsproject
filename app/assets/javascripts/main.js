$(function() {
	
	function basic_toggle(wrapper_id) {
		$(wrapper_id).show();
		$("[id*=_tab]:visible").not(wrapper_id).toggle();
	};
	
	$(".toggle").click(function() {
		basic_toggle($('#'+$(this).text().toLowerCase()+"_tab"));
		return false;
	});
});
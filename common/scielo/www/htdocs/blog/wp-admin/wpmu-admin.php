<?php
require_once('admin.php');

$title = __('WordPress MU &rsaquo; Admin');
$parent_file = 'wpmu-admin.php';
require_once('admin-header.php');

if( is_site_admin() == false ) {
	wp_die( __('<p>You do not have permission to access this page.</p>') );
}

if (isset($_GET['updated'])) {
	?>
	<div id="message" class="updated fade"><p><?php _e('Options saved.') ?></p></div>
	<?php
}
?>

<div class="wrap">
	<h2><?php _e('WordPress MU : Admin') ?></h2>
	<?php do_action('wpmuadminresult', ''); ?>
	
	<form name="searchform" action="wpmu-users.php" method="get">
		<p>
			<input type="hidden" name="action" value="users" />
			<input type="text" name="s" value="" size="17" /> 
			<input type="submit" name="submit" value="<?php _e("Search Users &raquo;"); ?>" />
		</p> 
	</form>
		
	<form name="searchform" action="wpmu-blogs.php" method="get">
		<p>
			<input type="hidden" name="action" value="blogs" />
			<input type="text" name="s" value="" size="17" />
			<input type="submit" name="submit" value="<?php _e("Search Blogs &raquo;"); ?>" />
		</p>
	</form>
</div>

<?php include('admin-footer.php'); ?>
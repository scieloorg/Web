<?php
require_once('admin.php');

$http_fopen = ini_get("allow_url_fopen");
if( !$http_fopen ) {
	require_once('../wp-includes/class-snoopy.php');
}

$title = __('WordPress MU &rsaquo; Admin &rsaquo; Upgrade Site');
$parent_file = 'wpmu-admin.php';
require_once('admin-header.php');

if( is_site_admin() == false ) {
    wp_die( __('<p>You do not have permission to access this page.</p>') );
}

echo '<div class="wrap">';
echo '<h2>'.__('Upgrade Site').'</h2>';
switch( $_GET['action'] ) {
	case "upgrade":
		$n = ( isset($_GET['n']) ) ? intval($_GET['n']) : 0;
		
		$blogs = $wpdb->get_results( "SELECT * FROM {$wpdb->blogs} WHERE site_id = '{$wpdb->siteid}' AND spam = '0' AND deleted = '0' AND archived = '0' ORDER BY registered DESC LIMIT {$n}, 5", ARRAY_A );
		if( is_array( $blogs ) ) {
			echo "<ul>";
			foreach( (array) $blogs as $details ) {
				if( $details['spam'] == 0 && $details['deleted'] == 0 && $details['archived'] == 0 ) {
					$siteurl = $wpdb->get_var("SELECT option_value from {$wpdb->base_prefix}{$details['blog_id']}_options WHERE option_name = 'siteurl'");
					echo "<li>$siteurl</li>";
					if( $http_fopen ) {
						$fp = fopen( $siteurl . "wp-admin/upgrade.php?step=1", "r" );
						if( $fp ) {
							while( feof( $fp ) == false ) {
								fgets($fp, 4096);
							}
							fclose( $fp );
						}
					} else {
						$client = new Snoopy();
						@$client->fetch($siteurl . "wp-admin/upgrade.php?step=1");
					}
				}
			}
			echo "</ul>";
			?>
			<p><?php _e("If your browser doesn't start loading the next page automatically click this link:"); ?> <a href="wpmu-upgrade-site.php?action=upgrade&amp;n=<?php echo ($n + 5) ?>"><?php _e("Next Blogs"); ?></a></p>
			<script type='text/javascript'>
				<!--
				function nextpage() {
					location.href = "wpmu-upgrade-site.php?action=upgrade&n=<?php echo ($n + 5) ?>";
				}
				setTimeout( "nextpage()", 250 );
				//-->
			</script>
			<?php
		} else {
			echo '<p>'.__('All Done!').'</p>';
		}
	break;
	
	default: ?>
		<p><?php _e("You can upgrade all the blogs on your site through this page. It works by calling the upgrade script of each blog automatically. Hit the link below to upgrade."); ?></p>
		<p><a href="wpmu-upgrade-site.php?action=upgrade"><?php _e("Upgrade Site"); ?></a></p>
	<?php
	break;
}
?>
</div>

<?php include('admin-footer.php'); ?>

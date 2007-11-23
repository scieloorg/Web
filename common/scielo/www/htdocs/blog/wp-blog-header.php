<?php

if (! isset($wp_did_header)):
if ( !file_exists( dirname(__FILE__) . '/wp-config.php') ) {
	if (strpos($_SERVER['PHP_SELF'], 'wp-admin') !== false) $path = '';
	else $path = 'wp-admin/';
	include( "index-install.php" ); // install WPMU!
	die();
}

$wp_did_header = true;

require_once( dirname(__FILE__) . '/wp-config.php');

wp();
gzip_compression();

require_once(ABSPATH . WPINC . '/template-loader.php');

endif;

?>

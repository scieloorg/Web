<?php
define( "WP_INSTALLING", true );
require ('wp-config.php');
require_once( ABSPATH . WPINC . '/registration.php');

do_action("activate_header");

get_header();
?>
<div id="content" class="widecolumn">
<style type="text/css">
form { margin-top: 2em; }
#submit, #key {
	width: 90%;
	font-size: 24px;
}
#language {
	margin-top: .5em;
}
.error {
	background-color: #f66;
}
</style>
<?php
if ( empty($_GET['key']) && empty($_POST['key']) ) {
?>
<h2><?php _e('Activation Key Required') ?></h2>
<form name="activateform" id="activateform" method="post" action="<?php echo 'http://' . $current_site->domain . $current_site->path ?>wp-activate.php">
<table border="0" width="100%" cellpadding="9">
<tr>
<th valign="top"><?php _e('Activation Key:') ?></th>
<td><input name="key" type="text" id="key" value="" /></td>
</tr>
<tr>
<th scope="row"  valign="top">&nbsp;</th>
<td><input id="submit" type="submit" name="Submit" class="submit" value="<?php _e('Activate &raquo;') ?>" /></td>
</tr>
</table>
</form>
<?php
} else {
	if ( ! empty($_GET['key']) )
		$key = $_GET['key'];
	else
		$key = $_POST['key'];

	$result = wpmu_activate_signup($key);
	if ( is_wp_error($result) ) {
		if ( 'already_active' == $result->get_error_code() || 'blog_taken' == $result->get_error_code() ) {
			$signup = $result->get_error_data();
			_e( '<h2>Your account is now active!</h2>' );
			if( $signup->domain . $signup->path == '' ) {
				printf(__('<p class="lead-in">Your account has been activated. You may now <a href="%1$s">login</a> to the site using your chosen username of "%2$s".  Please check your email inbox at %3$s for your password and login instructions. If you do not receive an email, please check your junk or spam folder. If you still do not receive an email within an hour, you can <a href="%4$s">reset your password</a>.</p>'), 'http://' . $current_site->domain . $current_site->path . 'wp-login.php', $signup->user_login, $signup->user_email, 'http://' . $current_site->domain . $current_site->path . 'wp-login.php?action=lostpassword');
			} else {
				printf(__('<p class="lead-in">Your blog at <a href="%1$s">%2$s</a> is active. You may now login to your blog using your chosen username of "%3$s".  Please check your email inbox at %4$s for your password and login instructions.  If you do not receive an email, please check your junk or spam folder.  If you still do not receive an email within an hour, you can <a href="%5$s">reset your password</a>.</p>'), 'http://' . $signup->domain, $signup->domain, $signup->user_login, $signup->user_email, 'http://' . $current_site->domain . $current_site->path . 'wp-login.php?action=lostpassword');
			}
		} else {
			echo $result->get_error_message();
		}
	} else {
		extract($result);
		$url = get_blogaddress_by_id($blog_id);
		$user = new WP_User($user_id);
?>
<h2><?php _e('Your account is now active!'); ?></h2>
<table border="0" id="signup-welcome">
<tr>
<td width="50%" align="center">
<h3><?php _e('Username'); ?>:</h3>
<p><?php echo $user->user_login ?></p></td>
<td width="50%" align="center">
<h3><?php _e('Password'); ?>:</h3>
<p><?php echo $password; ?></p>
</td>
</tr>
</table>
		<?php if( $url != 'http://' . $current_site->domain . $current_site->path ) { ?>
<p class="view"><?php printf(__('Your account is now activate. <a href="%1$s">View your site</a> or <a href="%2$s">Login</a>'), $url, $url . 'wp-login.php' ); ?></p> <?php 
		} else { 
?> <p class="view"><?php printf( __( 'Your account is now activate. <a href="%1$s">Login</a> or go back to the <a href="%2$s">homepage</a>.' ), 'http://' . $current_site->domain . $current_site->path . 'wp-login.php', 'http://' . $current_site->domain . $current_site->path ); ?></p> <?php
		}
	}
}
?>
</div>
<?php get_footer(); ?>

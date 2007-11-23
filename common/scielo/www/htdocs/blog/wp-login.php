<?php
require( dirname(__FILE__) . '/wp-config.php' );

$action = $_REQUEST['action'];
$errors = array();

if ( isset($_GET['key']) )
	$action = 'resetpass';

nocache_headers();

header('Content-Type: '.get_bloginfo('html_type').'; charset='.get_bloginfo('charset'));

if ( defined('RELOCATE') ) { // Move flag is set
	if ( isset( $_SERVER['PATH_INFO'] ) && ($_SERVER['PATH_INFO'] != $_SERVER['PHP_SELF']) )
		$_SERVER['PHP_SELF'] = str_replace( $_SERVER['PATH_INFO'], '', $_SERVER['PHP_SELF'] );

	$schema = ( isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on' ) ? 'https://' : 'http://';
	if ( dirname($schema . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF']) != get_option('siteurl') )
		update_option('siteurl', dirname($schema . $_SERVER['HTTP_HOST'] . $_SERVER['PHP_SELF']) );
}

//Set a cookie now to see if they are supported by the browser.
setcookie(TEST_COOKIE, 'WP Cookie check', 0, COOKIEPATH, COOKIE_DOMAIN);
if ( SITECOOKIEPATH != COOKIEPATH )
	setcookie(TEST_COOKIE, 'WP Cookie check', 0, SITECOOKIEPATH, COOKIE_DOMAIN);

// Rather than duplicating this HTML all over the place, we'll stick it in function
function login_header($title = 'Login', $message = '') {
	global $errors, $error, $wp_locale, $current_site;

	?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" <?php language_attributes(); ?>>
<head>
	<title><?php bloginfo('name'); ?> &rsaquo; <?php echo $title; ?></title>
	<meta http-equiv="Content-Type" content="<?php bloginfo('html_type'); ?>; charset=<?php bloginfo('charset'); ?>" />
	<?php wp_admin_css(); ?>
	<!--[if IE]><style type="text/css">#login h1 a { margin-top: 35px; } #login #login_error { margin-bottom: 10px; }</style><![endif]--><!-- Curse you, IE! -->
	<script type="text/javascript">
		function focusit() {
			document.getElementById('user_login').focus();
		}
		window.onload = focusit;
	</script>
<?php do_action('login_head'); ?>
</head>
<body class="login">

<div id="login"><h1><a href="<?php echo apply_filters('login_headerurl', 'http://' . $current_site->domain . $current_site->path ); ?>" title="<?php echo apply_filters('login_headertitle', $current_site->site_name ); ?>"><span class="hide"><?php bloginfo('name'); ?></span></a></h1>
<?php
	if ( !empty( $message ) ) echo apply_filters('login_message', $message) . "\n";

	// Incase a plugin uses $error rather than the $errors array
	if ( !empty( $error ) ) {
		$errors['error'] = $error;
		unset($error);
	}

	if ( !empty( $errors ) ) {
		if ( is_array( $errors ) ) {
			$newerrors = "\n";
			foreach ( $errors as $error ) $newerrors .= '	' . $error . "<br />\n";
			$errors = $newerrors;
		}

		echo '<div id="login_error">' . apply_filters('login_errors', $errors) . "</div>\n";
		echo "<p align='center'>".__("<strong>Note:</strong> You must <a style=\"color: #fff;\" href='http://www.google.com/cookies.html'>enable cookies</a> to use this site.")."</p>";
	}
} // End of login_header()


switch ($action) {

case 'logout' :

	wp_clearcookie();
	do_action('wp_logout');

	$redirect_to = 'wp-login.php?loggedout=true';
	if ( isset( $_REQUEST['redirect_to'] ) )
		$redirect_to = $_REQUEST['redirect_to'];

	wp_safe_redirect($redirect_to);
	exit();

break;

case 'lostpassword' :
case 'retrievepassword' :
	$user_login = '';
	$user_pass = '';

	if ( $_POST ) {
		if ( empty( $_POST['user_login'] ) )
			$errors['user_login'] = __('<strong>ERROR</strong>: The username field is empty.');
		if ( empty( $_POST['user_email'] ) )
			$errors['user_email'] = __('<strong>ERROR</strong>: The e-mail field is empty.');

		do_action('lostpassword_post');

		if ( empty( $errors ) ) {
			$user_data = get_userdatabylogin(trim($_POST['user_login']));
			// redefining user_login ensures we return the right case in the email
			$user_login = $user_data->user_login;
			$user_email = $user_data->user_email;

			if (!$user_email || $user_email != $_POST['user_email']) {
				$errors['invalidcombo'] = __('<strong>ERROR</strong>: Invalid username / e-mail combination.');
			} else {
				do_action('retreive_password', $user_login);  // Misspelled and deprecated
				do_action('retrieve_password', $user_login);

				// Generate something random for a password... md5'ing current time with a rand salt
				$key = substr( md5( uniqid( microtime() ) ), 0, 8);
				// Now insert the new pass md5'd into the db
				$wpdb->query("UPDATE $wpdb->users SET user_activation_key = '$key' WHERE user_login = '$user_login'");
				$message = __('Someone has asked to reset the password for the following site and username.') . "\r\n\r\n";
				$message .= get_option('siteurl') . "\r\n\r\n";
				$message .= sprintf(__('Username: %s'), $user_login) . "\r\n\r\n";
				$message .= __('To reset your password visit the following address, otherwise just ignore this email and nothing will happen.') . "\r\n\r\n";
				$message .= get_option('siteurl') . "/wp-login.php?action=rp&key=$key\r\n";

				if (FALSE == wp_mail($user_email, sprintf(__('[%s] Password Reset'), get_option('blogname')), $message)) {
					die('<p>' . __('The e-mail could not be sent.') . "<br />\n" . __('Possible reason: your host may have disabled the mail() function...') . '</p>');
				} else {
					wp_redirect('wp-login.php?checkemail=confirm');
					exit();
				}
			}
		}
	}

	if ( 'invalidkey' == $_GET['error'] ) $errors['invalidkey'] = __('Sorry, that key does not appear to be valid.');

	do_action('lost_password');
	login_header(__('Lost Password'), '<p class="message">' . __('Please enter your username and e-mail address. You will receive a new password via e-mail.') . '</p>');
?>

<form name="lostpasswordform" id="lostpasswordform" action="wp-login.php?action=lostpassword" method="post">
	<p>
		<label><?php _e('Username:') ?><br />
		<input type="text" name="user_login" id="user_login" class="input" value="<?php echo attribute_escape(stripslashes($_POST['user_login'])); ?>" size="20" tabindex="10" /></label>
	</p>
	<p>
		<label><?php _e('E-mail:') ?><br />
		<input type="text" name="user_email" id="user_email" class="input" value="<?php echo attribute_escape(stripslashes($_POST['user_email'])); ?>" size="25" tabindex="20" /></label>
	</p>
<?php do_action('lostpassword_form'); ?>
	<p class="submit"><input type="submit" name="wp-submit" id="wp-submit" value="<?php _e('Get New Password &raquo;'); ?>" tabindex="100" /></p>
</form>
</div>

<ul>
<?php if (get_option('users_can_register')) : ?>
	<li><a href="<?php bloginfo('wpurl'); ?>/wp-login.php"><?php _e('Login') ?></a></li>
	<li><a href="<?php bloginfo('wpurl'); ?>/wp-signup.php"><?php _e('Register') ?></a></li>
	<li><a href="<?php bloginfo('url'); ?>/" title="<?php _e('Are you lost?') ?>"><?php printf(__('Back to %s'), get_bloginfo('title')); ?></a></li>
<?php else : ?>
	<li><a href="<?php bloginfo('url'); ?>/" title="<?php _e('Are you lost?') ?>"><?php printf(__('Back to %s'), get_bloginfo('title')); ?></a></li>
	<li><a href="<?php bloginfo('wpurl'); ?>/wp-login.php"><?php _e('Login') ?></a></li>
<?php endif; ?>
</ul>

</body>
</html>
<?php
break;

case 'resetpass' :
case 'rp' :
	$key = preg_replace('/[^a-z0-9]/i', '', $_GET['key']);
	if ( empty( $key ) ) {
		wp_redirect('wp-login.php?action=lostpassword&error=invalidkey');
		exit();
	}

	$user = $wpdb->get_row("SELECT * FROM $wpdb->users WHERE user_activation_key = '$key'");
	if ( empty( $user ) ) {
		wp_redirect('wp-login.php?action=lostpassword&error=invalidkey');
		exit();
	}

	do_action('password_reset');

	// Generate something random for a password... md5'ing current time with a rand salt
	$new_pass = substr( md5( uniqid( microtime() ) ), 0, 7);
	$wpdb->query("UPDATE $wpdb->users SET user_pass = MD5('$new_pass'), user_activation_key = '' WHERE user_login = '$user->user_login'");
	wp_cache_delete($user->ID, 'users');
	wp_cache_delete($user->user_login, 'userlogins');
	$message  = sprintf(__('Username: %s'), $user->user_login) . "\r\n";
	$message .= sprintf(__('Password: %s'), $new_pass) . "\r\n";
	$message .= get_option('siteurl') . "/wp-login.php\r\n";

	if (FALSE == wp_mail($user->user_email, sprintf(__('[%s] Your new password'), get_option('blogname')), $message)) {
		die('<p>' . __('The e-mail could not be sent.') . "<br />\n" . __('Possible reason: your host may have disabled the mail() function...') . '</p>');
	} else {
		wp_redirect('wp-login.php?checkemail=newpass');
		exit();
	}
break;

case 'auth' :
	$_COOKIE = array(); // Prevent redirect loops caused by corrupted cookies

case 'login' :
default:
	$user_login = '';
	$user_pass = '';
	$using_cookie = FALSE;

	if ( !isset( $_REQUEST['redirect_to'] ) || is_user_logged_in() )
		$redirect_to = 'wp-admin/';
	else
		$redirect_to = $_REQUEST['redirect_to'];

	if ( $_POST ) {
		$user_login = $_POST['log'];
		$user_login = sanitize_user( $user_login );
		$user_pass  = $_POST['pwd'];
		$rememberme = $_POST['rememberme'];
	} else {
		$cookie_login = wp_get_cookie_login();
		if ( ! empty($cookie_login) ) {
			$using_cookie = true;
			$user_login = $cookie_login['login'];
			$user_pass = $cookie_login['password'];
		}
	}

	do_action_ref_array('wp_authenticate', array(&$user_login, &$user_pass));

	// If cookies are disabled we can't log in even with a valid user+pass
	if ( $_POST && empty($_COOKIE[TEST_COOKIE]) )
		$errors['test_cookie'] = __('<strong>ERROR</strong>: WordPress requires Cookies but your browser does not support them or they are blocked.');

	if ( $user_login && $user_pass && empty( $errors ) ) {
		$user = new WP_User(0, $user_login);

		// If the user can't edit posts, send them to their profile.
		if ( !$user->has_cap('edit_posts') && ( empty( $redirect_to ) || $redirect_to == 'wp-admin/' ) )
			$redirect_to = get_option('siteurl') . '/wp-admin/profile.php';

		if ( wp_login($user_login, $user_pass, $using_cookie) ) {
			if ( !$using_cookie )
				wp_setcookie($user_login, $user_pass, false, '', '', $rememberme);
			do_action('wp_login', $user_login);
			wp_safe_redirect($redirect_to);
			exit();
		} else {
			if ( $using_cookie )
				$errors['expiredsession'] = __('Your session has expired.');
		}
	}

	if ( $_POST && empty( $user_login ) )
		$errors['user_login'] = __('<strong>ERROR</strong>: The username field is empty.');
	if ( $_POST && empty( $user_pass ) )
		$errors['user_pass'] = __('<strong>ERROR</strong>: The password field is empty.');

	// Some parts of this script use the main login form to display a message
	if		( TRUE == $_GET['loggedout'] )			$errors['loggedout']		= __('Successfully logged you out.');
	elseif	( 'disabled' == $_GET['registration'] )	$errors['registerdiabled']	= __('User registration is currently not allowed.');
	elseif	( 'confirm' == $_GET['checkemail'] )	$errors['confirm']			= __('Check your e-mail for the confirmation link.');
	elseif	( 'newpass' == $_GET['checkemail'] )	$errors['newpass']			= __('Check your e-mail for your new password.');
	elseif	( 'registered' == $_GET['checkemail'] )	$errors['registered']		= __('Registration complete. Please check your e-mail.');

	if ( ! is_user_logged_in() )
		wp_clearcookie(); // Start with a clean slate
	login_header(__('Login'));
?>

<form name="loginform" id="loginform" action="http://<?php echo $current_blog->domain . $current_blog->path ?>wp-login.php" method="post">
<?php if ( !in_array( $_GET['checkemail'], array('confirm', 'newpass') ) ) : ?>
	<p>
		<label><?php _e('Username:') ?><br />
		<input type="text" name="log" id="user_login" class="input" value="<?php echo attribute_escape(stripslashes($user_login)); ?>" size="20" tabindex="10" /></label>
	</p>
	<p>
		<label><?php _e('Password:') ?><br />
		<input type="password" name="pwd" id="user_pass" class="input" value="" size="20" tabindex="20" /></label>
	</p>
<?php do_action('login_form'); ?>
	<p><label><input name="rememberme" type="checkbox" id="rememberme" value="forever" tabindex="90" /> <?php _e('Remember me'); ?></label></p>
	<p class="submit">
		<input type="submit" name="wp-submit" id="wp-submit" value="<?php _e('Login'); ?> &raquo;" tabindex="100" />
		<input type="hidden" name="redirect_to" value="<?php echo attribute_escape($redirect_to); ?>" />
	</p>
<?php else : ?>
	<p>&nbsp;</p>
<?php endif; ?>
</form>
</div>

<ul>
<?php if ( in_array( $_GET['checkemail'], array('confirm', 'newpass') ) ) : ?>
	<li><a href="<?php bloginfo('url'); ?>/" title="<?php _e('Are you lost?') ?>"><?php printf(__('Back to %s'), get_bloginfo('title', 'display')); ?></a></li>
<?php elseif (get_option('users_can_register')) : ?>
	<li><a href="<?php bloginfo('wpurl'); ?>/wp-signup.php"><?php _e('Register') ?></a></li>
	<li><a href="<?php bloginfo('wpurl'); ?>/wp-login.php?action=lostpassword" title="<?php _e('Password Lost and Found') ?>"><?php _e('Lost your password?') ?></a></li>
	<li><a href="<?php bloginfo('url'); ?>/" title="<?php _e('Are you lost?') ?>"><?php printf(__('Back to %s'), get_bloginfo('title', 'display')); ?></a></li>
<?php else : ?>
	<li><a href="<?php bloginfo('url'); ?>/" title="<?php _e('Are you lost?') ?>"><?php printf(__('Back to %s'), get_bloginfo('title', 'display')); ?></a></li>
	<li><a href="<?php bloginfo('wpurl'); ?>/wp-login.php?action=lostpassword" title="<?php _e('Password Lost and Found') ?>"><?php _e('Lost your password?') ?></a></li>
<?php endif; ?>
</ul>


</body>
</html>
<?php

break;
} // end action switch
?>

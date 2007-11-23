<?php
define( "WP_INSTALLING", true );
require( 'wp-config.php' );

add_action( 'wp_head', 'signuppageheaders' ) ;

require( 'wp-blog-header.php' );
require_once( ABSPATH . WPINC . '/registration.php' );

if( is_array( get_site_option( 'illegal_names' )) && $_GET[ 'new' ] != '' && in_array( $_GET[ 'new' ], get_site_option( 'illegal_names' ) ) == true ) {
	header( "Location: http://{$current_site->domain}{$current_site->path}" );
	die();
}

do_action("signup_header");

function signuppageheaders() {
	echo "<meta name='robots' content='noindex,nofollow'>\n";
}

if( $current_blog->domain . $current_blog->path != $current_site->domain . $current_site->path ) {
	header( "Location: http://" . $current_site->domain . $current_site->path . "wp-signup.php" );
	die();
}

function wpmu_signup_stylesheet() {
?>
<style type="text/css">
form { margin-top: 2em; }
#submit, #blog_title, #user_email {
	width: 90%;
	font-size: 24px;
}
.error {
	background-color: #f66;
}
</style>
<?php
}

add_action( 'wp_head', 'wpmu_signup_stylesheet' );
get_header();
?>
<div id="content" class="widecolumn">
<?php
function show_blog_form($blog_id = '', $blog_title = '', $errors = '') {
	global $current_site;
	$locale = get_locale();

	// Blog name/Username
	if ( $errors->get_error_message('blog_id') )
		print '<tr class="error">';
	else
		print '<tr>';

	if( constant( "VHOST" ) == 'no' )
		echo '<th valign="top">' . __('Blog Name:') . '</th><td>';
	else
		echo '<th valign="top">' . __('Blog Domain:') . '</th><td>';

	if ( $errmsg = $errors->get_error_message('blog_id') ) {
		?><p><strong><?php echo $errmsg ?></strong></p><?php
	}
	if( constant( "VHOST" ) == 'no' ) {
		print '<span style="font-size: 20px">' . $current_site->domain . $current_site->path . '</span><input name="blog_id" type="text" id="blog_id" value="'.$blog_id.'" maxlength="50" style="width:40%; text-align: left; font-size: 20px;" /><br />';
	} else {
		print '<input name="blog_id" type="text" id="blog_id" value="'.$blog_id.'" maxlength="50" style="width:40%; text-align: right; font-size: 20px;" /><span style="font-size: 20px">.' . $current_site->domain . $current_site->path . '</span><br />';
	}
	if ( !is_user_logged_in() ) {
		print '(<strong>' . __( 'Your address will be ' );
		if( constant( "VHOST" ) == 'no' ) {
			print $current_site->domain . $current_site->path . __( 'blogname' );
		} else {
			print __( 'domain.' ) . $current_site->domain . $current_site->path;
		}
		print '.</strong>' . __( 'Must be at least 4 characters, letters and numbers only. It cannot be changed so choose carefully!)' ) . '</td> </tr>';
	}

	// Blog Title
	if ( $errors->get_error_message('blog_title')) {
		print '<tr class="error">';
	} else {
		print '<tr>';
	}
?><th valign="top" width="120"><?php _e('Blog Title:') ?></th><td><?php

	if ( $errmsg = $errors->get_error_message('blog_title') ) {
?><p><strong><?php echo $errmsg ?></strong></p><?php
	}
	print '<input name="blog_title" type="text" id="blog_title" value="'.wp_specialchars($blog_title, 1).'" /></td>
		</tr>';
?>
<tr>
<th scope="row"  valign="top"><?php _e('Privacy:') ?></th>
<td><?php _e('I would like my blog to appear in search engines like Google and Technorati, and in public listings around this site.'); ?> 
<label><input type="radio" name="blog_public" value="1" <?php if( !isset( $_POST[ 'blog_public' ] ) || $_POST[ 'blog_public' ] == '1' ) { ?>checked="checked"<?php } ?> /> <strong>Yes</strong> </label> <label><input type="radio" name="blog_public" value="0" <?php if( isset( $_POST[ 'blog_public' ] ) && $_POST[ 'blog_public' ] == '0' ) { ?>checked="checked"<?php } ?> /><strong>No</strong> </label> <br />
</tr>
<?php
do_action('signup_blogform', $errors);
}

function validate_blog_form() {
	if ( is_user_logged_in() )
		$user = wp_get_current_user();
	else
		$user = '';

	$result = wpmu_validate_blog_signup($_POST['blog_id'], $_POST['blog_title'], $user);

	return $result;
}

function show_user_form($user_name = '', $user_email = '', $errors = '') {
	// Blog name/Username
	if ( $errors->get_error_message('user_name') ) {
		print '<tr class="error">';
	} else {
		print '<tr>';
	}

	echo '<th valign="top">' . __('Username:') . '</th><td>';

	if ( $errmsg = $errors->get_error_message('user_name') ) {
		?><p><strong><?php echo $errmsg ?></strong></p><?php
	}

	print '<input name="user_name" type="text" id="user_name" value="'.$user_name.'" maxlength="50" style="width:50%; font-size: 30px;" /><br />';
	_e('(Must be at least 4 characters, letters and numbers only.)'); echo '</td> </tr>';

	// User Email
	if ( $errors->get_error_message('user_email') ) {
		print '<tr class="error">';
	} else {
		print '<tr>';
	}
?><th valign="top"><?php _e('Email&nbsp;Address:') ?></th><td valign="top"><?php

	if ( $errmsg = $errors->get_error_message('user_email') ) {
?><p><strong><?php echo $errmsg ?></strong></p><?php
	}
	?>
	<input name="user_email" type="text" id="user_email" value="<?php  echo wp_specialchars($user_email, 1) ?>" maxlength="200" /><br /><?php _e('(We&#8217;ll send your password to this address, so <strong>triple-check it</strong>.)') ?></td>
	</tr>
	<?php
	if ( $errmsg = $errors->get_error_message('generic') )
		print '<tr class="error"> <th colspan="2">'.$errmsg.'</th> </tr>';
	do_action( 'signup_extra_fields', $errors );
}

function validate_user_form() {
	$result = wpmu_validate_user_signup($_POST['user_name'], $_POST['user_email']);

	return $result;
}

function signup_another_blog($blog_id = '', $blog_title = '', $errors = '') {
	global $current_user, $wpdb, $domain, $current_site;

	if ( ! is_wp_error($errors) )
		$errors = new WP_Error();

	// allow definition of default variables
	$filtered_results = apply_filters('signup_another_blog_init', array('blog_id' => $blog_id, 'blog_title' => $blog_title, 'errors' => $errors ));
	$blog_id = $filtered_results['blog_id'];
	$blog_title = $filtered_results['blog_title'];
	$errors = $filtered_results['errors'];

	echo '<h2>' . sprintf( __('Get <em>another</em> %s blog in seconds'), $current_site->site_name ) . '</h2>';

	if ( $errors->get_error_code() ) {
		echo "<p>" . __('There was a problem, please correct the form below and try again.') . "</p>";
	}

?>
<p><?php printf(__("Welcome back, %s. By filling out the form below, you can <strong>add another blog to your account</strong>. There is no limit to the number of blogs you can have, so create to your heart's content, but blog responsibly."), $current_user->display_name) ?></p>
<?php
	$blogs = get_blogs_of_user($current_user->ID);

	if ( ! empty($blogs) ) {
		?><p><?php _e('Here are the blogs you already have:') ?></p><ul><?php
		foreach ( $blogs as $blog )
			echo "<li><a href='http://" . $blog->domain . $blog->path . "'>" . $blog->domain . $blog->path . "</a></li>";
		?></ul><?php
	}
?>
<p><?php _e("If you&#8217;re not going to use a great blog domain, leave it for a new user. Now have at it!") ?></p>
<form name="setupform" id="setupform" method="post" action="wp-signup.php">
<input type="hidden" name="stage" value="gimmeanotherblog" />
<?php do_action( "signup_hidden_fields" ); ?>
<table border="0" width="100%" cellpadding="9">
<?php
	show_blog_form($blog_id, $blog_title, $errors);
?>
<tr>
<th scope="row"  valign="top">&nbsp;</th>
<td><input id="submit" type="submit" name="Submit" class="submit" value="<?php _e('Create Blog &raquo;') ?>" /></td>
</tr>
</table>
</form>
<?php
}

function validate_another_blog_signup() {
	global $current_user, $blog_id, $blog_title, $errors, $domain, $path;
	$current_user = wp_get_current_user();
	if( !is_user_logged_in() ) {
		die();
	}

	$result = validate_blog_form();
	extract($result);

	if ( $errors->get_error_code() ) {
		signup_another_blog($blog_id, $blog_title, $errors);
		return;
	}

	$public = (int) $_POST['blog_public'];
	$meta = apply_filters('signup_create_blog_meta', array ('lang_id' => 1, 'public' => $public));

	wpmu_create_blog($domain, $path, $blog_title, $current_user->id, $meta);
	confirm_another_blog_signup($domain, $path, $blog_title, $current_user->user_login, $current_user->user_email, $meta);
}

function confirm_another_blog_signup($domain, $path, $blog_title, $user_name, $user_email, $meta) {
?>
<h2><?php printf(__('The blog %s is yours.'), $domain.$path ) ?></h2>
<p><?php printf(__('<a href="http://%1$s">http://%2$s</a> is your new blog.  <a href="%3$s">Login</a> as "%4$s" using your existing password.'), $domain.$path, $domain.$path, "http://" . $domain.$path . "wp-login.php", $user_name) ?></p>
<?php
	do_action('signup_finished');
}

function signup_user($user_name = '', $user_email = '', $errors = '') {
	global $current_site, $active_signup;

	if ( ! is_wp_error($errors) )
		$errors = new WP_Error();
	if( isset( $_POST[ 'signup_for' ] ) ) {
		$signup[ wp_specialchars( $_POST[ 'signup_for' ] ) ] = 'checked="checked"';
	} else {
		$signup[ 'blog' ] = 'checked="checked"';
	}

	// allow definition of default variables
	$filtered_results = apply_filters('signup_user_init', array('user_name' => $user_name, 'user_email' => $user_email, 'errors' => $errors ));
	$user_name = $filtered_results['user_name'];
	$user_email = $filtered_results['user_email'];
	$errors = $filtered_results['errors'];
?>
<h2><?php printf( __('Get your own %s account in seconds'), $current_site->site_name ) ?></h2>
<p><?php _e( "Fill out this one-step form and you'll be blogging seconds later!" ); ?></p>
<form name="setupform" id="setupform" method="post" action="wp-signup.php">
<input type="hidden" name="stage" value="validate-user-signup" />
<?php do_action( "signup_hidden_fields" ); ?>
<table border="0" width="100%" cellpadding="9" cellspacing="4">
<?php show_user_form($user_name, $user_email, $errors); ?>
<tr>
<th scope="row"  valign="top">&nbsp;</th>
<td>
<p>
<?php if( $active_signup == 'blog' ) { ?>
<input id="signupblog" type="hidden" name="signup_for" value="blog" />
<?php } elseif( $active_signup == 'user' ) { ?>
<input id="signupblog" type="hidden" name="signup_for" value="user" />
<?php } else { ?>
<input id="signupblog" type="radio" name="signup_for" value="blog" <?php echo $signup[ 'blog' ] ?> />
<label for="signupblog"><?php _e('Gimme a blog!') ?></label>
<br />
<input id="signupuser" type="radio" name="signup_for" value="user" <?php echo $signup[ 'user' ] ?> />
<label for="signupuser"><?php _e('Just a username, please.') ?></label>
<?php } ?>
</p>
</td>
</tr>
<tr>
<th scope="row"  valign="top">&nbsp;</th>
<td><input id="submit" type="submit" name="Submit" class="submit" value="<?php _e('Next &raquo;') ?>" /></td>
</tr>
</table>
</form>
<?php

}

function validate_user_signup() {
	$result = validate_user_form();
	extract($result);

	if ( $errors->get_error_code() ) {
		signup_user($user_name, $user_email, $errors);
		return;
	}

	if ( 'blog' == $_POST['signup_for'] ) {
		signup_blog($user_name, $user_email);
		return;
	}

	wpmu_signup_user($user_name, $user_email, apply_filters( "add_signup_meta", array() ) );

	confirm_user_signup($user_name, $user_email);
}

function confirm_user_signup($user_name, $user_email) {
?>
<h2><?php printf(__('%s is your new username'), $user_name) ?></h2>
<p><?php _e('But, before you can start using your new username, <strong>you must activate it</strong>.') ?></p>
<p><?php printf(__('Check your inbox at <strong>%1$s</strong> and click the link given.  '),  $user_email) ?></p>
<p><?php _e('If you do not activate your username within two days, you will have to sign up again.'); ?></p>
<?php
}

function signup_blog($user_name = '', $user_email = '', $blog_id = '', $blog_title = '', $errors = '') {
	if ( ! is_wp_error($errors) )
		$errors = new WP_Error();

	// allow definition of default variables
	$filtered_results = apply_filters('signup_blog_init', array('user_name' => $user_name, 'user_email' => $user_email, 'blog_id' => $blog_id, 'blog_title' => $blog_title, 'errors' => $errors ));
	$user_name = $filtered_results['user_name'];
	$user_email = $filtered_results['user_email'];
	$blog_id = $filtered_results['blog_id'];
	$blog_title = $filtered_results['blog_title'];
	$errors = $filtered_results['errors'];

	if ( empty($blog_id) )
		$blog_id = $user_name;
?>
<form name="setupform" id="setupform" method="post" action="wp-signup.php">
<input type="hidden" name="stage" value="validate-blog-signup" />
<input type="hidden" name="user_name" value="<?php echo $user_name ?>" />
<input type="hidden" name="user_email" value="<?php echo $user_email ?>" />
<?php do_action( "signup_hidden_fields" ); ?>
<table border="0" width="100%" cellpadding="9">
<?php show_blog_form($blog_id, $blog_title, $errors); ?>
<tr>
<th scope="row"  valign="top">&nbsp;</th>
<td><input id="submit" type="submit" name="Submit" class="submit" value="<?php _e('Signup &raquo;') ?>" /></td>
</tr>
</table>
</form>
<?php
}

function validate_blog_signup() {
	// Re-validate user info.
	$result = wpmu_validate_user_signup($_POST['user_name'], $_POST['user_email']);
	extract($result);

	if ( $errors->get_error_code() ) {
		signup_user($user_name, $user_email, $errors);
		return;
	}

	$result = wpmu_validate_blog_signup($_POST['blog_id'], $_POST['blog_title']);
	extract($result);

	if ( $errors->get_error_code() ) {
		signup_blog($user_name, $user_email, $blog_id, $blog_title, $errors);
		return;
	}

	$public = (int) $_POST['blog_public'];
	$meta = array ('lang_id' => 1, 'public' => $public);
	$meta = apply_filters( "add_signup_meta", $meta );

	wpmu_signup_blog($domain, $path, $blog_title, $user_name, $user_email, $meta);

	confirm_blog_signup($domain, $path, $blog_title, $user_name, $user_email, $meta);
}

function confirm_blog_signup($domain, $path, $blog_title, $user_name, $user_email, $meta) {
?>
<h2><?php printf(__('The blog %s is yours'), $domain.$path) ?></h2>
<p><?php _e('But, before you can start using your blog, <strong>you must activate it</strong>.') ?></p>
<p><?php printf(__('Check your inbox at <strong>%s</strong> and click the link given.  '),  $user_email) ?></p>
<p><?php _e('If you do not activate your blog within two days, you will have to sign up again.'); ?></p>
<?php
	do_action('signup_finished');
}

// Main
$active_signup = get_site_option( 'registration' );
if( !$active_signup )
	$active_signup = 'all';

$active_signup = apply_filters( 'wpmu_active_signup', $active_signup ); // return "all", "none", "blog" or "user"

if( is_site_admin() ) {
	echo "<div style='background: #faf; font-weight: bold; border: 1px solid #333; margin: 2px; padding: 2px'>Greetings Site Administrator! You are currently allowing '$active_signup' registrations. To change or disable registration go to your <a href='wp-admin/wpmu-options.php'>Options page</a>.</div>";
}

$newblogname = isset($_GET['new']) ? strtolower(preg_replace('/^-|-$|[^-a-zA-Z0-9]/', '', $_GET['new'])) : null;

if( $active_signup == "none" ) {
	_e( "Registration has been disabled." );
} else {
switch ($_POST['stage']) {
	case 'validate-user-signup' :
		if( $active_signup == 'all' || $_POST[ 'signup_for' ] == 'blog' && $active_signup == 'blog' || $_POST[ 'signup_for' ] == 'user' && $active_signup == 'user' )
			validate_user_signup();
		else
			_e( "User registration has been disabled." );
		break;
	case 'validate-blog-signup':
		if( $active_signup == 'all' || $active_signup == 'blog' )
			validate_blog_signup();
		else
			_e( "Blog registration has been disabled." );
		break;
	case 'gimmeanotherblog':
		validate_another_blog_signup();
		break;
	default :
		$user_email = $_POST[ 'user_email' ];
		do_action( "preprocess_signup_form" ); // populate the form from invites, elsewhere?
		if ( is_user_logged_in() && ( $active_signup == 'all' || $active_signup == 'blog' ) ) {
			signup_another_blog($newblogname);
		} elseif( is_user_logged_in() == false && ( $active_signup == 'all' || $active_signup == 'user' ) ) {
			signup_user( $newblogname, $user_email );
		} elseif( is_user_logged_in() == false && ( $active_signup == 'blog' ) ) {
			_e( "I'm sorry. We're not accepting new registrations at this time." );
		} else {
			_e( "You're logged in already. No need to register again!" );
		}

		if ($newblogname) {
			if( constant( "VHOST" ) == 'no' )
				$newblog = 'http://' . $current_site->domain . $current_site->path . $newblogname . '/';
			else
				$newblog = 'http://' . $newblogname . '.' . $current_site->domain . $current_site->path;
			printf(__("<p><em>The blog you were looking for, <strong>%s</strong> doesn't exist but you can create it now!</em></p>"), $newblog );
		}
		break;
}
}
?>
</div>

<?php get_footer(); ?>

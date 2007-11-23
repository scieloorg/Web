<?php
require_once('admin.php');
if( is_site_admin() == false ) {
    wp_die( __('<p>You do not have permission to access this page.</p>') );
}

do_action('wpmuadminedit', '');

if( $_GET[ 'id' ] ) { 
	$id = intval( $_GET[ 'id' ] ); 
} elseif( $_POST[ 'id' ] ) { 
	$id = intval( $_POST[ 'id' ] ); 
}

if( isset( $_POST['ref'] ) == false && empty( $_SERVER['HTTP_REFERER'] ) == false ) {
	$_POST['ref'] = $_SERVER['HTTP_REFERER'];
}

switch( $_GET['action'] ) {
	// Options
	case "siteoptions":
		check_admin_referer('siteoptions');
		if( empty( $_POST ) )
			wp_die( __("You probably need to go back to the <a href='wpmu-options.php'>options page</a>") );

		update_site_option( "WPLANG", $_POST['WPLANG'] );
		if( is_email( $_POST['admin_email'] ) )
			update_site_option( "admin_email", $_POST['admin_email'] );
		$illegal_names = split( ' ', $_POST['illegal_names'] );
		
		foreach( (array) $illegal_names as $name ) {
			$name = trim( $name );
			if( $name != '' )
				$names[] = trim( $name );
		}
		
		update_site_option( "illegal_names", $names );
		update_site_option( "registration", $_POST['registration'] );
		update_site_option( "registrationnotification", $_POST['registrationnotification'] );
		
		if( $_POST['limited_email_domains'] != '' ) {
			update_site_option( "limited_email_domains", split( ' ', $_POST['limited_email_domains'] ) );
		} else {
			update_site_option( "limited_email_domains", '' );
		}
		
		if( $_POST['banned_email_domains'] != '' ) {
			$banned_email_domains = split( "\n", stripslashes($_POST['banned_email_domains']) );
			foreach( (array) $banned_email_domains as $domain ) {
				$banned[] = trim( $domain );
			}
			update_site_option( "banned_email_domains", $banned );
		} else {
			update_site_option( "banned_email_domains", '' );
		}
		
		update_site_option( "menu_items", $_POST['menu_items'] );
		update_site_option( "blog_upload_space", $_POST['blog_upload_space'] );
		update_site_option( "upload_filetypes", $_POST['upload_filetypes'] );
		update_site_option( "site_name", $_POST['site_name'] );
		update_site_option( "first_post", $_POST['first_post'] );
		update_site_option( "welcome_email", $_POST['welcome_email'] );
		update_site_option( "fileupload_maxk", $_POST['fileupload_maxk'] );
		
		$site_admins = explode( ' ', str_replace( ",", " ", $_POST['site_admins'] ) );
		if ( is_array( $site_admins ) ) {
			$mainblog_id = $wpdb->get_var( "SELECT blog_id FROM {$wpdb->blogs} WHERE domain='{$current_site->domain}' AND path='{$current_site->path}'" );
			if( $mainblog_id ) {
				reset( $site_admins );
				foreach( (array) $site_admins as $site_admin ) {
					$uid = $wpdb->get_var( "SELECT ID FROM {$wpdb->users} WHERE user_login='{$site_admin}'" );
					if( $uid )
						add_user_to_blog( $mainblog_id, $uid, 'Administrator' );
				}
			}
			update_site_option( 'site_admins' , $site_admins );
		}

		// Update more options here
		do_action( 'update_wpmu_options' );

		wp_redirect( add_query_arg( "updated", "true", $_SERVER['HTTP_REFERER'] ) );
		exit();
	break;
	
	// Blogs
	case "addblog":
		check_admin_referer('add-blog');

		$blog = $_POST['blog'];
		$domain = strtolower( wp_specialchars( $blog['domain'] ) );
		$email = wp_specialchars( $blog['email'] );
		
		if ( empty($domain) || empty($email))
			wp_die( __("<p>Missing blog address or email address.</p>") );
		if( !is_email( $email ) ) 
			wp_die( __("<p>Invalid email address</p>") ); 
		
		if( constant( "VHOST" ) == 'yes' ) {
			$newdomain = $domain.".".$current_site->domain;
			$path = $base;
		} else {
			$newdomain = $current_site->domain;
			$path = $base.$domain.'/';
		}

		$user_id = email_exists($email);
		if( !$user_id ) {
			$password = generate_random_password();
			$user_id = wpmu_create_user( $domain, $password, $email );
			if(false == $user_id) {
				wp_die( __("<p>There was an error creating the user</p>") );
			} else {
				wp_new_user_notification($user_id, $password);
			}
		}

		$wpdb->hide_errors();
		$blog_id = wpmu_create_blog($newdomain, $path, wp_specialchars( $blog['title'] ), $user_id ,'', $current_site->id);
		$wpdb->show_errors();
		if( !is_wp_error($blog_id) ) {
			if( get_user_option( $user_id, 'primary_blog' ) == 1 )
				update_user_option( $user_id, 'primary_blog', $blog_id, true );
			$content_mail = sprintf(__("New blog created by %1s\n\nAddress: http://%2s\nName: %3s"), $current_user->user_login , $newdomain.$path, wp_specialchars($blog['title']) );
			wp_mail( get_site_option('admin_email'),  sprintf(__('[%s] New Blog Created'), $current_site->site_name), $content_mail, 'From: "Site Admin" <' . get_site_option( 'admin_email' ) . '>' );
			wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'add-blog'), $_SERVER['HTTP_REFERER'] ) );
			exit();
		} else {
			die( $blog_id->get_error_message() );
		}
	break;
	
	case "updateblog":
		check_admin_referer('editblog');
		if( empty( $_POST ) )
			wp_die( __("You probably need to go back to the <a href='wpmu-blogs.php'>blogs page</a>") );

		// themes
		if( is_array( $_POST['theme'] ) ) {
			$_POST['option']['allowedthemes'] = $_POST['theme'];
		} else {
			$_POST['option']['allowedthemes'] = '';
		}
		
		if( is_array( $_POST['option'] ) ) {
			$c = 1;
			$count = count( $_POST['option'] );
			foreach ( (array) $_POST['option'] as $key => $val ) {
				if( $c == $count ) {
					update_blog_option( $id, $key, $val );
				} else {
					update_blog_option( $id, $key, $val, false ); // no need to refresh blog details yet
				}
				$c++;
			}
		}
		
		// update blogs table
		$result = $wpdb->query("UPDATE {$wpdb->blogs} SET
				domain       = '".$_POST['blog']['domain']."',
				path         = '".$_POST['blog']['path']."',
				registered   = '".$_POST['blog']['registered']."',
				public       = '".$_POST['blog']['public']."',
				archived     = '".$_POST['blog']['archived']."',
				mature       = '".$_POST['blog']['mature']."',
				deleted      = '".$_POST['blog']['deleted']."',
				spam         = '".$_POST['blog']['spam']."' 
			WHERE  blog_id = '$id'");
			
		update_blog_status( $id, 'spam', $_POST['blog']['spam'] );
		
		// user roles
		if( is_array( $_POST['role'] ) == true ) {
			$newroles = $_POST['role'];
			reset( $newroles );
			foreach ( (array) $newroles as $userid => $role ) {
				$role_len = strlen( $role );
				$existing_role = $wpdb->get_var( "SELECT meta_value FROM $wpdb->usermeta WHERE user_id = '$userid'  AND meta_key = '" . $wpdb->base_prefix . $id . "_capabilities'" );
				if( false == $existing_role ) {
					$wpdb->query( "INSERT INTO " . $wpdb->usermeta . "( `umeta_id` , `user_id` , `meta_key` , `meta_value` ) VALUES ( NULL, '$userid', '" . $wpdb->base_prefix . $id . "_capabilities', 'a:1:{s:" . strlen( $role ) . ":\"" . $role . "\";b:1;}')" );
				} elseif( $existing_role != "a:1:{s:" . strlen( $role ) . ":\"" . $role . "\";b:1;}" ) {
					$wpdb->query( "UPDATE $wpdb->usermeta SET meta_value = 'a:1:{s:" . strlen( $role ) . ":\"" . $role . "\";b:1;}' WHERE user_id = '$userid'  AND meta_key = '" . $wpdb->base_prefix . $id . "_capabilities'" );
				}

			}
		}

		// remove user
		if( is_array( $_POST['blogusers'] ) ) {
			reset( $_POST['blogusers'] );
			foreach ( (array) $_POST['blogusers'] as $key => $val ) {
				delete_usermeta( $key, $wpdb->base_prefix.$id.'_capabilities' );
				delete_usermeta( $key, $wpdb->base_prefix.$id.'_user_level' );
				delete_usermeta( $key, 'primary_blog', $id ); // Delete primary blog if need.
			}
		}

		// change password
		if( is_array( $_POST['user_password'] ) ) {
			reset( $_POST['user_password'] );
			$newroles = $_POST['role'];
			foreach ( (array) $_POST['user_password'] as $userid => $pass ) {
				unset( $_POST['role'] );
				$_POST['role'] = $newroles[ $userid ];
				if( $pass != '' ) {
					$cap = $wpdb->get_var( "SELECT meta_value FROM {$wpdb->usermeta} WHERE user_id = '{$userid}' AND meta_key = '{$wpdb->base_prefix}{$wpdb->blogid}_capabilities' AND meta_value = 'a:0:{}'" );
					$userdata = get_userdata($userid);
					$_POST['pass1'] = $_POST['pass2'] = $pass;
					$_POST['email'] = $userdata->user_email;
					$_POST['rich_editing'] = $userdata->rich_editing;
					edit_user( $userid );
					if( $cap == null )
						$wpdb->query( "DELETE FROM {$wpdb->usermeta} WHERE user_id = '{$userid}' AND meta_key = '{$wpdb->base_prefix}{$wpdb->blogid}_capabilities' AND meta_value = 'a:0:{}'" );
				}
			}
			unset( $_POST['role'] );
			$_POST['role'] = $newroles;
		}

		// add user?
		if( $_POST['newuser'] != '' ) {
			$newuser = $_POST['newuser'];
			$userid = $wpdb->get_var( "SELECT ID FROM " . $wpdb->users . " WHERE user_login = '$newuser'" );
			if( $userid ) {
				$user = $wpdb->get_var( "SELECT user_id FROM " . $wpdb->usermeta . " WHERE user_id='$userid' AND meta_key='wp_" . $id . "_capabilities'" );
				if( $user == false )
					$wpdb->query( "INSERT INTO " . $wpdb->usermeta . "( `umeta_id` , `user_id` , `meta_key` , `meta_value` ) VALUES ( NULL, '$userid', '" . $wpdb->base_prefix . $id . "_capabilities', 'a:1:{s:" . strlen( $_POST['new_role'] ) . ":\"" . $_POST['new_role'] . "\";b:1;}')" );
			}
		}
		wpmu_admin_do_redirect( "wpmu-blogs.php?action=editblog&updated=true&id=".$id );
	break;
	
	case "deleteblog":
		check_admin_referer('deleteblog');
		if( $id != '0' && $id != '1' )
			wpmu_delete_blog( $id, true );
			
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'delete'), $_POST[ 'ref' ] ) );
		exit();
	break;
	
	case "allblogs":
		check_admin_referer('allblogs');
		foreach ( (array) $_POST['allblogs'] as $key => $val ) {
			if( $val != '0' && $val != '1' ) {
				if( $_POST['blogfunction'] == 'delete' ) {
					wpmu_delete_blog( $val, true );
				} elseif( $_POST['blogfunction'] == 'spam' ) {
					update_blog_status( $val, "spam", '1', 0 );
					set_time_limit(60); 
				}
			}
		}

		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'all_'.$_POST['blogfunction']), $_SERVER['HTTP_REFERER'] ) );
		exit();
	break;
	
	case "archiveblog":
		check_admin_referer('archiveblog');
		update_blog_status( $id, "archived", '1' );
		do_action( "archive_blog", $id );
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'archive'), $_POST['ref'] ) );
		exit();
	break;
	
	case "unarchiveblog":
		check_admin_referer('unarchiveblog');
		do_action( "unarchive_blog", $id );
		update_blog_status( $id, "archived", '0' );
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'unarchive'), $_POST['ref'] ) );
		exit();
	break;
	
	case "activateblog":
		check_admin_referer('activateblog');
		update_blog_status( $id, "deleted", '0' );
		do_action( "activate_blog", $id );
		wp_redirect( add_query_arg( "updated", array('updated' => 'true', 'action' => 'activate'), $_POST['ref'] ) );
		exit();
	break;
	
	case "deactivateblog":
		check_admin_referer('deactivateblog');
		do_action( "deactivate_blog", $id );
		update_blog_status( $id, "deleted", '1' );
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'deactivate'), $_POST['ref'] ) );
		exit();
	break;
	
	case "unspamblog":
		check_admin_referer('unspamblog');
		update_blog_status( $id, "spam", '0' );
		do_action( "unspam_blog", $id );
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'unspam'), $_POST['ref'] ) );
		exit();
	break;
	
	case "spamblog":
		check_admin_referer('spamblog');
		update_blog_status( $id, "spam", '1' );
		do_action( 'make_spam_blog', $id );
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'spam'), $_POST['ref'] ) );
		exit();
	break;
	
	case "mature":
		update_blog_status( $id, 'mature', '1' );
		do_action( 'mature_blog', $id );
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'mature'), $_POST['ref'] ) );
		exit();
	break;
	
	case "unmature":
		update_blog_status( $id, 'mature', '0' );
		do_action( 'unmature_blog', $id );
		
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'umature'), $_POST['ref'] ) );
		exit();
	break;
	
	// Themes
    case "updatethemes":
    	if( is_array( $_POST['theme'] ) ) {
			$themes = get_themes();
			reset( $themes );
			foreach( (array) $themes as $key => $theme ) {
				if( $_POST['theme'][ wp_specialchars( $theme['Stylesheet'] ) ] == 'enabled' )
					$allowed_themes[ wp_specialchars( $theme['Stylesheet'] ) ] = true;
			}
			update_site_option( 'allowedthemes', $allowed_themes );
		}
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'themes'), $_SERVER['HTTP_REFERER'] ) );
		exit();
	break;
	
	// Common
	case "confirm":
		global $wp_locale;
		?>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" <?php if ( function_exists('language_attributes') ) language_attributes(); ?>>
			<head>
				<title><?php _e("WordPress MU &rsaquo; Confirm your action"); ?></title>

				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<link rel="stylesheet" href="css/install.css" type="text/css" />
				<?php if ( ( $wp_locale ) && ('rtl' == $wp_locale->text_direction) ) : ?>
					<link rel="stylesheet" href="css/install-rtl.css" type="text/css" />
				<?php endif; ?>
			</head>
			<body>
				<h1 id="logo"><img alt="WordPress" src="images/wordpress-logo.png" /></h1>
				<form action='wpmu-edit.php?action=<?php echo wp_specialchars( $_GET[ 'action2' ] ) ?>' method='post'>
					<input type='hidden' name='action' value='<?php echo wp_specialchars( $_GET['action2'] ) ?>' />
					<input type='hidden' name='id' value='<?php echo wp_specialchars( $id ); ?>' />
					<input type='hidden' name='ref' value='<?php if( isset( $_GET['ref'] ) ) {echo wp_specialchars( $_GET['ref'] ); } else { echo $_SERVER['HTTP_REFERER']; } ?>' />
					<?php wp_nonce_field( $_GET['action2'] ) ?>
					<p>						
						<?php echo wp_specialchars( $_GET['msg'] ) ?><br />
						<input type='submit' value='<?php _e("Confirm"); ?>' /></p>					
				</form>
			</body>
		</html>
		<?php
	break;
	
	// Users
	case "deleteuser":
		check_admin_referer('deleteuser');
		if( $id != '0' && $id != '1' )
			wpmu_delete_user($id);

		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'delete'), $_POST['ref'] ) );
		exit();
	break;
	
	case "allusers":
		check_admin_referer('allusers');
		foreach ( (array) $_POST['allusers'] as $key => $val ) {
			if( $val != '' && $val != '0' && $val != '1' ) {
				$user_details = get_userdata( $val );
				if( $_POST['userfunction'] == 'delete' ) {
					wpmu_delete_user($val);
				} elseif( $_POST['userfunction'] == 'spam' ) {
					$blogs = get_blogs_of_user( $val, true );
					foreach ( (array) $blogs as $key => $details ) {
						update_blog_status( $details->userblog_id, "spam", '1' );
						do_action( "make_spam_blog", $details->userblog_id );
					}
					update_user_status( $val, "spam", '1', 1 );
				} elseif ( $_POST[ 'userfunction' ] == 'notspam' ) {
					$blogs = get_blogs_of_user( $val, true );
					foreach ( (array) $blogs as $key => $details ) {
						update_blog_status( $details->userblog_id, "spam", '0' );
					}
					update_user_status( $val, "spam", '0', 1 );
				}
			}
		}		
		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'all_'.$_POST['userfunction']), $_SERVER['HTTP_REFERER'] ) );
		exit();
	break;
		
	case "adduser":
		check_admin_referer('add-user');

		$user = $_POST['user'];
		if ( empty($user['username']) && empty($user['email']) ) {
			wp_die( __("<p>Missing username and email.</p>") );
		} elseif ( empty($user['username']) ) {
			wp_die( __("<p>Missing username.</p>") );
		} elseif ( empty($user['email']) ) {
			wp_die( __("<p>Missing email.</p>") );
		}

		$password = generate_random_password();
		$user_id = wpmu_create_user(wp_specialchars( strtolower( $user['username'] ) ), $password, wp_specialchars( $user['email'] ) );

		if( false == $user_id ) {
 			wp_die( __("<p>Duplicated username or email address.</p>") );
		} else {
			wp_new_user_notification($user_id, $password);
		}

		wp_redirect( add_query_arg( array('updated' => 'true', 'action' => 'add'), $_SERVER['HTTP_REFERER'] ) );
		exit();
	break;
	
	default:
		wpmu_admin_do_redirect( "wpmu-admin.php" );
	break;	
}

?>

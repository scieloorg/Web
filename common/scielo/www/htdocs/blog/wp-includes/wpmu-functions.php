<?php
/*
	Helper functions for WPMU
*/
function load_muplugin_textdomain($domain, $path = false) {
	$locale = get_locale();
	if ( empty($locale) )
		$locale = 'en_US';

	if ( false === $path )
		$path = MUPLUGINDIR;

	$mofile = ABSPATH . "$path/$domain-$locale.mo";
	load_textdomain($domain, $mofile);
}

function wpmu_update_blogs_date() {
	global $wpdb;

	$wpdb->query( "UPDATE {$wpdb->blogs} SET last_updated = NOW() WHERE  blog_id = '{$wpdb->blogid}'" );
	refresh_blog_details( $wpdb->blogid );
}

add_action('delete_post', 'wpmu_update_blogs_date');
add_action('private_to_published', 'wpmu_update_blogs_date');
add_action('publish_phone', 'wpmu_update_blogs_date');
add_action('publish_post', 'wpmu_update_blogs_date');

function get_blogaddress_by_id( $blog_id ) {
	$bloginfo = get_blog_details( (int) $blog_id, false ); // only get bare details!
	return "http://" . $bloginfo->domain . $bloginfo->path;
}

function get_blogaddress_by_name( $blogname ) {
	global $hostname, $domain, $base;

	if( defined( "VHOST" ) && constant( "VHOST" ) == 'yes' ) {
		if( $blogname == 'main' )
			$blogname = 'www';
		return "http://".$blogname.".".$domain.$base;
	} else {
		return "http://".$hostname.$base.$blogname;
	}
}

function get_blogaddress_by_domain( $domain, $path ){
	if( defined( "VHOST" ) && constant( "VHOST" ) == 'yes' ) {
		$url = "http://".$domain.$path;
	} else {
		if( $domain != $_SERVER['HTTP_HOST'] ) {
			$blogname = substr( $domain, 0, strpos( $domain, '.' ) );
			if( $blogname != 'www.' ) {
				$url = 'http://' . substr( $domain, strpos( $domain, '.' ) + 1 ) . $path . $blogname . '/';
			} else { // we're installing the main blog
				$url = 'http://' . substr( $domain, strpos( $domain, '.' ) + 1 ) . $path;
			}
		} else { // main blog
			$url = 'http://' . $domain . $path;
		}
	}
	return $url;
}

function get_sitestats() {
	global $wpdb;

	$stats['blogs'] = get_blog_count();

	$count_ts = get_site_option( "get_user_count_ts" );
	if( time() - $count_ts > 3600 ) {
		$count = $wpdb->get_var( "SELECT count(*) as c FROM {$wpdb->users}" );
		update_site_option( "user_count", $count );
		update_site_option( "user_count_ts", time() );
	} else {
		$count = get_site_option( "user_count" );
	}
	$stats['users'] = $count;
	return $stats;
}

function get_admin_users_for_domain( $sitedomain = '', $path = '' ) {
	global $wpdb;
	if( $sitedomain == '' ) {
		$site_id = $wpdb->siteid;
	} else {
		$site_id = $wpdb->get_var( "SELECT id FROM ".$wpdb->site." WHERE domain = '".$sitedomain."' AND path = '".$path."'" );
	}
	if( $site_id != false ) {
		$details = $wpdb->get_results( "SELECT ID, user_login, user_pass FROM ".$wpdb->users.", ".$wpdb->sitemeta." WHERE meta_key = 'admin_user_id' AND ".$wpdb->users.".ID = ".$wpdb->sitemeta.".meta_value AND ".$wpdb->sitemeta.".site_id = '".$site_id."'", ARRAY_A );
	} else {
		$details = false;
	}
	return $details;
}

function get_user_details( $username ) {
	global $wpdb;
	return $wpdb->get_row( "SELECT * FROM $wpdb->users WHERE user_login = '$username'" );
}

function get_blog_details( $id, $getall = true ) {
	global $wpdb;

	$all = $getall == true ? '' : 'short';
	$details = wp_cache_get( $id . $all, 'blog-details' );

	if ( $details ) {
		if ( $details == -1 )
			return false;
		elseif ( !is_object($details) ) // Clear old pre-serialized objects. Cache clients do better with that.
			wp_cache_delete( $id . $all, 'blog-details' );
		else
			return $details;
	}

	$details = $wpdb->get_row( "SELECT * FROM $wpdb->blogs WHERE blog_id = '$id' /* get_blog_details */" );

	if ( !$details ) {
		wp_cache_set( $id . $all, -1, 'blog-details' );
		return false;
	}

	if ( !$getall ) {
		wp_cache_add( $id . $all, $details, 'blog-details' );
		return $details;
	}

	$wpdb->hide_errors();
	$details->blogname   = get_blog_option($id, 'blogname');
	$details->siteurl    = get_blog_option($id, 'siteurl');
	$details->post_count = get_blog_option($id, 'post_count');
	$wpdb->show_errors();

	$details = apply_filters('blog_details', $details);

	wp_cache_set( $id . $all, $details, 'blog-details' );

	$key = md5( $details->domain . $details->path );
	wp_cache_set( $key, $details, 'blog-lookup' );

	return $details;
}

function refresh_blog_details( $id ) {
	$id = (int) $id;
	$details = get_blog_details( $id, false );
	
	wp_cache_delete( $id , 'blog-details' );
	wp_cache_delete( md5( $details->domain . $details->path )  , 'blog-lookup' );
}

function get_current_user_id() {
	global $current_user;
	return $current_user->ID;
}

function is_site_admin( $user_login = false ) {
	global $current_user;

	if ( !$current_user && !$user_login )
		return false;

	if ( $user_login )
		$user_login = sanitize_user( $user_login );
	else
		$user_login = $current_user->user_login;

	$site_admins = get_site_option( 'site_admins', array('admin') );
	if( is_array( $site_admins ) && in_array( $user_login, $site_admins ) )
		return true;

	return false;
}

// expects key not to be SQL escaped
function get_site_option( $key, $default = false, $use_cache = true ) {
	global $wpdb;

	$safe_key = $wpdb->escape( $key );

	if( $use_cache == true ) {
		$value = wp_cache_get($wpdb->siteid . $key, 'site-options');
	} else {
		$value = false;
	}

	if ( false === $value ) {
		$value = $wpdb->get_var("SELECT meta_value FROM $wpdb->sitemeta WHERE meta_key = '$safe_key' AND site_id = '{$wpdb->siteid}'");
		if ( ! is_null($value) ) {
			wp_cache_add($wpdb->siteid . $key, $value, 'site-options');
		} elseif ( $default ) {
			wp_cache_add($wpdb->siteid . $key, addslashes( $default ), 'site-options');
			return $default;
		} else {
			wp_cache_add($wpdb->siteid . $key, false, 'site-options');
			return false;
		}
	}

	$value = stripslashes( $value );
	@ $kellogs = unserialize($value);
	if ( $kellogs !== FALSE )
		return $kellogs;
	else
		return $value;
}

// expects $key, $value not to be SQL escaped
function add_site_option( $key, $value ) {
	global $wpdb;

	$safe_key = $wpdb->escape( $key );

	$exists = $wpdb->get_row("SELECT meta_value FROM $wpdb->sitemeta WHERE meta_key = '$safe_key' AND site_id = '{$wpdb->siteid}'");
	if ( is_object( $exists ) ) {// If we already have it
		update_site_option( $key, $value );
		return false;
	}

	if ( is_array($value) || is_object($value) )
		$value = serialize($value);
	wp_cache_delete($wpdb->siteid . $key, 'site-options');
	$wpdb->query( "INSERT INTO $wpdb->sitemeta ( site_id , meta_key , meta_value ) VALUES ( '{$wpdb->siteid}', '$safe_key', '" . $wpdb->escape( $value ) . "')" );
	return $wpdb->insert_id;
}

// expects $key, $value not to be SQL escaped
function update_site_option( $key, $value ) {
	global $wpdb;

	$safe_key = $wpdb->escape( $key );

	if ( $value == get_site_option( $key ) )
	 	return;

	$exists = $wpdb->get_row("SELECT meta_value FROM $wpdb->sitemeta WHERE meta_key = '$safe_key' AND site_id = '{$wpdb->siteid}'");

	if ( false == is_object( $exists ) ) // It's a new record
		return add_site_option( $key, $value );

	if ( is_array($value) || is_object($value) )
		$value = serialize($value);

	$wpdb->query( "UPDATE $wpdb->sitemeta SET meta_value = '" . $wpdb->escape( $value ) . "' WHERE site_id='{$wpdb->siteid}' AND meta_key = '$safe_key'" );
	wp_cache_delete( $wpdb->siteid . $key, 'site-options' );
}

/*
function get_blog_option( $id, $key, $default='na' ) {
	switch_to_blog($id);
	$opt = get_option( $key );
	restore_current_blog();

	return $opt;
}
*/

function get_blog_option( $blog_id, $setting, $default='na' ) {
	global $wpdb;

	$key = $blog_id."-".$setting."-blog_option";
	$value = wp_cache_get( $key, "site-options" );
	if( $value == null ) {
		$row = $wpdb->get_row( "SELECT * FROM {$wpdb->base_prefix}{$blog_id}_options WHERE option_name = '{$setting}'" );
		if( is_object( $row) ) { // Has to be get_row instead of get_var because of funkiness with 0, false, null values
			$value = $row->option_value;
			if( $value == false ) {
				wp_cache_set($key, 'falsevalue', 'site-options');
				return false;
			} else {
				wp_cache_set($key, $value, 'site-options');
			}
		} else { // option does not exist, so we must cache its non-existence
			wp_cache_set($key, 'noop', 'site-options');
		}
	} elseif( $value == 'noop' ) {
		return false;
	} elseif( $value == 'falsevalue' ) {
		return false;
	}
	// If home is not set use siteurl.
	if ( 'home' == $setting && '' == $value )
		return get_blog_option($blog_id, 'siteurl');

	if ( 'siteurl' == $setting || 'home' == $setting || 'category_base' == $setting )
		$value = preg_replace('|/+$|', '', $value);

	if (! unserialize($value) )
		$value = stripslashes( $value );

	return apply_filters( 'option_' . $setting, maybe_unserialize($value) );
}

function add_blog_option( $id, $key, $value ) {
	switch_to_blog($id);
	add_option( $key, $value );
	restore_current_blog();
	$opt = $id."-".$key."-blog_option";
	wp_cache_set($opt, $value, 'site-options');
}

function delete_blog_option( $id, $key ) {
	switch_to_blog($id);
	delete_option( $key );
	restore_current_blog();
	$opt = $id."-".$key."-blog_option";
	wp_cache_set($opt, '', 'site-options');
}

function update_blog_option( $id, $key, $value, $refresh = true ) {
	switch_to_blog($id);
	$opt = update_option( $key, $value );
	restore_current_blog();
	if( $refresh == true )
		refresh_blog_details( $id );
	$opt = $id."-".$key."-blog_option";
	wp_cache_set($opt, $value, 'site-options');
}

function switch_to_blog( $new_blog ) {
	global $tmpoldblogdetails, $wpdb, $table_prefix, $blog_id, $switched, $switched_stack, $wp_roles, $current_user;

	if ( empty($new_blog) )
		$new_blog = $blog_id;

	if ( empty($switched_stack) )
		$switched_stack = array();

	$switched_stack[] = $blog_id;

	// backup
	$tmpoldblogdetails['blogid']         = $wpdb->blogid;
	$tmpoldblogdetails['posts']          = $wpdb->posts;
	$tmpoldblogdetails['categories']     = $wpdb->categories;
	$tmpoldblogdetails['post2cat']       = $wpdb->post2cat;
	$tmpoldblogdetails['comments']       = $wpdb->comments;
	$tmpoldblogdetails['links']          = $wpdb->links;
	$tmpoldblogdetails['link2cat']       = $wpdb->link2cat;
	$tmpoldblogdetails['linkcategories'] = $wpdb->linkcategories;
	$tmpoldblogdetails['options']        = $wpdb->options;
	$tmpoldblogdetails['postmeta']       = $wpdb->postmeta;
	$tmpoldblogdetails['terms']          = $wpdb->terms;
	$tmpoldblogdetails['term_taxonomy']  = $wpdb->term_taxonomy;
	$tmpoldblogdetails['term_relationships'] = $wpdb->term_relationships;
	$tmpoldblogdetails['prefix']         = $wpdb->prefix;
	$tmpoldblogdetails['table_prefix']   = $table_prefix;
	$tmpoldblogdetails['blog_id']        = $blog_id;

	// fix the new prefix.
	$table_prefix = $wpdb->base_prefix . $new_blog . "_";
	$wpdb->prefix			= $table_prefix;
	$wpdb->blogid           = $new_blog;
	$wpdb->posts            = $table_prefix . 'posts';
	$wpdb->categories       = $table_prefix . 'categories';
	$wpdb->post2cat         = $table_prefix . 'post2cat';
	$wpdb->comments         = $table_prefix . 'comments';
	$wpdb->links            = $table_prefix . 'links';
	$wpdb->link2cat         = $table_prefix . 'link2cat';
	$wpdb->linkcategories   = $table_prefix . 'linkcategories';
	$wpdb->options          = $table_prefix . 'options';
	$wpdb->postmeta         = $table_prefix . 'postmeta';
	$wpdb->terms            = $table_prefix . 'terms';
	$wpdb->term_taxonomy    = $table_prefix . 'term_taxonomy';
	$wpdb->term_relationships = $table_prefix . 'term_relationships';
	$blog_id = $new_blog;

	if( is_object( $wp_roles ) ) {
		$wpdb->hide_errors();
		$wp_roles->_init();
		$wpdb->show_errors();
	}
	if ( is_object( $current_user ) ) {
		$current_user->_init_caps();
	}

	do_action('switch_blog', $blog_id, $tmpoldblogdetails['blog_id']);
	$switched = true;
}

function restore_current_blog() {
	global $table_prefix, $tmpoldblogdetails, $wpdb, $blog_id, $switched, $switched_stack, $wp_roles, $current_user;

	if ( !$switched )
		return;

	$blog = array_pop($switched_stack);

	if ( $blog_id == $blog )
		return;

	// backup
	$wpdb->blogid = $tmpoldblogdetails['blogid'];
	$wpdb->posts = $tmpoldblogdetails['posts'];
	$wpdb->categories = $tmpoldblogdetails['categories'];
	$wpdb->post2cat = $tmpoldblogdetails['post2cat'];
	$wpdb->comments = $tmpoldblogdetails['comments'];
	$wpdb->links = $tmpoldblogdetails['links'];
	$wpdb->link2cat = $tmpoldblogdetails['link2cat'];
	$wpdb->linkcategories = $tmpoldblogdetails['linkcategories'];
	$wpdb->options = $tmpoldblogdetails['options'];
	$wpdb->postmeta = $tmpoldblogdetails['postmeta'];
	$wpdb->terms = $tmpoldblogdetails['terms'];
	$wpdb->term_taxonomy = $tmpoldblogdetails['term_taxonomy'];
	$wpdb->term_relationships = $tmpoldblogdetails['term_relationships'];
	$wpdb->prefix = $tmpoldblogdetails['prefix'];
	$table_prefix = $tmpoldblogdetails['table_prefix'];
	$prev_blog_id = $blog_id;
	$blog_id = $tmpoldblogdetails['blog_id'];
	unset( $tmpoldblogdetails );

	if( is_object( $wp_roles ) ) {
		$wpdb->hide_errors();
		$wp_roles->_init();
		$wpdb->show_errors();
	}
	if ( is_object( $current_user ) ) {
		$current_user->_init_caps();
	}
	do_action('switch_blog', $blog_id, $prev_blog_id);

	$switched = false;
}

function get_blogs_of_user( $id, $all = false ) {
	global $wpdb;

	$user = get_userdata( $id );
	if ( !$user )
		return false;

	$blogs = array();

	$i = 0;
	foreach ( (array) $user as $key => $value ) {
		if ( strstr( $key, '_capabilities') && strstr( $key, 'wp_') ) {
			preg_match('/' . $wpdb->base_prefix . '(\d+)_capabilities/', $key, $match);
			$blog = get_blog_details( $match[1] );
			if ( $blog && isset( $blog->domain ) && ( $all == true || $all == false && ( $blog->archived == 0 && $blog->spam == 0 && $blog->deleted == 0 ) ) ) {
				$blogs[$match[1]]->userblog_id = $match[1];
				$blogs[$match[1]]->blogname    = $blog->blogname;
				$blogs[$match[1]]->domain      = $blog->domain;
				$blogs[$match[1]]->path        = $blog->path;
				$blogs[$match[1]]->site_id     = $blog->site_id;
				$blogs[$match[1]]->siteurl     = $blog->siteurl;
			}
		}
	}

	return $blogs;
}

function get_active_blog_for_user( $user_id ) { // get an active blog for user - either primary blog or from blogs list
	$primary_blog = get_usermeta( $user_id, "primary_blog" );
	if( $primary_blog == false ) {
		$details = false;
	} else {
		$details = get_blog_details( $primary_blog );
	}

	if( ( is_object( $details ) == false ) || ( is_object( $details ) && $details->archived == 1 || $details->spam == 1 || $details->deleted == 1 ) ) {
		$blogs = get_blogs_of_user( $user_id, true ); // if a user's primary blog is shut down, check their other blogs.
		$ret = false;
		if( is_array( $blogs ) && count( $blogs ) > 0 ) {
			foreach( (array) $blogs as $blog_id => $blog ) {
				$details = get_blog_details( $blog_id );
				if( is_object( $details ) && $details->archived == 0 && $details->spam == 0 && $details->deleted == 0 ) {
					$ret = $blog;
					break;
				}
			}
		} else {
			$ret = "username only"; // user has no blogs. We can add details for dashboard.wordpress.com here.
		}
		return $ret;
	} else {
		return $details;
	}
}

function is_user_member_of_blog( $user_id, $blog_id = 0 ) {
	global $wpdb;
	if( $blog_id == 0 )
		$blog_id = $wpdb->blogid;

	$blogs = get_blogs_of_user( $user_id );
	if( is_array( $blogs ) ) {
		return array_key_exists( $blog_id, $blogs );
	} else {
		return false;
	}
}

function is_archived( $id ) {
	return get_blog_status($id, 'archived');
}

function update_archived( $id, $archived ) {
	update_blog_status($id, 'archived', $archived);
	return $archived;
}

function update_blog_status( $id, $pref, $value, $refresh = 1 ) {
	global $wpdb;

	$wpdb->query( "UPDATE {$wpdb->blogs} SET {$pref} = '{$value}', last_updated = NOW() WHERE blog_id = '$id'" );

	if( $refresh == 1 )
		refresh_blog_details($id);

	if( $pref == 'spam' ) {
		if( $value == 1 ) {
			do_action( "make_spam_blog", $id );
		} else {
			do_action( "make_ham_blog", $id );
		}
	}

	return $value;
}

function get_blog_status( $id, $pref ) {
	global $wpdb;

	$details = get_blog_details( $id, false );
	if( $details ) {
		return $details->$pref;
	}
	return $wpdb->get_var( "SELECT $pref FROM {$wpdb->blogs} WHERE blog_id = '$id'" );
}

function get_last_updated( $display = false ) {
	global $wpdb;
	return $wpdb->get_results( "SELECT blog_id, domain, path FROM $wpdb->blogs WHERE site_id = '$wpdb->siteid' AND public = '1' AND archived = '0' AND mature = '0' AND spam = '0' AND deleted = '0' AND last_updated != '0000-00-00 00:00:00' ORDER BY last_updated DESC limit 0,40", ARRAY_A );
}

function get_most_active_blogs( $num = 10, $display = true ) {
	global $wpdb;
	$most_active = get_site_option( "most_active" );
	$update = false;
	if( is_array( $most_active ) ) {
		if( ( $most_active['time'] + 60 ) < time() ) { // cache for 60 seconds.
			$update = true;
		}
	} else {
		$update = true;
	}

	if( $update == true ) {
		unset( $most_active );
		$blogs = get_blog_list( 0, 'all', false ); // $blog_id -> $details
		if( is_array( $blogs ) ) {
			reset( $blogs );
			foreach ( (array) $blogs as $key => $details ) {
				$most_active[ $details['blog_id'] ] = $details['postcount'];
				$blog_list[ $details['blog_id'] ] = $details; // array_slice() removes keys!!
			}
			arsort( $most_active );
			reset( $most_active );
			foreach ( (array) $most_active as $key => $details ) {
				$t[ $key ] = $blog_list[ $key ];
			}
			unset( $most_active );
			$most_active = $t;
		}
		update_site_option( "most_active", $most_active );
	}

	if( $display == true ) {
		if( is_array( $most_active ) ) {
			reset( $most_active );
			foreach ( (array) $most_active as $key => $details ) {
				$url = "http://" . $details['domain'] . $details['path'];
				echo "<li>" . $details['postcount'] . " <a href='$url'>$url</a></li>";
			}
		}
	}
	return array_slice( $most_active, 0, $num );
}

function get_blog_list( $start = 0, $num = 10, $display = true ) {
	global $wpdb;

	$blogs = get_site_option( "blog_list" );
	$update = false;
	if( is_array( $blogs ) ) {
		if( ( $blogs['time'] + 60 ) < time() ) { // cache for 60 seconds.
			$update = true;
		}
	} else {
		$update = true;
	}

	if( $update == true ) {
		unset( $blogs );
		$blogs = $wpdb->get_results( "SELECT blog_id, domain, path FROM $wpdb->blogs WHERE site_id = '$wpdb->siteid' AND public = '1' AND archived = '0' AND mature = '0' AND spam = '0' AND deleted = '0' ORDER BY registered DESC", ARRAY_A );

		foreach ( (array) $blogs as $key => $details ) {
			$blog_list[ $details['blog_id'] ] = $details;
			$blog_list[ $details['blog_id'] ]['postcount'] = $wpdb->get_var( "SELECT count(*) FROM " . $wpdb->base_prefix . $details['blog_id'] . "_posts WHERE post_status='publish' AND post_type='post'" );
		}
		unset( $blogs );
		$blogs = $blog_list;
		update_site_option( "blog_list", $blogs );
	}

	if( $num == 'all' ) {
		return array_slice( $blogs, $start, count( $blogs ) );
	} else {
		return array_slice( $blogs, $start, $num );
	}
}

function get_blog_count( $id = 0 ) {
	global $wpdb;

	if( $id == 0 )
		$id = $wpdb->siteid;

	$count_ts = get_site_option( "blog_count_ts" );
	if( time() - $count_ts > 3600 ) {
		$count = $wpdb->get_var( "SELECT count(*) as c FROM $wpdb->blogs WHERE site_id = '$id' AND spam='0' AND deleted='0' and archived='0'" );
		update_site_option( "blog_count", $count );
		update_site_option( "blog_count_ts", time() );
	}

	$count = get_site_option( "blog_count" );

	return $count;
}

function get_blog_post( $blog_id, $post_id ) {
	global $wpdb;

	$key = $blog_id."-".$post_id."-blog_post";
	$post = wp_cache_get( $key, "site-options" );
	if( $post == false ) {
		$post = $wpdb->get_row( "SELECT * FROM {$wpdb->base_prefix}{$blog_id}_posts WHERE ID = '{$post_id}'" );
		wp_cache_add( $key, $post, "site-options", 120 );
	}

	return $post;

}

function add_user_to_blog( $blog_id, $user_id, $role ) {
	switch_to_blog($blog_id);

	$user = new WP_User($user_id);

	if ( empty($user) )
		return new WP_Error('user_does_not_exist', __('That user does not exist.'));

	if ( !get_usermeta($user_id, 'primary_blog') ) {
		update_usermeta($user_id, 'primary_blog', $blog_id);
		$details = get_blog_details($blog_id);
		update_usermeta($user_id, 'source_domain', $details->domain);
	}

	$user->set_role($role);

	do_action('add_user_to_blog', $user_id, $role, $blog_id);
	wp_cache_delete( $user_id, 'users' );
	restore_current_blog();
}

function remove_user_from_blog($user_id, $blog_id = '') {
	global $wpdb;

	switch_to_blog($blog_id);

	$user_id = (int) $user_id;

	do_action('remove_user_from_blog', $user_id, $blog_id);

	// If being removed from the primary blog, set a new primary if the user is assigned
	// to multiple blogs.
	$primary_blog = get_usermeta($user_id, 'primary_blog');
	if ( $primary_blog == $blog_id ) {
		$new_id = '';
		$new_domain = '';
		$blogs = get_blogs_of_user($user_id);
		foreach ( (array) $blogs as $blog ) {
			if ( $blog->userblog_id == $blog_id )
				continue;
			$new_id = $blog->userblog_id;
			$new_domain = $blog->domain;
			break;
		}

		update_usermeta($user_id, 'primary_blog', $new_id);
		update_usermeta($user_id, 'source_domain', $new_domain);
	}

	wp_revoke_user($user_id);

	$blogs = get_blogs_of_user($user_id);
	if ( count($blogs) == 0 ) {
		update_usermeta($user_id, 'primary_blog', '');
		update_usermeta($user_id, 'source_domain', '');
	}

	restore_current_blog();
}

function create_empty_blog( $domain, $path, $weblog_title, $site_id = 1 ) {
	global $wpdb;

	$domain       = addslashes( $domain );
	$weblog_title = addslashes( $weblog_title );

	if( empty($path) )
		$path = '/';

	// Check if the domain has been used already. We should return an error message.
	if ( domain_exists($domain, $path, $site_id) )
		return __('error: Blog URL already taken.');

	// Need to backup wpdb table names, and create a new wp_blogs entry for new blog.
	// Need to get blog_id from wp_blogs, and create new table names.
	// Must restore table names at the end of function.

	if ( ! $blog_id = insert_blog($domain, $path, $site_id) )
		return __('error: problem creating blog entry');

	switch_to_blog($blog_id);
	install_blog($blog_id);
	restore_current_blog();

	return true;
}

function get_blog_permalink( $blog_id, $post_id ) {
	$key = "{$blog_id}-{$post_id}-blog_permalink";
	$link = wp_cache_get( $key, 'site-options' );
	if( $link == false ) {
		switch_to_blog( $blog_id );
		$link = get_permalink( $post_id );
		restore_current_blog();
		wp_cache_add( $key, $link, "site-options", 30 );
	}
	return $link;
}

// wpmu admin functions

function wpmu_admin_do_redirect( $url = '' ) {
	$ref = '';
	if ( isset( $_GET['ref'] ) )
		$ref = $_GET['ref'];
	if ( isset( $_POST['ref'] ) )
		$ref = $_POST['ref'];
	
	if( $ref ) {
		$ref = wpmu_admin_redirect_add_updated_param( $ref );
		wp_redirect( $ref );
		die();
	}
	if( empty( $_SERVER['HTTP_REFERER'] ) == false ) {
		wp_redirect( $_SERVER['HTTP_REFERER'] );
		die();
	}

	$url = wpmu_admin_redirect_add_updated_param( $url );
	if( isset( $_GET['redirect'] ) ) {
		if( substr( $_GET['redirect'], 0, 2 ) == 's_' ) {
			$url .= "&action=blogs&s=". wp_specialchars( substr( $_GET['redirect'], 2 ) );
		}
	} elseif( isset( $_POST['redirect'] ) ) {
		$url = wpmu_admin_redirect_add_updated_param( $_POST['redirect'] );
	}
	wp_redirect( $url );
	die();
}

function wpmu_admin_redirect_add_updated_param( $url = '' ) {
	if( strpos( $url, 'updated=true' ) === false ) {
		if( strpos( $url, '?' ) === false ) {
			return $url . '?updated=true';
		} else {
			return $url . '&updated=true';
		}
	}
	return $url;
}

function wpmu_admin_redirect_url() {
	if( isset( $_GET['s'] ) ) {
		return "s_".$_GET['s'];
	}
}

function is_blog_user( $blog_id = 0 ) {
	global $current_user, $wpdb;

	if ( !$blog_id )
		$blog_id = $wpdb->blogid;

	$cap_key = $wpdb->base_prefix . $blog_id . '_capabilities';

	if ( is_array($current_user->$cap_key) && in_array(1, $current_user->$cap_key) )
		return true;

	return false;
}

function validate_email( $email, $check_domain = true) {
    if (ereg('^[-!#$%&\'*+\\./0-9=?A-Z^_`a-z{|}~]+'.'@'.
        '[-!#$%&\'*+\\/0-9=?A-Z^_`a-z{|}~]+\.'.
        '[-!#$%&\'*+\\./0-9=?A-Z^_`a-z{|}~]+$', $email))
    {
        if ($check_domain && function_exists('checkdnsrr')) {
            list (, $domain)  = explode('@', $email);

            if (checkdnsrr($domain.'.', 'MX') || checkdnsrr($domain.'.', 'A')) {
                return true;
            }
            return false;
        }
        return true;
    }
    return false;
}

function is_email_address_unsafe( $user_email ) {
	$banned_names = get_site_option( "banned_email_domains" );
	if ( is_array( $banned_names ) && empty( $banned_names ) == false ) {
		$email_domain = strtolower( substr( $user_email, 1 + strpos( $user_email, '@' ) ) );
		foreach( (array) $banned_names as $banned_domain ) {
			if( $banned_domain == '' )
				continue;
			if (
				strstr( $email_domain, $banned_domain ) ||
				(
					strstr( $banned_domain, '/' ) &&
					preg_match( $banned_domain, $email_domain )
				)
			) 
			return true;
		}
	}
	return false;
}

function wpmu_validate_user_signup($user_name, $user_email) {
	global $wpdb, $current_site;

	$errors = new WP_Error();

	$user_name = sanitize_user($user_name);
	$user_email = sanitize_email( $user_email );

	if ( empty( $user_name ) )
	   	$errors->add('user_name', __("Please enter a username"));

	preg_match( "/[a-z0-9]+/", $user_name, $maybe );

	if( $user_name != $maybe[0] ) {
	    $errors->add('user_name', __("Only lowercase letters and numbers allowed"));
	}

	$illegal_names = get_site_option( "illegal_names" );
	if( is_array( $illegal_names ) == false ) {
		$illegal_names = array(  "www", "web", "root", "admin", "main", "invite", "administrator" );
		add_site_option( "illegal_names", $illegal_names );
	}
	if( in_array( $user_name, $illegal_names ) == true ) {
	    $errors->add('user_name',  __("That username is not allowed"));
	}

	if( is_email_address_unsafe( $user_email ) ) 
		$errors->add('user_email',  __("You cannot use that email address to signup. We are having problems with them blocking some of our email. Please use another email provider."));

	if( strlen( $user_name ) < 4 ) {
	    $errors->add('user_name',  __("Username must be at least 4 characters"));
	}

	if ( strpos( " " . $user_name, "_" ) != false )
		$errors->add('user_name', __("Sorry, usernames may not contain the character '_'!"));

	// all numeric?
	preg_match( '/[0-9]*/', $user_name, $match );
	if ( $match[0] == $user_name )
		$errors->add('user_name', __("Sorry, usernames must have letters too!"));

	if ( !is_email( $user_email ) )
	    $errors->add('user_email', __("Please enter a correct email address"));

	if ( !validate_email( $user_email ) )
		$errors->add('user_email', __("Please check your email address."));

	$limited_email_domains = get_site_option( 'limited_email_domains' );
	if ( is_array( $limited_email_domains ) && empty( $limited_email_domains ) == false ) {
		$emaildomain = substr( $user_email, 1 + strpos( $user_email, '@' ) );
		if( in_array( $emaildomain, $limited_email_domains ) == false ) {
			$errors->add('user_email', __("Sorry, that email address is not allowed!"));
		}
	}

	// Check if the username has been used already.
	if ( username_exists($user_name) )
		$errors->add('user_name', __("Sorry, that username already exists!"));

	// Check if the email address has been used already.
	if ( email_exists($user_email) )
		$errors->add('user_email', __("Sorry, that email address is already used!"));

	// Has someone already signed up for this username?
	$signup = $wpdb->get_row("SELECT * FROM $wpdb->signups WHERE user_login = '$user_name'");
	if ( $signup != null ) {
		$registered_at =  mysql2date('U', $signup->registered);
		$now = current_time( 'timestamp', true );
		$diff = $now - $registered_at;
		// If registered more than two days ago, cancel registration and let this signup go through.
		if ( $diff > 172800 ) {
			$wpdb->query("DELETE FROM $wpdb->signups WHERE user_login = '$user_name'");
		} else {
			$errors->add('user_name', __("That username is currently reserved but may be available in a couple of days."));
		}
		if( $signup->active == 0 && $signup->user_email == $user_email )
			$errors->add('user_email_used', __("username and email used"));
	}

	$signup = $wpdb->get_row("SELECT * FROM $wpdb->signups WHERE user_email = '$user_email'");
	if ( $signup != null ) {
		$registered_at =  mysql2date('U', $signup->registered);
		$now = current_time( 'timestamp', true );
		$diff = $now - $registered_at;
		// If registered more than two days ago, cancel registration and let this signup go through.
		if ( $diff > 172800 ) {
			$wpdb->query("DELETE FROM $wpdb->signups WHERE user_email = '$user_email'");
		} else {
			$errors->add('user_email', __("That email address has already been used. Please check your inbox for an activation email. It will become available in a couple of days if you do nothing."));
		}
	}

	$result = array('user_name' => $user_name, 'user_email' => $user_email,	'errors' => $errors);

	return apply_filters('wpmu_validate_user_signup', $result);
}

function wpmu_validate_blog_signup($blog_id, $blog_title, $user = '') {
	global $wpdb, $domain, $base;

	$blog_id = sanitize_user( $blog_id );
	$blog_title = strip_tags( $blog_title );
	$blog_title = substr( $blog_title, 0, 50 );

	$errors = new WP_Error();
	$illegal_names = get_site_option( "illegal_names" );
	if( $illegal_names == false ) {
	    $illegal_names = array( "www", "web", "root", "admin", "main", "invite", "administrator" );
	    add_site_option( "illegal_names", $illegal_names );
	}

	if ( empty( $blog_id ) )
	    $errors->add('blog_id', __("Please enter a blog name"));

	preg_match( "/[a-z0-9]+/", $blog_id, $maybe );
	if( $blog_id != $maybe[0] ) {
	    $errors->add('blog_id', __("Only lowercase letters and numbers allowed"));
	}
	if( in_array( $blog_id, $illegal_names ) == true ) {
	    $errors->add('blog_id',  __("That name is not allowed"));
	}
	if( strlen( $blog_id ) < 4 && !is_site_admin() ) {
	    $errors->add('blog_id',  __("Blog name must be at least 4 characters"));
	}

	if ( strpos( " " . $blog_id, "_" ) != false )
		$errors->add('blog_id', __("Sorry, blog names may not contain the character '_'!"));

	// all numeric?
	preg_match( '/[0-9]*/', $blog_id, $match );
	if ( $match[0] == $blog_id )
		$errors->add('blog_id', __("Sorry, blog names must have letters too!"));

	$blog_id = apply_filters( "newblog_id", $blog_id );

	$blog_title = stripslashes(  $blog_title );

	if ( empty( $blog_title ) )
	    $errors->add('blog_title', __("Please enter a blog title"));

	// Check if the domain/path has been used already.
	if( constant( "VHOST" ) == 'yes' ) {
		$mydomain = "$blog_id.$domain";
		$path = $base;
	} else {
		$mydomain = "$domain";
		$path = $base.$blog_id.'/';
	}
	if ( domain_exists($mydomain, $path) )
		$errors->add('blog_id', __("Sorry, that blog already exists!"));

	if ( username_exists($blog_id) ) {
		if  ( !is_object($user) && ( $user->user_login != $blog_id ) )
			$errors->add('blog_id', __("Sorry, that blog is reserved!"));
	}

	// Has someone already signed up for this domain?
	// TODO: Check email too?
	$signup = $wpdb->get_row("SELECT * FROM $wpdb->signups WHERE domain = '$mydomain' AND path = '$path'");
	if ( ! empty($signup) ) {
		$registered_at =  mysql2date('U', $signup->registered);
		$now = current_time( 'timestamp', true );
		$diff = $now - $registered_at;
		// If registered more than two days ago, cancel registration and let this signup go through.
		if ( $diff > 172800 ) {
			$wpdb->query("DELETE FROM $wpdb->signups WHERE domain = '$mydomain' AND path = '$path'");
		} else {
			$errors->add('blog_id', __("That blog is currently reserved but may be available in a couple days."));
		}
	}

	$result = array('domain' => $mydomain, 'path' => $path, 'blog_id' => $blog_id, 'blog_title' => $blog_title,
				'errors' => $errors);

	return apply_filters('wpmu_validate_blog_signup', $result);
}

// Record signup information for future activation. wpmu_validate_signup() should be run
// on the inputs before calling wpmu_signup().
function wpmu_signup_blog($domain, $path, $title, $user, $user_email, $meta = '') {
	global $wpdb;

	$key = substr( md5( time() . rand() . $domain ), 0, 16 );
	$registered = current_time('mysql', true);
	$meta = serialize($meta);
	$domain = $wpdb->escape($domain);
	$path = $wpdb->escape($path);
	$title = $wpdb->escape($title);
	$wpdb->query( "INSERT INTO $wpdb->signups ( domain, path, title, user_login, user_email, registered, activation_key, meta )
					VALUES ( '$domain', '$path', '$title', '$user', '$user_email', '$registered', '$key', '$meta' )" );

	wpmu_signup_blog_notification($domain, $path, $title, $user, $user_email, $key, $meta);
}

function wpmu_signup_user($user, $user_email, $meta = '') {
	global $wpdb;

	$user = sanitize_user( $user );
	$user_email = sanitize_email( $user_email );

	$key = substr( md5( time() . rand() . $user_email ), 0, 16 );
	$registered = current_time('mysql', true);
	$meta = serialize($meta);
	$wpdb->query( "INSERT INTO $wpdb->signups ( domain, path, title, user_login, user_email, registered, activation_key, meta )
					VALUES ( '', '', '', '$user', '$user_email', '$registered', '$key', '$meta' )" );

	wpmu_signup_user_notification($user, $user_email, $key, $meta);
}

// Notify user of signup success.
function wpmu_signup_blog_notification($domain, $path, $title, $user, $user_email, $key, $meta = '') {
	global $current_site;
	// Send email with activation link.
	if( constant( "VHOST" ) == 'no' ) {
		$activate_url = "http://" . $current_site->domain . $current_site->path . "wp-activate.php?key=$key";
	} else {
		$activate_url = "http://{$domain}{$path}wp-activate.php?key=$key";
	}
	$admin_email = get_site_option( "admin_email" );
	if( $admin_email == '' )
		$admin_email = 'support@' . $_SERVER['SERVER_NAME'];
	$from_name = get_site_option( "site_name" ) == '' ? 'WordPress' : wp_specialchars( get_site_option( "site_name" ) );
	$message_headers = "MIME-Version: 1.0\n" . "From: \"{$from_name}\" <{$admin_email}>\n" . "Content-Type: text/plain; charset=\"" . get_option('blog_charset') . "\"\n";
	$message = sprintf(__("To activate your blog, please click the following link:\n\n%s\n\nAfter you activate, you will receive *another email* with your login.\n\nAfter you activate, you can visit your blog here:\n\n%s"), $activate_url, "http://{$domain}{$path}");
	// TODO: Don't hard code activation link.
	$subject = '[' . $from_name . '] ' . sprintf(__('Activate %s'), 'http://' . $domain . $path);
	wp_mail($user_email, $subject, $message, $message_headers);
}

function wpmu_signup_user_notification($user, $user_email, $key, $meta = '') {
	global $current_site;
	// Send email with activation link.
	$admin_email = get_site_option( "admin_email" );
	if( $admin_email == '' )
		$admin_email = 'support@' . $_SERVER['SERVER_NAME'];
	$from_name = get_site_option( "site_name" ) == '' ? 'WordPress' : wp_specialchars( get_site_option( "site_name" ) );
	$message_headers = "MIME-Version: 1.0\n" . "From: \"{$from_name}\" <{$admin_email}>\n" . "Content-Type: text/plain; charset=\"" . get_option('blog_charset') . "\"\n";
	$message = sprintf(__("To activate your user, please click the following link:\n\n%s\n\nAfter you activate, you will receive *another email* with your login.\n\n"), "http://{$current_site->domain}{$current_site->path}wp-activate.php?key=$key" );
	// TODO: Don't hard code activation link.
	$subject = sprintf(__('Activate %s'), $user);
	wp_mail($user_email, $subject, $message, $message_headers);
}

function wpmu_activate_signup($key) {
	global $wpdb;

	$result = array();
	$signup = $wpdb->get_row("SELECT * FROM $wpdb->signups WHERE activation_key = '$key'");

	if ( empty($signup) )
		return new WP_Error('invalid_key', __('Invalid activation key.'));

	if ( $signup->active )
		return new WP_Error('already_active', __('The blog is already active.'), $signup);

	$meta = unserialize($signup->meta);
	$user_login = $wpdb->escape($signup->user_login);
	$user_email = $wpdb->escape($signup->user_email);
	wpmu_validate_user_signup($user_login, $user_email);
	$password = generate_random_password();

	$user_id = username_exists($user_login);

	if ( ! $user_id )
		$user_id = wpmu_create_user($user_login, $password, $user_email);
	else
		$user_already_exists = true;

	if ( ! $user_id )
		return new WP_Error('create_user', __('Could not create user'), $signup);

	$now = current_time('mysql', true);

	if ( empty($signup->domain) ) {
		$wpdb->query("UPDATE $wpdb->signups SET active = '1', activated = '$now' WHERE activation_key = '$key'");
		if ( isset($user_already_exists) )
			return new WP_Error('user_already_exists', __('That username is already activated.'), $signup);
		wpmu_welcome_user_notification($user_id, $password, $meta);
		add_user_to_blog('1', $user_id, 'subscriber');
		do_action('wpmu_activate_user', $user_id, $password, $meta);
		return array('user_id' => $user_id, 'password' => $password, 'meta' => $meta);
	}

	wpmu_validate_blog_signup($signup->domain, $signup->title);
	$blog_id = wpmu_create_blog($signup->domain, $signup->path, $signup->title, $user_id, $meta);

	// TODO: What to do if we create a user but cannot create a blog?
	if ( is_wp_error($blog_id) ) {
		// If blog is taken, that means a previous attempt to activate this blog failed in between creating the blog and
		// setting the activation flag.  Let's just set the active flag and instruct the user to reset their password.
		if ( 'blog_taken' == $blog_id->get_error_code() ) {
			$blog_id->add_data($signup);
			$wpdb->query("UPDATE $wpdb->signups SET active = '1', activated = '$now' WHERE activation_key = '$key'");
			error_log("Blog $blog_id failed to complete activation.", 0);	
		}

		return $blog_id;
	}

	$wpdb->query("UPDATE $wpdb->signups SET active = '1', activated = '$now' WHERE activation_key = '$key'");

	wpmu_welcome_notification($blog_id, $user_id, $password, $signup->title, $meta);

	do_action('wpmu_activate_blog', $blog_id, $user_id, $password, $signup->title, $meta);

	return array('blog_id' => $blog_id, 'user_id' => $user_id, 'password' => $password, 'title' => $signup->title, 'meta' => $meta);
}

function generate_random_password( $len = 8 ) {
	$random_password = substr(md5(uniqid(microtime())), 0, intval( $len ) );
	$random_password = apply_filters('random_password', $random_password);
	return $random_password;
}

function wpmu_create_user( $user_name, $password, $email) {
	if ( username_exists($user_name) )
		return false;

	// Check if the email address has been used already.
	if ( email_exists($email) )
		return false;

	$user_id = wp_create_user( $user_name, $password, $email );
	$user = new WP_User($user_id);
	// Newly created users have no roles or caps until they are added to a blog.
	update_usermeta($user_id, 'capabilities', '');
	update_usermeta($user_id, 'user_level', '');

	do_action( 'wpmu_new_user', $user_id );

	return $user_id;
}

function wpmu_create_blog($domain, $path, $title, $user_id, $meta = '', $site_id = 1) {
	$domain = sanitize_user( $domain );
	$title = strip_tags( $title );
	$user_id = (int) $user_id;

	if( empty($path) )
		$path = '/';

	// Check if the domain has been used already. We should return an error message.
	if ( domain_exists($domain, $path, $site_id) )
		return new WP_Error('blog_taken', __('Blog already exists.'));

	if ( !defined("WP_INSTALLING") )
		define( "WP_INSTALLING", true );

	if ( ! $blog_id = insert_blog($domain, $path, $site_id) )
		return new WP_Error('insert_blog', __('Could not create blog.'));

	switch_to_blog($blog_id);

	install_blog($blog_id, $title);

	install_blog_defaults($blog_id, $user_id);

	add_user_to_blog($blog_id, $user_id, 'administrator');

	restore_current_blog();

	if ( is_array($meta) ) foreach ($meta as $key => $value) {
		update_blog_status( $blog_id, $key, $value );
		update_blog_option( $blog_id, $key, $value );
	}

	update_blog_option( $blog_id, 'blog_public', $meta['public'] );
	delete_blog_option( $blog_id, 'public' );

	if(get_usermeta( $user_id, 'primary_blog' ) == 1 )
		update_usermeta( $user_id, 'primary_blog', $blog_id );


	do_action( 'wpmu_new_blog', $blog_id, $user_id );

	return $blog_id;
}

function newblog_notify_siteadmin( $blog_id, $user_id ) {
	global $current_site;
	if( get_site_option( 'registrationnotification' ) != 'yes' )
		return;
	$email = get_site_option( 'admin_email' );
	if( is_email( $email ) == false )
		return false;
	$msg = "New Blog: " . get_blog_option( $blog_id, "blogname" ) . "\nURL: " . get_blog_option( $blog_id, "siteurl" ) . "\nRemote IP: {$_SERVER['REMOTE_ADDR']}\n\nDisable these notifications: http://{$current_site->domain}{$current_site->path}wp-admin/wpmu-options.php";
	$msg = apply_filters( 'newblog_notify_siteadmin', $msg );
	wp_mail( $email, "New Blog Registration: " . get_blog_option( $blog_id, "siteurl" ), $msg );
}
add_action( "wpmu_new_blog", "newblog_notify_siteadmin", 10, 2 );

function newuser_notify_siteadmin( $user_id ) {
	global $current_site;
	if( get_site_option( 'registrationnotification' ) != 'yes' )
		return;
	$email = get_site_option( 'admin_email' );
	if( is_email( $email ) == false )
		return false;
	$user = new WP_User($user_id);
	$msg = "New User: " . $user->user_login . "\nRemote IP: {$_SERVER['REMOTE_ADDR']}\n\nDisable these notifications: http://{$current_site->domain}{$current_site->path}wp-admin/wpmu-options.php";
	$msg = apply_filters( 'newuser_notify_siteadmin', $msg );
	wp_mail( $email, "New User Registration: " . $user->user_login, $msg );
}
add_action( "wpmu_new_user", "newuser_notify_siteadmin" );

function domain_exists($domain, $path, $site_id = 1) {
	global $wpdb;
	return $wpdb->get_var("SELECT blog_id FROM $wpdb->blogs WHERE domain = '$domain' AND path = '$path' AND site_id = '$site_id'" );
}

function insert_blog($domain, $path, $site_id) {
	global $wpdb;
	$path = trailingslashit( $path );
	$query = "INSERT INTO $wpdb->blogs ( blog_id, site_id, domain, path, registered ) VALUES ( NULL, '$site_id', '$domain', '$path', NOW( ))";
	$result = $wpdb->query( $query );
	if ( ! $result )
		return false;

	$id = $wpdb->insert_id;
	refresh_blog_details($id);
	return $id;
}

// Install an empty blog.  wpdb should already be switched.
function install_blog($blog_id, $blog_title = '') {
	global $wpdb, $table_prefix, $wp_roles;
	$wpdb->hide_errors();

	require_once( ABSPATH . 'wp-admin/includes/upgrade.php');
	$installed = $wpdb->get_results("SELECT * FROM $wpdb->posts");
	if ($installed) die(__('<h1>Already Installed</h1><p>You appear to have already installed WordPress. To reinstall please clear your old database tables first.</p>') . '</body></html>');

	$url = get_blogaddress_by_id($blog_id);
	error_log("install_blog - ID: $blog_id  URL: $url Title: $blog_title ", 0);

	// Set everything up
	make_db_current_silent();
	populate_options();
	populate_roles();
	$wp_roles->_init();
	// fix url.
	wp_cache_delete('notoptions', 'options');
	wp_cache_delete('alloptions', 'options');
	update_option('siteurl', $url);
	update_option('home', $url);
	update_option('fileupload_url', $url . "files" );
	update_option('upload_path', "wp-content/blogs.dir/" . $blog_id . "/files");
	update_option('blogname', $blog_title);

	$wpdb->query("UPDATE $wpdb->options SET option_value = '' WHERE option_name = 'admin_email'");

	// Default category
	$cat_name = $wpdb->escape(__('Uncategorized'));
	$cat_slug = sanitize_title(__('Uncategorized'));
	$wpdb->query("INSERT INTO $wpdb->terms (term_id, name, slug, term_group) VALUES ('1', '$cat_name', '$cat_slug', '0')");

	$wpdb->query("INSERT INTO $wpdb->term_taxonomy (term_id, taxonomy, description, parent, count) VALUES ('1', 'category', '', '0', '1')");

	// Default link category
	$cat_name = $wpdb->escape(__('Blogroll'));
	$cat_slug = sanitize_title(__('Blogroll'));
	$blogroll_id = $wpdb->get_var( "SELECT cat_ID FROM {$wpdb->sitecategories} WHERE category_nicename = '$cat_slug'" );
	if( $blogroll_id == null ) {
		$wpdb->query( "INSERT INTO " . $wpdb->sitecategories . " (cat_ID, cat_name, category_nicename, last_updated) VALUES (0, '$cat_name', '$cat_slug', NOW())" );
		$blogroll_id = $wpdb->insert_id;
	}
	$wpdb->query("INSERT INTO $wpdb->terms (term_id, name, slug, term_group) VALUES ('$blogroll_id', '$cat_name', '$cat_slug', '0')");
	$wpdb->query("INSERT INTO $wpdb->term_taxonomy (term_id, taxonomy, description, parent, count) VALUES ('$blogroll_id', 'link_category', '', '0', '2')");

	update_option('default_link_category', $blogroll_id);

	// remove all perms
	$wpdb->query( "DELETE FROM ".$wpdb->usermeta." WHERE meta_key = '".$table_prefix."user_level'" );
	$wpdb->query( "DELETE FROM ".$wpdb->usermeta." WHERE meta_key = '".$table_prefix."capabilities'" );

	$wpdb->show_errors();
}

function install_blog_defaults($blog_id, $user_id) {
	global $wpdb, $wp_rewrite, $current_site, $table_prefix;

	$wpdb->hide_errors();

	// Default links
	$wpdb->query("INSERT INTO $wpdb->links (link_url, link_name, link_category, link_owner, link_rss) VALUES ('http://wordpress.com/', 'WordPress.com', 1356, '$user_id', 'http://wordpress.com/feed/');");
	$wpdb->query("INSERT INTO $wpdb->links (link_url, link_name, link_category, link_owner, link_rss) VALUES ('http://wordpress.org/', 'WordPress.org', 1356, '$user_id', 'http://wordpress.org/development/feed/');");
	$wpdb->query( "INSERT INTO $wpdb->term_relationships (`object_id`, `term_taxonomy_id`) VALUES (1, 2)" );
	$wpdb->query( "INSERT INTO $wpdb->term_relationships (`object_id`, `term_taxonomy_id`) VALUES (2, 2)" );

	// First post
	$now = date('Y-m-d H:i:s');
	$now_gmt = gmdate('Y-m-d H:i:s');
	$first_post = get_site_option( 'first_post' );
	if( $first_post == false )
		$first_post = stripslashes( __( 'Welcome to <a href="SITE_URL">SITE_NAME</a>. This is your first post. Edit or delete it, then start blogging!' ) );

	$first_post = str_replace( "SITE_URL", "http://" . $current_site->domain . $current_site->path, $first_post );
	$first_post = str_replace( "SITE_NAME", $current_site->site_name, $first_post );
	$first_post = stripslashes( $first_post );

	$wpdb->query("INSERT INTO $wpdb->posts (post_author, post_date, post_date_gmt, post_content, post_title, post_category, post_name, post_modified, post_modified_gmt, comment_count) VALUES ('".$user_id."', '$now', '$now_gmt', '".addslashes($first_post)."', '".addslashes(__('Hello world!'))."', '0', '".addslashes(__('hello-world'))."', '$now', '$now_gmt', '1')");
	$wpdb->query( "INSERT INTO $wpdb->term_relationships (`object_id`, `term_taxonomy_id`) VALUES (1, 1)" );
	update_option( "post_count", 1 );

	// First page
	$wpdb->query("INSERT INTO $wpdb->posts (post_author, post_date, post_date_gmt, post_content, post_excerpt, post_title, post_category, post_name, post_modified, post_modified_gmt, post_status, post_type, to_ping, pinged, post_content_filtered) VALUES ('$user_id', '$now', '$now_gmt', '".$wpdb->escape(__('This is an example of a WordPress page, you could edit this to put information about yourself or your site so readers know where you are coming from. You can create as many pages like this one or sub-pages as you like and manage all of your content inside of WordPress.'))."', '', '".$wpdb->escape(__('About'))."', '0', '".$wpdb->escape(__('about'))."', '$now', '$now_gmt', 'publish', 'page', '', '', '')");
	// Flush rules to pick up the new page.
	$wp_rewrite->init();
	$wp_rewrite->flush_rules();

	// Default comment
	$wpdb->query("INSERT INTO $wpdb->comments (comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, comment_date, comment_date_gmt, comment_content) VALUES ('1', '".addslashes(__('Mr WordPress'))."', '', 'http://" . $current_site->domain . $current_site->path . "', '127.0.0.1', '$now', '$now_gmt', '".addslashes(__('Hi, this is a comment.<br />To delete a comment, just log in, and view the posts\' comments, there you will have the option to edit or delete them.'))."')");

	$user = new WP_User($user_id);
	$wpdb->query("UPDATE $wpdb->options SET option_value = '$user->user_email' WHERE option_name = 'admin_email'");

	// Remove all perms except for the login user.
	$wpdb->query( "DELETE FROM ".$wpdb->usermeta." WHERE  user_id != '".$user_id."' AND meta_key = '".$table_prefix."user_level'" );
	$wpdb->query( "DELETE FROM ".$wpdb->usermeta." WHERE  user_id != '".$user_id."' AND meta_key = '".$table_prefix."capabilities'" );
	// Delete any caps that snuck into the previously active blog. (Hardcoded to blog 1 for now.) TODO: Get previous_blog_id.
	if ( $user_id != 1 )
		$wpdb->query( "DELETE FROM ".$wpdb->usermeta." WHERE  user_id = '".$user_id."' AND meta_key = '" . $wpdb->base_prefix . "1_capabilities'" );

	$wpdb->show_errors();
}

function wpmu_welcome_notification($blog_id, $user_id, $password, $title, $meta = '') {
	global $current_site;

	$welcome_email = stripslashes( get_site_option( 'welcome_email' ) );
	if( $welcome_email == false )
		$welcome_email = stripslashes( __( "Dear User,

Your new SITE_NAME blog has been successfully set up at:
BLOG_URL

You can log in to the administrator account with the following information:
Username: USERNAME
Password: PASSWORD
Login Here: BLOG_URLwp-login.php

We hope you enjoy your new weblog.
Thanks!

--The WordPress Team
SITE_NAME" ) );

	$url = get_blogaddress_by_id($blog_id);
	$user = new WP_User($user_id);

	$welcome_email = str_replace( "SITE_NAME", $current_site->site_name, $welcome_email );
	$welcome_email = str_replace( "BLOG_URL", $url, $welcome_email );
	$welcome_email = str_replace( "USERNAME", $user->user_login, $welcome_email );
	$welcome_email = str_replace( "PASSWORD", $password, $welcome_email );

	$welcome_email = apply_filters( "update_welcome_email", $welcome_email, $blog_id, $user_id, $password, $title, $meta);
	$admin_email = get_site_option( "admin_email" );
	if( $admin_email == '' )
		$admin_email = 'support@' . $_SERVER['SERVER_NAME'];
	$from_name = get_site_option( "site_name" ) == '' ? 'WordPress' : wp_specialchars( get_site_option( "site_name" ) );
	$message_headers = "MIME-Version: 1.0\n" . "From: \"{$from_name}\" <{$admin_email}>\n" . "Content-Type: text/plain; charset=\"" . get_option('blog_charset') . "\"\n";
	$message = $welcome_email;
	if( empty( $current_site->site_name ) )
		$current_site->site_name = "WordPress MU";
	$subject = sprintf(__('New %1$s Blog: %2$s'), $current_site->site_name, $title);
	wp_mail($user->user_email, $subject, $message, $message_headers);
}

function wpmu_welcome_user_notification($user_id, $password, $meta = '') {
	global $current_site;

	$welcome_email = __( "Dear User,

Your new account is setup.

You can log in with the following information:
Username: USERNAME
Password: PASSWORD

Thanks!

--The WordPress Team
SITE_NAME" );

	$user = new WP_User($user_id);

	$welcome_email = apply_filters( "update_welcome_user_email", $welcome_email, $user_id, $password, $meta);
	$welcome_email = str_replace( "SITE_NAME", $current_site->site_name, $welcome_email );
	$welcome_email = str_replace( "USERNAME", $user->user_login, $welcome_email );
	$welcome_email = str_replace( "PASSWORD", $password, $welcome_email );

	$admin_email = get_site_option( "admin_email" );
	if( $admin_email == '' )
		$admin_email = 'support@' . $_SERVER['SERVER_NAME'];
	$from_name = get_site_option( "site_name" ) == '' ? 'WordPress' : wp_specialchars( get_site_option( "site_name" ) );
	$message_headers = "MIME-Version: 1.0\n" . "From: \"{$from_name}\" <{$admin_email}>\n" . "Content-Type: text/plain; charset=\"" . get_option('blog_charset') . "\"\n";
	$message = $welcome_email;
	if( empty( $current_site->site_name ) )
		$current_site->site_name = "WordPress MU";
	$subject = sprintf(__('New %1$s User: %2$s'), $current_site->site_name, $user->user_login);
	wp_mail($user->user_email, $subject, $message, $message_headers);
}

function get_current_site() {
	global $current_site;
	return $current_site;
}

function get_user_id_from_string( $string ) {
	global $wpdb;
	if( is_email( $string ) ) {
		$user_id = $wpdb->get_var( "SELECT ID FROM {$wpdb->users} WHERE user_email = '$string'" );
	} elseif ( is_numeric( $string ) ) {
		$user_id = $string;
	} else {
		$user_id = $wpdb->get_var( "SELECT ID FROM {$wpdb->users} WHERE user_login = '$string'" );
	}

	return $user_id;
}

function get_most_recent_post_of_user( $user_id ) {
	global $wpdb;

	$user_id = (int) $user_id;

	$user_blogs = get_blogs_of_user($user_id);
	$most_recent_post = array();

	// Walk through each blog and get the most recent post
	// published by $user_id
	foreach ( $user_blogs as $blog ) {
		$recent_post = $wpdb->get_row("SELECT ID, post_date_gmt FROM {$wpdb->base_prefix}{$blog->userblog_id}_posts WHERE post_author = '{$user_id}' AND post_type = 'post' AND post_status = 'publish' ORDER BY post_date_gmt DESC LIMIT 1", ARRAY_A);

		// Make sure we found a post
		if ( isset($recent_post['ID']) ) {
			$post_gmt_ts = strtotime($recent_post['post_date_gmt']);

			// If this is the first post checked or if this post is
			// newer than the current recent post, make it the new
			// most recent post.
			if (
				!isset($most_recent_post['post_gmt_ts'])
				|| ($post_gmt_ts > $most_recent_post['post_gmt_ts'])
			) {
				$most_recent_post = array(
					'blog_id'		=> $blog->userblog_id,
					'post_id'		=> $recent_post['ID'],
					'post_date_gmt'	=> $recent_post['post_date_gmt'],
					'post_gmt_ts'	=> $post_gmt_ts
				);
			}
		}
	}

	return $most_recent_post;
}

/* Misc functions */

function fix_upload_details( $uploads ) {
	$uploads['url'] = str_replace( UPLOADS, "files", $uploads['url'] );
	return $uploads;
}
add_filter( "upload_dir", "fix_upload_details" );


function get_dirsize($directory) {
	$size = 0;
	if(substr($directory,-1) == '/') $directory = substr($directory,0,-1);
	if(!file_exists($directory) || !is_dir($directory) || !is_readable($directory)) return false;
	if($handle = opendir($directory)) {
		while(($file = readdir($handle)) !== false) {
			$path = $directory.'/'.$file;
			if($file != '.' && $file != '..') {
				if(is_file($path)) {
					$size += filesize($path);
				} elseif(is_dir($path)) {
					$handlesize = get_dirsize($path);
					if($handlesize >= 0) {
						$size += $handlesize;
					} else {
						return false;
					}
				}
			}
		}
		closedir($handle);
	}
	return $size;
}

function upload_is_user_over_quota( $echo = true ) {
	global $wpdb;
	
	// Default space allowed is 10 MB 
	$spaceAllowed = get_space_allowed();
	if(empty($spaceAllowed) || !is_numeric($spaceAllowed)) $spaceAllowed = 10;
	
	$dirName = constant( "ABSPATH" ) . constant( "UPLOADS" );
	$size = get_dirsize($dirName) / 1024 / 1024;
	
	if( ($spaceAllowed-$size) < 0 ) { 
		if( $echo )
			_e( "Sorry, you have used your space allocation. Please delete some files to upload more files." ); //No space left
		return true;
	} else {
		return false;
	}
}
add_action( 'upload_files_upload', 'upload_is_user_over_quota' );
add_action( 'upload_files_browse', 'upload_is_user_over_quota' );
add_action( 'upload_files_browse-all', 'upload_is_user_over_quota' );

function check_upload_mimes($mimes) {
	$site_exts = explode( " ", get_site_option( "upload_filetypes" ) );
	foreach ( $site_exts as $ext )
		foreach ( $mimes as $ext_pattern => $mime )
			if ( preg_match("/$ext_pattern/", $ext) )
				$site_mimes[$ext_pattern] = $mime;
	return $site_mimes;
}
add_filter('upload_mimes', 'check_upload_mimes');

function update_posts_count( $post_id ) {
	global $wpdb;
	$post_id = intval( $post_id );
	$c = $wpdb->get_var( "SELECT count(*) FROM {$wpdb->posts} WHERE post_status = 'publish' and post_type='post'" );
	update_option( "post_count", $c );
}
add_action( "publish_post", "update_posts_count" );

function wpmu_log_new_registrations( $blog_id, $user_id ) {
	global $wpdb;
	$user = new WP_User($user_id);
	$email = $wpdb->escape($user->user_email);
	$IP = preg_replace( '/[^0-9., ]/', '',$_SERVER['REMOTE_ADDR'] );
	$wpdb->query( "INSERT INTO {$wpdb->registration_log} ( email , IP , blog_id, date_registered ) VALUES ( '{$email}', '{$IP}', '{$blog_id}', NOW( ))" );
}

add_action( "wpmu_new_blog" ,"wpmu_log_new_registrations", 10, 2 );

function scriptaculous_admin_loader() {
	        wp_enqueue_script('scriptaculous');
}
add_action( 'admin_print_scripts', 'scriptaculous_admin_loader' );

function fix_import_form_size( $size ) {
	if( upload_is_user_over_quota( false ) == false )
		return 0;
	$dirName = constant( "ABSPATH" ) . constant( "UPLOADS" );
	$dirsize = get_dirsize($dirName) / 1024;
	if( $size > $dirsize ) {
		return $dirsize;
	} else {
		return $size;
	}
}
add_filter( 'import_upload_size_limit', 'fix_import_form_size' );

if ( !function_exists('graceful_fail') ) :
function graceful_fail( $message ) {
	die('
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head profile="http://gmpg.org/xfn/11">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Error!</title>
<style type="text/css">
img {
	border: 0;
}
body {
line-height: 1.6em; font-family: Georgia, serif; width: 390px; margin: auto;
text-align: center;
}
.message {
	font-size: 22px;
	width: 350px;
	margin: auto;
}
</style>
</head>
<body>
<p class="message">' . $message . '</p>
</body>
</html>
	');
}
endif;

/* Delete blog */

class delete_blog {

	function delete_blog() {
		$this->reallydeleteblog = false;
		add_action('admin_menu', array(&$this, 'admin_menu'));
		add_action('admin_footer', array(&$this, 'admin_footer'));
	}

	function admin_footer() {
		global $wpdb;

		if( $this->reallydeleteblog == true ) {
			wpmu_delete_blog( $wpdb->blogid ); 
		}
	}

	function admin_menu() {
		add_submenu_page('options-general.php', __('Delete Blog'), __('Delete Blog'), 'manage_options', 'delete-blog', array(&$this, 'plugin_content'));
	}

	function plugin_content() {
		global $wpdb, $current_blog, $current_site;
		$this->delete_blog_hash = get_settings('delete_blog_hash');
		echo '<div class="wrap"><h2>' . __('Delete Blog') . '</h2>';
		if( $_POST['action'] == "deleteblog" && $_POST['confirmdelete'] == '1' ) {
			$hash = substr( md5( $_SERVER['REQUEST_URI'] . time() ), 0, 6 );
			update_option( "delete_blog_hash", $hash );
			$url_delete = get_option( "siteurl" ) . "/wp-admin/options-general.php?page=delete-blog&h=" . $hash;
			$msg = __("Dear User,
You recently clicked the 'Delete Blog' link on your blog and filled in a 
form on that page.
If you really want to delete your blog, click the link below. You will not
be asked to confirm again so only click this link if you are 100% certain:
URL_DELETE

If you delete your blog, please consider opening a new blog here
some time in the future! (But remember your current blog and username 
are gone forever.)

Thanks for using the site,
Webmaster
SITE_NAME
");
			$msg = str_replace( "URL_DELETE", $url_delete, $msg );
			$msg = str_replace( "SITE_NAME", $current_site->site_name, $msg );
			wp_mail( get_option( "admin_email" ), "[ " . get_option( "blogname" ) . " ] ".__("Delete My Blog"), $msg );
			?>
			<p><?php _e('Thank you. Please check your email for a link to confirm your action. Your blog will not be deleted until this link is clicked.') ?></p>
			<?php
		} elseif( isset( $_GET['h'] ) && $_GET['h'] != '' && get_option('delete_blog_hash') != false ) {
			if( get_option('delete_blog_hash') == $_GET['h'] ) {
				$this->reallydeleteblog = true;
				echo "<p>" . sprintf(__('Thank you for using %s, your blog has been deleted. Happy trails to you until we meet again.'), $current_site->site_name) . "</p>";
			} else {
				$this->reallydeleteblog = false;
				echo "<p>" . __("I'm sorry, the link you clicked is stale. Please select another option.") . "</p>";
			}
		} else {
?>
			<p><?php printf(__('If you do not want to use your %s blog any more, you can delete it using the form below. When you click <strong>Delete My Blog</strong> you will be sent an email with a link in it. Click on this link to delete your blog.'), $current_site->site_name); ?></p>
			<p><?php _e('Remember, once deleted your blog cannot be restored.') ?></p>
			<form method='post' name='deletedirect'>
			<input type="hidden" name="page" value="<?php echo $_GET['page'] ?>" />
			<input type='hidden' name='action' value='deleteblog' />
			<p><input id='confirmdelete' type='checkbox' name='confirmdelete' value='1' /> <label for='confirmdelete'><strong><?php printf( __("I'm sure I want to permanently disable my blog, and I am aware I can never get it back or use %s again."), $current_blog->domain); ?></strong></label></p>
			<p class="submit"><input type='submit' value='<?php _e('Delete My Blog Permanently &raquo;') ?>' /></p>
			</form>
<?php
		}
		echo "</div>";
	}
}

$delete_blog_obj = new delete_blog();

/* Dashboard Switcher */

add_action( 'admin_print_scripts', 'switcher_scripts' );

function switcher_scripts() {
	wp_enqueue_script('jquery');
}


function switcher_css() {
?>
<style type="text/css">
#switchermenu a {
	font-size: 20px;
	padding: 0 1.5em 0 10px;
	display: block;
	color: #c3def1;
}

#switchermenu a:hover {
	background: #1a70b4;
	color: #fff;
}

#switchermenu li {
	margin: 0;
	padding: 2px;
}

#switchermenu {
	display: none;
	list-style: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
	border-top: 1px solid #1a70b4;
	border-left: 1px solid #1a70b4;
	position: absolute;
	left: 0;
	top: 1em;
	background: #14568a;
	z-index: 1;
}
</style>
<script type="text/javascript">
jQuery( function($) {
var switchTime;
var w = false;
var h = $( '#blog-title' )
	.css({
		background: 'transparent url( ../wp-includes/images/bullet_arrow_down.gif ) no-repeat scroll 100% .2em',
		padding: '0 25px 2px 5px',
		cursor: 'pointer',
		border: '1px solid #14568a'
	})
	.parent().css( { position: 'relative' }).end()
	.append( $('#switchermenu') )
	.hover( function() {
		$(this).css({ border: '1px solid #1a70b4'});
		switchTime = window.setTimeout( function() {
			$('#switchermenu').fadeIn('fast').css( 'top', h ).find('a').width( w = w ? w : $('#switchermenu').width() );
		}, 300 );
	}, function() {
		window.clearTimeout( switchTime );
		$(this).css({ border: '1px solid #14568a' }) ;
		$('#switchermenu').hide();
	})
	.height() - 3;
});
</script>
<?php
}
add_action( "admin_head", "switcher_css" );

function add_switcher() {
	global $current_user;
	$out = '<h1><span id="blog-title">' . wptexturize(get_bloginfo(("name"))) . '</span><span id="viewsite">(<a href="' . get_option("home") . "/" . '">' . __("View site &raquo;") . '</a>)</span></h1>';
	$out .= '<ul id="switchermenu">';
	$blogs = get_blogs_of_user($current_user->ID);
	if ( ! empty($blogs) ) foreach ( $blogs as $blog ) {
		$out .= '<li><a href="http://' . $blog->domain . $blog->path . 'wp-admin/">' . addslashes( $blog->blogname ) . '</a></li>';
	}
	$out .= "</ul>";
	?>
	<script type="text/javascript">
	<!--
	document.getElementById('wphead').innerHTML = '<?php echo $out ?>'
	-->
	</script>
	<?php
}
add_action( 'admin_footer', 'add_switcher' );

/* Global Categories */

function global_terms( $term_id, $tt_id ) {
	global $wpdb;

	$term_id = intval( $term_id );
	$c = $wpdb->get_row( "SELECT * FROM $wpdb->terms WHERE term_id = '$term_id'" );

	$global_id = $wpdb->get_var( "SELECT cat_ID FROM $wpdb->sitecategories WHERE category_nicename = '" . $wpdb->escape( $c->slug ) . "'" );

	if ( $global_id == null ) {
		$wpdb->query( "INSERT INTO $wpdb->sitecategories ( cat_name, category_nicename ) VALUES ( '" . $wpdb->escape( $c->name ) . "', '" . $wpdb->escape( $c->slug ) . "' )" );
		$global_id = $wpdb->insert_id;
	}

	if ( $global_id == $term_id )
		return $global_id;

	$wpdb->query( "UPDATE $wpdb->terms SET term_id = '$global_id' WHERE term_id = '$term_id'" ); 
	$wpdb->query( "UPDATE $wpdb->term_taxonomy SET term_id = '$global_id' WHERE term_id = '$term_id'" );
	$wpdb->query( "UPDATE $wpdb->term_taxonomy SET parent = '$global_id' WHERE parent = '$term_id'" );

	$wpdb->query( "UPDATE $wpdb->categories SET cat_ID = '$global_id' WHERE cat_ID = '$term_id'" );
	$wpdb->query( "UPDATE $wpdb->categories SET category_parent = '$global_id' WHERE category_parent = '$term_id'" );

	clean_term_cache($global_id, 'category');
	clean_term_cache($global_id, 'post_tag');

	return $global_id; 
}   
add_filter( 'term_id_filter', 'global_terms', 10, 2 ); // taxonomy specific filter

/* WordPress MU Default Filters */
add_filter('the_title', 'wp_filter_kses');

function choose_primary_blog() {
	global $current_user;
	echo __('Primary Blog:') . ' ';
	$all_blogs = get_blogs_of_user( $current_user->ID );
	if( count( $all_blogs ) > 1 ) {
		$primary_blog = get_usermeta($current_user->ID, 'primary_blog');
		?>
		<p><select name="primary_blog">
			<?php foreach( (array) $all_blogs as $blog ) { ?>
				<option value='<?php echo $blog->userblog_id ?>'<?php if( $primary_blog == $blog->userblog_id ) echo ' selected="selected"' ?>>http://<?php echo $blog->domain.$blog->path ?></option>
			<?php } ?>
		</select></p><?php
	} else {
		echo $_SERVER['HTTP_HOST'];
	}       
}
add_action( 'profile_personal_options', 'choose_primary_blog' );

function redirect_this_site( $hosts ) {
	global $current_site;
	return array( $current_site->domain );
}
add_filter( 'allowed_redirect_hosts', 'redirect_this_site' );
?>

<?php
/*
***BETA BETA BETA BETA BETA BETA BETA BETA BETA BETA BETA BETA***
* This script will create and sync the new taxonomy tables in WordPress 2.3
* 
* Please only use this on a test server. You'll have to remove the comments 
* starting below this text and at the end of this file to activate it.
* 
* You should use this if your server is busy and/or you have many blogs.
* 
* To upgrade your blogs:
* 1. Open the front page of your site and add the string "?upgradetaxonomy=1"
*    to generate a secret key. You must use this key to run the global upgrade process.
* 2. Look in the site_options table of your database for the key. It's called "upgradetaxonomysecret".
* 3. Now, load the front page of your site again with the string "?upgradetaxonomy=<secretkey>"
* 4. Your blogs should upgrade, 10 at a time.
*
* How to force an upgrade:
* If you need to force the upgrade of a blog, open the blog and append "?taxonomysync=<secretkey>"
* where secretkey is the key from your site_options table.
*/

/*
$wpdb->terms = $wpdb->prefix . "terms";
$wpdb->term_taxonomy = $wpdb->prefix . "term_taxonomy";
$wpdb->term_relationships = $wpdb->prefix . "term_relationships";

function sync_link2cat( $link_id ) {
	global $wpdb;

	if ( get_option('db_version') != 6124 )
		return;
	
	if( function_exists( 'get_term' ) ) {
		$wpdb->query( "DELETE FROM {$wpdb->link2cat} WHERE link_id = '{$link_id}'" );
		$terms = $wpdb->get_results( "SELECT {$wpdb->term_taxonomy}.term_id FROM {$wpdb->term_taxonomy}, {$wpdb->term_relationships} WHERE {$wpdb->term_taxonomy}.term_taxonomy_id = {$wpdb->term_relationships}.term_taxonomy_id AND {$wpdb->term_relationships}.object_id = '{$link_id}' AND {$wpdb->term_taxonomy}.taxonomy = 'link_category'" );
		if( is_array( $terms ) )
			foreach( $terms as $term )
				$wpdb->query( "INSERT INTO {$wpdb->link2cat} ( `link_id`, `category_id` ) VALUES ( '$link_id', '{$term->term_id}' )" );

		return $link_id;
	}

	$cats = $wpdb->get_results( "SELECT category_id, category_description, category_parent, link_count FROM {$wpdb->link2cat}, {$wpdb->categories} WHERE {$wpdb->link2cat}.category_id = {$wpdb->categories}.cat_ID AND link_id = '{$link_id}'" );
	foreach( $cats as $cat ) {
		if ( !$wpdb->get_var( "SELECT term_taxonomy_id FROM $wpdb->term_taxonomy WHERE taxonomy = 'link_category' AND term_id = '{$cat->category_id}'" ) )
			$wpdb->query( "INSERT INTO $wpdb->term_taxonomy ( term_id, taxonomy, description, parent, count ) VALUES ( '{$cat->category_id}', 'link_category', '" . $wpdb->escape( $cat->category_description ) . "', '{$cat->category_parent}', '{$cat->link_count}' )" );
	}
	$terms = $wpdb->get_results( "SELECT {$wpdb->term_relationships}.object_id, {$wpdb->term_relationships}.term_taxonomy_id FROM {$wpdb->term_taxonomy}, {$wpdb->term_relationships} WHERE {$wpdb->term_taxonomy}.term_taxonomy_id = {$wpdb->term_relationships}.term_taxonomy_id AND {$wpdb->term_relationships}.object_id = '{$link_id}' AND {$wpdb->term_taxonomy}.taxonomy = 'link_category'" );
	if( is_array( $terms ) ) {
		foreach( $terms as $term ) {
			$wpdb->query( "DELETE FROM $wpdb->term_relationships WHERE object_id = '{$term->object_id}' AND term_taxonomy_id = '{$term->term_taxonomy_id}'" );
		}
	}
	$cats = $wpdb->get_results( "SELECT link_id, term_taxonomy_id, link_count FROM $wpdb->link2cat, {$wpdb->term_taxonomy}, {$wpdb->categories} WHERE {$wpdb->link2cat}.category_id = {$wpdb->term_taxonomy}.term_id AND link_id = '{$link_id}' AND {$wpdb->categories}.cat_ID = {$wpdb->link2cat}.category_id AND {$wpdb->term_taxonomy}.taxonomy = 'link_category'" );
	if( is_array( $cats ) ) {
		foreach( $cats as $cat ) {
			$wpdb->query( "INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) VALUES ( '{$cat->link_id}', '{$cat->term_taxonomy_id}' )" );
			$wpdb->query( "UPDATE $wpdb->term_taxonomy SET count = '{$cat->link_count}' WHERE taxonomy = 'link_category' AND term_taxonomy_id = '{$cat->term_taxonomy_id}'" );
		}
	}
	wp_cache_delete( 'get_bookmarks', 'bookmark' );
	wp_cache_delete( 'all_category_ids', 'category' );
	wp_cache_delete( 'get_terms', 'terms' );
}
add_action( 'edit_link', 'sync_link2cat' );
add_action( 'add_link', 'sync_link2cat' );

function sync_post2cat( $post_id ) {
	global $wpdb;

	if ( get_option('db_version') != 6124 )
		return;
	
	if( function_exists( 'get_term' ) ) {
		$wpdb->query( "DELETE FROM {$wpdb->post2cat} WHERE post_id = '{$post_id}'" );
		$terms = $wpdb->get_results( "SELECT {$wpdb->term_taxonomy}.term_id FROM {$wpdb->term_taxonomy}, {$wpdb->term_relationships} WHERE {$wpdb->term_taxonomy}.term_taxonomy_id = {$wpdb->term_relationships}.term_taxonomy_id AND {$wpdb->term_relationships}.object_id = '{$post_id}' AND {$wpdb->term_taxonomy}.taxonomy = 'category'" );
		if( is_array( $terms ) )
			foreach( $terms as $term )
				$wpdb->query( "INSERT INTO {$wpdb->post2cat} ( `post_id`, `category_id` ) VALUES ( '$post_id', '{$term->term_id}' )" );

		wp_cache_delete( 'all_category_ids', 'category' );
		wp_cache_delete( 'get_terms', 'terms' );
		return $post_id;
	}

	$cats = $wpdb->get_results( "SELECT category_id, category_description, category_parent, category_count FROM {$wpdb->post2cat}, {$wpdb->categories} WHERE {$wpdb->post2cat}.category_id = {$wpdb->categories}.cat_ID AND post_id = '{$post_id}'" );
	foreach( $cats as $cat ) {
		if ( !$wpdb->get_var( "SELECT term_taxonomy_id FROM $wpdb->term_taxonomy WHERE taxonomy = 'category' AND term_id = '{$cat->category_id}'" ) )
			$wpdb->query( "INSERT INTO $wpdb->term_taxonomy ( term_id, taxonomy, description, parent, count ) VALUES ( '{$cat->category_id}', 'category', '" . $wpdb->escape( $cat->category_description ) . "', '{$cat->category_parent}', '{$cat->category_count}' )" );
	}
	$terms = $wpdb->get_results( "SELECT {$wpdb->term_taxonomy}.term_id, {$wpdb->term_relationships}.object_id, {$wpdb->term_relationships}.term_taxonomy_id FROM {$wpdb->term_taxonomy}, {$wpdb->term_relationships} WHERE {$wpdb->term_taxonomy}.term_taxonomy_id = {$wpdb->term_relationships}.term_taxonomy_id AND {$wpdb->term_relationships}.object_id = '{$post_id}' AND {$wpdb->term_taxonomy}.taxonomy = 'category'" );
	if( is_array( $terms ) ) {
		foreach( $terms as $term ) {
			$wpdb->query( "DELETE FROM $wpdb->term_relationships WHERE object_id = '{$term->object_id}' AND term_taxonomy_id = '{$term->term_taxonomy_id}'" );
		}
	}
	$cats = $wpdb->get_results( "SELECT post_id, term_taxonomy_id, category_count FROM $wpdb->post2cat, {$wpdb->term_taxonomy}, {$wpdb->categories} WHERE {$wpdb->post2cat}.category_id = {$wpdb->term_taxonomy}.term_id AND post_id = '{$post_id}' AND {$wpdb->categories}.cat_ID = {$wpdb->post2cat}.category_id AND {$wpdb->term_taxonomy}.taxonomy = 'category'" );
	if( is_array( $cats ) ) {
		foreach( $cats as $cat ) {
			$wpdb->query( "INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) VALUES ( '{$cat->post_id}', '{$cat->term_taxonomy_id}' )" );
			$wpdb->query( "UPDATE $wpdb->term_taxonomy SET count = '{$cat->category_count}' WHERE taxonomy = 'category' AND term_taxonomy_id = '{$cat->term_taxonomy_id}'" );
		}
	}
	wp_cache_delete( 'all_category_ids', 'category' );
	wp_cache_delete( 'get_terms', 'terms' );
}
add_action( 'save_post', 'sync_post2cat' );

function sync_terms_edit_cat( $cat_ID ) {
	sync_terms_edit( $cat_ID, "category" );
}
function sync_terms_edit_link( $cat_ID ) {
	sync_terms_edit( $cat_ID, "link_category" );
}
function sync_terms_edit( $cat_ID, $taxonomy ) {
	global $wpdb;

	if ( get_option('db_version') != 6124 )
		return;
	
	if( function_exists( 'get_term' ) ) {
		$cat = $wpdb->get_row( "SELECT * FROM {$wpdb->terms}, {$wpdb->term_taxonomy} WHERE {$wpdb->terms}.term_id = {$wpdb->term_taxonomy}.term_id AND {$wpdb->term_taxonomy}.term_id = '$cat_ID'" );
		$wpdb->query( "UPDATE {$wpdb->categories} SET cat_name = '" . $wpdb->escape( $cat->name ) . "', category_nicename = '" . $wpdb->escape( $cat->slug ) . "', category_description = '" . $wpdb->escape( $cat->description ) . "', category_parent = '{$cat->parent}' WHERE cat_ID = '$cat_ID'" );
		
		return $cat_ID;
	}

	$cat = get_category( $cat_ID );
	$wpdb->query( "UPDATE $wpdb->terms SET name = '" . $wpdb->escape( $cat->cat_name ) . "', slug = '$cat->category_nicename' WHERE term_id = '$cat_ID'" );
	$count = $taxonomy == "category" ? $cat->category_count : $cat->link_count;
	$wpdb->query( "UPDATE $wpdb->term_taxonomy SET description = '" . $wpdb->escape( $cat->description ) . "', parent = '$cat->category_parent', count = '$count' WHERE term_id = '$cat_ID' AND taxonomy = '$taxonomy'" );
	wp_cache_delete( 'get_terms', 'terms' );
	return $cat_ID;
}
add_filter( 'edit_category', 'sync_terms_edit_cat');
add_filter( 'edit_link_category', 'sync_terms_edit_link');

function sync_terms_create( $cat_ID ) {
	global $wpdb;

	if ( get_option('db_version') != 6124 )
		return;
	
	if( strpos( $_SERVER[ 'HTTP_REFERER' ], 'link-add.php' ) ) {
		$taxonomy = 'link_category';
	} else {
		$taxonomy = 'category';
	}
	if( function_exists( 'get_term' ) ) {
		$cat = $wpdb->get_row( "SELECT * FROM {$wpdb->terms}, {$wpdb->term_taxonomy} WHERE {$wpdb->terms}.term_id = {$wpdb->term_taxonomy}.term_id AND {$wpdb->term_taxonomy}.term_id = '$cat_ID' AND {$wpdb->term_taxonomy}.taxonomy = '$taxonomy'" );
		$wpdb->query( "INSERT INTO {$wpdb->categories} ( `cat_ID`, `cat_name`, `category_nicename`, `category_description`, `category_parent` ) VALUES ( '{$cat->term_id}', '" . $wpdb->escape( $cat->name ) . "', '" . $wpdb->escape( $cat->slug ) . "', '" . $wpdb->escape( $cat->description ) . "', '{$cat->parent}' )" );
		
		return $cat_ID;
	}

	$cat = get_category( $cat_ID );
	$wpdb->query( "INSERT INTO $wpdb->terms ( term_id, name, slug, term_group ) VALUES ( '{$cat->cat_ID}', '" . $wpdb->escape( $cat->cat_name ) . "', '{$cat->category_nicename}', '0' )" );
	$wpdb->query( "INSERT INTO $wpdb->term_taxonomy ( term_id, taxonomy, description, parent, count ) VALUES ( '{$cat->cat_ID}', '$taxonomy', '" . $wpdb->escape( $cat->category_description ) . "', '{$cat->category_parent}', '$count' )" );
	$wpdb->query( "INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) SELECT post_id, term_taxonomy_id FROM $wpdb->post2cat, {$wpdb->term_taxonomy} WHERE {$wpdb->post2cat}.category_id = {$wpdb->term_taxonomy}.term_id AND {$wpdb->post2cat}.category_id = '$cat_ID'" );
	$wpdb->query( "INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) SELECT link_id, term_taxonomy_id FROM $wpdb->link2cat, {$wpdb->term_taxonomy} WHERE {$wpdb->link2cat}.category_id = {$wpdb->term_taxonomy}.term_id AND {$wpdb->link2cat}.category_id = '$cat_ID'" );
	wp_cache_delete( 'get_terms', 'terms' );
	return $cat_ID;
}
add_filter( 'create_category', 'sync_terms_create');
add_filter( 'create_link_category', 'sync_terms_create');

function sync_terms_delete( $cat_ID ) {
	global $wpdb;

	if ( get_option('db_version') != 6124 )
		return;
	
	if( function_exists( 'get_term' ) ) {
		$wpdb->query( "DELETE FROM {$wpdb->categories} WHERE cat_ID = '$cat_ID'" );
		$wpdb->query( "DELETE FROM {$wpdb->post2cat} WHERE cat_ID = '$cat_ID'" );
		$wpdb->query( "DELETE FROM {$wpdb->link2cat} WHERE cat_ID = '$cat_ID'" );
		
		return $cat_ID;
	}

	$wpdb->query( "DELETE FROM $wpdb->terms WHERE term_id = '$cat_ID'" );
	$term_taxonomy_ids = $wpdb->get_col( "SELECT term_taxonomy_id FROM $wpdb->term_taxonomy WHERE term_id = '$cat_ID'" );
	if ( !empty($term_taxonomy_ids) ) {
		foreach ( $term_taxonomy_ids as $term_taxonomy_id ) {
			$wpdb->query( "DELETE FROM $wpdb->term_taxonomy WHERE term_taxonomy_id = '$term_taxonomy_id'" );
			$wpdb->query( "DELETE FROM $wpdb->term_relationships WHERE term_taxonomy_id = '$term_taxonomy_id'" );
		}
	}
	wp_cache_delete( 'get_terms', 'terms' );
}
add_filter( 'delete_category', 'sync_terms_delete');
add_filter( 'delete_link_category', 'sync_terms_delete');

function backfill_tags( $force = false ) {
	global $wpdb, $blog_id;

	if( function_exists( 'get_term' ) )
		return;

	$upgradetaxonomysecret = get_taxonomy_secret();

	$needs_fix = $wpdb->get_col( "SELECT term_id FROM $wpdb->term_taxonomy WHERE taxonomy = ''" );
	if ( isset( $_GET['taxonomysync'] ) && $upgradetaxonomysecret == $_GET['taxonomysync'] ) {
		do_backfill( $needs_fix );
	}

	if ( get_option('db_version') == 6124 )
		return;

	if ( !current_user_can( 'publish_posts' ) )
		return;

	do_backfill( $needs_fix );
}
add_action( 'init', 'backfill_tags' );

function do_backfill( $term_ids = array() ) {
	global $wpdb, $blog_id;

	$wp_queries="CREATE TABLE IF NOT EXISTS $wpdb->terms (
		term_id bigint(20) NOT NULL auto_increment,
		name varchar(55) NOT NULL default '',
		slug varchar(200) NOT NULL default '',
		term_group bigint(10) NOT NULL default 0,
		PRIMARY KEY  (term_id),
		UNIQUE KEY slug (slug)
	);";
	$wpdb->query( $wp_queries );
	$wp_queries="CREATE TABLE IF NOT EXISTS $wpdb->term_taxonomy (
		term_taxonomy_id bigint(20) NOT NULL auto_increment,
		term_id bigint(20) NOT NULL default 0,
		taxonomy varchar(32) NOT NULL default '',
		description longtext NOT NULL,
		parent bigint(20) NOT NULL default 0,
		count bigint(20) NOT NULL default 0,
		PRIMARY KEY  (term_taxonomy_id),
		UNIQUE KEY term_id_taxonomy (term_id,taxonomy)
	);";
	$wpdb->query( $wp_queries );
	$wp_queries="CREATE TABLE IF NOT EXISTS $wpdb->term_relationships (
		object_id bigint(20) NOT NULL default 0,
		term_taxonomy_id bigint(20) NOT NULL default 0,
		PRIMARY KEY  (object_id,term_taxonomy_id),
		KEY term_taxonomy_id (term_taxonomy_id)
	);";
	$wpdb->query( $wp_queries );

	$wpdb->query( "TRUNCATE TABLE $wpdb->terms" );
	$wpdb->query( "TRUNCATE TABLE $wpdb->term_relationships" );
	$wpdb->query( "TRUNCATE TABLE $wpdb->term_taxonomy" );

	if( $wpdb->get_results( "SELECT cat_ID FROM $wpdb->categories LIMIT 0,1" ) ) { 
		// If we have categories and no terms do initial sync
		$cats = $wpdb->get_results( "SELECT * FROM $wpdb->categories" );

		foreach( $cats as $cat ) {
			$cat->link_count = $wpdb->get_var( "SELECT COUNT(*) FROM $wpdb->link2cat WHERE category_id = $cat->cat_ID" );
			$cat->category_count = $wpdb->get_var( "SELECT COUNT(post_id) FROM $wpdb->post2cat WHERE category_id = $cat->cat_ID" );

			$wpdb->query( "INSERT INTO $wpdb->terms ( term_id, name, slug, term_group ) VALUES ( '$cat->cat_ID', '" . $wpdb->escape( $cat->cat_name ) . "', '$cat->category_nicename', '0' )" );
			if ( $cat->link_count ) {
				$count = $cat->link_count;
				if ( !$wpdb->get_var( "SELECT term_taxonomy_id FROM $wpdb->term_taxonomy WHERE taxonomy = 'link_category' AND term_id = '$cat->cat_ID'" ) )
					$wpdb->query( "INSERT INTO $wpdb->term_taxonomy ( term_id, taxonomy, description, parent, count ) VALUES ( '{$cat->cat_ID}', 'link_category', '" . $wpdb->escape( $cat->category_description ) . "', '{$cat->category_parent}', '{$count}' )" );				
			} 
			if ( $cat->category_count || ( !$cat->category_count && !$cat->link_category ) ) {
				$count = $cat->category_count;
				if ( !$wpdb->get_var( "SELECT term_taxonomy_id FROM $wpdb->term_taxonomy WHERE taxonomy = 'category' AND term_id = '$cat->cat_ID'" ) )
					$wpdb->query( "INSERT INTO $wpdb->term_taxonomy ( term_id, taxonomy, description, parent, count ) VALUES ( '{$cat->cat_ID}', 'category', '" . $wpdb->escape( $cat->category_description ) . "', '{$cat->category_parent}', '{$count}' )" );				
			}

			wp_cache_delete( $cat->cat_ID, 'category' );
			wp_cache_delete( $cat->cat_ID, 'link_category' );
			if ( function_exists( "clean_term_cache" ) ) {
				clean_term_cache( $cat->cat_ID, 'category' );
				clean_term_cache( $cat->cat_ID, 'link_category' );
			}
		}
		$cats = $wpdb->get_results( "SELECT link_id, term_taxonomy_id, link_count FROM $wpdb->link2cat, {$wpdb->term_taxonomy}, {$wpdb->categories} WHERE {$wpdb->link2cat}.category_id = {$wpdb->term_taxonomy}.term_id AND {$wpdb->categories}.cat_ID = {$wpdb->link2cat}.category_id AND {$wpdb->term_taxonomy}.taxonomy = 'link_category'" );
		if( is_array( $cats ) ) {
			foreach( $cats as $cat ) {
				$wpdb->query( "INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) VALUES ( '{$cat->link_id}', '{$cat->term_taxonomy_id}' )" );
				$wpdb->query( "UPDATE $wpdb->term_taxonomy SET count = '{$cat->link_count}' WHERE taxonomy = 'link_category' AND term_taxonomy_id = '{$cat->term_taxonomy_id}'" );
			}
		}
		$cats = $wpdb->get_results( "SELECT post_id, term_taxonomy_id, category_count FROM $wpdb->post2cat, {$wpdb->term_taxonomy}, {$wpdb->categories} WHERE {$wpdb->post2cat}.category_id = {$wpdb->term_taxonomy}.term_id AND {$wpdb->categories}.cat_ID = {$wpdb->post2cat}.category_id AND {$wpdb->term_taxonomy}.taxonomy = 'category'" );
		if( is_array( $cats ) ) {
			foreach( $cats as $cat ) {
				$wpdb->query( "INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) VALUES ( '{$cat->post_id}', '{$cat->term_taxonomy_id}' )" );
				$wpdb->query( "UPDATE $wpdb->term_taxonomy SET count = '{$cat->category_count}' WHERE taxonomy = 'category' AND term_taxonomy_id = '{$cat->term_taxonomy_id}'" );
			}
		}
	}
	wp_cache_delete( 'get_bookmarks', 'bookmark' );
	wp_cache_delete( 'all_category_ids', 'category' );
	wp_cache_delete( 'get_terms', 'terms' );

	update_option( 'db_version', 6124 );

	if( empty( $term_ids ) )
		return;

	foreach( $term_ids as $term_id ) {
		$post_ids = $wpdb->get_col( "SELECT post_id FROM {$wpdb->post2cat} WHERE category_id = '{$term_id}'" );
		if( is_array( $post_ids ) && !empty( $post_ids ) ) {
			foreach( $post_ids as $post_id ) {
				do_action( 'edit_post', $post_id );
			}
		}
	}
}

function make_tags_global( $global_id, $cat_ID ) {
	global $wpdb;

	if ( get_option('db_version') != 6124 )
		return;
	
	if( $global_id == $cat_ID )
		return;
		
	$wpdb->query( "UPDATE $wpdb->terms SET term_id = '$global_id' WHERE term_id = '$cat_ID'" );
	$wpdb->query( "UPDATE $wpdb->term_taxonomy SET term_id = '$global_id' WHERE term_id = '$cat_ID'" );
	$wpdb->query( "UPDATE $wpdb->term_taxonomy SET parent = '$global_id' WHERE parent = '$cat_ID'" );
}
add_action( 'update_cat_id', 'make_tags_global', 10, 2 );

function redo_relationships() {
	global $wpdb, $blog_id;

	if ( get_option('db_version') != 6124 )
		return;
	
	$upgradetaxonomysecret = get_taxonomy_secret();

	if ( !isset( $_GET['redorelationships'] ) || $upgradetaxonomysecret != $_GET['redorelationships'] )
		return;

	// For all posts in post2cat, erase relationships in term_relationships and repopulate
	// term_relationships with relationships from post2cat

	$tt_ids = array();

	// Get all post IDs from post2cat
	$posts = $wpdb->get_col("SELECT post_id FROM $wpdb->post2cat GROUP BY post_id");

	foreach ( $posts as $post_id ) {
		// Clear out category relationships for this post.
		$terms = $wpdb->get_col("SELECT tr.term_taxonomy_id FROM $wpdb->term_relationships AS tr INNER JOIN $wpdb->term_taxonomy AS tt ON tr.term_taxonomy_id = tt.term_taxonomy_id WHERE tr.object_id = '$post_id' AND tt.taxonomy = 'category'");
		foreach ( (array) $terms as $term) 
			$wpdb->query("DELETE FROM $wpdb->term_relationships WHERE object_id = '$post_id' AND term_taxonomy_id = '$term'");
		$cats = $wpdb->get_col("SELECT category_id FROM $wpdb->post2cat WHERE post_id = '$post_id'");
		foreach ( $cats as $cat ) {
			// Get the tt_id for the term.  Assume it already exists.
			if ( empty($tt_ids[$cat]) )
				$tt_ids[$cat] = $wpdb->get_var("SELECT term_taxonomy_id FROM $wpdb->term_taxonomy WHERE term_id = '$cat' AND taxonomy = 'category'");
			if ( empty($tt_ids[$cat]) || 'empty' == $tt_ids[$cat] ) {
				error_log("No tt_id for post $post_id, cat $cat, blog $blog_id", 0);
				$tt_ids[$cat] = 'empty';
				continue;
			}
			// Create the relationship.
			$tt_id = $tt_ids[$cat];
			$wpdb->query("INSERT INTO $wpdb->term_relationships (object_id, term_taxonomy_id) VALUES ('$post_id', '$tt_id')");
		}
		clean_post_cache($post_id);
	}

	wp_cache_delete( 'get_bookmarks', 'bookmark' );
	wp_cache_delete( 'all_category_ids', 'category' );
	wp_cache_delete( 'get_terms', 'terms' );
}

add_action('init', 'redo_relationships');

function get_taxonomy_secret() {
	$upgradetaxonomysecret = get_site_option( 'upgradetaxonomysecret' );
	if( $upgradetaxonomysecret == false ) {
		$upgradetaxonomysecret = md5( uniqid(time() . mt_rand()) );
		add_site_option( 'upgradetaxonomysecret', $upgradetaxonomysecret );
	}
	return $upgradetaxonomysecret;
}

function upgrade_all_taxonomy() {
	global $wpdb, $wpmuBaseTablePrefix;

	if( isset( $_GET[ 'upgradetaxonomy' ] ) == false )
		return;

	$upgradetaxonomysecret = get_taxonomy_secret();

	if( $_GET[ 'upgradetaxonomy' ] == $upgradetaxonomysecret ) {
		$http_fopen = ini_get("allow_url_fopen");
		if(!$http_fopen) require_once('../../wp-includes/class-snoopy.php');
		if( isset( $_GET[ 'n' ] ) == false ) {
			$n = 0;
		} else {
			$n = intval( $_GET[ 'n' ] );
		}
		$blogs = $wpdb->get_results( "SELECT * FROM $wpdb->blogs WHERE site_id = '$wpdb->siteid' AND spam = '0' AND deleted = '0' AND archived = '0' ORDER BY registered DESC LIMIT $n, 10", ARRAY_A );
		if( is_array( $blogs ) ) {
			print "<ul>";
			foreach( $blogs as $details ) {
				$siteurl = $wpdb->get_var( "SELECT option_value from {$wpmuBaseTablePrefix}{$details[ 'blog_id' ]}_options WHERE option_name = 'siteurl'" );
				print "<li>$siteurl</li>";
				if($http_fopen) {
					$fp = fopen( trailingslashit( $siteurl ) . '?taxonomysync=' . get_site_option( 'upgradetaxonomysecret' ), "r" );
					if( $fp ) {
						while( feof( $fp ) == false ) {
							fgets($fp, 4096);
						}
						fclose( $fp );
					}
				} else {
					$client = new Snoopy();
					@$client->fetch( trailingslashit( $siteurl ) . '?taxonomysync=' . get_site_option( 'upgradetaxonomysecret' ));
				}
			}
			print "</ul>";
			?>
			<p><?php _e("If your browser doesn't start loading the next page automatically click this link:"); ?> <a href="<?php echo trailingslashit( get_option( 'siteurl' ) ) ?>?upgradetaxonomy=<?php echo $upgradetaxonomysecret ?>&n=<?php echo ($n + 5) ?>"><?php _e("Next Blogs"); ?></a> </p>
			<script language='javascript'>
			<!--

			function nextpage() {
				location.href="<?php echo trailingslashit( get_option( 'siteurl' ) ) ?>?upgradetaxonomy=<?php echo $upgradetaxonomysecret ?>&n=<?php echo ($n + 10) ?>";
			}
			setTimeout( "nextpage()", 25 );

			//-->
			</script>
			<?php
			die();
		} else {
			_e("All Done!");
			die();
		}
	}
	
}

add_action('init', 'upgrade_all_taxonomy');
*/
?>

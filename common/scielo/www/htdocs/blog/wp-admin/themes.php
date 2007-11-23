<?php
require_once('admin.php');

$themes = get_themes();
$ct = current_theme_info();
$allowed_themes = get_site_allowed_themes();
if( $allowed_themes == false )
	$allowed_themes = array();

$blog_allowed_themes = wpmu_get_blog_allowedthemes();
if( is_array( $blog_allowed_themes ) )
	$allowed_themes = array_merge( $allowed_themes, $blog_allowed_themes );
if( $blog_id != 1 )
	unset( $allowed_themes[ "h3" ] );

if( isset( $allowed_themes[ wp_specialchars( $ct->stylesheet ) ] ) == false )
    $allowed_themes[ wp_specialchars( $ct->stylesheet ) ] = true;

reset( $themes );
foreach( $themes as $key => $theme ) {
    if( isset( $allowed_themes[ wp_specialchars( $theme[ 'Stylesheet' ] ) ] ) == false ) {
		unset( $themes[ $key ] );
    }
}
reset( $themes );

if ( isset($_GET['action']) ) {
	check_admin_referer('switch-theme_' . $_GET['template']);

	if ('activate' == $_GET['action']) {
		$found = false;
		while( list( $key, $details ) = each( $themes ) ) { 
			if( $details[ 'Template' ] == $_GET['template'] && $details[ 'Stylesheet' ] == $_GET['stylesheet'] ) {
				$found = true;
				break;
			}
		}
		if( $found == true ) {
			if ( isset($_GET['template']) )
				update_option('template', $_GET['template']);

			if ( isset($_GET['stylesheet']) )
				update_option('stylesheet', $_GET['stylesheet']);

			do_action('switch_theme', get_current_theme());

			wp_redirect('themes.php?activated=true');
		} else {
			wp_redirect('themes.php');
		}
		exit;
	}
}

$title = __('Manage Themes');
$parent_file = 'themes.php';
require_once('admin-header.php');
if( is_site_admin() ) {
	?><div id="message0" class="updated fade"><p><?php _e('Administrator: new themes must be activated in the <a href="wpmu-themes.php">Themes Admin</a> page before they appear here.'); ?></p></div><?php
}
?>

<?php if ( ! validate_current_theme() ) : ?>
<div id="message1" class="updated fade"><p><?php _e('The active theme is broken.  Reverting to the default theme.'); ?></p></div>
<?php elseif ( isset($_GET['activated']) ) : ?>
<div id="message2" class="updated fade"><p><?php printf(__('New theme activated. <a href="%s">View site &raquo;</a>'), get_bloginfo('url') . '/'); ?></p></div>
<?php endif; ?>


<div class="wrap">
<h2><?php _e('Current Theme'); ?></h2>
<div id="currenttheme">
<?php if ( $ct->screenshot ) : ?>
<img src="<?php echo get_option('siteurl') . '/' . $ct->stylesheet_dir . '/' . $ct->screenshot; ?>" alt="<?php _e('Current theme preview'); ?>" />
<?php endif; ?>
<h3><?php printf(_c('%1$s %2$s by %3$s|1: theme title, 2: theme version, 3: theme author'), $ct->title, $ct->version, $ct->author) ; ?></h3>
<p><?php echo $ct->description; ?></p>
</div>

<br style="clear: both" />
<h2><?php _e('Available Themes'); ?></h2>
<?php if ( 1 < count($themes) ) { ?>

<?php
$style = '';

$theme_names = array_keys($themes);
natcasesort($theme_names);

foreach ($theme_names as $theme_name) {
	if ( $theme_name == $ct->name )
		continue;
	$template = $themes[$theme_name]['Template'];
	$stylesheet = $themes[$theme_name]['Stylesheet'];
	$title = $themes[$theme_name]['Title'];
	$version = $themes[$theme_name]['Version'];
	$description = $themes[$theme_name]['Description'];
	$author = $themes[$theme_name]['Author'];
	$screenshot = $themes[$theme_name]['Screenshot'];
	$stylesheet_dir = $themes[$theme_name]['Stylesheet Dir'];
	$activate_link = wp_nonce_url("themes.php?action=activate&amp;template=".urlencode($template)."&amp;stylesheet=".urlencode($stylesheet), 'switch-theme_' . $template);
?>
<div class="available-theme">
<h3><a href="<?php echo $activate_link; ?>"><?php echo $title; ?></a></h3>

<a href="<?php echo $activate_link; ?>" class="screenshot">
<?php if ( $screenshot ) : ?>
<img src="<?php echo get_option('siteurl') . '/' . $stylesheet_dir . '/' . $screenshot; ?>" alt="" />
<?php endif; ?>
</a>

<p><?php echo $description; ?></p>
</div>
<?php } // end foreach theme_names ?>

<?php } ?>

<?php
// List broken themes, if any.
$broken_themes = get_broken_themes();
if ( is_site_admin() && count($broken_themes) ) {
?>

<h2><?php _e('Broken Themes'); ?> (Site admin only)</h2>
<p><?php _e('The following themes are installed but incomplete.  Themes must have a stylesheet and a template.'); ?></p>

<table width="100%" cellpadding="3" cellspacing="3">
	<tr>
		<th><?php _e('Name'); ?></th>
		<th><?php _e('Description'); ?></th>
	</tr>
<?php
	$theme = '';

	$theme_names = array_keys($broken_themes);
	natcasesort($theme_names);

	foreach ($theme_names as $theme_name) {
		$title = $broken_themes[$theme_name]['Title'];
		$description = $broken_themes[$theme_name]['Description'];

		$theme = ('class="alternate"' == $theme) ? '' : 'class="alternate"';
		echo "
		<tr $theme>
			 <td>$title</td>
			 <td>$description</td>
		</tr>";
	}
?>
</table>
<?php
}
?>
<br clear="all" />
</div>

<?php require('admin-footer.php'); ?>

<?php
require_once('admin.php');

$title = __('WordPress MU &rsaquo; Admin &rsaquo; Themes');
$parent_file = 'wpmu-admin.php';
require_once('admin-header.php');

if( is_site_admin() == false ) {
	wp_die( __('<p>You do not have permission to access this page.</p>') );
}

if (isset($_GET['updated'])) {
	?>
	<div id="message" class="updated fade"><p><?php _e('Site themes saved.') ?></p></div>
	<?php
}

$themes = get_themes();
$allowed_themes = get_site_allowed_themes();
?>
<div class="wrap">
	<form action='wpmu-edit.php?action=updatethemes' method='post'>
		<h2><?php _e('Site Themes') ?></h2>
		<p><?php _e('Disable themes site-wide. You can enable themes on a blog by blog basis.') ?></p>		
		<table style="border:0; width:100%;" cellspacing="5" cellpadding="5">
			<thead>
			<tr>
				<th style="width:15%;"><?php _e('Active') ?></th>
				<th style="width:15%;"><?php _e('Theme') ?></th>
				<th style="width:70%;"><?php _e('Description') ?></th>
			</tr>
			</thead>
			<tbody id="the-list">
			<?php
			foreach( (array) $themes as $key => $theme ) :
				$theme_key = wp_specialchars($theme['Stylesheet']);
				$class = ('alternate' == $class) ? '' : 'alternate';
				$enabled = $disabled = '';
				
				if( isset( $allowed_themes[ $theme_key ] ) == true ) {
					$enabled = 'checked="checked" ';
				} else {
					$disabled = 'checked="checked" ';
				}
				?>
				<tr valign="top" class="<?php echo $class; ?>">
					<td style="text-align:center;">
						<label><input name="theme[<?php echo $theme_key ?>]" type="radio" id="disabled_<?php echo $theme_key ?>" value="disabled" <?php echo $disabled ?> /> <?php _e('No') ?></label>
						&nbsp;&nbsp;&nbsp; 
						<label><input name="theme[<?php echo $theme_key ?>]" type="radio" id="enabled_<?php echo $theme_key ?>" value="enabled" <?php echo $enabled ?> /> <?php _e('Yes') ?></label>
					</td>
					<th scope="row" style="text-align:left;"><?php echo $key ?></th> 
					<td><?php echo $theme['Description'] ?></td>
				</tr> 
			<?php endforeach; ?>
			</tbody>
		</table>
		
		<p class="submit">
			<input type='submit' value='<?php _e('Update Themes &raquo;') ?>' /></p>
	</form>
</div>

<?php include('admin-footer.php'); ?>

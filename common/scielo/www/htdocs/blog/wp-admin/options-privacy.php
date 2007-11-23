<?php
require_once('./admin.php');

$title = __('Privacy Options');
$parent_file = 'options-general.php';

include('./admin-header.php');

if( trim( get_option('blog_public') ) == '' )
	update_option('blog_public', get_blog_status( $wpdb->blogid, 'public'));
?>

<div class="wrap">
<h2><?php _e('Privacy Options') ?></h2>
<form method="post" action="options.php">
<?php wp_nonce_field('update-options') ?>
<table class="optiontable">
<tr valign="top">
<th scope="row"><?php _e('Blog visibility:') ?> </th>
<td>
<input id="blog-public" type="radio" name="blog_public" value="1" <?php checked('1', get_option('blog_public')); ?> />
	<label for="blog-public"><?php _e('I would like my blog to be visible to anyone who visits, including search engines, archivers and in public listings around this site.') ?></label>
<br />
<input id="blog-norobots" type="radio" name="blog_public" value="0" <?php checked('0', get_option('blog_public')); ?> />
	<label for="blog-norobots"><?php _e( 'I would like to block search engines, but allow normal visitors' ); ?></label>
<?php do_action('blog_privacy_selector'); ?>
</td>
</tr>
</table>

<p class="submit"><input type="submit" name="Submit" value="<?php _e('Update Options &raquo;') ?>" />
<input type="hidden" name="action" value="update" />
<input type="hidden" name="page_options" value="blog_public" />
</p>
</form>

</div>

<?php include('./admin-footer.php') ?>

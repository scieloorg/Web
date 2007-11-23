<?php
require_once('admin.php');

$title = __('Writing Options');
$parent_file = 'options-general.php';

include('admin-header.php');
?>

<div class="wrap">
<h2><?php _e('Writing Options') ?></h2>
<form method="post" action="options.php">
<?php wp_nonce_field('update-options') ?>
<p class="submit"><input type="submit" name="Submit" value="<?php _e('Update Options &raquo;') ?>" /></p>
<table width="100%" cellspacing="2" cellpadding="5" class="optiontable editform">
<tr valign="top">
<th width="33%" scope="row"> <?php _e('Size of the post box:') ?></th>
<td><input name="default_post_edit_rows" type="text" id="default_post_edit_rows" value="<?php form_option('default_post_edit_rows'); ?>" size="2" style="width: 1.5em; " />
<?php _e('lines') ?></td>
</tr>
<tr valign="top">
<th scope="row"><?php _e('Formatting:') ?></th>
<td>
<label for="use_smilies">
<input name="use_smilies" type="checkbox" id="use_smilies" value="1" <?php checked('1', get_option('use_smilies')); ?> />
<?php _e('Convert emoticons like <code>:-)</code> and <code>:-P</code> to graphics on display') ?></label><br />
<label for="use_balanceTags"><input name="use_balanceTags" type="checkbox" id="use_balanceTags" value="1" <?php checked('1', get_option('use_balanceTags')); ?> /> <?php _e('WordPress should correct invalidly nested XHTML automatically') ?></label>
</td>
</tr>
<tr valign="top">
<th scope="row"><?php _e('Default post category:') ?></th>
<td><select name="default_category" id="default_category">
<?php
$categories = get_categories('get=all');
foreach ($categories as $category) :
$category = sanitize_category($category);
if ($category->term_id == get_option('default_category')) $selected = " selected='selected'";
else $selected = '';
echo "\n\t<option value='$category->term_id' $selected>$category->name</option>";
endforeach;
?>
</select></td>
</tr>
<tr valign="top">
<th scope="row"><?php _e('Default link category:') ?></th>
<td><select name="default_link_category" id="default_link_category">
<?php
$link_categories = get_terms('link_category', 'get=all');
foreach ($link_categories as $category) :
$category = sanitize_term($category, 'link_category');
if ($category->term_id == get_option('default_link_category')) $selected = " selected='selected'";
else $selected = '';
echo "\n\t<option value='$category->term_id' $selected>$category->name</option>";
endforeach;
?>
</select></td>
</tr>
</table>
<p class="submit">
<input type="hidden" name="action" value="update" />
<input type="hidden" name="page_options" value="default_post_edit_rows,use_smilies,default_category,default_email_category,use_balanceTags,default_link_category" /> 
<input type="submit" name="Submit" value="<?php _e('Update Options &raquo;') ?>" />
</p>
</form>
</div>

<?php include('./admin-footer.php') ?>

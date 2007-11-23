<?php
require_once('./admin.php');

$title = __('General Options');
$parent_file = 'options-general.php';

include('./admin-header.php');
?>

<div class="wrap">
<h2><?php _e('General Options') ?></h2>
<form method="post" action="options.php">
<?php wp_nonce_field('update-options') ?>
<p class="submit"><input type="submit" name="Submit" value="<?php _e('Update Options &raquo;') ?>" /></p>
<table class="optiontable">
<tr valign="top">
<th scope="row"><?php _e('Blog title:') ?></th>
<td><input name="blogname" type="text" id="blogname" value="<?php form_option('blogname'); ?>" size="40" /></td>
</tr>
<tr valign="top">
<th scope="row"><?php _e('Tagline:') ?></th>
<td><input name="blogdescription" type="text" id="blogdescription" style="width: 95%" value="<?php form_option('blogdescription'); ?>" size="45" />
<br />
<?php _e('In a few words, explain what this blog is about.') ?></td>
</tr> 
<tr valign="top"> 
<th scope="row"><?php _e('Membership:') ?></th> 
<td> <label for="comment_registration">
<input name="comment_registration" type="checkbox" id="comment_registration" value="1" <?php checked('1', get_option('comment_registration')); ?> /> 
<?php _e('Users must be registered and logged in to comment') ?>
</label>
</td> 
</tr> 
<tr valign="top"> 
<th scope="row"><?php _e('E-mail address:') ?> </th> 
<td><input name="new_admin_email" type="text" id="new_admin_email" value="<?php form_option('admin_email'); ?>" size="40" class="code" />
<br />
<p><?php _e('This address is used only for admin purposes.') ?> <?php _e('If you change this we will send you an email at your new address to confirm it. <strong>The new address will not become active until confirmed.</strong>') ?></p>
</td> 
</tr>

<?php
$lang_files = glob( ABSPATH . LANGDIR . '/*.mo' );
$lang = get_option('WPLANG');

if( is_array( $lang_files ) ) {
	?>
	<tr valign="top"> 
		<th width="33%" scope="row"><?php _e('Blog language:') ?></th> 
		<td>
			<select name="WPLANG" id="WPLANG">
				<?php
				echo '<option value=""'.((empty($lang)) ? 'selected="selected"': '').'>'.__('English').'</option>';
				foreach ( (array) $lang_files as $key => $val ) {
					$code_lang = basename( $val, '.mo' );
					echo '<option value="'.$code_lang.'"'.(($lang == $code_lang) ? ' selected="selected"' : '').'> '.format_code_lang($code_lang).'</option>';
				}
				?>
			</select>
		</td>
	</tr> 
	<?php
} // languages
?>
</table> 
<fieldset class="options"> 
<legend><?php _e('Date and Time') ?></legend> 
<table class="optiontable"> 
<tr> 
<th scope="row"><?php _e('<abbr title="Coordinated Universal Time">UTC</abbr> time is:') ?> </th> 
<td><code><?php echo gmdate(__('Y-m-d g:i:s a')); ?></code></td> 
</tr>
<tr>
<th scope="row"><?php _e('Times in the blog should differ by:') ?> </th>
<td><input name="gmt_offset" type="text" id="gmt_offset" size="2" value="<?php form_option('gmt_offset'); ?>" />
<?php _e('hours') ?> (<?php _e('Your timezone offset, for example <code>-6</code> for Central Time.'); ?>)</td>
</tr>
<tr>
<th scope="row"><?php _e('Default date format:') ?></th>
<td><input name="date_format" type="text" id="date_format" size="30" value="<?php form_option('date_format'); ?>" /><br />
<?php _e('Output:') ?> <strong><?php echo mysql2date(get_option('date_format'), current_time('mysql')); ?></strong></td>
</tr>
<tr>
<th scope="row"><?php _e('Default time format:') ?></th>
<td><input name="time_format" type="text" id="time_format" size="30" value="<?php form_option('time_format'); ?>" /><br />
<?php _e('Output:') ?> <strong><?php echo gmdate(get_option('time_format'), current_time('timestamp')); ?></strong></td>
</tr>
<tr>
<th scope="row">&nbsp;</th>
<td><?php _e('<a href="http://codex.wordpress.org/Formatting_Date_and_Time">Documentation on date formatting</a>. Click "Update options" to update sample output.') ?> </td>
</tr>
<tr>
<th scope="row"><?php _e('Weeks in the calendar should start on:') ?></th>
<td><select name="start_of_week" id="start_of_week">
<?php
for ($day_index = 0; $day_index <= 6; $day_index++) :
	$selected = (get_option('start_of_week') == $day_index) ? 'selected="selected"' : '';
	echo "\n\t<option value='$day_index' $selected>" . $wp_locale->get_weekday($day_index) . '</option>';
endfor;
?>
</select></td>
</tr>
</table>
</fieldset>

<p class="submit"><input type="submit" name="Submit" value="<?php _e('Update Options &raquo;') ?>" />
<input type="hidden" name="action" value="update" />
<input type="hidden" name="page_options" value="blogname,blogdescription,new_admin_email,users_can_register,gmt_offset,date_format,time_format,start_of_week,comment_registration,WPLANG,language" />
</p>
</form>

</div>

<?php include('./admin-footer.php') ?>

<?
if ( $def['GOOGLE_ANALYTICS_ID'] != '')
{
?>
	<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
	<script type="text/javascript">
		_uacct = "<?=$def['GOOGLE_ANALYTICS_ID']?>";
		urchinTracker();
	</script>
<?}?>
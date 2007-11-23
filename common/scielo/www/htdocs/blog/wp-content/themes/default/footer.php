
<?php $current_site = get_current_site(); ?>
<hr />
<div id="footer">
<!-- If you'd like to support WordPress, having the "powered by" link somewhere on your blog is the best way; it's our only promotion or advertising. -->
	<p>
		<?php bloginfo('name'); ?> is proudly powered by
		<a href="http://mu.wordpress.org/">WordPress MU</a> running on <a href="http://<?php echo $current_site->domain . $current_site->path ?>"><?php echo $current_site->site_name ?></a>. <a href="http://<?php echo $current_site->domain . $current_site->path ?>wp-signup.php" title="Create a new blog">Create a new blog</a> and join in the fun!
		<br /><a href="<?php bloginfo('rss2_url'); ?>">Entries (RSS)</a>
		and <a href="<?php bloginfo('comments_rss2_url'); ?>">Comments (RSS)</a>.
		<!-- <?php echo get_num_queries(); ?> queries. <?php timer_stop(1); ?> seconds. -->
	</p>
</div>
</div>

<!-- Gorgeous design by Michael Heilemann - http://binarybonsai.com/kubrick/ -->
<?php /* "Just what do you think you're doing Dave?" */ ?>

		<?php wp_footer(); ?>
</body>
</html>

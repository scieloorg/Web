<?php get_header(); ?>

<div id="content" class="widecolumn">
				
<h2>WordPress &micro;</h2>
<p>This is a <a href="http://mu.wordpress.org/">WordPress Mu</a> powered site.</p>
<p>You can: <ul><li> <a href="wp-login.php">Login</a> </li><li> <a href="wp-signup.php">Create a new blog</a></li><li> Edit this file at <code>wp-content/themes/home/home.php</code> with your favourite text editor and customize this screen.</li></ul></p>
<h3>The Latest News</h3>
<ul>
<strong>Site News</strong>
<?php 
query_posts('showposts=7');
if (have_posts()) : ?><?php while (have_posts()) : the_post(); ?>
<li><a href="<?php the_permalink() ?>" rel="bookmark" title="Permanent Link to <?php the_title(); ?>"><?php the_title();?> </a></li>
<?php endwhile; ?><?php endif; ?>
</ul>
<?php
$blogs = get_last_updated();
if( is_array( $blogs ) ) {
	?>
	<ul>
	<strong>Updated Blogs</strong>
	<?php foreach( $blogs as $details ) {
		?><li><a href="http://<?php echo $details[ 'domain' ] . $details[ 'path' ] ?>"><?php echo get_blog_option( $details[ 'blog_id' ], 'blogname' ) ?></a></li><?php
	}
	?>
	</ul>
	<?php
}
?>
</div>

<?php get_footer(); ?>

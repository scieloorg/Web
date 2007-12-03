<?php // Do not delete these lines
	if ('comments.php' == basename($_SERVER['SCRIPT_FILENAME']))
		die ('Please do not load this page directly. Thanks!');

		

	if (!empty($post->post_password)) { // if there's a password
		if ($_COOKIE['wp-postpass_' . COOKIEHASH] != $post->post_password) {  // and it doesn't match the cookie
			?>

			<p class="nocomments">This post is password protected. Enter the password to view comments.</p>

			<?php
			return;
		}
	}

	/* This variable is for alternating comment background */
	$oddcomment = 'class="alt" ';
?>

<!-- You can start editing here. -->

<?php if ($comments) : ?>
	<h3 id="comments"><?php //comments_number('No Responses', 'One Response', '% Responses' );?> to &#8220;<?php the_title(); ?>&#8221;</h3>

	<ol id="ajax" class="commentlist">

	<?php foreach ($comments as $comment) : ?>
		
		
		<li style="width:70%; margin-top:5px; margin-left:-18px; background:#f7f8f7;" <?php echo $oddcomment; ?>id="comment-<?php comment_ID() ?>"
			<div style="color:#990000; font-family:Trebuchet; font-weight:bold; padding:10px">
				<? if($_COOKIE['clientLanguage']=="pt"){echo utf8_encode("Comentário enviado por:");}else if($_COOKIE['clientLanguage']=="es"){echo "Comentario em espanhol:";}else{echo "Comments send from:";} ?>
				<?php comment_author() ?> 
				<?php if ($comment->comment_approved == '0') : ?>
				<? if($_COOKIE['clientLanguage']=="pt"){echo utf8_encode("aguardando aprovação.");}else if($_COOKIE['clientLanguage']=="es"){echo "aguardando aprovacao (espanhol).";}else{echo "wait aprove.";} ?>
				<? //echo var_dump($_COOKIE)."teste"; ?>
				<?php endif; ?>
				<div style="color:#000000; font-weight:normal; font-family:Trebuchet;">
				<?php comment_text() ?></div>
			</div>

		</li>

	<?php
		/* Changes every other comment to a different class */
		$oddcomment = ( empty( $oddcomment ) ) ? 'class="alt" ' : '';
	?>

	<?php endforeach; /* end for each comment */ ?>

	</ol>


 <?php else : // this is displayed if there are no comments so far ?>

	<?php if ('open' == $post->comment_status) : ?>
		<!-- If comments are open, but there are no comments. -->

	 <?php else : // comments are closed ?>
		<!-- If comments are closed. -->
		<p class="nocomments">Comments are closed.</p>

	<?php endif; ?>
<?php endif; ?>



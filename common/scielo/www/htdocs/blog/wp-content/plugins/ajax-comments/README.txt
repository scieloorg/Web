AJAX Comments 2.07 by Mike Smullin
http://www.mikesmullin.com/2006/06/05/ajax-comments-20/

Post comments quickly without leaving or refreshing the page.

--------------------------------------------------------------

Demo:

I install most of the plugins I create on my own blog. In this case, feel free to use the comment form to see AJAX Comments in action!

Features:

    * comment form validation happens server-side without refreshing or leaving the page
    * Script.aculo.us Fade In/Out Effects make readers happy
    * works with AuthImage captcha word verification plug-in to prevent comment spam
    * still works traditionally if browsers don’t support JavaScript (or have it disabled)
    * uses existing theme code to match styled comment threads when producing new comments
    * 25-second server timeout ensures readers aren’t left hanging
    * works in current versions of Firefox, Internet Explorer, Opera, Netscape, and Safari.

Recommendations:

    * perfectly compliments any well-styled comment form design--don’t design without it
    * best when moderation is off (seems more real-time) and AuthImage is installed (self-moderation is the best moderation)

License:

No license; feel free to implement for a smooth combination of AJAX functionality via Prototype and yummy Script.aculo.us Effects whenever you like.

Plugin Installation:

   1. Unzip/upload to /plugins directory.
   2. Activate via WordPress Plugins tab.

AuthImage Integration:

   1. Open ajax-comments.php and uncomment lines: 92, 152, 153.
   2. Open comments.php from your /themes directory and use the
      following code (mostly just the ids) for AuthImage to appear
      in your comments form:

<?php if ( !$user_ID ) : ?>

<p><img id="auth-image" src="<?php echo get_option('siteurl'); ?>/wp-content/plugins/authimage/authimage-inc/image.veriword.php" alt="Verification Image" /></p>
<p><label for="code">Word Verification (<a href="#" onclick="document.getElementById('auth-image').src+='?'+Math.random();return false" title="Generate another Captcha Word Verification image.">can't read it? try another!</a>)</label></p>
<p>Please type the letters you see in the picture.</p>
<p><input name="code" id="code" type="text" class="text" tabindex="5" /></p>

<?php endif; ?>

Feedback:

Write to mike_smullin@yahoo.com
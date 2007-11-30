<?php
/*
Plugin Name: AJAX Comments
Version: 2.07
Plugin URI: http://www.mikesmullin.com/2006/06/05/ajax-comments-20/
Description: Post comments quickly without leaving or refreshing the page.
Author: Mike Smullin
Author URI: http://www.mikesmullin.com
*/

if(!function_exists('get_option'))
  require_once('../../../wp-config.php');

define('PLUGIN_AJAXCOMMENTS_FILE', 'ajax-comments.php');
define('PLUGIN_AJAXCOMMENTS_PATH', '/wp-content/plugins/ajax-comments/');

// Echo Dynamic JavaScript (.js)
if(strstr($_SERVER['PHP_SELF'], PLUGIN_AJAXCOMMENTS_PATH.PLUGIN_AJAXCOMMENTS_FILE)
   && isset($_GET['js'])):
header("Content-Type:text/javascript"); ?>
var ajax_comment_loading = false;

//*****************************************
var quant=0;
//*****************************************

function ajax_comments_loading(on) { if(on) {
  ajax_comment_loading = true;
  var f = $('commentform');
  f.submit.disabled = true; // disable submitS
  new Insertion.Before(f, '<div id="ajax_comments_loading" style="display:none;">Adicionando</div>'); // create loading

  var l = $('ajax_comments_loading');
  new Effect.Appear(l, { beforeStart: function() { with(l.style) {
    display = 'block';
    margin = '0 auto';
    width = '100px';
    font = 'normal 12px Arial';
    background = 'url(<?=get_settings('siteurl').PLUGIN_AJAXCOMMENTS_PATH?>loading.gif) no-repeat 0 50%';
    padding = '0 0 0 23px';
  }}});
} else {
	//alert('Teste');
    new Effect.Fade('ajax_comments_loading', { afterFinish: function() { // hide loading
    Element.remove('ajax_comments_loading'); // dystroy loading
  }});
  $('commentform').submit.disabled = false; // enable submit
  ajax_comment_loading = false;
}}

function rotate_auth_image() {
  var img = $('auth-image'), input = $('code');
  if(img) img.src += '?'+Math.random(); // Change AuthImage
  if(input) input.value = ''; // Reset Code
}

function find_commentlist() {
  var e = $('commentlist');
  if(e == null) {
    var e = document.getElementsByTagName('ol');
    for(var i=0; i<e.length; i++)
      if(e[i].className=='commentlist')
        return e[i];
  } else return e;

  /* commentslist doesn't exist (no posts yet)
  so create it above the commentform and return it */
  var f = $('commentform');
  new Insertion.Before(f, '<ol id="commentlist"></ol>'); // create commentform
  return $('commentlist');
}


function ajax_comments_submit() {


if(quant>=1){

//*****************************************
 //alert(quant);
 //*****************************************
 document.getElementById('commentlist').innerHTML="";
 //*****************************************

  if(ajax_comment_loading) return false;

  ajax_comments_loading(true);
  var f = $('commentform'), ol = find_commentlist();
  new Ajax.Request('<?=get_settings('siteurl').PLUGIN_AJAXCOMMENTS_PATH.PLUGIN_AJAXCOMMENTS_FILE?>?submit', {
    method: 'post',
    asynchronous: true,
    postBody: Form.serialize(f),
    onLoading: function(request) {
      request['timeout_ID'] = window.setTimeout(function() {
        switch (request.readyState) {
        case 1: case 2: case 3:
          request.abort();
          alert('Comment Error: Timeout\nThe server is taking a long time to respond. Try again in a few minutes.');
          break;
        }
      }, 25000);
    },
    onFailure: function(request) {
      alert((request.status!=406? 'Comment Error '+request.status+' : '+request.statusText+'\n' : '')+request.responseText);
    },
    onComplete: function(request) { ajax_comments_loading(false);
      window.clearTimeout(request['timeout_ID']);
//      rotate_auth_image(); // AuthImage
      if(request.status!=200){ return;}
	   else{
	   quant = quant + 1;
	   //alert(quant);
	   }
   	   //*****************************************
		
       // Reset comment
       // f.comment.value=''; 
	   //*****************************************
	   //document.getElementById('author').value="";
 	   //document.getElementById('email').value="";
       document.getElementById('comment').value="";
  	   //*****************************************

      f.comment.value=''; // Reset comment

      new Insertion.Bottom(ol, request.responseText);
      var li = ol.lastChild, className = li.className, style = li.style;
      new Effect.BlindDown(li, {
        //*****************************************
	    <!--removido param afterFinish: function() { li.className = className; li.style = style; }-->
	   //*****************************************
        afterFinish: function() { li.className = className; }
      });
    }
  });
  return false;

  }else{

	alert(quant);
    if(ajax_comment_loading) return false;

  ajax_comments_loading(true);
  var f = $('commentform'), ol = find_commentlist();
  new Ajax.Request('<?=get_settings('siteurl').PLUGIN_AJAXCOMMENTS_PATH.PLUGIN_AJAXCOMMENTS_FILE?>?submit', {
    method: 'post',
    asynchronous: true,
    postBody: Form.serialize(f),
    onLoading: function(request) {
      request['timeout_ID'] = window.setTimeout(function() {
        switch (request.readyState) {
        case 1: case 2: case 3:
          request.abort();
          alert('Comment Error: Timeout\nThe server is taking a long time to respond. Try again in a few minutes.');
          break;
        }
      }, 25000);
    },
    onFailure: function(request) {
      alert((request.status!=406? 'Comment Error '+request.status+' : '+request.statusText+'\n' : '')+request.responseText);
    },
    onComplete: function(request) { ajax_comments_loading(false);
      window.clearTimeout(request['timeout_ID']);
//      rotate_auth_image(); // AuthImage
      if(request.status!=200){ return;}
	   else{
	   quant = quant + 1;
	   //alert(quant);
	   }
   	   //*****************************************
		
       // Reset comment
       // f.comment.value=''; 
	   //*****************************************
	   //document.getElementById('author').value="";
 	   //document.getElementById('email').value="";
       document.getElementById('comment').value="";
  	   //*****************************************

      f.comment.value=''; // Reset comment

      new Insertion.Bottom(ol, request.responseText);
      var li = ol.lastChild, className = li.className, style = li.style;
      new Effect.BlindDown(li, {
		//*****************************************
	    <!--removido param afterFinish: function() { li.className = className; li.style = style; }-->
	   //*****************************************
        afterFinish: function() { li.className = className; }
      });
    }
  });
  return false;
  }
}
<?php endif;


// Receive AJAX requests
// and return a new comment LI element
if(strstr($_SERVER['PHP_SELF'], PLUGIN_AJAXCOMMENTS_PATH.PLUGIN_AJAXCOMMENTS_FILE)
   && isset($_GET['submit'])):
  global $comment, $comments, $post, $wpdb, $user_ID, $user_identity, $user_email, $user_url;
  
  function fail($s) { header('HTTP/1.0 406 Not Acceptable'); die($s); }

	/******************************************/
	//$wpdb->posts = $_REQUEST['post'];


  // trim and decode all POST variables
 
  //foreach($_POST as $k => $v)
    $_POST[$k] = trim(urldecode($v));

  // extract & alias POST variables
   extract($_POST, EXTR_PREFIX_ALL, '');
	 
	$wpdb->posts = "wp_".$_blogId."_posts";
	//fail($_comment.$_blogId.$_email.$_url);
	$wpdb->comments = "wp_".$_blogId."_comments";
	//fail($_POST['_comment']);
	//fail($_REQUEST['_comment']);

  // get the post comment_status {$wpdb->posts}
  $post_status = $wpdb->get_var("SELECT comment_status FROM {$wpdb->posts} WHERE ID = '".$wpdb->escape($_comment_post_ID)."' LIMIT 1;");
 //echo ("SELECT comment_status FROM {$wpdb->posts} WHERE ID = '".$wpdb->escape($_comment_post_ID)."' LIMIT 1;");
  if ( empty($post_status) ) // make sure the post exists
	//fail($wpdb->posts);
    fail("That post doesn't even exist! Id post: ".$post_status);
  if ( $post_status == 'closed' ) // and the post is not closed for comments
    fail("Sorry, comments are closed.");

  // if the user is already logged in
  //get_currentuserinfo();
  if ( $user_ID ) {
    $_author = addslashes($user_identity); // get their name
    $_email = addslashes($user_email); // email
    $_url = addslashes($user_url); // and url
  } else if ( get_option('comment_registration') ) // otherwise, if logging in is required
    fail("Sorry, you must login to post a comment.");

  // if a Name and Email Address are required to post comments
  if ( get_settings('require_name_email') && !$user_ID )
    if ( $_author == '' ){ // make sure the Name isn't blank
	   if($_POST['lang']=='pt'){
			fail("Você esqueceu de preencher o seu nome!");
		}else if($_POST['lang']=='en'){	
			 fail('You forgot to fill-in your Name!');
		}else{
			fail("Si te olvidaste de relleno en su Nombre!");
		}
  }elseif ( $_email == '' ){ // make sure the Email Address isn't blank
		 if($_POST['lang']=='pt'){
			fail("Você esqueceu de preencher o email!");
		}else if($_POST['lang']=='en'){	
			 fail('You forgot to fill-in your Email Address!');
		}else{
			fail("Si te olvidaste de relleno en su Dirección de correo electrónico!");
		}
  }elseif ( !is_email($_email) ){ // make sure the Email Address looks right
		  if($_POST['lang']=='pt'){
			fail("Seu e-mail esta inválido. Por favor tente outro.");
		}else if($_POST['lang']=='en'){	
			 fail('Your Email Address appears invalid. Please try another.');
		}else{
			fail("Su dirección de correo electrónico aparece inválido. Por favor, pruebe con otra.");
		}
  }
  if ( $_comment == '' ){ // make sure the Comment isn't blank
	  if($_POST['lang']=='pt'){
			fail("Você esqueceu de preencher seu comentário!");
		}else if($_POST['lang']=='en'){	
			 fail('You forgot to fill-in your Comment!');
		}else{
			fail("Si te olvidaste de relleno en su comentario!");
		}
  }
  // Simple duplicate check
  if($wpdb->get_var("
  SELECT comment_ID FROM {$wpdb->comments}
  WHERE comment_post_ID = '".$wpdb->escape($_comment_post_ID)."'
    AND ( comment_author = '".$wpdb->escape($_author)."'
  ".($_email? " OR comment_author_email = '".$wpdb->escape($_email)."'" : "")."
  ) AND comment_content = '".$wpdb->escape($_comment)."'
  LIMIT 1;")){
		if($_POST['lang']=='pt'){
			fail("Você falou isso antes.!");
		}else if($_POST['lang']=='en'){	
			 fail("You've said that before. No need to repeat yourself.!");
		}else{
			fail("Usted ha dicho que antes. No hay necesidad de repetir a ti mismo.!");
		}
  }
  // Simple flood-protection
  if ( $lasttime = $wpdb->get_var("SELECT comment_date_gmt FROM $wpdb->comments WHERE comment_author_IP = '$comment_author_IP' OR comment_author_email = '".$wpdb->escape($_email)."' ORDER BY comment_date DESC LIMIT 1") ) {
    $time_lastcomment = mysql2date('U', $lasttime);
    $time_newcomment  = mysql2date('U', current_time('mysql', 1));

    if ( ($time_newcomment - $time_lastcomment) < 15 ) {
      do_action('comment_flood_trigger', $time_lastcomment, $time_newcomment);
      
		if($_POST['lang']=='pt'){
			fail("Desculpe, mas você só pode postar um novo comentário uma vez a cada 15 segundos.");
		}else if($_POST['lang']=='en'){	
			 fail("Sorry, you can only post a new comment once every 15 seconds. Slow down cowboy.");
		}else{
			fail("Lo siento, sólo puede enviar un nuevo comentario una vez cada 15 segundos.");
		}
    }
  }

  // insert comment into WordPress database

function wp_insert_comment_ajax($commentdata) {
	global $wpdb;
	extract($commentdata, EXTR_SKIP);

	if ( ! isset($comment_author_IP) )
		$comment_author_IP = preg_replace( '/[^0-9., ]/', '',$_SERVER['REMOTE_ADDR'] );
	if ( ! isset($comment_date) )
		$comment_date = current_time('mysql');
	if ( ! isset($comment_date_gmt) )
		$comment_date_gmt = get_gmt_from_date($comment_date);
	if ( ! isset($comment_parent) )
		$comment_parent = 0;
	if ( ! isset($comment_approved) )
		//Alterado
		$comment_approved = 0;
	if ( ! isset($user_id) )
		$user_id = 0;

	$result = $wpdb->query("INSERT INTO ".$comment_blog_ID."
	(comment_post_ID, comment_author, comment_author_email, comment_author_url, comment_author_IP, comment_date, comment_date_gmt, comment_content, comment_approved, comment_agent, comment_type, comment_parent, user_id)
	VALUES
	('$comment_post_ID', '$comment_author', '$comment_author_email', '$comment_author_url', '$comment_author_IP', '$comment_date', '$comment_date_gmt', '$comment_content', '$comment_approved', '$comment_agent', '$comment_type', '$comment_parent', '$user_id')
	");

	$id = (int) $wpdb->insert_id;

	if ( $comment_approved == 1)
		wp_update_comment_count($comment_post_ID);
	return $id;
}

$idReturnInsert = wp_insert_comment_ajax(array(
 	'comment_blog_ID' => "wp_".$_blogId."_comments",
	'comment_post_ID' => $_comment_post_ID,
    'comment_author' => $_author,
    'comment_author_email' => $_email,
    'comment_author_url' => $_url,
    'comment_content' => $_comment,
    'comment_type' => '',
    'user_ID' => $user_ID
  ));

  // if the user is not already logged in and wants to be Remembered
  if ( !$user_ID && isset($_remember) ) { // remember cookie
    //setcookie('comment_author_' . COOKIEHASH, $_author, time() + 30000000, COOKIEPATH, COOKIE_DOMAIN);
    //setcookie('comment_author_email_' . COOKIEHASH, $_email, time() + 30000000, COOKIEPATH, COOKIE_DOMAIN);
    //setcookie('comment_author_url_' . COOKIEHASH, $_url, time() + 30000000, COOKIEPATH, COOKIE_DOMAIN);
	//setcookie('lang', "en", time() + 30000000, COOKIEPATH, COOKIE_DOMAIN);
  } else { // forget cookie
    //setcookie('comment_author_' . COOKIEHASH, '', time() - 30000000, COOKIEPATH, COOKIE_DOMAIN);
    //setcookie('comment_author_email_' . COOKIEHASH, '', time() - 30000000, COOKIEPATH, COOKIE_DOMAIN);
    //setcookie('comment_author_url_' . COOKIEHASH, '', time() - 30000000, COOKIEPATH, COOKIE_DOMAIN);
	//setcookie('lang', "en", time() + 30000000, COOKIEPATH, COOKIE_DOMAIN);
  }
	
	

  // grab comment as it exists in the WordPress database (after being manipulated by wp_new_comment())
  //$comment = $wpdb->get_row("SELECT * FROM {$wpdb->comments} WHERE comment_ID = {$wpdb->insert_id} LIMIT 1;");
  $comment = $wpdb->get_row("SELECT * FROM {$wpdb->comments} WHERE comment_ID = {$idReturnInsert} LIMIT 1;");
  //echo "SELECT * FROM {$wpdb->comments} WHERE comment_ID = ".$idReturnInsert."} LIMIT 1;";
  $commentcount = $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->comments} WHERE comment_post_ID = '".$wpdb->escape($_comment_post_ID)."' LIMIT 1;");
  $post->comment_status = $wpdb->get_var("SELECT comment_status FROM {$wpdb->posts} WHERE ID = '".$wpdb->escape($_comment_post_ID)."' LIMIT 1;");

  // scrape templated comment HTML from /themes directory
  ob_start(); // start buffering output
  $comments = array($comment); // make it look like there is one comment to be displayed
  include(TEMPLATEPATH.'/comments.php'); // now ask comments.php from the themes directory to display it
  $commentout = ob_get_clean(); // grab buffered output
  preg_match('#<li(.*?)>(.*)</li>#ims', $commentout, $matches); // Regular Expression cuts out the LI element's HTML

  // return comment HTML to XML HTTP Request object
  echo '<li '.$matches[1].' style="display:none">'.$matches[2].'</li>';
	/*if($_POST['lang']=='pt'){
		fail("Sua mensagem foi adicionada com sucesso aguarde aprovação");
	}else if($_POST['lang']=='en'){	
		fail("Your message has been successfully added wait approval");
	}else{
		fail("Su mensaje se ha añadido la aprobación de espera");
	}*/
  exit;
endif;


add_action('wp_head','ajax_comments_js'); // Set Hook for outputting JavaScript
function ajax_comments_js() { if(is_single()): ?>
<script type="text/javascript" src="<?=get_settings('siteurl').PLUGIN_AJAXCOMMENTS_PATH?>scriptaculous/prototype.js"></script>
<script type="text/javascript" src="<?=get_settings('siteurl').PLUGIN_AJAXCOMMENTS_PATH?>scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="<?=get_settings('siteurl').PLUGIN_AJAXCOMMENTS_PATH.PLUGIN_AJAXCOMMENTS_FILE?>?js"></script>
<? endif; }

add_action('comment_form','ajax_comments_inline_js');
function ajax_comments_inline_js() { ?>
<script type="text/javascript"><!--
$('commentform').onsubmit = ajax_comments_submit;
//--></script>
<? }
?>
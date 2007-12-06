<?php
ini_set("display_errors","1");
error_reporting(E_ALL ^E_NOTICE);
$lang = isset($_REQUEST['lang'])?($_REQUEST['lang']):"";
$pid = isset($_REQUEST['pid'])?($_REQUEST['pid']):"";
$defFile = parse_ini_file(dirname(__FILE__)."/../../scielo.def");
require_once(dirname(__FILE__)."/../../applications/scielo-org/users/functions.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/users/langs.php");
require_once(dirname(__FILE__)."/../../classDefFile.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/services/ArticleServices.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/wpPosts.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/classes/wpBlog.php");
require_once(dirname(__FILE__)."/../../applications/scielo-org/sso/header.php");

	$applServer = $defFile["SERVER_SCIELO"];
	$wordpress =  $defFile["WORDPRESS"];
	$databasePath = $defFile["PATH_DATABASE"];
	$flagLog  = $defFile["ENABLE_SERVICES_LOG"];

	//getting metadatas from PID
	$articleService = new ArticleService($applServer);
	$articleService->setParams($pid);
	$article = $articleService->getArticle();
	$ArticleDAO = new articleDAO();

	$insertDate = date('Y-m-d h:i:s');
	$acron = $_REQUEST["acron"];
	$BlogDAO = new wpBlogDAO();
	$PostsDAO = new wpPostsDAO();

	$guidUrl = "http://".$_SERVER["SERVER_NAME"]."/blog/".$acron."/".substr($insertDate,0,4)."/".substr($insertDate,5,2)."/".substr($insertDate,8,2)."/".$article->getPID()."/";
	$guiSubmit = "http://".$_SERVER["SERVER_NAME"]."/blog/".$acron."/wp-comments-post.php";

	$Post = new wpPosts();
	$Post->setPostName($article->getPID());
	$Post->setPostGuid($guidUrl);
	$Post->setPostDate($insertDate);
	//Tratamento title
	$title = str_replace("<![CDATA[","",$article->getTitle());
	$title = str_replace("]]>","",$title);
	$Post->setPostTitle(ereg_replace("<[^>]*>", "",$title));
	$Post->setPostAuth("1");
	$Post->setPostDateGmt($insertDate);
	$Post->setPostContent("");
	$Post->setPostCategory("0");
	$Post->setPostStatus("publish");
	$Post->setPingStatus("open");
	$Post->setPostModified($insertDate);
	$Post->setPostModifiedGmt($insertDate);
	$Post->setPostParent("0");
	$Post->setMenuOrder("0");
	$Post->setCommentCount("0");
	$Post->setCommentStatus("1");

	$blogId = $BlogDAO->getBlogIdByName($acron);
	$blogTable = "wp_".$blogId."_posts";

		if($ArticleDAO->getArticleByPID($article->getPID())){
			if($ArticleDAO->getWpPostByID($article->getPID())){
				$postDate = $ArticleDAO->getPostDate($article->getPID());
				//redefinindo a url 
				$guidUrl = "http://".$_SERVER["SERVER_NAME"]."/blog/".$acron."/".substr($postDate,0,4)."/".substr($postDate,5,2)."/".substr($postDate,8,2)."/".$article->getPID()."/";
			}else{
				if ($blogId != 0){ 
					//verifica se blog da revista já existe.
					$addedPostId = $PostsDAO->addPost($Post,$blogId);
					$article->setWpPostID($addedPostId);
					$article->setWpURL($guidUrl);		
					$article->setWpPostDate($insertDate);
					//Pesquisa o ID do Blog
					$ArticleDAO->updatePosts($article,$blogId);
				}
			}
		}else{
				if ($blogId != 0){ //verifica se blog da revista já existe.
					//Adiciona o post 
					$addedPostId = $PostsDAO->addPost($Post,$blogId);
					$article->setWpPostID($addedPostId);
					$article->setWpURL($guidUrl);
					$article->setWpPostDate($insertDate);
					//Pesquisa o ID do Blog
					$ArticleDAO->AddArticle($article);
				}

		}
?>

<!DOCTYPE html
PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html>
<head>
<!-- Adicionado script para passar a utilizar o serviço de ajax comentado por Jamil Atta Junior (jamil.atta@bireme.org)-->
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<script type="text/javascript" src="/blog/wp-content/plugins/ajax-comments/scriptaculous/prototype.js"></script>
<script type="text/javascript" src="/blog/wp-content/plugins/ajax-comments/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" 
src="/blog/wp-content/plugins/ajax-comments/ajax-comments.php?js"></script>

<link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>

<!-- Adicionado script para passar a utilizar o serviço de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)-->
<script language="javascript" src="/../../applications/scielo-org/js/httpAjaxHandler.js"></script>
</head>
<body>
<div class="container">
<div class="level2">
<div class="bar">
</div>
<div class="top">
<div id="parent">
<img src="/img/<?=$lang?>/scielobre.gif" alt="SciELO - Scientific Electronic Library Online"/>
</div>
<div id="identification">
<h1>
	<span>
		SciELO - Scientific Electronic Library Online
	</span>
</h1>
</div>
</div>
<div class="middle">
<div id="collection">
<h3>
	<span>
		<?=COMMENTS_ARTICLE?> 
	</span>
	
	<?
		//Verificando se o User esta logado
		if($_COOKIE["userID"] && $_COOKIE["userID"]!=-2 && $blogId!=0){
	?>
	<span class="addSpanAnchor">
		<A HREF="#add" class="addCommentAnchor"><?=COMMENTS_ADD?></A>
	</span>
	<?
		}
	?>
</h3>
<div class="content">
<form action="<?php echo $guiSubmit; ?>" method="post" id="commentform">
	<TABLE border="0" cellpadding="0" cellspacing="2" width="700" align="center">
	<TR>
		<TD colspan="2">
			<h3><span style="font-weight:100;font-size: 70%; background:none;">
			<?php
			$author = getAutors($article->getAuthorXML());
			$pos = strrpos($author, ";");
			$author[$pos] = " ";

			echo $author;
			echo '<i><b>';
			echo (getTitle($article->getTitle(), $lang).". ");
			echo ('</b></i>');
			echo ($article->getSerial(). ', '.$article->getYear().', vol.'.$article->getVolume());
			echo (', n. '.$article->getNumber().', ISSN '.substr($article->getPID(),1,9).'.<br/><br/>'."\n");
			?>
			</span></h3>
		</TD>
	</TR>
	<TR>
		<TD colspan="2">
		<?php
			//Alterar URL para busca os comments por artigo
				if($blogId!=0){
					$serviceUrl =  $guidUrl."feed/";	
					//echo $serviceUrl;
					$xmlFile = file_get_contents($serviceUrl);
					$xml = '<?xml version="1.0" encoding="utf-8"?>';
					$xml .='<root>';
					$xml .='<vars><htdocs>'.$htdocsPath.'</htdocs><lang>'.$lang.'</lang><applserver>'. $wordpress .'</applserver><service_log>'.$flagLog.'</service_log></vars>';
					$xml .= str_replace('<?xml version="1.0" encoding="UTF-8"?><!-- generator="wordpress/2.3.1" -->','',$xmlFile);
					$xml .='</root>';
					if($_REQUEST['debug'] == 'on'){
						die($xml);
					}else if($_REQUEST['debug'] == 'xml'){
						header("Content-type:text/xml; charset=utf-8\n");
						echo ($xml);
					}

					$xsl = $defFile["PATH_XSL"]."comments.xsl";
					
					$transformer = new XSLTransformer();

					if (getenv("ENV_SOCKET")!="true"){  //socket
						$xsl = file_get_contents($xsl);
						//die("socket = false");
					} else {
						$xsl = 'COMMENTS';
					}
					//die("socket = true");

					$transformer->setXslBaseUri($defFile["PATH_XSL"]);
					$transformer->setXML($xml);
					$transformer->setXSL($xsl);
					$transformer->transform();
					$output = $transformer->getOutput();
					$output = str_replace('&amp;','&',$output);
					$output = str_replace('&slt;','<',$output);
					$output = str_replace('&gt;','>',$output);
					$output = str_replace('&quot;','"',$output);
					$output = str_replace('<p>',' ',$output);
					$output = str_replace('</p>',' ',$output);
					echo $output;
			}
		?>
		</TD>
	</TR>
	<TR>
<TD colspan="2" >
<div id="commentimage"></div>
<ol id="commentlist"></ol>
<? 
	//Verificando se o User esta logado e se o blog existe 
	if($_COOKIE["userID"] && $_COOKIE["userID"]!=-2 && $blogId!=0){?>
		<h3>
			<span class="addComments">
				<A NAME="add"></A>
				<?
				$quotes = array("(",")");
				$comments = str_replace($quotes,"",COMMENTS_ADD);
				echo $comments;
				?>
			</span>		
		</h3>
					<input type="hidden" name="blogId" value="<?=$blogId?>"/>
					<input type="hidden" name="comment_post_ID" value="<?php echo $ArticleDAO->getWpPostByIDValue($article->getPID());?>" />
					<input type="hidden" name="lang" value="<?=$lang ?>" />
		<TR>
			<TD align="right" width="0" valign="top">
			</TD>
			<TD>
			</TD>
		</TR>
		<TR>
			<TD height="15">
			</TD>
		</TR>
		<TR>
			<TD  align="right" width="0">
				<span>
					<?=COMMENTS_USER_AUTHOR?>
				</span>
			</TD>
			<TD><!---->
				<input type="text" name="author" id="author" value="<?=$_COOKIE["firstName"]?>" size="22" tabindex="1"  />
			</TD>
		</TR>
		<TR>
			<TD  align="right">
				
				<span>
					<?=COMMNETS_USER_EMAIL?>
				</span>
			</TD>
			<TD><!---->
				<input type="text" name="email" id="email" value="<?=$_COOKIE["email"]?>" size="30" tabindex="2" />
			</TD>
		</TR>
		<TR>
			<TD  align="right" valign="top">
				<?=COMMNETS_USER_COMMENT?>
			</TD>
			<TD>
				<p><textarea name="comment" id="comment" cols="70%" rows="10" tabindex="3"></textarea></p>
			</TD>
		</TR>
		
		<TR>
			<TD height="10" align="right">
			
			</TD>
			<TD height="10" align="left">
			<input name="submit" type="submit" id="submit" class="submit" tabindex="5" value="<?=COMMNETS_USER_BUTTON?>" />
			</TD>
		</TR>
			<TR>
			<TD >
			</TD>
			<TD >
			*campus requeridos
			</TD>
		</TR>
				<script type="text/javascript"><!--
				$('commentform').onsubmit = ajax_comments_submit;
				//--></script>	
		<?}elseif($blogId==0){
			echo COMMNETS_DONT_BLOG;
		}else{
			echo COMMNETS_MESSAGE_BLOG_INI.'<a href="http://'.$defFile["SCIELO_REGIONAL_DOMAIN"].'//applications/scielo-org/sso/loginScielo.php?lang='.$lang.'">login</a>'.COMMNETS_MESSAGE_BLOG_FIM;
		} ?>
</tr>
</td>
</TABLE>
</div>
</div>
</div>
</div>
</div>
<?
if($defFile['LOG']['ACTIVATE_LOG'] == '1') {
?>
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript"></script>
<script type="text/javascript">
_uacct = "UA-604844-1";
urchinTracker();
</script>
<?}?>
</form>
</BODY>
</HTML>

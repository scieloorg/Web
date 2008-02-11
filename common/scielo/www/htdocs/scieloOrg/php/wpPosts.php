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
			$wordpress =  $defFile["DB_WORDPRESS"];
			$databasePath = $defFile["PATH_DATABASE"];
			$flagLog  = $defFile["ENABLE_SERVICES_LOG"];
			$blogLastComment = $_REQUEST['commentID'];

			//getting metadatas from PID
			$articleService = new ArticleService($applServer);
			$articleService->setParams($pid);
			$article = $articleService->getArticle();
			$ArticleDAO = new articleDAO();
			$BlogDAO = new wpBlogDAO();
			$PostsDAO = new wpPostsDAO();

			$insertDate = date('Y-m-d h:i:s');
			$acron = $_REQUEST["acron"];

			$guidUrl = "http://".$wordpress."/".$acron."/".substr($insertDate,0,4)."/".substr($insertDate,5,2)."/".substr($insertDate,8,2)."/".$article->getPID()."/";

			$guiSubmit = "http://".$wordpress."/".$acron."/wp-comments-post.php";
			$Post = new wpPosts();
			$Post->setPostName($article->getPID());
			$Post->setPostGuid($guidUrl);
			$Post->setPostDate($insertDate);
			$title = $article->getTitle();

			/************************************************
			* Transformando e assegurando que o Title seja cadastrado em English
			************************************************/
			$posTitleEn = strpos($article->getTitle(),'"en"');
			$titleEn = substr($title, $posTitleEn);
			$title = ereg_replace("<[^>]*>", "",$titleEn);
			$title = str_replace('"en">',"",$title);
			$title = str_replace("]]>","",$title);
			$Post->setPostTitle($title);
			/************************************************/

			$Post->setPostAuth("1");
			$Post->setPostDateGmt($insertDate);

			/************************************************
			* Abstract cadastrado nas duas linguagens
			************************************************/
			$abstract = $article->getAbstractXML();
			$posAbstractpt = strpos($article->getAbstractXML(),'"pt\"');
			if($posAbstractpt){

				$abstractpt = substr($abstract, $posAbstractpt);
				$abstract = str_replace('"pt\"><![CDATA[',"",$abstractpt);
				$abstract = str_replace(']]></ABSTRACT>',"",$abstract);

			}else{

				$posAbstracten = strpos($article->getAbstractXML(),'"en\"');
				$abstracten = substr($abstract, $posAbstracten);
				$abstract = str_replace('"en\"><![CDATA[',"",$abstracten);
				$abstract = str_replace(']]></ABSTRACT>',"",$abstract);

			}
			$Post->setPostContent($abstract);
			/************************************************/
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


				if($ArticleDAO->getArticleByPID($article->getPID())){//se o artigo existe

					if($ArticleDAO->getWpPostByID($article->getPID())){//se existe o id do blog

						$postDate = $ArticleDAO->getPostDate($article->getPID());

						//redefinindo a url 
						$guidUrl = "http://".$wordpress."/".$acron."/".substr($postDate,0,4)."/".substr($postDate,5,2)."/".substr($postDate,8,2)."/".$article->getPID()."/";

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
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<script language="javascript" src="validate.js"></script>
		<link rel="stylesheet" href="/applications/scielo-org/css/public/style-<?=$lang?>.css" type="text/css" media="screen"/>
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
				if($_COOKIE["userID"] && $_COOKIE["userID"]!=-2 && $blogId!=0){
			?>
			<span class="addSpanAnchor">
				<A HREF="#add" class="addCommentAnchor"><?=COMMENTS_ADD?></A>
			</span>
			<span>
				<a class="rssComments"  target="_blank" title=<?="RSS Feed".$title ?> href=<?=$guidUrl."feed/"?>><img src=<?='"http://'.$_SERVER["SERVER_NAME"].'/img/feed.gif"'?>> </a>
			</span>
			<?
			}
			?>
</h3>
	<div class="content"> 
		<form action="<?php echo $guiSubmit?>" method="post" id="commentform" onSubmit="return validaSubmit()" >
		<TABLE border="0" cellpadding="0" cellspacing="2" width="700" align="center">
	<TR>
		<TD colspan="2">
			<h3><span style="font-weight:100;font-size: 70%; background:none;">
					<?php
					echo $guiSubmit;
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
						if($blogId!=0){

							$serviceUrl =  $guidUrl."feed/";
							$xmlFile = file_get_contents($serviceUrl);
							$xml = '<?xml version="1.0" encoding="utf-8"?>';
							$xml .='<root>';
							$xml .='<vars><lang>'.$lang.'</lang><applserver>'. $wordpress .'</applserver><service_log>'.$flagLog.'</service_log></vars>';
							$xml .= str_replace('<?xml version="1.0" encoding="UTF-8"?><!-- generator="wordpress/2.3.1" -->','',$xmlFile);
							$xml .='</root>';

							if(isset($_REQUEST['debug']))
							{

								echo '<textarea cols="100" rows="50">';
								echo $xml;
								echo '</textarea>';
								exit;

							}

							$xsl = $defFile["PATH_XSL"]."comments.xsl";
							
							$transformer = new XSLTransformer();

							if (getenv("ENV_SOCKET")!="true"){

								$xsl = file_get_contents($xsl);

							} else {

								$xsl = 'COMMENTS';

							}

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
		<?
	if(isset($blogLastComment)){?>
	<ol class="commentlist">
		<li class="liComments">
			<div class="divComments">
				<?php
				 $lastComment = $PostsDAO->getLastComment($blogId,$blogLastComment);

				 echo COMMNETS_MESSAGE_INFO_1;

				 echo $lastComment[0]['comment_author'];

				 echo COMMNETS_MESSAGE_INFO_2;

				 ?>
				<div class="divCommentText">
				<?=$lastComment[0]['comment_content'];?>
				</div>
			</div>
		</li>
	</ol>
		<?}
			if(isset($_REQUEST['erro'])){

				if($_REQUEST['erro']==1){?>

			<ol class="commentlist">
			<li class="liComments">
			<div class="divComments">
			<?=COMMNETS_MESSAGE_ERRO_1?>
			</div>
		</li>
	</ol>
				<?}elseif($_REQUEST['erro']==2){?>

				<ol class="commentlist">
			<li class="liComments">
			<div class="divComments">
			<?=COMMNETS_MESSAGE_ERRO_2?>
			</div>
		</li>
	</ol>
			<?}
		}?>
		<input type="hidden" name="blogId" value="<?=$blogId?>"/>
		<input type="hidden" name="comment_post_ID" value="<?php echo $ArticleDAO->getWpPostByIDValue($article->getPID());?>" />
		<input type="hidden" name="userID" value="<?=$_COOKIE['userID']?>"/>
			<input type="hidden" name="origem" value=<?='"http://'.$_SERVER["SERVER_NAME"].'/scieloOrg/php/wpPosts.php?pid='.$pid."&lang=".$lang."&acron=".$acron.'"'?>/>
			<!-- <? echo "blogId=".$blogId."postId=".$ArticleDAO->getWpPostByIDValue($article->getPID())."userId=".$_COOKIE['userID']; ?> -->
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
			<TD>
				<input type="text" name="author" id="author" value="<?=$_COOKIE["firstName"]?>" size="22" tabindex="1"  />
			</TD>
		</TR>
		<TR>
			<TD  align="right">
				
				<span>
					<?=COMMNETS_USER_EMAIL?>
				</span>
			</TD>
			<TD>
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
					<?=REQUIRED_FIELD_TEXT?>
					 </TD>
					 </tr>
					 <TR>
					 	<TD >
						 </TD>
						<TD >
					<?}elseif($blogId==0){

							echo COMMNETS_DONT_BLOG;

						}else{?>

							<strong>
							<div style="font-size: 10pt; font-family:Arial,Verdana;color:#990000;">
								<?
								echo COMMNETS_MESSAGE_BLOG_INI.'<a href="http://'.$defFile["SCIELO_REGIONAL_DOMAIN"].'//applications/scielo-org/sso/loginScielo.php?lang='.$lang.'">login</a>'.COMMNETS_MESSAGE_BLOG_FIM;
								?>
								<?}?>
								</div>
								</strong>
						 </TD>
					 </tr>
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

<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^ E_NOTICE);
	
	ini_set("include_path",".");

	require_once(dirname(__FILE__)."/../classes/Links.php");
	require_once(dirname(__FILE__)."/../../../php/include.php");
	require_once(dirname(__FILE__)."/langs.php");
	require_once(dirname(__FILE__)."/functions.php");
	
	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php", true);

	$home = $ini['this']['url'];

	ob_start("ob_gzhandler");
	session_start();
//variaveis do formulário
$cgi = array_merge($_GET,$_POST);

$acao = $cgi["acao"];
$linkName = $cgi["linkName"];
$linkDescription = $cgi["linkDescription"];
$linkUrl = $cgi["linkUrl"];
$linkRate = $cgi["linkRate"];
$linkInHome = ($cgi["linkInHome"]=="" ? 0 : 1);
$linkId = $cgi["linkId"];

$submitButtom = "criar";

	switch($acao)
	{
		case "gravar":	
			$link = new Links();
			$link->setLink_id($linkId);
			$link->setUser_id($_COOKIE['userID']);
			$link->setName($linkName);
			$link->setUrl($linkUrl);
			$link->setDescription($linkDescription);
			$link->setInHome($linkInHome);
			$link->setRate($linkRate);
			$linkList = $link->addLink();
				?>
					<script language="javascript">
						opener.location.reload(true);
						window.close();
					</script>
				<?
		break;
		case "editar":
			$link = new Links();
			$link->setUser_id($_COOKIE['userID']);
			$link->setLink_id($linkId);
			$linkItem = $link->getLink();
			$linkId = $linkItem[0]->getLink_Id();
			$linkName = $linkItem[0]->getName();
			$linkUrl = $linkItem[0]->getUrl();
			$linkDescription = $linkItem[0]->getDescription();
			$linkInHome = $linkItem[0]->getInHome();
			$acao = "atualizar";
			$submitButtom = "editar";
		break;
		case "atualizar":
			$link = new Links();
			$link->setLink_id($linkId);
			$link->setUser_id($_COOKIE['userID']);
			$link->setName($linkName);
			$link->setUrl($linkUrl);
			$link->setDescription($linkDescription);
			$link->setInHome($linkInHome);
			$link->setRate($linkRate);
			$linkList = $link->updateLink();
				?>
					<script language="javascript">
						opener.location.reload(true);
						window.close();
					</script>
				<?
		break;
		default:
			$acao = "gravar";
		break;
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			SciELO.org - Scientific Electronic Library Online 
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
		<meta http-equiv="Expires" content="-1" />
		<meta http-equiv="pragma" content="no-cache" />
		<meta name="robots" content="all" />
		<meta name="MSSmartTagsPreventParsing" content="true" />

		<meta name="generator" content="BVS-Site 4.0-rc4" />
		<link rel="stylesheet" href="../css/public/print.css" type="text/css" media="print" />
		<link rel="stylesheet" href="../css/public/style-pt.css" type="text/css" media="screen" />
	</head>
<?	if(!isset($_COOKIE['userID'])){?>
	<body onLoad="javascript: opener.location.reload(true); window.close()">
<?}else{?>
	<body>
<?}?>
		<div class="container">			
			<div class="top">
					<div id="parent">
						<img src="../image/public/skins/classic/pt/banner.jpg" alt="SciELO - Scientific Electronic Librery Online">

					</div>
					<div id="identification">
						<h1>
							<span>
								SciELO.org - Scientific Electronic Library Online 
							</span>
						</h1>
					</div>
			</div>	
			<div class="form">
				<h4><img src="../image/public/skins/classic/common/link_add.gif" /> <span><?=ADD_LINK?></span></h4>
				<form name="form" method="post" action="">
					<input type="hidden" name="acao" value="<?=$acao?>"/>
					<input type="hidden" name="linkID" value="<?=$linkID?>"/>					
					<table class="form" cellspacing="0">
					  <tr> 
						<td><?=LINK_TITLE?></td>
						<td> 
						  <input type="text" name="linkName" value="<?=$linkName?>" maxlength="25" size="35" class="textEntry"/>
						</td>

					  </tr>
					  <tr> 
						<td><?=LINK_URL?></td>
						<td> 
						  <input type="text" name="linkUrl" value="<?=$linkUrl?>" maxlength="60" size="35" class="textEntry"/>
						</td>
					  </tr>
					  <tr> 
						<td><?=LINK_DESCRIPTION?></td>

						<td> 
						  <textarea name="linkDescription" cols="32" rows="3"><?=$linkDescription?></textarea>
						</td>
					  </tr>
					  <tr> 
						<td><?=IN_HOME?></td>
						<td> 
						  <input type="checkbox" name="linkInHome" value="1" <?if ($linkInHome==1){?>checked="true"<?}?>/>
						</td>
					  </tr>					  
					  <tr> 
						<td></td>
						<td>
						  <input type="submit" name="<?=$submitButton?>" value="Salvar" class="submitTrue" />
						  <input type="submit" name="Submit" value="Cancelar" class="submitFalse" onClick="window.close(); " />

						</td>
					  </tr>
					</table>
				</form>
			</div>
		</div>	
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>	
</html>
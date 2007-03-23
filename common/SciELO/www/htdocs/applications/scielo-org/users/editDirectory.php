<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^ E_NOTICE);
	
	ini_set("include_path",".");

	require_once(dirname(__FILE__)."/../classes/UserDirectory.php");
	require_once(dirname(__FILE__)."/../../../php/include.php");
	require_once(dirname(__FILE__)."/langs.php");
	require_once(dirname(__FILE__)."/functions.php");
	
	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def", true);

	$home = $ini['this']['url'];

	ob_start("ob_gzhandler");
	session_start();
//variaveis do formulário
$cgi = array_merge($_GET,$_POST);

$acao = $cgi["acao"];
$directoryName = $cgi["directoryName"];
$directoryID = $cgi["directory_id"];

$submitButtom = BUTTON_CREATE;

	switch($acao)
	{
		case "gravar":	
			$directory = new UserDirectory();
			$directory->setUser_id($_COOKIE['userID']);
			$directory->setName($directoryName);
			$directoryList = $directory->addDirectory();
				?>
					<script language="javascript">
						opener.location.reload(true);
						window.close();
					</script>
				<?
		break;
		case "editar":
			$directory = new UserDirectory();
			$directory->setUser_id($_COOKIE['userID']);
			$directory->setDirectory_id($directoryID);
			$directoryItem = $directory->getDirectory($directory);
			$directoryName = $directoryItem[0]->getName();
			$acao = "atualizar";
			$submitButtom = BUTTON_EDIT;
		break;
		case "atualizar":
			$directory = new UserDirectory();
			$directory->setUser_id($_COOKIE['userID']);
			$directory->setName($directoryName);
			$directory->setDirectory_id($directoryID);
			$directoryList = $directory->updateDirectory();
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
				<form name="addDir" method="post" action="">
					<input type="hidden" name="acao" value="<?=$acao?>"/>
					<h4><img src="../image/public/skins/classic/common/folder_edit.gif" /> <span><?=EDIT_FOLDER?>:</span></h4>
					<table class="form" cellspacing="0">
						<tr> 
							<td><?=FOLDER_NAME?>:</td>
							<td class="inputArea"> 
								<input type="text" name="directoryName" value="<?=$directoryName?>" maxlength="20" size="20" class="textEntry"/>
							</td>
						</tr>
						 <tr> 
						    <td></td>
						    <td>
						      <input type="submit" value="<?=$submitButtom?>" class="submitTrue" />
							  <input type="submit" value="<?=BUTTON_CANCEL?>" class="submitFalse" onClick="window.close(); "/>
						    </td>
				  		</tr>
					</table>

				</form>
			</div>
		</div>	
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>	
</html>
<?php
	ini_set("display_errors","1");
	error_reporting(E_ALL ^ E_NOTICE);
	
	ini_set("include_path",".");

	require_once(dirname(__FILE__)."/../classes/UserDirectory.php");
	require_once(dirname(__FILE__)."/../classes/Shelf.php");
	require_once(dirname(__FILE__)."/../../../php/include.php");
	require_once(dirname(__FILE__)."/langs.php");
	require_once(dirname(__FILE__)."/functions.php");
	
	$site = parse_ini_file(dirname(__FILE__)."/../../../../ini/" . $lang . "/bvs.ini", true);
	$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def", true);
	$home = $ini['this']['url'];

	ob_start("ob_gzhandler");
	session_start();
	
	$cgi = array_merge($_GET,$_POST);
	$acao = $cgi["acao"];
	
	$user_id = $_COOKIE['userID'];
	$shelf_id = $cgi["shelf_id"];
	$directory_id = $cgi["directory_id"];
	$removeDir = $cgi["removeDir"];

		switch($acao)
		{
			case "remove":	
				$shelf = new Shelf();
				$directory = new UserDirectory();
				$shelf->setUserID($user_id);
				$shelf->setShelf_id($shelf_id);
				$shelf->setDirectory($directory_id);
				$directoryList = $shelf->deleteAllOfDirectory($removeDir);
				$directory->setDirectory_id($removeDir);
				$directory->removeDirectoryFromShelf();
				?>
					<script language="javascript">
						opener.location.reload(true);
						window.close();
					</script>
				<?
			break;
			case "move":
				$shelf = new Shelf();
				$directory = new UserDirectory();
				$shelf->setUserID($user_id);
				$shelf->setShelf_id($shelf_id);
				$shelf->setDirectory($directory_id);
				$directoryList = $shelf->moveAllToAnotherDirectory($removeDir);
				$directory->setDirectory_id($removeDir);
				$directory->removeDirectoryFromShelf();
				?>
					<script language="javascript">
						opener.location.reload(true);
						window.close();
					</script>
				<?
			break;
		}

?>
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
			<?
			$directory =  new UserDirectory();
			$directory->setUser_id($_COOKIE['userID']);
			$directoryList = $directory->getDirectoryList($directory);
			$directory->setDirectory_id($removeDir);
			$directoryName = $directory->getDirectory();
			?>			
			<div class="form">
				<form name="form" method="post" action="">
					<input type="hidden" name="shelf_id" value="<?=$shelf_id?>"/>
					<input type="hidden" name="acao" value="move"/>					
					<input type="hidden" name="removeDir" value="<?=$removeDir?>"/>					
					<h4><img src="../image/public/skins/classic/common/doc_move.gif" /> <span><?=DELETE_FOLDER?> (<?=$directoryName[0]->getName();?>):</span></h4>
					<h5><input type="radio" name="mode" valeu="delete" onClick="document.form.acao.value='remove';"/> <?=REMOVE_CONTENT?></span></h5>
					<h5><input type="radio" name="mode" valeu="move" checked="true" onCLick="document.form.acao.value='move';"/> <?=MOVE_CONTENT_TO_OTHER_FOLDER?></span></h5>
					<table class="form" cellspacing="0">
						<tr> 
						    <td>						
						        <input type="radio" name="directory_id" value="0" checked="true"><label for="folderCheck"><img src="../image/public/skins/classic/common/folder.gif" /><?=INCOMING_FOLDER?></label>
						    </td>
						</tr>					
					<?
					for($i = 0; $i < count($directoryList); $i++)
					{
						$directoryName = $directoryList[$i]->getName();
						$directory_id = $directoryList[$i]->getDirectory_id();
						if ($removeDir != $directory_id){
					?>
						<tr> 
						    <td>						
						        <input type="radio" name="directory_id" value="<?=$directory_id?>"><label for="folderCheck"><img src="../image/public/skins/classic/common/folder.gif" /><?=$directoryName?></label>
						    </td>
						</tr>
					<?
						}
					}?>					
						<tr> 

							<td>
								<input type="submit" value="<?=BUTTON_REMOVE?>" class="submitTrue"/>
								<input type="submit" value="<?=BUTTON_CANCEL?>" class="submitFalse" onClick="window.close(); " />
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>	
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>	
</html>

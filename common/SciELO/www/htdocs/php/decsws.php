<?php

session_start();
$DirNameLocal=dirname(__FILE__).'/';
include_once($DirNameLocal . "./include.php");
include_once($DirNameLocal . "./common.php");

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<? include($DirNameLocal . "./head.php"); ?>
		<script type="text/javascript" src="<?=$def['DIRECTORY']?>js/ajax.js"></script>
		<script type="text/javascript" src="<?=$def['DIRECTORY']?>js/basket.js"></script>
	</head>
	<body>
		<div class="container">
			<div class="level2">
				<? include($localPath['html'] . "/bvs.html"); ?>
				<div class="middle">
					<?php
					
					$tree_id = $_REQUEST["tree_id"];
					$VARS["expression"] = $_SESSION["expression"];
					$VARS["source"] = "decs";
					$VARS["lang"] = $checked["lang"];

					$xml = getDeCSTree($tree_id);
					$xsl = "xsl/public/components/page_decs.xsl";
					
					require($DirNameLocal . "./xmlRoot.php");
					
					?>
				</div>			
				<div class="bottom">	
					<? include($localPath['html'] . "/responsable.html"); ?>
				</div>	
			</div>
		</div>
	</body>
</html>
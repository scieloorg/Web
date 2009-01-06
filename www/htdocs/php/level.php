<?php
	$DirNameLocal=dirname(__FILE__).'/';
	include_once($DirNameLocal . "./include.php");

	$title = parse_ini_file($localPath['ini'] . $checked['component'] . ".ini");

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?= $title[$checked['item']] ?>
		</title>
		<? include($DirNameLocal . "./head.php"); ?>		
	</head>
	<body>
		<div class="container">
			<div class="level2">
				<? include($localPath['html'] . "bvs.html"); ?>
				<div class="middle">
					<?php

					$xml = "xml/" . $checked['lang'] . "/bvs.xml";
					$xsl = "xsl/public/components/page_level.xsl";

					$VARS["component"] = $checked['component'];
					require($DirNameLocal . 'xmlRoot.php');

					?>
				</div>		
				<div class="bottom">	
					<? include($localPath['html'] . "/responsable.html"); ?>
				</div>
			</div>
			<div class="copyright">
				BVS Site <?= VERSION ?> &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a> 
			</div>			
		</div>
		<? include($DirNameLocal. "./foot.php");  ?>
	</body>
</html>
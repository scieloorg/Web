<?php
	$DirNameLocal=dirname(__FILE__).'/';
	include_once($DirNameLocal."./include.php");
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<? include("./head.php"); ?>
	</head>
	<body>
		<div class="container">
			<div class="level2">
				<? include($localPath['html'] . "/bvs.html"); ?>
				<div class="middle">
					<?php
					
					$xml = $localPath['xml'] . "/bvs.xml";
					
					switch($_GET["mode"]) {
						case "response":
							$xsl = "xsl/public/components/page_contactResponse.xsl";
							break;
						default:
							$xsl = "xsl/public/components/page_contact.xsl";
							break;
					}
					
					require($DirNameLocal . 'xmlRoot.php');
					
					?>
				</div>		
				<div class="bottom">	
					<? include($localPath['html'] . "/responsable.html"); ?>
				</div>
			</div>
		</div>
		<? include($DirNameLocal. "./foot.php");  ?>
	</body>
</html>
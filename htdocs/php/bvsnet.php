<?php
	$DirNameLocal=dirname(__FILE__).'/';
	include_once($DirNameLocal . "./include.php");
	include_once($DirNameLocal . "./common.php");
	
	$bvsNetUrl = "http://" . $def['SERVER'] ."/bvsnet/list?lang=" . $checked["lang"];

	$network = $_GET["network"];
	if ( isset($network) && !ereg("^[A-Za-z]+$",$network) )
		die("invalid parameter");
	else
		$bvsNetUrl .= "&network=" . $network;
	
	$country = $_GET["country"];
	if ( isset($country) && !ereg("^[A-Za-z]+$",$country) )
		die("invalid parameter");
	else
		$bvsNetUrl .= "&country=" . $country;

	$type = $_GET["type"];
	if ( isset($type) && !ereg("^[0-9]+$",$type) )
		die("invalid parameter");
	else
		$bvsNetUrl .= "&type=" . $type;

	$messages["pt"]["network"] = "Redes";
	$messages["pt"]["connection.fail"] = "Não foi possivel conectar com a aplicação. Por favor tente mais tarde!";
	$messages["es"]["network"] = "Redes";
	$messages["es"]["connection.fail"] = "No fue posible conectarse con la aplicación. Por favor intente mas tarde!";
	$messages["en"]["network"] = "Networks";
	$messages["en"]["connection.fail"] = "It was not possible to connect with the application. Please try later!";

	$texts = $messages[$lang];
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?=$title[$item]?>
		</title>
		<? include($DirNameLocal . "./head.php"); ?>		
	</head>
	<body>
	<div class="container">			
		<div class="level2">	
			<? include($localPath['html'] . "/bvs.html"); ?>
			<div class="middle">
				<div id="portal">
					<h3><span><?=$texts["network"]?></span></h3>					
					<div id="breadCrumb">
					    <a href="../index.php?lang=<?=$lang?>">home</a>&gt;
						<a href="../php/bvsnet.php?lang=<?=$lang?>"><?=$texts["network"]?></a>
						<? if ($network != "")  echo "&gt; " .$network;?>
					</div>					
					<div class="content">
						<h4><span><? if ($network != "")  echo $network; else echo $texts["network"];?></span></h4>
						<?
							$bvsNetList= getDoc($bvsNetUrl);
							if ($bvsNetList == "[open failure]"){
								echo "<img src='/image/common/alert.gif'>" . $texts["connection.fail"];
							}else{	
								echo $bvsNetList;
							}	
						?>
					</div>
				</div>	
			</div>		
		</div>	
		<? include($DirNameLocal. "./foot.php");  ?>
	</body>
</html>
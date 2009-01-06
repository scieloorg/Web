<?php
	ini_set("include_path",".");
	require_once("../classes/Links.php");
	require_once("../../../php/include.php");
	require_once("functions.php");
	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file("../scielo.def.php", true);
	$home = $ini['this']['url'];
	if(!isset($_COOKIE['userID']))
		header("Location: ".$home);

	ob_start("ob_gzhandler");
	session_start();
	
	$link = new Links();
	$link->setUser_Id($_COOKIE['userID']);
	$link->setLink_id($_GET['link']);
	$link->setRate($_GET['rate']);
	$result = $link->updateLinkRate();
	echo "Content-type: text/plain \n";
	echo "true";
	ob_end_flush();
?>
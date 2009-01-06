<?php
	ini_set("include_path",".");
	require_once("../classes/Shelf.php");
	require_once("../../../php/include.php");
	require_once("langs.php");
	require_once("functions.php");
	$site = parse_ini_file(dirname(__FILE__)."/../../../ini/" . $lang . "/bvs.ini", true);

	$ini = parse_ini_file("../scielo.def.php", true);
	$home = $ini['this']['url'];
	if(!isset($_COOKIE['userID']))
		header("Location: ".$home);

	ob_start("ob_gzhandler");
	session_start();
	
	$shelf = new Shelf();
	$shelf->setUserID($_COOKIE['userID']);
	$shelf->setShelf_id($_GET['shelf']);
	$shelf->setRate($_GET['rate']);	
	$result = $shelf->updateArticleRate();
	echo "Content-type: text/plain \n";
	echo "true";
	ob_end_flush();
?>

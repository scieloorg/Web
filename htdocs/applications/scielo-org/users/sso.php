<?php
session_start();

$dir = dirname(__FILE__)."/";
include_once($dir."UserClass.php");
include_once($dir."langs.php");

$dir = dirname(__FILE__);
$ini = parse_ini_file($dir."/../scielo.def.php" , true);
$url = $ini['scielo_org_urls']['home'];

$origem = $_GET['origem']?$_GET['origem']:$_SERVER['HTTP_REFERER'];

if($origem == "")
{
	$origem = $url;
}

if(isset($_COOKIE['userID']) && (intval($_COOKIE['userID']) > 0))
{

	session_write_close();
	if(strpos($origem,"?"))
		header("Location: ".$origem."&userID=".$_COOKIE['userID']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']);
	else
		header("Location: ".$origem."?userID=".$_COOKIE['userID']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']);
}
else
{
	if(strpos($origem,"?"))
	{
		header("Location: $origem&userID=0");
	}
	else{
		header("Location: $origem?userID=0");
	}
}
?>
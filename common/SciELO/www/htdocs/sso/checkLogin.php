<?php

$dir = dirname(__FILE__);
ini_set("display_errors","1");
error_reporting(E_ALL ^ E_NOTICE);
session_start();

//include_once($dir."/../users/UserClass.php");
//include_once($dir."/../users/langs.php");

$ini = parse_ini_file($dir."/../scielo.def" , true);
$url = $ini['SCIELO_REGIONAL']['SCIELO_REGIONAL_DOMAIN'];

$origem = $_GET['origem']?$_GET['origem']:$_SERVER['HTTP_REFERER'];

if($origem == "")
{
	$origem = $url;
}

if(isset($_COOKIE['userID']) && (intval($_COOKIE['userID']) > 0))
{
    session_write_close();
    if(strpos($origem,"?"))
    {
        header("Location: ".$origem."&userID=".$_COOKIE['userID']."&userToken=".$_COOKIE['userToken']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']);
    }
    else{
        header("Location: ".$origem."?userID=".$_COOKIE['userID']."&userToken=".$_COOKIE['userToken']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']);
    }
}
else
{
    session_write_close();
    if(strpos($origem,"?"))
    {
        header("Location: $origem&userID=-1");}
    else{
        header("Location: $origem?userID=-1");
    }
}
?>

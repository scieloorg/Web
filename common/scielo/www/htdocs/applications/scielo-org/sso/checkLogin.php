<?php

ini_set("display_errors","1");
error_reporting(E_ALL ^ E_NOTICE);
session_start();

require_once(dirname(__FILE__)."/../users/UserClass.php");
require_once(dirname(__FILE__)."/../users/langs.php");

$ini = parse_ini_file($dir."/../scielo.def.php" , true);
$url = $ini['scielo_org_urls']['home'];

$origem = $_GET['origem']?$_GET['origem']:$_SERVER['HTTP_REFERER'];

$count = 0;
foreach ($_GET as $key => $value) {
	$count = $count+1;
	if ($count == 1){
		$origem = $value."?";
	}else{
		$origem .= $key."=".$value."&";
	}
}
$origem = substr($origem,0,strlen($origem)-1);

if($origem == ""){
	$origem = $url;
}

if(isset($_COOKIE['userID']) && (intval($_COOKIE['userID']) > 0))
{
    session_write_close();
    if(strpos($origem,"?")){
        header("Location: ".$origem."&userID=".$_COOKIE['userID']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']."&lng=".$lang."&tlng=".$lang."&lang=".$lang."&userToken=".$_COOKIE['userToken']."&tokenVisit=".$_COOKIE['tokenVisit']);
    }
    else{
        header("Location: ".$origem."?userID=".$_COOKIE['userID']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']."&lng=".$lang."&tlng=".$lang."&lang=".$lang."&userToken=".$_COOKIE['userToken']."&tokenVisit=".$_COOKIE['tokenVisit']);
    }
}
else
{
    session_write_close();
    if(strpos($origem,"?"))
    {
        header("Location: $origem&userID=-2");}
    else{
        header("Location: $origem?userID=-2");
    }
}

?>
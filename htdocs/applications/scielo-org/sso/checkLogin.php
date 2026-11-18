<?php
ini_set("display_errors", "0");
	ini_set("log_errors", "1");
error_reporting(E_ALL ^ E_NOTICE);
session_start();

$dir = dirname(__FILE__);
require_once(dirname(__FILE__)."/../users/langs.php");

$ini = parse_ini_file($dir."/../scielo.def.php" , true);
$url = $ini['scielo_org_urls']['home'];
$lang = isset($_GET['lang']) ? $_GET['lang'] : (isset($_GET['lng']) ? $_GET['lng'] : 'en');

function sso_clean_url($url, $fallback)
{
	$url = str_replace(array("\r", "\n"), '', (string)$url);
	$parts = parse_url($url);
	if ($url === '' || !is_array($parts)) {
		return $fallback;
	}
	if (isset($parts['scheme']) && !in_array(strtolower($parts['scheme']), array('http', 'https'))) {
		return $fallback;
	}
	return $url;
}

function sso_redirect_location($baseUrl, $params)
{
	$separator = (strpos($baseUrl, '?') !== false) ? '&' : '?';
	$query = http_build_query($params, '', '&');
	return 'Location: '.$baseUrl.($query !== '' ? $separator.$query : '');
}

function sso_public_login_params($userID, $firstName, $lastName, $lang)
{
	return array(
		'userID' => $userID,
		'firstName' => $firstName,
		'lastName' => $lastName,
		'lng' => $lang,
		'tlng' => $lang,
		'lang' => $lang
	);
}

$origem = $_GET['origem']?$_GET['origem']:$_SERVER['HTTP_REFERER'];
$origem = sso_clean_url($origem, $url);

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
$origem = sso_clean_url($origem, $url);

if($origem == ""){
	$origem = $url;
}

if(isset($_COOKIE['userID']) && (intval($_COOKIE['userID']) > 0))
{
    session_write_close();
    header(sso_redirect_location($origem, sso_public_login_params($_COOKIE['userID'], $_COOKIE['firstName'], $_COOKIE['lastName'], $lang)));
}
else
{
    session_write_close();
    header(sso_redirect_location($origem, array('userID' => -2)));
}

?>

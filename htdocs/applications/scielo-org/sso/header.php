<?php
//consulta a instancia para pegar o COOKIE se jah logado
//ini_set("display_errors","1");
//error_reporting(E_ALL);
session_start();
$dir = dirname(__FILE__);
$defFile = $dir."/../../../scielo.def.php";
if (!file_exists($defFile) && file_exists($defFile.".template")) {
    @copy($defFile.".template", $defFile);
}
$defi = @parse_ini_file($defFile, true);
if (!is_array($defi)) {
    $defi = array();
}
$robotsUserAgents = parse_ini_file($dir."/../../../robotsUserAgents.def",true); 

$isaRobot = false;
$userAgent = strtolower($_SERVER['HTTP_USER_AGENT'] ?? '');

foreach($robotsUserAgents["ROBOTS_AGENT"] as $key => $value){
	$agent = strtolower($value);
	if (strstr($userAgent,$agent)){
		$isaRobot = true;
		break;
	}
}
if (!$isaRobot){
	if (($defi['services']['show_login'] ?? "0") != "0"){

	$loginURL = "http://".($defi['SCIELO_REGIONAL']['SCIELO_REGIONAL_DOMAIN'] ?? '').($defi['SCIELO_REGIONAL']['check_login_url'] ?? '');
		if(isset($_GET['userID']))
		{
				if (strpos($_SERVER["REQUEST_URI"],"lng"))
				{
					$self_url = str_replace("lng=en","lng=".$_GET['lng'],"http://".$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"]);
				}else{
					$self_url = "http://".$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"]."&lng=".$_GET['lng'];
				}
				$inicio = strpos($self_url,"userID") -1 ;
				$self_url = substr($self_url, 0, $inicio);
	
				header('P3P: CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"');
				$cookieOptions = array(
					'expires' => time()+3600,
					'path' => '/',
					'secure' => (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off'),
					'httponly' => true,
					'samesite' => 'Lax'
				);
				setcookie("userID",$_GET['userID'],$cookieOptions);
				setcookie("firstName",$_GET['firstName'],$cookieOptions);
				setcookie("lastName",$_GET['lastName'],$cookieOptions);
				if (isset($_GET['userToken'])) {
					setcookie("userToken",$_GET['userToken'],$cookieOptions);
				}
				if (isset($_GET['tokenVisit'])) {
					setcookie("tokenVisit",$_GET['tokenVisit'],$cookieOptions);
				}
				if (isset($_GET['email'])) {
					setcookie("email",$_GET['email'],$cookieOptions);
				}
				session_write_close();
				Header("Location: ".$self_url);
				exit;
		}
		/*
		se nao verificou no Regional o Login do usuario vai verificar
		*/
/*
		if(!isset($_SESSION['checkedLogin']))
		{
				if(!isset($_REQUEST['skpa'])=="on"){
					$self_url = "http://".$_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
					$inicio = strpos($self_url,"userID") -1 ;
	
					if($inicio > 0){
					   $self_url = substr($self_url, 0, $inicio);
					}
					$_SESSION['checkedLogin'] = "true";
					session_write_close();
					$self_url = '?origem='.str_replace('?','&',$self_url);
					header("Location: ".$loginURL.$self_url);
				}
		}
*/

	}
}
?>

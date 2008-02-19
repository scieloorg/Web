<?
//consulta a instancia para pegar o COOKIE se jah logado
//ini_set("display_errors","1");
//error_reporting(E_ALL);
session_start();
$dir = dirname(__FILE__);
$defi = parse_ini_file($dir."/../../../scielo.def.php",true);
$robotsUserAgents = parse_ini_file($dir."/../../../robotsUserAgents.def",true); 

$isaRobot = false;

foreach($robotsUserAgents["ROBOTS_AGENT"] as $key => $value){
	$userAgent = strtolower($HTTP_USER_AGENT);
	$agent = strtolower($value);
	if (strstr($userAgent,$agent)){
		$isaRobot = true;
		break;
	}
}
if (!$isaRobot){
	if($defi['services']['show_login'] != "0"){

	$loginURL = "http://".$defi['SCIELO_REGIONAL']['SCIELO_REGIONAL_DOMAIN']. $defi['SCIELO_REGIONAL']['check_login_url'];
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
				setcookie("userID",$_GET['userID'],time()+3600,"/");
				setcookie("userToken",$_GET['userToken'],time()+3600,"/");
				setcookie("tokenVisit",$_GET['tokenVisit'],time()+3600,"/");
				setcookie("firstName",$_GET['firstName'],time()+3600,"/");
				setcookie("lastName",$_GET['lastName'],time()+3600,"/");
				setcookie("userToken",$_GET['userToken'],time()+3600,"/");
				setcookie("email",$_GET['email'],time()+3600,"/");
				session_write_close();
				Header("Location: ".$self_url);
				exit;
		}
		/*
		se nao verificou no Regional o Login do usuario vai verificar
		*/
		if(!isset($_SESSION['checkedLogin']))
		{
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
}
?>

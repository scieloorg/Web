<?php

ini_set("display_errors","1");
error_reporting(1);
session_start();

$dir = dirname(__FILE__);
$lang = $_REQUEST['lang'];
require_once(dirname(__FILE__)."/../users/langs.php");

$ini = parse_ini_file($dir."/../scielo.def" , true);
$url = $ini['scielo_org_urls']['home'];
$useSGU = intval($ini['sgu']['enabled'])?true:false;
$hotsiteurl = $ini['hotsite']['url'];


if($useSGU)
{
require_once(dirname(__FILE__)."/../users/UserClassWS.php");
}else{
require_once(dirname(__FILE__)."/../users/UserClass.php");
}

$origem = $_GET['origem']?$_GET['origem']:$_SERVER['HTTP_REFERER'];

if($origem == "")
{
		$origem = $url;
}

if(isset($_COOKIE['userID']) && (intval($_COOKIE['userID']) != 0))
{
	$origem = str_replace("?logout=true","",$origem);

	if(strpos($origem,"?"))
    {
		$redirectCommand = ("Location: ".$origem."&userID=".$_COOKIE['userID']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']."&lng=".$lang."&tlng=".$lang."&lang=".$lang."&userToken=".$_COOKIE['userToken']."&tokenVisit=".$_COOKIE['tokenVisit']);
    }
    else{
		$redirectCommand = ("Location: ".$origem."?userID=".$_COOKIE['userID']."&firstName=".$_COOKIE['firstName']."&lastName=".$_COOKIE['lastName']."&lng=".$lang."&tlng=".$lang."&lang=".$lang."&userToken=".$_COOKIE['userToken']."&tokenVisit=".$_COOKIE['tokenVisit']);
    }
	session_write_close();
	header($redirectCommand);
		
}
else
{
	$acao = $_REQUEST['acao'];
	$usr = new UserClass();
	if(isset($acao))
	{
		$login_error = 0;
		$login = $_REQUEST['login'];
		$senha = $_REQUEST['password'];
		$usr->setLogin($login);
		$usr->setPassword($senha);
		$userValid = $usr->validateUser();

		if($userValid == 1)
		{
			header('P3P: CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"');
			setcookie("userID",$usr->getID(),time()+3600,"/");
			setcookie("firstName",$usr->getFirstName(),time()+3600,"/");
			setcookie("lastName",$usr->getlastName(),time()+3600,"/");
			setcookie("email",$usr->getEmail(),time()+3600,"/");

			if($useSGU){
				setcookie("userToken",$usr->getToken(),time()+3600,"/");
				setcookie("tokenVisit",$usr->getVisitToken(),time()+3600,"/");
			}

			$result = "userID=".$usr->getID()."&firstName=".$usr->getfirstName()."&lastName=".$usr->getlastName()."&lng=".$lang."&tlng=".$lang."&lang=".$lang."&userToken=".$usr->getToken()."&tokenVisit=".$usr->getVisitToken()."&email=".$usr->getEmail();

			if(strpos($origem,"?"))
			{
				$redirectCommand = "Location: ".$origem."&".$result;
			}
			else{
				$redirectCommand = "Location: ".$origem."?".$result;
			}
			session_write_close();
			header($redirectCommand);
		}
		else
		{
			$login_error = 1;
			session_write_close();
		} // userValid
	} // acao
} // userID


		$id = $_COOKIE['userID'];

ob_start();

		if ($usr->loadUser($id) == 0)
		{
		?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			SciELO.org - Scientific Electronic Library Online		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Expires" content="-1" />
<meta http-equiv="pragma" content="no-cache" />	


<meta name="robots" content="all" />
<meta name="MSSmartTagsPreventParsing" content="true" />
<meta name="generator" content="BVS-Site 4.0-rc4" />


<script language="JavaScript">lang = 'pt';</script>

<script language="JavaScript" src="/js/functions.js"></script>
<script language="JavaScript" src="/js/showHide.js"></script>
<script language="JavaScript" src="/js/metasearch.js"></script>

<link rel="stylesheet" href="/applications/scielo-org/css/public/print.css" type="text/css" media="print"/>
<link rel="stylesheet" href="/applications/scielo-org/css/public/style-pt.css" type="text/css" media="screen"/>	

<style>
	.container {
		width: 760px;
		margin: 0 auto;
	}
	.login {
		width: 25%;
		float: right;
	}
	.intro {
		width: 75%;
		float: left;
		line-height: 150%;
	}
</style>
</head>
	<body>
	
		<div class="container">	
			
			<div class="top">
					<div id="parent"><img src="/applications/scielo-org/image/public/skins/classic/<?=$lang?>/banner.jpg" alt="SciELO - Scientific Electronic Librery Online"></div>
				<div id="identification">
					<h1><span>SciELO.org - Scientific Electronic Library Online</span></h1>
				</div>
			</div>
			
			<div class="middle">	
				<div class="intro">
					<h4><?=FREE_REGISTRATION?></h4>
					<p><?=FREE_REGISRATION_DESC?><br/><a href="<?=$hotsiteurl?>?lang=<?=$lang?>"><strong><?=LEARN_MORE?></strong></a></p>					
				</div>
				<div class="login">
					<form name="login" method="get" >
						<table width="100%" cellpadding="0" cellspacing="0" border="0">
							<tr>
								<th align="right"><?=FIELD_LOGIN?></th>
								<td align="right"><input type="text" name="login" size="25"/>
										<?
											if($login_error)
												echo '<span class="tfvHighlight" >'. LOGIN_ERROR . '</span>';
										?>
								</td>
							</tr>
							<tr>
								<th align="right"><?=FIELD_PASSWORD?></th>
								<td align="right"><input type="password" name="password" size="25"/></td>
							</tr>
							<tr>
								<th>&nbsp;</th>
								<td><input type="submit" class="submit" value="<?=BUTTON_LOGIN?>"/></td>
							</tr>
							<tr>
								<th>&nbsp;</th>
								<td>
									<a href="../users/forgot.php"><?=FORGOT_PASSWORD?></a>
									<br/>
									<a href="../users/userData.php"><?=REGISTER?></a>							
								</td>
							</tr>
						</table>
						<input type="hidden" name="acao" value="login"/>
						<input type="hidden" name="origem" value="<?=$origem?>"/>
					</form>
				</div>

			</div>
		</div>
	</body>
</html>
<?
 }

ob_flush();

?>
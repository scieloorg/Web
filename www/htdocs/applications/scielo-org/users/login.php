<?php
/*
Tela de Login da página inicial do Portal Regional
Após logado mostra a lista de serviços para usuários logados
*/

ini_set("include_path",".");
ini_set("display_errors","1");
error_reporting(E_ALL ^ E_NOTICE);
/**
*Verificando se é para usar o SGU ou não
*/
$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php",true);
$useSGU = intval($ini['sgu']['enabled'])?true:false;

require_once(dirname(__FILE__)."/langs.php");

if($useSGU)
{
	require_once(dirname(__FILE__)."/UserClassWS.php");
}else{
	require_once(dirname(__FILE__)."/UserClass.php");
}

require_once(dirname(__FILE__)."/../../../php/include.php");

$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php", true);

$home = $ini['scielo_org_urls']['home'];

$thisScielo = $ini['this']['url'];
$logout = $ini['scielo_org_urls']['logout'];


$regional = ($home == $thisScielo);

$action = "";

if(!$regional){

	if(isset($acao)){
		header('P3P: CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"');
		setcookie("userID",$_GET['userID'],time()+3600,"/");
		setcookie("userToken",$_GET['userToken'],time()+3600,"/");
		setcookie("tokenVisit",$_GET['tokenVisit'],time()+3600,"/");
		setcookie("firstName",$_GET['firstName'],time()+3600,"/");
		setcookie("lastName",$_GET['lastName'],time()+3600,"/");
		setcookie("userToken",$_GET['userToken'],time()+3600,"/");
		header("Location: ".$thisScielo);
	}else{
		require_once(dirname(__FILE__)."/../../../sso/header.php");	
	}
	
	
	$action = $ini['scielo_org_urls']['login'];
}

$acao = $_REQUEST['acao'];

$usr = new UserClass();
if(isset($acao)){

	if($regional){

		$login = $_REQUEST['login'];
		$senha = $_REQUEST['password'];

		$usr->setLogin($login);
		$usr->setPassword($senha);

		$userValid = $usr->validateUser();

		if($userValid == 1)
		{
			header('P3P: CP="NOI ADM DEV PSAi COM NAV OUR OTRo STP IND DEM"');
			setcookie("userID",$usr->getID(),time()+3600,"/");

			if($useSGU)
			{
				setcookie("userToken",$usr->getToken(),time()+3600,"/");
				setcookie("tokenVisit",$usr->getVisitToken(),time()+3600,"/");
			}

			setcookie("firstName",$usr->getFirstName(),time()+3600,"/");
			setcookie("lastName",$usr->getLastName(),time()+3600,"/");
			session_write_close();
			header("Location: ".$thisScielo);
		}
		else
		{
			setcookie("userID","-1",0,"/");
			session_write_close();
			header("Location: ".$thisScielo);
		}
	}
}else if (isset($_REQUEST['logout']))
{
		//header("Location: ".$logout);

		/*
		Faz o logout na instancia (ou seja "mata" os cookies de usuario) 
		*/
			session_start();
			setcookie("userID","",0,"/");
			setcookie("firstName","",0,"/");
			setcookie("lastName","",0,"/");

			unset($_COOKIE['userID']);
			unset($_COOKIE['checkedLogin']);
			unset($_COOKIE['firstName']);
			unset($_COOKIE['lastName']);

			if($useSGU){
				/*
					se estiver usando SGU e estiver no portal regional (Scielo.org), chama o logout do SGU
				*/
				if($ini['this']['url'] == $ini['controler']['url'])
				{
					require_once(dirname(__FILE__)."/../users/UserClassWS.php");
					$usr = new UserClass();
					$usr->setToken($_COOKIE['userToken']);
					$usr->logout();
				}
				setcookie("userToken","",0,"/");
				setcookie("tokenVisit","",0,"/");
				unset($_COOKIE['userToken']);
			}

/*
abre os IFRAMEs para "deslogar" nas instancias
*/
			$logouURLs = $ini['logout_urls'];

			foreach($logouURLs as $url)
			{
				echo '<iframe src="'.$url.'" width="0" height="0" frameborder="0"></iframe>';
			}
usleep(300);
header("Location: /");

}



/*
* Verifica se o usuário já esta logado para mostrar a tela adequada : Login ou "Ola"
*/


	if($useSGU)
	{
		if($_COOKIE['userToken'] == "")
		{
			$id = 0;
		}
		else
		{
			$id = $_COOKIE['userToken'];
		}
	}else{
		if($_COOKIE['userID'] == "")
		{
			$id = 0;
		}
		else
		{
			$id = $_COOKIE['userID'];
		}
	}

		if ($usr->loadUser($id) == 0)
		{
			//Antes de Logado
		?>

			<div class="login">
				<form name="login" method="post" action="<?=$action?>">
				<input type="hidden" name="acao" value="login" />
					<table width="100%" cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td><label><?=FIELD_LOGIN?></label></td>
							<td><input type="text" class="expression" name="login" />
									<?
										if($_COOKIE['userID'] == -1)
											echo '<br/><span class="tfvHighlight" >'. LOGIN_ERROR . '</span>';
									?>
							</td>
							<td>&#160;</td>
						</tr>
						<tr>
							<td><label><?=FIELD_PASSWORD?></label></td>
							<td><input type="password" class="expression" name="password" /></td>
							<td>
								<input type="submit" class="submit" value="<?=BUTTON_LOGIN?>"/>
							</td>
						</tr>
					</table>
					<span>
						<a href="<?=$ini['this']['relpath']?>/users/forgot.php"><?=FORGOT_PASSWORD?></a><br />
						<a href="<?=$ini['this']['relpath']?>/users/userData.php"><strong><?=REGISTER?></strong></a> <?=FOR_SERVICES?>
					</span>
					<input type="hidden" name="acao" value="login"/>
				</form>
			</div>

		<? }
			else 
						//Depois de Logado
			{?>
		<div class="userInfo">
						<span><?=HELLO_STRING?> <strong><?=$usr->getFirstName()." ".$usr->getLastName() ?></strong> | <a href="<?=$ini['this']['relpath']?>/users/userData.php?id=<?=$_COOKIE['userID'];?>"><?=EDIT_USER_DATA?></a> | <a href="?logout=true"><?=BUTTON_LOGOUT?></a></span>
		</div>
						<ul>
							<li><a href="<?=$ini['this']['relpath']?>/users/myShelf.php"><?=MY_SHELF?></a></li>
							<li><a href="<?=$ini['this']['relpath']?>/users/myArticleProfile.php"><?=MY_ARTICLE_PROFILE?></a></li>
							<li><a href="<?=$ini['this']['relpath']?>/users/myArticleProfile.php?new"><?=MY_NEW_ARTICLE_PROFILE?></a></li>
							<li><a href="<?=$ini['this']['relpath']?>/users/myNews.php"><?=MY_NEWS?></a></li>
							<li><a href="<?=$ini['this']['relpath']?>/users/myLinks.php"><?=MY_LINKS?></a></li>
							<li><a href="<?=$ini['this']['relpath']?>/users/myAlerts.php"><?=MY_ALERTS?></a></li>
						</ul>
		
		<?
			require_once(dirname(__FILE__)."/../sgu/traker.php");
		}
		?>

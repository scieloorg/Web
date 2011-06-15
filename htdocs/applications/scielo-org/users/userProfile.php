<?php
ob_start("ob_gzhandler");

/**
* processamento da tela de cadastro de usuários
*/
session_start();

$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php",true);

$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

$baseDir = "";

if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
	$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}else{
	$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}

$useSGU = intval($ini['sgu']['enabled'])?true:false;

if($useSGU){
	require_once(dirname(__FILE__)."/UserClassWS.php");
}else{
	require_once(dirname(__FILE__)."/UserClass.php");
}
require_once(dirname(__FILE__)."/langs.php");

require_once(dirname(__FILE__)."/../classes/GrandeArea.php");

require_once(dirname(__FILE__)."/UserProfileClass.php");



//variaveis do formulário
$cgi = array_merge($_GET,$_POST);

	$profilesTexts = $cgi['profiletext'];
	$profilesNames = $cgi['profilename'];
	$profilesIDs = $cgi['profileid'];
	$acao = $cgi['acao'];

	$grandeAreaId = array();

	$grandeAreaId[] = $cgi['GrandeArea1'];
	$grandeAreaId[] = $cgi['GrandeArea2'];
	$grandeAreaId[] = $cgi['GrandeArea3'];

	$subAreaId = array();

	$subAreaId[] = $cgi['SubArea1'];
	$subAreaId[] = $cgi['SubArea2'];
	$subAreaId[] = $cgi['SubArea3'];

	$arrProfile = array();

	switch($acao)
	{
		case "gravar":

			$usr = new UserClass($firstName, $lastName, $gender, $login, $email, $password);

			for($i = 0; $i < count($profilesTexts); $i ++){
				$p = new UserProfileClass();

				$p->setProfileText();
				$p->setUserID($_COOKIE['userID']);
				$p->setProfileText(addslashes($profilesTexts[$i]));
				$p->setProfileName(addslashes($profilesNames[$i]));
				$p->getGrandeAreaID($grandeAreaId[$i]);
				$p->getSubAreaID($subAreaId[$i]);
				array_push($arrProfile, $p);
			}

			$usr->setProfiles($arrProfile);
			$usr->setID($_COOKIE['userID']);

			$result = $usr->addUserProfiles();

			if(!is_array($result))
			{
				if($useSGU)
				{
					setcookie("userToken",$usr->getToken(),time()+3600,"/");
				}

				setcookie("firstName",$usr->getFirstName(),time()+3600,"/");
				setcookie("lastName",$usr->getLastName(),time()+3600,"/");
				setcookie("userID",$usr->getID(),time()+3600,"/");
				session_write_close();
				header("Location: /");
				exit;
			}


//apos o cadastro jah loga o usuário

		break;

		case "atualizar":
			$usr = new UserClass();

			$usr->setID($_COOKIE['userID']);

			if($useSGU){
				$usr->setToken($_COOKIE['userToken']);
			}

			if($password != "")
				$usr->setPassword($password);

			for($i = 0; $i < count($profilesTexts); $i ++){
				$profile = new UserProfileClass();
				$profile->setUserID($usr->getID());
				$profile->setProfileID($profilesIDs[$i]);
				$profile->setProfileText($profilesTexts[$i]);
				$profile->setProfileName($profilesNames[$i]);
				$profile->setGrandeAreaID($grandeAreaId[$i]);
				$profile->setSubAreaID($subAreaId[$i]);
				$profile->setProfileStatus('on');

				$usr->setProfiles($profile);
			}
			$a = $usr->updateProfiles();

			if($useSGU){
				$usr->loadUser($_COOKIE['userToken']);
			}else{
				$usr->loadUser($_COOKIE['userID']);
			}

			header("Location: /");

		break;

		default:
			$usr = new UserClass();
			$profiles = array(new UserProfileClass(), new UserProfileClass(), new UserProfileClass());

			if(isset($_REQUEST['id']) && isset($_COOKIE['userID']))
			{
				if($useSGU){
					$usr->loadUser($_COOKIE['userToken']);
				}else{
					$usr->loadUser($_COOKIE['userID']);
				}
				$profiles = $usr->getProfiles();
			}
		break;
	}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
		<?
			if($usr->getID() != 0) 
			{
				echo UPDATE_USER_TITLE;
			}
			else
			{
				echo REGISTER_NEW_USER_TITLE;
			}

		?>

		</title>
		<? require_once(dirname(__FILE__)."/../../../php/head.php"); ?>

		<script language="JavaScript" src="../js/validator.js"></script>

<style>
	/* classes for validator */
	.tfvHighlight
		{font-weight: bold; color: red; display:inline;}
	.tfvNormal
		{font-weight: normal;	color: black; display: inline;}
</style>



<script type="text/javascript">

            xmlhttp = false;

try{
    xmlhttp = new XMLHttpRequest();
//			alert('saco');
}catch(ee){
//	alert('ee');
    try{
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    }catch(e){
//	alert('e');
		try{
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        }catch(E){
        }
    }
}

function doBusca(id_grande_area,destino,lang){
	//limpa o select
    var c=document.getElementById(destino);
    while(c.options.length>0)c.options[0]=null
    c.options[0]=new Option(" -- "," -- ");

    xmlhttp.open("GET", "ajax.php?id_grande_area="+id_grande_area+"&lang="+lang,true);

    xmlhttp.onreadystatechange=	function ()
	{
		var total = 0;
		if (xmlhttp.readyState==4){
            //limpa o select
			try{
	            var c = document.getElementById(destino);
			}catch(aaaa){
				alert(aaaa);
			}
            while(c.options.length>0)c.options[0]=null
            var retorno = xmlhttp.responseText;
			var arr = retorno.split('|');
			total = arr.length;
            //popula o select com a lista de cidades obtida
            for(var i=0;i<total;i++){
				var texto = arr[i].split('\,');
				
				if(texto[1] != undefined)
				{
					c.options[c.options.length]=new Option(texto[1],unescape(texto[0]));
				}else{
					c.options[c.options.length]=new Option("--","0");
				}
            }
        }
	}

    xmlhttp.send(null)
}
</script>
	</head>
	<body>
		<div class="container">
			<div class="level2">
				<? require_once($baseDir."html/" . $lang . "/bvs.html"); ?>
				<div class="middle">
					<div id="breadCrumb">
						<a href="/">
							home
						</a>
						&gt; <?
								if($usr->getID() != 0) 
								{
									echo UPDATE_USER_TITLE;
								}
								else
								{
									echo REGISTER_NEW_USER_TITLE;
								}

					?>
					</div>
					<div class="content">
						<h3>
							<span>
								<?
									if($usr->getID() != 0) 
									{
										echo UPDATE_USER_TITLE;
										$showLoginField = false;
									}
									else
									{
										echo REGISTER_NEW_USER_TITLE;
										$showLoginField = true;
									}
								?>
							</span>
						</h3>
						<div id="messages">
							<?
								
								if($acao == "gravar" && $result['ERROR'] == "")
									echo REGISTER_NEW_USER_SUCESS;
								else if($acao == "gravar" && $result['ERROR'] != "")
									echo FIELD_LOGIN_ALREADY_EXISTS;
								else if ($acao == "atualizar" && $result['ERROR'] == "")
									echo UPDATE_USER_SUCESS;
								else if ($acao == "atualizar" && $result['ERROR'] != "")
									echo FIELD_LOGIN_ALREADY_EXISTS;
							?>
						</div>
						<form method="post" name="cadastro">
							<h4><?=STEP." 2 ".OF." 2 - ".PROFILES?></h4>
								<? $htmlProfiles = array(FIELD_PROFILE_ONE, FIELD_PROFILE_TWO,FIELD_PROFILE_TREE);
								$id = 0;

								foreach ($htmlProfiles as $i=>$text){
									$id++;

									$profileText = '';
									$profileID = '';
									$profileName = '';
									if ($profiles[$i]){
										$profileText = $profiles[$i]->getProfileText();
										$profileID = $profiles[$i]->getProfileID();
										$profileName = $profiles[$i]->getProfileName();
										$gAreaID = $profiles[$i]->getGrandeAreaID();
										$sAreaID = $profiles[$i]->getSubAreaID();
									}
								
									echo '<table class="register">'."\n";
									echo '	<tr>'."\n";
									echo '		<td colspan="2">'."\n";
									echo '			<strong>'.$text.'</strong>'."\n";
									echo '		</td>'."\n";
									echo '	</tr>'."\n";
									echo '	<tr>'."\n";
									echo '		<td class="label">'."\n";
									echo '			'.FIELD_PROFILE_NAME.''."\n";
									echo '		</td>'."\n";
									echo '		<td>'."\n";
									echo '			<input type="text" class="expression" name="profilename[]"  value="'.$profileName.'"/>'."\n";
									echo '		</td>'."\n";
									echo '	</tr>'."\n";
									
									echo '	<tr>'."\n";
									echo '		<td class="label">'."\n";
									echo '			Areas de Interesse'."\n";
									echo '		</td>'."\n";
									echo '		<td>'."\n";
									
									$a = new GrandeArea();

									$a->setLang($lang);

									$arr = $a->getGrandeAreas();

									?>
									<select name="GrandeArea<?=$id?>" id="GrandeArea<?=$id?>" onchange="doBusca(this.options[this.selectedIndex].value,'SubArea<?=$id?>','<?=$lang?>')">
									<?
										echo '<option value="0"> -- </option>';
										foreach($arr as $item)
										{

											if($gAreaID == $item->getID())
											{
												echo '<option SELECTED value="'.$item->getID().'">'.$item->getDescricao()."</option>";
											}else{
												echo '<option value="'.$item->getID().'">'.$item->getDescricao()."</option>";
											}
										}
									?>
									</select>

									<select name="SubArea<?=$id?>" id="SubArea<?=$id?>">
									<?
										if($gAreaID != 0){
											$a->setID($gAreaID);
											$arr = $a->getSubAreas();

											foreach($arr as $item)
											{
												if($item->getID() == $sAreaID)
												{
													echo '<option SELECTED value="'.$item->getID().'">'.$item->getDescricao()."</option>";
												}else{
													echo '<option value="'.$item->getID().'">'.$item->getDescricao()."</option>";
												}
											}

										}	
									?>
									</select>
<?
									echo '		</td>'."\n";
									echo '	</tr>'."\n";

									echo '	<tr>'."\n";
									echo '		<td class="label">'."\n";
									echo '			'.FIELD_PROFILE_DESCRIPTION_TEXT.''."\n";
									echo '		</td>'."\n";
									echo '		<td  align="left" >'."\n";
									echo '			<input type="hidden" name="profileid[]" value="'.$profileID.'" />'."\n";
									echo '			<textarea name="profiletext[]" class="expression" cols="40" rows="5">'.trim($profileText).'</textarea>'."\n";
									echo '		</td>'."\n";
									echo '	</tr>'."\n";
									echo '</table>'."\n";
								}
								?>
								<h4>&#160;</h4>
							<?
							if($usr->getID() != 0) 
							{
								echo('<input type="hidden" value="atualizar" name="acao" />');
								echo('<input type="submit" value="'.BUTTON_UPDATE_USER.'" class="submitTrue" />');
							}
							else
							{
								echo('<input type="hidden" value="gravar" name="acao" />'."\n");
								echo('<input type="submit" value="'.BUTTON_NEW_USER.'" class="submitTrue" />');
							}
							?>
							<!-- a href="http://<?=$_SERVER['HTTP_HOST']?>"><?=BUTTON_CANCEL?></a -->
								<input type="button" value="<?=BUTTON_BACK?>" onclick="javascript:history.go(-1)" class="submitFalse"/>
								<input type="button" value="<?=BUTTON_CANCEL?>" onclick="javascript:window.location ='/'" class="submitFalse"/>
						</form>
					</div>
				</div>
			</div>
			<div class="copyright">
				BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
			</div>
		</div>
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>
</html>
<?
ob_end_flush();
?>
<?php
ob_start("ob_gzhandler");

/**
* processamento da tela de cadastro de usuários
*/
session_start();

ini_set("display_errors", "1");
error_reporting(E_ALL);

$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php",true);
$useSGU = intval($ini['sgu']['enabled'])?true:false;

$bvsSiteIni = parse_ini_file(dirname(__FILE__)."/../../../bvs-site-conf.php",true);

$baseDir = "";

if($bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'] != null){
	$baseDir = $bvsSiteIni['ENVIRONMENT']['LETTER_UNIT'].$bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}else{
	$baseDir = $bvsSiteIni['ENVIRONMENT']['DATABASE_PATH'];
}

if($useSGU){
	require_once(dirname(__FILE__)."/UserClassWS.php");
}else{
	require_once(dirname(__FILE__)."/UserClass.php");
}
require_once(dirname(__FILE__)."/langs.php");

//variaveis do formulário
$cgi = array_merge($_GET,$_POST);

	$userID = $cgi['id'];
	$firstName = $cgi['firstName'];
	$lastName = $cgi['lastName'];
	$gender = $cgi['gender'];
	$email = $cgi['email'];
	$login = $cgi['login'];
	$password = $cgi['password'];
	$profilesTexts = $cgi['profiletext'];
	$profilesNames = $cgi['profilename'];
	$profilesIDs = $cgi['profileid'];
	$acao = $cgi['acao'];

	switch($acao)
	{
		case "gravar":
			$usr = new UserClass($firstName, $lastName, $gender, $login, $email, $password);

			for($i = 0; $i < count($profilesTexts); $i ++){
				$usr->setProfiles(addslashes  ($profilesTexts[$i]), addslashes  ($profilesNames[$i]));
			}

			$result = $usr->AddUser();

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
		
			$usr->setID($userID);
			$usr->setFirstName($firstName);
			$usr->setLastName($lastName);
			$usr->setGender($gender);
			$usr->setEmail($email);
//			$usr->setLogin($login);

			if($useSGU){
				$usr->setToken($_COOKIE['userToken']);
			}

			if($password != "")
				$usr->setPassword($password);

			for($i = 0; $i < count($profilesTexts); $i ++){
				$profile = new UserProfileClass();
				$profile->setUserID($userID);
				$profile->setProfileID($profileid[$i]);
				$profile->setProfileText($profilesTexts[$i]);
				$profile->setProfileName($profilesNames[$i]);
				$profile->setProfileStatus('on');
				$usr->setProfiles($profile);
			}

			$a = $usr->UpdateUser();

			if($useSGU){
				$usr->loadUser($_COOKIE['userToken']);
			}else{
				$usr->loadUser($_COOKIE['userID']);
			}

			$profiles = $usr->getProfiles();

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
				echo UPDATE_USER_TITLE;
			else
				echo REGISTER_NEW_USER_TITLE;
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
									echo UPDATE_USER_TITLE;
								else
									echo REGISTER_NEW_USER_TITLE;
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
						<form method="post" name="cadastro" onsubmit="return v.exec()">
							<input type="hidden" name="postback" value="1" />
							<input type="hidden" name="userid" value="<?=trim($usr->getID())?> " />
							<?=REQUIRED_FIELD_TEXT?>
							<h4><?=PERSONAL_DATA?></h4>
							<table class="register">
								<tr>
									<td class="label"><?=FIELD_FIRST_NAME?></td>
									<td><input type="text" class="expression" name="firstName" value="<?=trim($usr->getFirstName())?>"/>
									<span id="firstNameMsg" class="tfvNormal"><?=FIELD_FIRST_NAME_ERROR_DESCRIPTION?></span></td>
								</tr>
								<tr>
									<td class="label"><?=FIELD_LAST_NAME?></td>
									<td><input type="text" class="expression" name="lastName" value="<?=trim($usr->getLastName())?>" />
									<span id="lastNameMsg" class="tfvNormal"><?=FIELD_LAST_NAME_ERROR_DESCRIPTION?></span></td>
								</tr>
								<tr>
									<td class="label"><?=FIELD_GENDER?></td>
									<td>
										<label for="genderM"><?=FIELD_GENDER_MALE?>
										<input type="radio" <?if ($usr->getGender() == "M") echo "checked"; ?> name="gender" id="genderM" value="M" />
										<label for="genderF"><?=FIELD_GENDER_FEMALE?>
										<input type="radio" <?if ($usr->getGender() == "F") echo "checked"; ?> name="gender" id="genderF" value="F" />
										<span id="genderMsg" class="tfvNormal"><?=FIELD_GENDER_ERROR_DESCRIPTION?></span>
									</td>
								</tr>
								<tr>
									<td class="label"><?=FIELD_EMAIL?></td>
									<td><input type="text" class="expression" name="email" value="<?=trim($usr->getEMail())?>" />
									<span id="emailMsg" class="tfvNormal"><?=FIELD_EMAIL_ERROR_DESCRIPTION?></span></td>
								</tr>
								<?php
									if($showLoginField)
									{
								?>
								<tr>
									<td class="label"><?=FIELD_LOGIN?></td>
									<td><input type="text" class="expression" name="login" value="<?=trim($usr->getLogin())?>" />
									<span id="loginMsg" class="tfvNormal"><?=FIELD_LOGIN_ERROR_DESCRIPTION?></span></td>
								<tr>
								<?
									}
								?>
									<td class="label"><?=FIELD_PASSWORD?></td>
									<td>
									<input type="password" class="expression" name="password" />
									<span id="passwordMsg" class="tfvNormal"><?=FIELD_PASSWORD_ERROR_DESCRIPTION?></span>
									<?=FIELD_PASSWORD_CONFIRMATION?>
									<input type="password" class="expression" name="password2" />
									<span id="password2Msg" class="tfvNormal"></span>
									<?
										if(isset($_REQUEST['id']) && isset($_COOKIE['userID'])){
											echo FIELD_PASSWORD_CHANGE_MESSAGE;
										}
									?>
									</td>
								</tr>
							</table>
							<h4><?=PROFILE?></h4>
								<? $htmlProfiles = array(FIELD_PROFILE_ONE, FIELD_PROFILE_TWO,FIELD_PROFILE_TREE);
								foreach ($htmlProfiles as $i=>$text){
									$profileText = '';
									$profileID = '';
									$profileName = '';
									if ($profiles[$i]){
										$profileText = $profiles[$i]->getProfileText();
										$profileID = $profiles[$i]->getProfileID();
										$profileName = $profiles[$i]->getProfileName();
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
									echo '			'.FIELD_PROFILE_DESCRIPTION_TEXT.''."\n";
									echo '		</td>'."\n";
									echo '		<td class="label">'."\n";
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
								<input type="button" value="<?=BUTTON_CANCEL?>" onclick="javascript:history.go(-1)" class="submitFalse"/>
						</form>
					</div>
				</div>
			</div>
			<div class="copyright">
				BVS Site 4.0-rc4 &copy; <a href="http://www.bireme.br/" target="_blank">BIREME/OPS/OMS</a>
			</div>
		</div>
<!--
JS para a validação do formulário
-->
			<script>
			// form fields description structure
			var a_fields = {
				'firstName': {
					'l': 'Nome',  // label
					'r': true,    // required
					'f': 'qqcoisa',  // format (see below)
					't': 'firstNameMsg',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				},
				'lastName': {
					'l': 'LastNome',  // label
					'r': true,    // required
					'f': 'qqcoisa',  // format (see below)
					't': 'lastNameMsg',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				},
					<?
//depois de cadastrado não se pode alterar o login!!!!!

				if($showLoginField)
				{
					?>
				'login': {
					'l': 'Login',  // label
					'r': true,    // required
					'f': 'qqcoisa',  // format (see below)
					't': 'loginMsg',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 50       // maximum length
				},
					<?
				}
				?>
				'email': {
					'l': 'email',  // label
					'r': true,    // required
					'f': 'email',  // format (see below)
					't': 'emailMsg',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 100       // maximum length
				},
				'password' : {
					'l':'Password',
					'r':<? if ($usr->getID() == 0 ) { echo 'true';} else { echo 'false';} ?>,
					'f':'alphanum',
					't':'passwordMsg',
					'm':'password2'
				},
				'password2' : {
					'l':'Password copy',
					'r':<? if ($usr->getID() == 0 ) { echo 'true';} else { echo 'false';} ?>,
					'f':'alphanum',
					't':'password2',
					't':'password2Msg'
				}

			};

			o_config = {
				'to_disable' : [],
				'alert' : 1
			};

			// validator constructor call
			var v = new validator('cadastro', a_fields, o_config);

			</script>
		<?require_once(dirname(__FILE__)."/../sgu/traker.php")?>
	</body>
</html>
<?
ob_end_flush();
?>

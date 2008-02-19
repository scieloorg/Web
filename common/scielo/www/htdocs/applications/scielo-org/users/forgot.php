<?
ini_set("include_path",".");

require_once("langs.php");

$acao = $_REQUEST['acao'];

/**
*Verificando se é para usar o SGU ou não
*/
$ini = parse_ini_file(dirname(__FILE__)."/../scielo.def.php",true);
$useSGU = intval($ini['sgu']['enabled'])?true:false;


if($useSGU){
	require_once(dirname(__FILE__)."/UserClassWS.php");
}else{
	require_once(dirname(__FILE__)."/UserClass.php");
}

$usr = new UserClass();

if(isset($acao)){
	$login = $_REQUEST['login'];

	$usr->setLogin($login);

	$ret = $usr->createNewPassword();
}

/**
*Cabechalho BVS Site
*/
	include_once(dirname(__FILE__)."/../../../php/include.php");

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title>
			<?=FORGOT_TITLE?>
		</title>
		<? include(dirname(__FILE__)."/../../../php/head.php"); ?>
		<script language="JavaScript" src="/js/validator.js"></script>

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
				<? include(dirname(__FILE__)."/../../../html/" . $lang . "/bvs.html"); ?>
				<div class="middle">
				<h1><?=FORGOT_TITLE?></h1>
				<? if ($ret == "")  { ?>
					<form method="post" name="cadastro" onsubmit="return v.exec()">
					<?=FIELD_LOGIN?>
						<input type="text" name="login" />
						<span id="loginMsg" class="tfvNormal"><?=FIELD_LOGIN_ERROR_DESCRIPTION?></span>
						<br />
						<input type="hidden"  name="acao" value="enviar"/>
						<span class="tfvNormal"><?=REQUIRED_FIELD_TEXT?></span>
						<br />
						<input type="submit" value="<?=BUTTON_SEND_NEW_PASSORD?>" />
					</form>
					<?
						} else if($ret == 1){
							echo SEND_NEW_PASSWORD_SUCCESS;
						}
						 else if (is_array($ret)) {
							if($ret['ERROR'] == "1")
								echo '<span class="tfvHighlight" >' . UNKNOW_USER_ERROR . '</span>';
						}
					?>
					<br />
						<a href="http://<?=$_SERVER['HTTP_HOST']?>"><?=BUTTON_BACK?></a>
				</div>
			</div>
		</div>
					<script>
			// form fields description structure
			var a_fields = {
				'login': {
					'l': 'Login',  // label
					'r': true,    // required
					'f': 'qqcoisa',  // format (see below)
					't': 'loginMsg',// id of the element to highlight if input not validated
					'm': null,     // must match specified form field
					'mn': 3,       // minimum length
					'mx': 50       // maximum length
				}
			};

			o_config = {
				'to_disable' : [],
				'alert' : 0
			};

			// validator constructor call
			var v = new validator('cadastro', a_fields, o_config);

			</script>
	</body>
</html>
<?php
	$DirNameLocal=dirname(__FILE__).'/';
	ini_set("error_reporting", E_ERROR);

	// define constants
	define("VERSION","4.0-rc7");
	define("USE_SERVER_PATH", false);

	if (USE_SERVER_PATH == true){
		$pathTranslated = dirname($_SERVER["PATH_TRANSLATED"]);
		$sitePath = dirname($pathTranslated);
	}else{
		$sitePath = realpath($DirNameLocal . "..");
	}		
	$def = parse_ini_file($sitePath ."/bvs-site-conf.php");
	$lang = "";
	
	if ( !isset($_REQUEST["lang"]) || $_REQUEST["lang"] == "" ) {
		if (!isset($_COOKIE["clientLanguage"])) {
			$lang = $def["DEFAULT LANGUAGE"];
		} else {
			$lang = $_COOKIE["clientLanguage"];
		}
	} else {
		$lang = $_REQUEST["lang"];
		setCookie("clientLanguage",$lang,time()+60*60*24*30,"/");
	}

	foreach ($def as $key => $value){
		define($key, $value);
	}

	// URL parameters security filter
	$checked  = array();

	if ( isset($_GET["component"]) && !ereg("^[0-9]+$", $_GET["component"]) )
		die("404 - File Not Found");
	else
		$checked['component'] = $_GET["component"];	

	if ( isset($_GET["item"]) && !ereg("^[0-9]+$", $_GET["item"]) )
		die("404 - File Not Found");
	else
		$checked['item'] = $_GET["item"];	
	
	if ( isset($_GET["id"]) && !ereg("^[0-9]+$", $_GET["id"]) )
		die("404 - File Not Found");
	else
		$checked['id'] = $_GET["id"];	

	if ( !ereg("^(pt)|(es)|(en)$",$lang) )	
		$checked['lang'] = 'en';
	else 
		$checked['lang'] = $lang;	

	$localPath['html']= $def['DATABASE_PATH'] . "html/" . $checked['lang'] . "/";
	$localPath['xml'] = $def['DATABASE_PATH'] . "xml/" . $checked['lang'] . "/";
	$localPath['ini'] = $def['DATABASE_PATH'] . "ini/" . $checked['lang'] . "/";

	//IAH - METAIAH PATH  Para SciELO ORG
	$orgDef = parse_ini_file($DirNameLocal."../applications/scielo-org/scielo.def.php", true);
	$IAH = $orgDef["services"]["IAH"];
	if ($IAH == 1){
		$IAHService = $orgDef["services"]["IAHPATH"];
	}else{
		$IAHService = "metaiah";
	}
?>
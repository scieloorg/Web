<?php

$xmlRootPath = dirname(__FILE__).'/';
require($xmlRootPath . '../bvs-lib/common/scripts/php/xslt.php');
require($xmlRootPath . '../admin/auth_check.php');
require($xmlRootPath . '../php/include.php');
require($xmlRootPath . "./xmlRoot_functions.php");

$checked = array();

$xml = ( $xml != "" ? $xml : $_REQUEST['xml'] );
$xsl = ( $xsl != "" ? $xsl : $_REQUEST['xsl'] );
$lang = ( $lang != "" ? $lang : $_REQUEST['lang'] );
$page = ( $page != "" ? $page : $_REQUEST['page'] );
	
$xslSave = $_REQUEST['xslSave'];
$xmlSave = $_REQUEST['xmlSave'];

check_parameters();

if (eregi("(adm.xml)|(users.xml)",$checked['xml']) || eregi("adm",$checked['xsl']) || isset($xmlSave) ){
	auth_check_login();
}


$xmlContent = BVSDocXml("root",$checked['xml']);
	
if ( isset($_REQUEST['debug']) ){	
	debug($_REQUEST['debug']);
}

if ( isset($xslSave) )
{
	$xslSave = "../" . $checked['xslSave'];
	$sucessWriteXml = xmlWrite($xmlContent,$xslSave,$checked['xmlSave']);

	if ( $sucessWriteXml != '' && $checked['page'] != 'users' ){
		// generate html
		htmlWrite($sucessWriteXml);

		// generate ini 
		iniWrite($sucessWriteXml);

		if ($checked['page'] == 'collection' || $checked['page'] == 'topic'){
			// generate metaiah define xml
			defineMetaIAHWrite();
		}
	}	

	if ( isset($xmlT) )
	{		if ( $xmlT == "saved" )
		{
			$xmlContent = BVSDocXml("root",$checked['xmlSave']);
		}
	}
}

$xslTransform = normalizePath($checked['xsl'], "SITE_PATH");

if ( $debug == "XSL" ) { die($xslContent); }

if ( isset($xsl) ){
	print( processTransformation($xmlContent,$xslTransform) );
}else{
	print($xmlContent);
}

?>


<?php
require_once('lib/class_xml_check/class_xml_check.php');

function validateXML($xml){
	$validXML = true;
		
	$xmlCheck = new XML_check();
	$xml1 = $xml;
	$validXML = $xmlCheck->check_string($xml1); // verifica se o XML � bem formado
	
	return $validXML;
}

?>
<?php
header("Content-Type: application/xhtml+xml; charset=iso-8859-1");

require_once(dirname(__FILE__)."/../classes/GrandeArea.php");

$idGrandeArea = $_REQUEST['id_grande_area'];
$lang = $_REQUEST['lang'];

$a = new GrandeArea();

$a->setID($idGrandeArea);

if($lang != ""){
	$a->setLang($lang);
}

$arr = $a->getSubAreas();
$str = '';

foreach($arr as $item)
{
	$str .= ''.$item->getID().','.urldecode($item->getDescricao()).'|';
}

$str = ereg_replace("\|$","",$str);

echo $str;
?>

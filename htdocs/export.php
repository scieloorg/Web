<?
/**
* cria o arquivo de texto com a citacao exportada para
* o formato selecionado
*/
$pid = isset($_REQUEST['PID'])?$_REQUEST['PID']:$_REQUEST['pid'];
$format = $_REQUEST['format'];

if(!isset($pid) || $pid == '' || !isset($format) || $format == ''){
    //header('Location: / ');
    print('Error: Exportation tool.<br/>');
    exit;
}


$url = "http://".$_SERVER['HTTP_HOST']."/cgi-bin/wxis.exe/?IsisScript=ScieloXML/sci_artmetadata.xis&def=scielo.def.php&pid=".$pid."&";

$handle = fopen($url, "rb");

$xml = "";
do {
    $data = fread($handle, 8192);
    if (strlen($data) == 0) {
        break;
    }
    $xml .= $data;
} while(true);

fclose ($handle);

$xsl = dirname(__FILE__)."/xsl/";

switch($format){

	case "BibTex":
		$xsl .= "createBibTexReference.xsl";
	break;

	case "RefMan":
		$xsl .= "createRefManReference.xsl";
	break;

	case "EndNote":
		$xsl .= "createEndNoteReference.xsl";
	break;

	case "RefMan":
		$xsl .= "createRefManReference.xsl";
	break;

	case "ProCite":
		$xsl .= "createProCiteReference.xsl";
	break;

	case "RefWorks":
		$xsl .= "createRefWorksReference.xsl";
	break;

	case "XML":
		$xsl .= "createXMLReference.xsl";
	break;
}


$result = "";

if($xsl != dirname(__FILE__)."/xsl/")
{
	require_once(dirname(__FILE__)."/class.XSLTransformer.php");
	$t = new XSLTransformer();
	$t->setXml($xml);
//	$t->setXsl(file_get_contents($xsl));
	$t->setXslFile($xsl);
	$t->transform();
	$result = $t->getOutput();
}


	if($format != "XML")
	{

		/*
		tirando TAGs HTML e mais umas coisas . . .
		*/
		$search = array ('@<script[^>]*?>.*?</script>@si', // Strip out javascript
						 '@<[\/\!]*?[^<>]*?>@si',          // Strip out HTML tags
						 '@([\r\n])[\s]+@',                // Strip out white space
						 '@&(quot|#34);@i',                // Replace HTML entities
						 '@&(amp|#38);@i',
						 '@&(lt|#60);@i',
						 '@&(gt|#62);@i',
						 '@&(nbsp|#160);@i',
						 '@&(iexcl|#161);@i',
						 '@&(cent|#162);@i',
						 '@&(pound|#163);@i',
						 '@&(copy|#169);@i',
						 '@&#(\d+);@e');                    // evaluate as php

		$replace = array ('',
						  '',
						  '\1',
						  '"',
						  '&',
						  '<',
						  '>',
						  ' ',
						  chr(161),
						  chr(162),
						  chr(163),
						  chr(169),
						  'chr(\1)');

		$result = preg_replace($search, $replace, $result);
	}

$inicio = strpos($xml,'<SIGLUM>');
$fim = strpos($xml,'</SIGLUM>');


$id = substr($xml, $inicio+8, ($fim-$inicio)-8).$pid;

switch($format){

	case "BibTex":
		/**
		*	Dando um acerto na formata��o da saida da XSL . . .
		*/
		$result = str_replace("|",",\r\n",$result);
		$result = str_replace(",\n   }","\r\n}",$result);
		$result = str_replace("�","!`",$result);
		$result = str_replace("�","\\textcent",$result);
		$result = str_replace("�","\\pounds",$result);
		$result = str_replace("�","\\textcurrency",$result);
		$result = str_replace("�","\\textyen",$result);
		$result = str_replace("�","\\textbrokenbar",$result);
		$result = str_replace("�","\\S",$result);
		$result = str_replace("�","\\texthighdiaeresis",$result);
		$result = str_replace("�","\\copyright",$result);
		$result = str_replace("�","\\textordfemenine",$result);
		$result = str_replace("�","\\ll",$result);
		$result = str_replace("�","\\neg",$result);
		$result = str_replace("�","\\-",$result);
		$result = str_replace("�","\\textregistered",$result);
		$result = str_replace("�","\\textmacron",$result);
		$result = str_replace("�","\\textdegree",$result);
		$result = str_replace("�","\\pm",$result);
		$result = str_replace("�","\\texttwosuperior",$result);
		$result = str_replace("�","\\textthreesuperior",$result);
		$result = str_replace("�","\\'{}",$result);
		$result = str_replace("�","\\mu",$result);
		$result = str_replace("�","\\P",$result);
		$result = str_replace("�","\\cdot",$result);
		$result = str_replace("�","\\c{}",$result);
		$result = str_replace("�","\\textonesuperior",$result);
		$result = str_replace("�","\\textordmasculine",$result);
		$result = str_replace("�","\\gg",$result);
		$result = str_replace("�","\\textonequater",$result);
		$result = str_replace("�","\\textonehalf",$result);
		$result = str_replace("�","\\textthreequaters",$result);
		$result = str_replace("�","?`",$result);
		$result = str_replace("�","\\`A",$result);
		$result = str_replace("�","\\'A",$result);
		$result = str_replace("�","\\^A",$result);
		$result = str_replace("�","\\~A",$result);
		$result = str_replace("�","\\\"A",$result);
		$result = str_replace("�","\\AA",$result);
		$result = str_replace("�","\\AE",$result);
		$result = str_replace("�","\\c{C}",$result);
		$result = str_replace("�","\\`E",$result);
		$result = str_replace("�","\\'E",$result);
		$result = str_replace("�","\\^E",$result);
		$result = str_replace("�","\\\"E",$result);
		$result = str_replace("�","\\`I",$result);
		$result = str_replace("�","\\'I",$result);
		$result = str_replace("�","\\^I",$result);
		$result = str_replace("�","\\\"I",$result);
		$result = str_replace("�","\\Dstroke",$result);
		$result = str_replace("�","\\~N",$result);
		$result = str_replace("�","\\`O",$result);
		$result = str_replace("�","\\'O",$result);
		$result = str_replace("�","\\^O",$result);
		$result = str_replace("�","\\~O",$result);
		$result = str_replace("�","\\\"O",$result);
		$result = str_replace("�","\\times",$result);
		$result = str_replace("�","\\O",$result);
		$result = str_replace("�","\\`U",$result);
		$result = str_replace("�","\\'U",$result);
		$result = str_replace("�","\\^U",$result);
		$result = str_replace("�","\\\"U",$result);
		$result = str_replace("�","\\'Y",$result);
		$result = str_replace("�","\\Thorn",$result);
		$result = str_replace("�","\\ss",$result);
		$result = str_replace("�","\\`a",$result);
		$result = str_replace("�","\\'a",$result);
		$result = str_replace("�","\\^a",$result);
		$result = str_replace("�","\\~a",$result);
		$result = str_replace("�","\\\"a",$result);
		$result = str_replace("�","\\aa",$result);
		$result = str_replace("�","\\ae",$result);
		$result = str_replace("�","\\c{c}",$result);
		$result = str_replace("�","\\`e",$result);
		$result = str_replace("�","\\'e",$result);
		$result = str_replace("�","\\^e",$result);
		$result = str_replace("�","\\\"e",$result);
		$result = str_replace("�","\\`{\\i}",$result);
		$result = str_replace("�","\\'{\\i}",$result);
		$result = str_replace("�","\\^{\\i}",$result);
		$result = str_replace("�","\\\"{\\i}",$result);
		$result = str_replace("�","\\dstroke",$result);
		$result = str_replace("�","\\~n",$result);
		$result = str_replace("�","\\`o",$result);
		$result = str_replace("�","\\'o",$result);
		$result = str_replace("�","\\^o",$result);
		$result = str_replace("�","\\~o",$result);
		$result = str_replace("�","\\\"o",$result);
		$result = str_replace("�","\\div",$result);
		$result = str_replace("�","\\o",$result);
		$result = str_replace("�","\\`u",$result);
		$result = str_replace("�","\\'u",$result);
		$result = str_replace("�","\\^u",$result);
		$result = str_replace("�","\\\"u",$result);
		$result = str_replace("�","\\'y",$result);
		$result = str_replace("�","\\thorn",$result);
		$result = str_replace("�","\\\"y",$result);

		Header("Content-type: application/octet-stream");
		Header("Content-disposition: attachment; filename=".$id.".bib");
		echo $result;
	break;

	case "RefMan":
		$result = str_replace("|","\r\n",$result);
		Header("Content-type: application/octet-stream");
		Header("Content-disposition: attachment; filename=".$id.".ris");
		echo $result;
	break;

	case "EndNote":
		$result = str_replace("|","\r\n",$result);
		Header("Content-type: application/octet-stream");
		Header("Content-disposition: attachment; filename=".$id.".enw");
		echo $result;
	break;

	case "ProCite":
		$result = str_replace("|","\r\n",$result);
		Header("Content-type: application/octet-stream");
		Header("Content-disposition: attachment; filename=".$id.".txt");
		echo $result;
	break;

	case "RefWorks":

		$args = split("\|",$result);

		$element = split("=",$args[0]);

		$query = $element[0]."=".rawurlencode($element[1]);

		for($i = 1; $i < count($args); $i++){
			$element = split("=",$args[$i]);
			$query .= "&".$element[0]."=".rawurlencode(utf8_encode($element[1]));
		}

		$result = "http://www.refworks.com/express?".$query;

		Header("Location: ".$result);
	break;

	case "XML":
		Header("Content-type: application/octet-stream");
		Header("Content-disposition: attachment; filename=".$id.".xml");
		echo $result;
	break;
}

?>

<?php
ini_set("display_errors", "0");
	ini_set("log_errors", "1");
error_reporting(E_ALL ^ E_NOTICE);

$lang = isset($_REQUEST['lng']) ? ($_REQUEST['lng']) : 'en';
$_REQUEST['lang'] = $lang;
$pid = isset($_REQUEST['pid']) ? ($_REQUEST['pid']) : '';
$text = isset($_REQUEST['text']) ? ($_REQUEST['text']) : '';
$refPid = isset($_REQUEST['refpid']) ? ($_REQUEST['refpid']) : '';

require_once(dirname(__FILE__) . '/../../applications/scielo-org/users/functions.php');
require_once(dirname(__FILE__) . '/../../applications/scielo-org/users/langs.php');
require_once(dirname(__FILE__) . '/../../classDefFile.php');
require_once(dirname(__FILE__) . '/../../applications/scielo-org/classes/services/ArticleServices.php');

function fetchWxisXml($query, $pathHtdocs, $applServer)
{
    $wxisBinary = rtrim($pathHtdocs, '/') . '/../cgi-bin/wxis.exe';

    // Prefer local WXIS execution to avoid CGI alias/port mismatches.
    if (is_executable($wxisBinary)) {
        $args = array_filter(explode('&', $query), 'strlen');
        $cmd = escapeshellarg($wxisBinary);
        foreach ($args as $arg) {
            $cmd .= ' ' . escapeshellarg($arg);
        }
        $cmd .= ' ' . escapeshellarg('PATH_TRANSLATED=' . $pathHtdocs);

        $output = shell_exec($cmd);
        if (!empty($output)) {
            $xmlStart = strpos($output, '<');
            return ($xmlStart !== false) ? substr($output, $xmlStart) : $output;
        }
    }

    $context = stream_context_create(array('http' => array('timeout' => 4)));
    $url = 'http://' . $applServer . '/cgi-bin/wxis.exe?' . $query;
    $xml = @file_get_contents($url, false, $context);

    return $xml ? $xml : '';
}

$defFile = parse_ini_file(dirname(__FILE__) . '/../../scielo.def.php');
$applServer = $defFile['SERVER_SCIELO'];
$databasePath = $defFile['PATH_DATABASE'];
$pathHtdocs = $defFile['PATH_HTDOCS'];

// Adicionado para flag de log comentado por Jamil Atta Junior (jamil.atta@bireme.org)
$flagLog = $defFile['ENABLE_SERVICES_LOG'];

// XML que tem as informacoes se determinado artigo tem referencia no Medline, Lilacs, etc.
$query2 = 'IsisScript=ScieloXML/sci_reflinks.xis&def=scielo.def.php&lng=' . $lang . '&pid=' . $refPid;
$xml2 = fetchWxisXml($query2, $pathHtdocs, $applServer);

$fullTitle = '';
if (!$_REQUEST['refid']) {
    // XML que tem o Titulo completo do artigo
    $query1 = 'IsisScript=ScieloXML/sci_references.xis&database=artigo&gizmo=GIZMO_XML_REF&search=rp=' . $pid . '$';
    $xml1 = fetchWxisXml($query1, $pathHtdocs, $applServer);

    // XML da primeira transformacao para conseguirmos o titulo completo
    $xml = '<?xml version="1.0" encoding="ISO-8859-1"?>';
    $xml .= '<root>';
    $xml .= '<vars><refId>' . number_format(substr($refPid, 23, 27), 0, '', '') . '</refId><applserver>' . $applServer . '</applserver><lang>' . $lang . '</lang></vars>';
    $xml .= str_replace('<?xml version="1.0" encoding="ISO-8859-1"?>', '', $xml1);
    $xml .= '</root>';

    if ($_REQUEST['debug1'] == 'on') {
        die($xml);
    }

    $xsl = rtrim($pathHtdocs, '/') . '/xsl/getReferencebyId.xsl';
    $transformer = new XSLTransformer();
    $transformer->setXslBaseUri(dirname(__FILE__));
    $transformer->setXml($xml);
    $transformer->setXslFile($xsl);
    $transformer->transform();
    $output = $transformer->getOutput();

    // Pegamos o titulo completo da referencia do artigo
    $fullTitle = $output;

    if (($transformer->transformedBy ?? '') == 'PHP') {
        $fullTitle = utf8_decode($fullTitle);
    }
}

// XML Final que contem os dados que precisamos do XML1 e XML2
$xmlFinal = '<?xml version="1.0" encoding="ISO-8859-1"?>';
$rootPos = strpos($xml2, '<root>');
$titlePos = strpos($xml2, '<TITLE>');

if ($rootPos !== false && $titlePos !== false && $titlePos > $rootPos) {
    $xmlFinal .= substr($xml2, $rootPos, $titlePos - $rootPos) . '<vars><refid>' . $_REQUEST['refid'] . '</refid><htdocs>' . $pathHtdocs . '</htdocs><service_log>' . $flagLog . '</service_log></vars>';
    $xmlFinal .= ' <ref_TITLE><![CDATA[' . $fullTitle . ']]></ref_TITLE>';
    $xmlFinal .= substr($xml2, $titlePos);
} else {
    // Safe fallback to avoid invalid XML in PHP 8 environments.
    $xmlFinal .= '<root><vars><refid>' . $_REQUEST['refid'] . '</refid><htdocs>' . $pathHtdocs . '</htdocs><service_log>' . $flagLog . '</service_log></vars><ref_TITLE><![CDATA[' . $fullTitle . ']]></ref_TITLE><TITLE></TITLE></root>';
}

if ($_REQUEST['debug2'] == 'on') {
    die($xmlFinal);
}

// Transformacao Final, pagina de links de referencia
$transformerFinal = new XSLTransformer();
$xslFinal = rtrim($pathHtdocs, '/') . '/xsl/sci_reflinks.xsl';
$transformerFinal->setXslBaseUri(rtrim($pathHtdocs, '/') . '/xsl');
$transformerFinal->setXml($xmlFinal);
$transformerFinal->setXslFile($xslFinal);
$transformerFinal->transform();
$output = $transformerFinal->getOutput();

if (($transformer->transformedBy ?? '') == 'PHP') {
    $output = utf8_decode($output);
}

if ($transformerFinal->getError()) {
    echo $transformerFinal->getError();
}

$output = str_replace('&amp;', '&', $output);
$output = str_replace('&lt;', '<', $output);
$output = str_replace('&gt;', '>', $output);
$output = str_replace('&quot;', '"', $output);
$output = str_replace('<p>', ' ', $output);
$output = str_replace('</p>', ' ', $output);

echo html_entity_decode($output);

/**
 * Inclusao do arquivo gerador de log de usuarios autenticados somente se o servico estiver habilitado no scielo.def, e existir o cookie userID
 */
if (($defFile['ENABLE_AUTH_USERS_LOG'] ?? 0) == 1) {
    if (isset($_COOKIE['userID']) && $_COOKIE['userID'] != -2) {
        require_once(dirname(__FILE__) . '/../../applications/scielo-org/ajax/authLogServicesInclude.php');
    }
}
?>

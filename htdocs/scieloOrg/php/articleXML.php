<?php
/**
 * XML do PubMed Central no servico "Artigo em formato XML"
 *
 * Concatenacao de dois XML.
 */
header('Content-type: text/xml; charset=ISO-8859-1');

$lang = isset($_REQUEST['lang']) ? ($_REQUEST['lang']) : '';
$pid = isset($_REQUEST['pid']) ? ($_REQUEST['pid']) : '';
$text = isset($_REQUEST['text']) ? ($_REQUEST['text']) : '';

require_once(dirname(__FILE__) . '/../../applications/scielo-org/users/functions.php');
require_once(dirname(__FILE__) . '/../../applications/scielo-org/users/langs.php');
require_once(dirname(__FILE__) . '/../../classDefFile.php');
require_once(dirname(__FILE__) . '/../../class.XSLTransformer.php');

$defFile = @parse_ini_file(dirname(__FILE__) . '/../../scielo.def.php');
if (!is_array($defFile)) {
    $defFile = array();
}

$applServer = isset($defFile['SERVER_SCIELO']) ? $defFile['SERVER_SCIELO'] : '127.0.0.1';
$pathHtdocs = isset($defFile['PATH_HTDOCS']) ? $defFile['PATH_HTDOCS'] : '/var/www/html/htdocs/';

function fetchWxisXml($query, $pathHtdocs, $applServer)
{
    $wxisBinary = rtrim($pathHtdocs, '/') . '/../cgi-bin/wxis.exe';

    // Prefer local WXIS execution to avoid CGI alias/port mismatch.
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

    $context = stream_context_create(array('http' => array('timeout' => 5)));
    $url = 'http://' . $applServer . '/cgi-bin/wxis.exe?' . $query;
    $xml = @file_get_contents($url, false, $context);
    return $xml ? $xml : '';
}

if ($pid === '') {
    echo '<?xml version="1.0" encoding="ISO-8859-1"?><error>missing pid</error>';
    exit;
}

// Contem o artigo da revista.
$query1 = 'IsisScript=ScieloXML/sci_xmloutput.xis&database=artigo&search=IV=' . $pid . '$';
$xml1 = fetchWxisXml($query1, $pathHtdocs, $applServer);

if (isset($_REQUEST['debug']) && $_REQUEST['debug'] == 'xml') {
    die($xml1);
}

// Contem o elemento BODY/BACK.
$query2 = 'IsisScript=ScieloXML/sci_arttext.xis&def=scielo.def.php&pid=' . $pid;
$xml2 = fetchWxisXml($query2, $pathHtdocs, $applServer);
$xml2 = str_replace('<REFERENCES></REFERENCES>', '', $xml2);
if (isset($_REQUEST['debug']) && $_REQUEST['debug'] == 'body') {
    die($xml2);
}

if ($xml1 === '' || $xml2 === '') {
    echo '<?xml version="1.0" encoding="ISO-8859-1"?><error>backend unavailable</error>';
    exit;
}

$body = '';

// Pegando o conteudo entre as tags BODY ... (SciELO antigo)
$posicaoInicial = strpos($xml2, '<BODY>');
if ($posicaoInicial !== false) {
    $posicaoFinal = strpos($xml2, '</ARTICLE>');
    if ($posicaoFinal !== false && $posicaoFinal > $posicaoInicial) {
        $body = substr($xml2, $posicaoInicial, $posicaoFinal - $posicaoInicial);
        $body = str_replace('<BODY>', '<body>', $body);
        $body = str_replace('</BODY>', '</body>', $body);
    }
} else {
    // body - pubmed central - tags body/back dentro de fulltext
    $posicaoInicial = strpos($xml2, '<body');
    if ($posicaoInicial !== false) {
        $posicaoFinal = strpos($xml2, '</body>');
        if ($posicaoFinal !== false && $posicaoFinal > $posicaoInicial) {
            $body = substr($xml2, $posicaoInicial, ($posicaoFinal + strlen('</body>')) - $posicaoInicial);
        }
    }
}

// Retirando do <article ...> ate antes de <search mfn...>
$tagWxis = strpos($xml1, '<article xmlns');
$tagSearch = strpos($xml1, '<search mfn');
if ($tagWxis === false || $tagSearch === false || $tagSearch <= $tagWxis) {
    // Fallback: devolve XML original do sci_xmloutput quando nao conseguir compor.
    echo $xml1;
    exit;
}

$temp = $xml1;
$xml1 = '<?xml version="1.0" encoding="ISO-8859-1"?>';
$xml1 .= substr($temp, $tagWxis, $tagSearch - $tagWxis);

// Criando o XML no formato exigido pela PubMed.
$posFimFront = strpos($xml1, '</front>');
if ($posFimFront === false) {
    echo $xml1;
    exit;
}

$posComBack = strpos($xml1, '<back>');
$xmlPubMed = substr($xml1, 0, $posFimFront + strlen('</front>'));

if ($body !== '') {
    $xmlPubMed .= $body;
}

if ($posComBack !== false) {
    $xmlPubMed .= substr($xml1, $posComBack);
} else {
    $xmlPubMed .= substr($xml1, $posFimFront + strlen('</front>'));
}

echo $xmlPubMed;

?>

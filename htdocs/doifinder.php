<?
error_reporting(1);
require_once('articlemeta/broker.php');

$collections = array(
    'scl' => 'www.scielo.br',
    'arg' => 'www.scielo.org.ar',
    'cub' => 'scielo.sld.cu',
    'esp' => 'scielo.isciii.es',
    'col' => 'www.scielo.org.co',
    'sss' => 'socialsciences.scielo.org',
    'spa' => 'www.scielosp.org',
    'mex' => 'www.scielo.org.mx',
    'prt' => 'www.scielo.gpeari.mctes.pt',
    'cri' => 'www.scielo.sa.cr',
    'ven' => 'www.scielo.org.ve',
    'ury' => 'www.scielo.edu.uy',
    'per' => 'www.scielo.org.pe',
    'chl' => 'www.scielo.cl',
    'sza' => 'www.scielo.org.za',
    'bol' => 'www.scielo.org.bo',
    'par' => 'scielo.iics.una.py'
);

$doi = $_REQUEST['q'];
$lng = $_REQUEST['lng'];

$articlemeta = new Broker();

$json = $articlemeta->get_document_by_doi($doi);
$pid = $json->code;
$collection = $json->collection;

if ($pid == NULL) {
      header('HTTP/1.0 404 Not Found');
?>
    <!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
    <html><head>
    <title>404 Not Found</title>
    </head><body>
    <h1>Not Found</h1>
    <p>The requested URL <?=$_SERVER['REQUEST_URI']?> was not found on this server.</p>
    <hr>
    <?=$_SERVER['SERVER_SIGNATURE']?>
    </body></html>
<?
      exit();
}

if ($lng == '') {
   /// Pegando idioma original
   $lng = $json->article->v40[0]->_;
}

$redirect = "http://".$collections[$collection]."/scielo.php?script=sci_arttext&pid=".$pid."&lng=".$lng;
header("location:$redirect");
?>
